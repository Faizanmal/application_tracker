from django.contrib import admin
from .models import (
    DataExportRequest,
    GDPRRequest,
    TwoFactorAuth,
    LoginAttempt,
    EncryptedNote,
    SecurityAuditLog,
    PrivacySetting,
)


@admin.register(DataExportRequest)
class DataExportRequestAdmin(admin.ModelAdmin):
    list_display = ['user', 'status', 'format', 'file_size', 'created_at', 'completed_at']
    list_filter = ['status', 'format']
    search_fields = ['user__email']
    readonly_fields = ['created_at', 'completed_at', 'downloaded_at']


@admin.register(GDPRRequest)
class GDPRRequestAdmin(admin.ModelAdmin):
    list_display = ['user_email', 'request_type', 'status', 'due_date', 'created_at']
    list_filter = ['request_type', 'status']
    search_fields = ['user_email']
    readonly_fields = ['created_at', 'completed_at']


@admin.register(TwoFactorAuth)
class TwoFactorAuthAdmin(admin.ModelAdmin):
    list_display = ['user', 'is_enabled', 'primary_method', 'totp_confirmed', 'last_used_at']
    list_filter = ['is_enabled', 'primary_method']
    search_fields = ['user__email']
    readonly_fields = ['totp_secret', 'backup_codes_encrypted']


@admin.register(LoginAttempt)
class LoginAttemptAdmin(admin.ModelAdmin):
    list_display = ['email', 'ip_address', 'successful', 'is_suspicious', 'created_at']
    list_filter = ['successful', 'is_suspicious']
    search_fields = ['email', 'ip_address']
    readonly_fields = ['created_at']


@admin.register(EncryptedNote)
class EncryptedNoteAdmin(admin.ModelAdmin):
    list_display = ['title', 'user', 'category', 'is_pinned', 'created_at']
    list_filter = ['category', 'is_pinned']
    search_fields = ['title', 'user__email']


@admin.register(SecurityAuditLog)
class SecurityAuditLogAdmin(admin.ModelAdmin):
    list_display = ['user_email', 'event_type', 'severity', 'ip_address', 'created_at']
    list_filter = ['event_type', 'severity']
    search_fields = ['user_email', 'description']
    readonly_fields = ['created_at']


@admin.register(PrivacySetting)
class PrivacySettingAdmin(admin.ModelAdmin):
    list_display = ['user', 'allow_analytics', 'allow_ai_training', 'profile_visibility']
    list_filter = ['allow_analytics', 'profile_visibility']
    search_fields = ['user__email']
