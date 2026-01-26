import secrets
from datetime import timedelta
from django.conf import settings
from django.utils import timezone
from rest_framework import generics, status, permissions
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework_simplejwt.views import TokenRefreshView
from google.oauth2 import id_token
from google.auth.transport import requests as google_requests
import requests

from .models import User, UserProfile, Resume, PasswordResetToken, EmailVerificationToken
from .serializers import (
    UserSerializer, UserProfileSerializer, RegisterSerializer, LoginSerializer,
    TokenSerializer, ChangePasswordSerializer, ForgotPasswordSerializer,
    ResetPasswordSerializer, GoogleAuthSerializer, GitHubAuthSerializer,
    ResumeSerializer, UserWithProfileSerializer
)
from .tasks import send_password_reset_email, send_verification_email


class RegisterView(generics.CreateAPIView):
    """User registration endpoint."""
    
    permission_classes = [permissions.AllowAny]
    serializer_class = RegisterSerializer
    
    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        user = serializer.save()
        
        # Create profile
        UserProfile.objects.create(user=user)
        
        # Generate tokens
        refresh = RefreshToken.for_user(user)
        
        # Send verification email
        try:
            token = secrets.token_urlsafe(32)
            EmailVerificationToken.objects.create(
                user=user,
                token=token,
                expires_at=timezone.now() + timedelta(days=1)
            )
            send_verification_email.delay(user.id, token)
        except Exception:
            pass  # Don't fail registration if email fails
        
        return Response({
            'access': str(refresh.access_token),
            'refresh': str(refresh),
            'user': UserSerializer(user).data
        }, status=status.HTTP_201_CREATED)


class LoginView(APIView):
    """User login endpoint."""
    
    permission_classes = [permissions.AllowAny]
    
    def post(self, request):
        serializer = LoginSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        
        user = serializer.validated_data['user']
        refresh = RefreshToken.for_user(user)
        
        return Response({
            'access': str(refresh.access_token),
            'refresh': str(refresh),
            'user': UserSerializer(user).data
        })


class LogoutView(APIView):
    """User logout endpoint - blacklists the refresh token."""
    
    def post(self, request):
        try:
            refresh_token = request.data.get('refresh')
            if refresh_token:
                token = RefreshToken(refresh_token)
                token.blacklist()
            return Response(status=status.HTTP_205_RESET_CONTENT)
        except Exception:
            return Response(status=status.HTTP_400_BAD_REQUEST)


class MeView(generics.RetrieveUpdateAPIView):
    """Get or update current user."""
    
    serializer_class = UserWithProfileSerializer
    
    def get_object(self):
        return self.request.user


class ChangePasswordView(APIView):
    """Change user password."""
    
    def post(self, request):
        serializer = ChangePasswordSerializer(data=request.data, context={'request': request})
        serializer.is_valid(raise_exception=True)
        
        request.user.set_password(serializer.validated_data['new_password'])
        request.user.save()
        
        return Response({'message': 'Password changed successfully.'})


class ForgotPasswordView(APIView):
    """Send password reset email."""
    
    permission_classes = [permissions.AllowAny]
    
    def post(self, request):
        serializer = ForgotPasswordSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        
        email = serializer.validated_data['email']
        
        try:
            user = User.objects.get(email=email)
            token = secrets.token_urlsafe(32)
            PasswordResetToken.objects.create(
                user=user,
                token=token,
                expires_at=timezone.now() + timedelta(hours=1)
            )
            send_password_reset_email.delay(user.id, token)
        except User.DoesNotExist:
            pass  # Don't reveal if user exists
        
        return Response({'message': 'If an account exists, a password reset email has been sent.'})


class ResetPasswordView(APIView):
    """Reset password with token."""
    
    permission_classes = [permissions.AllowAny]
    
    def post(self, request):
        serializer = ResetPasswordSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        
        try:
            reset_token = PasswordResetToken.objects.get(
                token=serializer.validated_data['token']
            )
            
            if not reset_token.is_valid():
                return Response(
                    {'error': 'Token is invalid or expired.'},
                    status=status.HTTP_400_BAD_REQUEST
                )
            
            user = reset_token.user
            user.set_password(serializer.validated_data['password'])
            user.save()
            
            reset_token.used = True
            reset_token.save()
            
            return Response({'message': 'Password reset successfully.'})
            
        except PasswordResetToken.DoesNotExist:
            return Response(
                {'error': 'Invalid token.'},
                status=status.HTTP_400_BAD_REQUEST
            )


class VerifyEmailView(APIView):
    """Verify email with token."""
    
    permission_classes = [permissions.AllowAny]
    
    def post(self, request):
        token = request.data.get('token')
        
        try:
            verification = EmailVerificationToken.objects.get(token=token)
            
            if not verification.is_valid():
                return Response(
                    {'error': 'Token is invalid or expired.'},
                    status=status.HTTP_400_BAD_REQUEST
                )
            
            user = verification.user
            user.is_verified = True
            user.save()
            
            verification.used = True
            verification.save()
            
            return Response({'message': 'Email verified successfully.'})
            
        except EmailVerificationToken.DoesNotExist:
            return Response(
                {'error': 'Invalid token.'},
                status=status.HTTP_400_BAD_REQUEST
            )


