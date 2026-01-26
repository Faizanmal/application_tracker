from rest_framework import serializers
from .models import (
    DataExportRequest,
    GDPRRequest,
    TwoFactorAuth,
    LoginAttempt,
    EncryptedNote,
    SecurityAuditLog,
    PrivacySetting,
)


class DataExportRequestSerializer(serializers.ModelSerializer):
    """Serializer for DataExportRequest."""
    
    class Meta:
        model = DataExportRequest
        fields = [
            'id', 'status', 'format',
            'include_applications', 'include_interviews', 'include_contacts',
            'include_notes', 'include_analytics', 'include_ai_data',
            'file_size', 'download_url', 'expires_at', 'downloaded_at',
            'created_at', 'completed_at'
        ]
        read_only_fields = [
            'id', 'status', 'file_size', 'download_url',
            'expires_at', 'downloaded_at', 'created_at', 'completed_at'
        ]


class GDPRRequestSerializer(serializers.ModelSerializer):
    """Serializer for GDPRRequest."""
    request_type_display = serializers.CharField(
        source='get_request_type_display',
        read_only=True
    )
    status_display = serializers.CharField(
        source='get_status_display',
        read_only=True
    )
    
    class Meta:
        model = GDPRRequest
        fields = [
            'id', 'request_type', 'request_type_display',
            'status', 'status_display', 'description',
            'data_to_correct', 'due_date',
            'created_at', 'completed_at'
        ]
        read_only_fields = ['id', 'status', 'due_date', 'created_at', 'completed_at']


class TwoFactorAuthSerializer(serializers.ModelSerializer):
    """Serializer for TwoFactorAuth."""
    backup_codes_remaining = serializers.SerializerMethodField()
    
    class Meta:
        model = TwoFactorAuth
        fields = [
            'id', 'is_enabled', 'primary_method',
            'totp_confirmed', 'phone_confirmed',
            'backup_codes_remaining', 'recovery_email',
            'last_used_at', 'created_at'
        ]
        read_only_fields = [
            'id', 'is_enabled', 'totp_confirmed', 'phone_confirmed',
            'backup_codes_remaining', 'last_used_at', 'created_at'
        ]
    
    def get_backup_codes_remaining(self, obj):
        if not obj.backup_codes_encrypted:
            return 0
        total = len(obj.backup_codes_encrypted.split(','))
        used = len(obj.backup_codes_used)
        return total - used


class TwoFactorSetupSerializer(serializers.Serializer):
    """Serializer for 2FA setup process."""
    method = serializers.ChoiceField(choices=TwoFactorAuth.TwoFactorMethod.choices)
    phone_number = serializers.CharField(required=False, allow_blank=True)
    recovery_email = serializers.EmailField(required=False, allow_blank=True)


class TwoFactorVerifySerializer(serializers.Serializer):
    """Serializer for verifying 2FA codes."""
    code = serializers.CharField(min_length=6, max_length=10)
    use_backup = serializers.BooleanField(default=False)


class LoginAttemptSerializer(serializers.ModelSerializer):
    """Serializer for LoginAttempt."""
    
    class Meta:
        model = LoginAttempt
        fields = [
            'id', 'ip_address', 'user_agent',
            'successful', 'failure_reason',
            'country', 'city',
            'is_suspicious', 'suspicious_reason',
            'created_at'
        ]


class EncryptedNoteSerializer(serializers.ModelSerializer):
    """Serializer for EncryptedNote."""
    
    class Meta:
        model = EncryptedNote
        fields = [
            'id', 'application', 'title',
            'encrypted_content', 'category', 'tags',
            'encryption_version', 'iv', 'is_pinned',
            'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'created_at', 'updated_at']


class SecurityAuditLogSerializer(serializers.ModelSerializer):
    """Serializer for SecurityAuditLog."""
    event_type_display = serializers.CharField(
        source='get_event_type_display',
        read_only=True
    )
    
    class Meta:
        model = SecurityAuditLog
        fields = [
            'id', 'event_type', 'event_type_display',
            'description', 'details',
            'ip_address', 'severity', 'created_at'
        ]


class PrivacySettingSerializer(serializers.ModelSerializer):
    """Serializer for PrivacySetting."""
    
    class Meta:
        model = PrivacySetting
        fields = [
            'id', 'allow_analytics', 'allow_ai_training', 'allow_personalization',
            'allow_marketing_emails', 'allow_product_updates', 'allow_tips_emails',
            'profile_visibility', 'show_in_leaderboards', 'allow_anonymous_posts',
            'session_timeout_minutes', 'logout_on_inactivity',
            'auto_delete_rejected_after_days', 'updated_at'
        ]
        read_only_fields = ['id', 'updated_at']
