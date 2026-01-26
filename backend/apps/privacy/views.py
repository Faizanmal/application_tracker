from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from rest_framework.views import APIView
from django.utils import timezone
from datetime import timedelta

from .models import (
    DataExportRequest,
    GDPRRequest,
    TwoFactorAuth,
    LoginAttempt,
    EncryptedNote,
    SecurityAuditLog,
    PrivacySetting,
)
from .serializers import (
    DataExportRequestSerializer,
    GDPRRequestSerializer,
    TwoFactorAuthSerializer,
    TwoFactorSetupSerializer,
    TwoFactorVerifySerializer,
    LoginAttemptSerializer,
    EncryptedNoteSerializer,
    SecurityAuditLogSerializer,
    PrivacySettingSerializer,
)
from .services import DataExportService, SecurityService


class DataExportViewSet(viewsets.ModelViewSet):
    """ViewSet for data export requests."""
    serializer_class = DataExportRequestSerializer
    permission_classes = [IsAuthenticated]
    http_method_names = ['get', 'post']
    
    def get_queryset(self):
        return DataExportRequest.objects.filter(user=self.request.user)
    
    def perform_create(self, serializer):
        export = serializer.save(user=self.request.user)
        
        # Queue export task
        from .tasks import process_data_export
        process_data_export.delay(str(export.id))
    
    @action(detail=True, methods=['get'])
    def download(self, request, pk=None):
        """Get download link for export."""
        export = self.get_object()
        
        if export.status != DataExportRequest.ExportStatus.COMPLETED:
            return Response(
                {'error': 'Export not ready'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        if export.expires_at and export.expires_at < timezone.now():
            return Response(
                {'error': 'Export has expired'},
                status=status.HTTP_410_GONE
            )
        
        # Generate signed URL
        service = DataExportService()
        url = service.get_download_url(export)
        
        export.downloaded_at = timezone.now()
        export.save()
        
        return Response({'download_url': url})


class GDPRRequestViewSet(viewsets.ModelViewSet):
    """ViewSet for GDPR requests."""
    serializer_class = GDPRRequestSerializer
    permission_classes = [IsAuthenticated]
    http_method_names = ['get', 'post']
    
    def get_queryset(self):
        return GDPRRequest.objects.filter(user=self.request.user)
    
    def perform_create(self, serializer):
        # Calculate due date (30 days per GDPR)
        due_date = timezone.now().date() + timedelta(days=30)
        
        serializer.save(
            user=self.request.user,
            user_email=self.request.user.email,
            due_date=due_date
        )
        
        # Log security event
        SecurityService.log_event(
            user=self.request.user,
            event_type=SecurityAuditLog.EventType.DATA_EXPORT,
            description=f"GDPR request submitted: {serializer.validated_data['request_type']}",
            request=self.request
        )
    
    @action(detail=False, methods=['post'])
    def delete_account(self, request):
        """Request complete account deletion."""
        gdpr_request = GDPRRequest.objects.create(
            user=request.user,
            user_email=request.user.email,
            request_type=GDPRRequest.RequestType.DATA_DELETION,
            description="User requested complete account deletion",
            due_date=timezone.now().date() + timedelta(days=30)
        )
        
        return Response({
            'message': 'Account deletion request submitted',
            'request_id': str(gdpr_request.id),
            'due_date': gdpr_request.due_date
        })


class TwoFactorAuthView(APIView):
    """View for 2FA management."""
    permission_classes = [IsAuthenticated]
    
    def get(self, request):
        """Get current 2FA status."""
        two_fa, created = TwoFactorAuth.objects.get_or_create(user=request.user)
        serializer = TwoFactorAuthSerializer(two_fa)
        return Response(serializer.data)
    
    def post(self, request):
        """Start 2FA setup."""
        serializer = TwoFactorSetupSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        
        two_fa, created = TwoFactorAuth.objects.get_or_create(user=request.user)
        method = serializer.validated_data['method']
        
        response_data = {
            'method': method
        }
        
        if method == TwoFactorAuth.TwoFactorMethod.TOTP:
            secret = two_fa.generate_totp_secret()
            two_fa.primary_method = method
            two_fa.save()
            
            response_data['secret'] = secret
            response_data['qr_uri'] = two_fa.get_totp_uri()
        
        elif method == TwoFactorAuth.TwoFactorMethod.SMS:
            phone = serializer.validated_data.get('phone_number')
            if not phone:
                return Response(
                    {'error': 'Phone number required for SMS'},
                    status=status.HTTP_400_BAD_REQUEST
                )
            two_fa.phone_number = phone
            two_fa.primary_method = method
            two_fa.save()
            
            # Send verification SMS
            # TODO: Implement SMS sending
            response_data['message'] = 'Verification code sent to your phone'
        
        # Save recovery email if provided
        if serializer.validated_data.get('recovery_email'):
            two_fa.recovery_email = serializer.validated_data['recovery_email']
            two_fa.save()
        
        return Response(response_data)
    
    def delete(self, request):
        """Disable 2FA."""
        try:
            two_fa = TwoFactorAuth.objects.get(user=request.user)
            two_fa.is_enabled = False
            two_fa.totp_secret = ''
            two_fa.totp_confirmed = False
            two_fa.save()
            
            SecurityService.log_event(
                user=request.user,
                event_type=SecurityAuditLog.EventType.TWO_FA_DISABLED,
                description="Two-factor authentication disabled",
                request=request
            )
            
            return Response({'message': '2FA disabled'})
        except TwoFactorAuth.DoesNotExist:
            return Response({'message': '2FA not configured'})


class TwoFactorVerifyView(APIView):
    """View for verifying 2FA codes."""
    permission_classes = [IsAuthenticated]
    
    def post(self, request):
        """Verify 2FA code and enable 2FA."""
        serializer = TwoFactorVerifySerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        
        try:
            two_fa = TwoFactorAuth.objects.get(user=request.user)
        except TwoFactorAuth.DoesNotExist:
            return Response(
                {'error': '2FA not set up'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        code = serializer.validated_data['code']
        use_backup = serializer.validated_data.get('use_backup', False)
        
        if use_backup:
            if two_fa.verify_backup_code(code):
                return Response({'verified': True})
            return Response(
                {'error': 'Invalid backup code'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        if two_fa.verify_totp(code):
            if not two_fa.is_enabled:
                # First verification - enable 2FA
                two_fa.is_enabled = True
                two_fa.totp_confirmed = True
                two_fa.last_used_at = timezone.now()
                
                # Generate backup codes
                backup_codes = two_fa.generate_backup_codes()
                two_fa.save()
                
                SecurityService.log_event(
                    user=request.user,
                    event_type=SecurityAuditLog.EventType.TWO_FA_ENABLED,
                    description="Two-factor authentication enabled",
                    request=request
                )
                
                return Response({
                    'verified': True,
                    'enabled': True,
                    'backup_codes': backup_codes
                })
            
            two_fa.last_used_at = timezone.now()
            two_fa.save()
            return Response({'verified': True})
        
        return Response(
            {'error': 'Invalid verification code'},
            status=status.HTTP_400_BAD_REQUEST
        )


class LoginAttemptViewSet(viewsets.ReadOnlyModelViewSet):
    """ViewSet for viewing login attempts."""
    serializer_class = LoginAttemptSerializer
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        return LoginAttempt.objects.filter(
            user=self.request.user
        ).order_by('-created_at')[:50]
    
    @action(detail=False, methods=['get'])
    def suspicious(self, request):
        """Get suspicious login attempts."""
        attempts = self.get_queryset().filter(is_suspicious=True)
        serializer = self.get_serializer(attempts, many=True)
        return Response(serializer.data)


class EncryptedNoteViewSet(viewsets.ModelViewSet):
    """ViewSet for encrypted notes."""
    serializer_class = EncryptedNoteSerializer
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        return EncryptedNote.objects.filter(user=self.request.user)
    
    def perform_create(self, serializer):
        serializer.save(user=self.request.user)


class SecurityAuditLogViewSet(viewsets.ReadOnlyModelViewSet):
    """ViewSet for security audit logs."""
    serializer_class = SecurityAuditLogSerializer
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        return SecurityAuditLog.objects.filter(
            user=self.request.user
        ).order_by('-created_at')[:100]


class PrivacySettingViewSet(viewsets.ModelViewSet):
    """ViewSet for privacy settings."""
    serializer_class = PrivacySettingSerializer
    permission_classes = [IsAuthenticated]
    http_method_names = ['get', 'put', 'patch']
    
    def get_object(self):
        obj, created = PrivacySetting.objects.get_or_create(
            user=self.request.user
        )
        return obj
    
    def list(self, request, *args, **kwargs):
        """Return single object instead of list."""
        instance = self.get_object()
        serializer = self.get_serializer(instance)
        return Response(serializer.data)