class GoogleAuthView(APIView):
    """Google OAuth login/register."""
    
    permission_classes = [permissions.AllowAny]
    
    def post(self, request):
        serializer = GoogleAuthSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        
        try:
            # Verify the Google token
            idinfo = id_token.verify_oauth2_token(
                serializer.validated_data['token'],
                google_requests.Request(),
                settings.GOOGLE_CLIENT_ID
            )
            
            email = idinfo['email']
            google_id = idinfo['sub']
            
            # Try to find existing user
            try:
                user = User.objects.get(google_id=google_id)
            except User.DoesNotExist:
                try:
                    user = User.objects.get(email=email)
                    user.google_id = google_id
                    user.save()
                except User.DoesNotExist:
                    # Create new user
                    user = User.objects.create_user(
                        email=email,
                        google_id=google_id,
                        first_name=idinfo.get('given_name', ''),
                        last_name=idinfo.get('family_name', ''),
                        is_verified=True
                    )
                    UserProfile.objects.create(user=user)
            
            refresh = RefreshToken.for_user(user)
            
            return Response({
                'access': str(refresh.access_token),
                'refresh': str(refresh),
                'user': UserSerializer(user).data
            })
            
        except ValueError as e:
            return Response(
                {'error': 'Invalid Google token.'},
                status=status.HTTP_400_BAD_REQUEST
            )


class GitHubAuthView(APIView):
    """GitHub OAuth login/register."""
    
    permission_classes = [permissions.AllowAny]
    
    def post(self, request):
        serializer = GitHubAuthSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        
        code = serializer.validated_data['code']
        
        try:
            # Exchange code for access token
            token_response = requests.post(
                'https://github.com/login/oauth/access_token',
                data={
                    'client_id': settings.GITHUB_CLIENT_ID,
                    'client_secret': settings.GITHUB_CLIENT_SECRET,
                    'code': code
                },
                headers={'Accept': 'application/json'}
            )
            token_data = token_response.json()
            access_token = token_data.get('access_token')
            
            if not access_token:
                return Response(
                    {'error': 'Failed to get access token from GitHub.'},
                    status=status.HTTP_400_BAD_REQUEST
                )
            
            # Get user info from GitHub
            user_response = requests.get(
                'https://api.github.com/user',
                headers={'Authorization': f'Bearer {access_token}'}
            )
            github_user = user_response.json()
            
            # Get email if not public
            if not github_user.get('email'):
                email_response = requests.get(
                    'https://api.github.com/user/emails',
                    headers={'Authorization': f'Bearer {access_token}'}
                )
                emails = email_response.json()
                primary_email = next(
                    (e['email'] for e in emails if e['primary']),
                    emails[0]['email'] if emails else None
                )
                github_user['email'] = primary_email
            
            if not github_user.get('email'):
                return Response(
                    {'error': 'Could not get email from GitHub.'},
                    status=status.HTTP_400_BAD_REQUEST
                )
            
            github_id = str(github_user['id'])
            email = github_user['email']
            
            # Try to find existing user
            try:
                user = User.objects.get(github_id=github_id)
            except User.DoesNotExist:
                try:
                    user = User.objects.get(email=email)
                    user.github_id = github_id
                    user.save()
                except User.DoesNotExist:
                    # Create new user
                    name_parts = (github_user.get('name') or '').split(' ', 1)
                    user = User.objects.create_user(
                        email=email,
                        github_id=github_id,
                        first_name=name_parts[0] if name_parts else '',
                        last_name=name_parts[1] if len(name_parts) > 1 else '',
                        is_verified=True
                    )
                    UserProfile.objects.create(user=user)
            
            refresh = RefreshToken.for_user(user)
            
            return Response({
                'access': str(refresh.access_token),
                'refresh': str(refresh),
                'user': UserSerializer(user).data
            })
            
        except Exception as e:
            return Response(
                {'error': str(e)},
                status=status.HTTP_400_BAD_REQUEST
            )


class ResumeListCreateView(generics.ListCreateAPIView):
    """List and create resumes."""
    
    serializer_class = ResumeSerializer
    
    def get_queryset(self):
        return Resume.objects.filter(user=self.request.user)


class ResumeDetailView(generics.RetrieveUpdateDestroyAPIView):
    """Get, update, or delete a resume."""
    
    serializer_class = ResumeSerializer
    
    def get_queryset(self):
        return Resume.objects.filter(user=self.request.user)


class CustomTokenRefreshView(TokenRefreshView):
    """Custom token refresh view."""
    pass
