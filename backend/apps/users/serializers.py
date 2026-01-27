from rest_framework import serializers
from django.contrib.auth import authenticate
from django.contrib.auth.password_validation import validate_password
from .models import User, UserProfile, Resume


class UserSerializer(serializers.ModelSerializer):
    """Serializer for user model."""
    
    full_name = serializers.ReadOnlyField()
    is_pro = serializers.ReadOnlyField()
    
    class Meta:
        model = User
        fields = [
            'id', 'email', 'first_name', 'last_name', 'full_name', 'avatar',
            'subscription_tier', 'is_pro', 'email_notifications', 'push_notifications',
            'user_timezone', 'is_verified', 'date_joined', 'last_login'
        ]
        read_only_fields = ['id', 'email', 'date_joined', 'last_login', 'is_verified']


class UserProfileSerializer(serializers.ModelSerializer):
    """Serializer for user profile."""
    
    class Meta:
        model = UserProfile
        fields = [
            'target_role', 'target_industry', 'preferred_locations',
            'min_salary', 'max_salary', 'linkedin_url', 'portfolio_url',
            'years_of_experience', 'current_company', 'current_role',
            'bio', 'skills', 'google_calendar_connected', 'created_at', 'updated_at'
        ]
        read_only_fields = ['created_at', 'updated_at', 'google_calendar_connected']


class RegisterSerializer(serializers.Serializer):
    """Serializer for user registration."""
    
    email = serializers.EmailField()
    password = serializers.CharField(write_only=True, validators=[validate_password])
    password_confirm = serializers.CharField(write_only=True)
    first_name = serializers.CharField(max_length=100, required=False, allow_blank=True)
    last_name = serializers.CharField(max_length=100, required=False, allow_blank=True)
    
    def validate_email(self, value):
        if User.objects.filter(email=value.lower()).exists():
            raise serializers.ValidationError("User with this email already exists.")
        return value.lower()
    
    def validate(self, attrs):
        if attrs['password'] != attrs['password_confirm']:
            raise serializers.ValidationError({"password_confirm": "Passwords don't match."})
        return attrs
    
    def create(self, validated_data):
        validated_data.pop('password_confirm')
        user = User.objects.create_user(
            email=validated_data['email'],
            password=validated_data['password'],
            first_name=validated_data.get('first_name', ''),
            last_name=validated_data.get('last_name', '')
        )
        return user


class LoginSerializer(serializers.Serializer):
    """Serializer for user login."""
    
    email = serializers.EmailField()
    password = serializers.CharField(write_only=True)
    
    def validate(self, attrs):
        email = attrs.get('email', '').lower()
        password = attrs.get('password', '')
        
        user = authenticate(username=email, password=password)
        
        if not user:
            raise serializers.ValidationError("Invalid email or password.")
        
        if not user.is_active:
            raise serializers.ValidationError("User account is disabled.")
        
        attrs['user'] = user
        return attrs


class TokenSerializer(serializers.Serializer):
    """Serializer for JWT tokens."""
    
    access = serializers.CharField()
    refresh = serializers.CharField()
    user = UserSerializer()


class ChangePasswordSerializer(serializers.Serializer):
    """Serializer for password change."""
    
    old_password = serializers.CharField(write_only=True)
    new_password = serializers.CharField(write_only=True, validators=[validate_password])
    new_password_confirm = serializers.CharField(write_only=True)
    
    def validate_old_password(self, value):
        user = self.context['request'].user
        if not user.check_password(value):
            raise serializers.ValidationError("Current password is incorrect.")
        return value
    
    def validate(self, attrs):
        if attrs['new_password'] != attrs['new_password_confirm']:
            raise serializers.ValidationError({"new_password_confirm": "Passwords don't match."})
        return attrs


class ForgotPasswordSerializer(serializers.Serializer):
    """Serializer for forgot password."""
    
    email = serializers.EmailField()
    
    def validate_email(self, value):
        try:
            User.objects.get(email=value.lower())
        except User.DoesNotExist:
            # Don't reveal if user exists
            pass
        return value.lower()


class ResetPasswordSerializer(serializers.Serializer):
    """Serializer for password reset."""
    
    token = serializers.CharField()
    password = serializers.CharField(write_only=True, validators=[validate_password])
    password_confirm = serializers.CharField(write_only=True)
    
    def validate(self, attrs):
        if attrs['password'] != attrs['password_confirm']:
            raise serializers.ValidationError({"password_confirm": "Passwords don't match."})
        return attrs


class GoogleAuthSerializer(serializers.Serializer):
    """Serializer for Google OAuth."""
    
    token = serializers.CharField()


class GitHubAuthSerializer(serializers.Serializer):
    """Serializer for GitHub OAuth."""
    
    code = serializers.CharField()


class ResumeSerializer(serializers.ModelSerializer):
    """Serializer for resume model."""
    
    class Meta:
        model = Resume
        fields = [
            'id', 'name', 'file', 'version', 'is_default',
            'skills_extracted', 'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'skills_extracted', 'created_at', 'updated_at']
    
    def create(self, validated_data):
        validated_data['user'] = self.context['request'].user
        return super().create(validated_data)


class UserWithProfileSerializer(serializers.ModelSerializer):
    """Serializer for user with profile."""
    
    profile = UserProfileSerializer()
    full_name = serializers.ReadOnlyField()
    is_pro = serializers.ReadOnlyField()
    
    class Meta:
        model = User
        fields = [
            'id', 'email', 'first_name', 'last_name', 'full_name', 'avatar',
            'subscription_tier', 'is_pro', 'email_notifications', 'push_notifications',
            'user_timezone', 'is_verified', 'date_joined', 'last_login', 'profile'
        ]
        read_only_fields = ['id', 'email', 'date_joined', 'last_login', 'is_verified']
    
    def update(self, instance, validated_data):
        profile_data = validated_data.pop('profile', None)
        
        # Update user fields
        for attr, value in validated_data.items():
            setattr(instance, attr, value)
        instance.save()
        
        # Update profile if provided
        if profile_data:
            profile, created = UserProfile.objects.get_or_create(user=instance)
            for attr, value in profile_data.items():
                setattr(profile, attr, value)
            profile.save()
        
        return instance
