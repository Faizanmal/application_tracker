import uuid
import pyotp
from django.db import models
from django.conf import settings


class DataExportRequest(models.Model):
    """GDPR data export requests."""
    
    class ExportStatus(models.TextChoices):
        PENDING = 'pending', 'Pending'
        PROCESSING = 'processing', 'Processing'
        COMPLETED = 'completed', 'Completed'
        FAILED = 'failed', 'Failed'
        EXPIRED = 'expired', 'Expired'
    
    class ExportFormat(models.TextChoices):
        JSON = 'json', 'JSON'
        CSV = 'csv', 'CSV'
        PDF = 'pdf', 'PDF'
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='data_exports'
    )
    
    status = models.CharField(
        max_length=20,
        choices=ExportStatus.choices,
        default=ExportStatus.PENDING
    )
    format = models.CharField(
        max_length=10,
        choices=ExportFormat.choices,
        default=ExportFormat.JSON
    )
    
    # What data to include
    include_applications = models.BooleanField(default=True)
    include_interviews = models.BooleanField(default=True)
    include_contacts = models.BooleanField(default=True)
    include_notes = models.BooleanField(default=True)
    include_analytics = models.BooleanField(default=True)
    include_ai_data = models.BooleanField(default=True)
    
    # File info
    file_path = models.CharField(max_length=500, blank=True)
    file_size = models.BigIntegerField(null=True, blank=True)
    download_url = models.URLField(blank=True)
    download_token = models.CharField(max_length=100, blank=True)
    
    # Expiry
    expires_at = models.DateTimeField(null=True, blank=True)
    downloaded_at = models.DateTimeField(null=True, blank=True)
    
    # Processing
    error_message = models.TextField(blank=True)
    
    created_at = models.DateTimeField(auto_now_add=True)
    completed_at = models.DateTimeField(null=True, blank=True)
    
    class Meta:
        ordering = ['-created_at']
    
    def __str__(self):
        return f"Data Export - {self.user.email} ({self.status})"


class GDPRRequest(models.Model):
    """GDPR-related requests (right to be forgotten, etc.)."""
    
    class RequestType(models.TextChoices):
        DATA_EXPORT = 'export', 'Data Export (Art. 15)'
        DATA_DELETION = 'deletion', 'Data Deletion (Art. 17)'
        DATA_RECTIFICATION = 'rectification', 'Data Rectification (Art. 16)'
        DATA_PORTABILITY = 'portability', 'Data Portability (Art. 20)'
        PROCESSING_RESTRICTION = 'restriction', 'Processing Restriction (Art. 18)'
        OBJECTION = 'objection', 'Objection to Processing (Art. 21)'
    
    class RequestStatus(models.TextChoices):
        SUBMITTED = 'submitted', 'Submitted'
        VERIFICATION_PENDING = 'verification_pending', 'Verification Pending'
        IN_PROGRESS = 'in_progress', 'In Progress'
        COMPLETED = 'completed', 'Completed'
        DENIED = 'denied', 'Denied'
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.SET_NULL,
        null=True,
        related_name='gdpr_requests'
    )
    
    # Keep email even if user is deleted
    user_email = models.EmailField()
    
    request_type = models.CharField(max_length=20, choices=RequestType.choices)
    status = models.CharField(
        max_length=30,
        choices=RequestStatus.choices,
        default=RequestStatus.SUBMITTED
    )
    
    # Request details
    description = models.TextField(blank=True)
    
    # For rectification
    data_to_correct = models.JSONField(default=dict, blank=True)
    
    # Verification
    verification_code = models.CharField(max_length=100, blank=True)
    verified_at = models.DateTimeField(null=True, blank=True)
    verified_by = models.CharField(max_length=100, blank=True)
    
    # Processing
    processed_by = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='processed_gdpr_requests'
    )
    admin_notes = models.TextField(blank=True)
    denial_reason = models.TextField(blank=True)
    
    # Deadlines
    due_date = models.DateField(null=True, blank=True)  # GDPR 30-day deadline
    
    created_at = models.DateTimeField(auto_now_add=True)
    completed_at = models.DateTimeField(null=True, blank=True)
    
    class Meta:
        ordering = ['-created_at']
        verbose_name = 'GDPR Request'
    
    def __str__(self):
        return f"GDPR {self.get_request_type_display()} - {self.user_email}"
    
    def save(self, *args, **kwargs):
        if self.user and not self.user_email:
            self.user_email = self.user.email
        super().save(*args, **kwargs)


class TwoFactorAuth(models.Model):
    """Two-factor authentication configuration."""
    
    class TwoFactorMethod(models.TextChoices):
        TOTP = 'totp', 'Authenticator App (TOTP)'
        SMS = 'sms', 'SMS'
        EMAIL = 'email', 'Email'
        BACKUP_CODES = 'backup', 'Backup Codes'
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.OneToOneField(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='two_factor'
    )
    
    is_enabled = models.BooleanField(default=False)
    primary_method = models.CharField(
        max_length=20,
        choices=TwoFactorMethod.choices,
        default=TwoFactorMethod.TOTP
    )
    
    # TOTP
    totp_secret = models.CharField(max_length=100, blank=True)
    totp_confirmed = models.BooleanField(default=False)
    
    # SMS
    phone_number = models.CharField(max_length=20, blank=True)
    phone_confirmed = models.BooleanField(default=False)
    
    # Backup codes (stored encrypted)
    backup_codes_encrypted = models.TextField(blank=True)
    backup_codes_used = models.JSONField(default=list)
    
    # Recovery
    recovery_email = models.EmailField(blank=True)
    
    # Session tracking
    last_used_at = models.DateTimeField(null=True, blank=True)
    trusted_devices = models.JSONField(default=list)
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        verbose_name = 'Two-Factor Authentication'
    
    def __str__(self):
        status = "enabled" if self.is_enabled else "disabled"
        return f"2FA for {self.user.email} - {status}"
    
    def generate_totp_secret(self):
        """Generate a new TOTP secret."""
        self.totp_secret = pyotp.random_base32()
        self.totp_confirmed = False
        return self.totp_secret
    
    def get_totp_uri(self):
        """Get the TOTP provisioning URI for QR code."""
        if not self.totp_secret:
            return None
        totp = pyotp.TOTP(self.totp_secret)
        return totp.provisioning_uri(
            name=self.user.email,
            issuer_name="JobScouter"
        )
    
    def verify_totp(self, code):
        """Verify a TOTP code."""
        if not self.totp_secret:
            return False
        totp = pyotp.TOTP(self.totp_secret)
        return totp.verify(code, valid_window=1)  # Allow 30-second window
    
    def generate_backup_codes(self, count=10):
        """Generate backup codes."""
        import secrets
        codes = [secrets.token_hex(4).upper() for _ in range(count)]
        
        # Encrypt and store
        # In production, use proper encryption
        self.backup_codes_encrypted = ','.join(codes)
        self.backup_codes_used = []
        return codes
    
    def verify_backup_code(self, code):
        """Verify and consume a backup code."""
        if not self.backup_codes_encrypted:
            return False
        
        codes = self.backup_codes_encrypted.split(',')
        code_upper = code.upper().replace('-', '')
        
        if code_upper in codes and code_upper not in self.backup_codes_used:
            self.backup_codes_used.append(code_upper)
            self.save()
            return True
        return False


class LoginAttempt(models.Model):
    """Track login attempts for security."""
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    
    email = models.EmailField(db_index=True)
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='login_attempts'
    )
    
    ip_address = models.GenericIPAddressField()
    user_agent = models.TextField(blank=True)
    
    successful = models.BooleanField()
    failure_reason = models.CharField(max_length=100, blank=True)
    
    # Location (from IP)
    country = models.CharField(max_length=100, blank=True)
    city = models.CharField(max_length=100, blank=True)
    
    # Flags
    is_suspicious = models.BooleanField(default=False)
    suspicious_reason = models.CharField(max_length=200, blank=True)
    
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        ordering = ['-created_at']
        indexes = [
            models.Index(fields=['email', 'created_at']),
            models.Index(fields=['ip_address', 'created_at']),
        ]
    
    def __str__(self):
        status = "success" if self.successful else "failed"
        return f"Login {status} - {self.email} from {self.ip_address}"


class EncryptedNote(models.Model):
    """End-to-end encrypted notes."""
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='encrypted_notes'
    )
    
    # Application or general note
    application = models.ForeignKey(
        'applications.JobApplication',
        on_delete=models.CASCADE,
        null=True,
        blank=True,
        related_name='encrypted_notes'
    )
    
    title = models.CharField(max_length=200)
    
    # Encrypted content (client-side encrypted)
    encrypted_content = models.TextField()
    
    # Metadata (unencrypted)
    category = models.CharField(max_length=50, blank=True)
    tags = models.JSONField(default=list)
    
    # Encryption info
    encryption_version = models.CharField(max_length=20, default='v1')
    iv = models.CharField(max_length=100, blank=True)  # Initialization vector
    
    is_pinned = models.BooleanField(default=False)
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        ordering = ['-is_pinned', '-updated_at']
    
    def __str__(self):
        return f"Encrypted Note: {self.title}"


class SecurityAuditLog(models.Model):
    """Security audit log for compliance."""
    
    class EventType(models.TextChoices):
        LOGIN = 'login', 'Login'
        LOGOUT = 'logout', 'Logout'
        PASSWORD_CHANGE = 'password_change', 'Password Change'
        EMAIL_CHANGE = 'email_change', 'Email Change'
        TWO_FA_ENABLED = '2fa_enabled', '2FA Enabled'
        TWO_FA_DISABLED = '2fa_disabled', '2FA Disabled'
        DATA_EXPORT = 'data_export', 'Data Export'
        DATA_DELETION = 'data_deletion', 'Data Deletion'
        PERMISSION_CHANGE = 'permission_change', 'Permission Change'
        API_KEY_CREATED = 'api_key_created', 'API Key Created'
        API_KEY_REVOKED = 'api_key_revoked', 'API Key Revoked'
        SUSPICIOUS_ACTIVITY = 'suspicious', 'Suspicious Activity'
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.SET_NULL,
        null=True,
        related_name='security_audit_logs'
    )
    user_email = models.EmailField()  # Preserved even if user deleted
    
    event_type = models.CharField(max_length=30, choices=EventType.choices)
    
    # Event details
    description = models.TextField()
    details = models.JSONField(default=dict)
    
    # Request info
    ip_address = models.GenericIPAddressField(null=True, blank=True)
    user_agent = models.TextField(blank=True)
    
    # Severity
    severity = models.CharField(max_length=20, default='info')  # info, warning, critical
    
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        ordering = ['-created_at']
        verbose_name = 'Security Audit Log'
        indexes = [
            models.Index(fields=['user', 'event_type']),
            models.Index(fields=['created_at']),
        ]
    
    def __str__(self):
        return f"{self.event_type} - {self.user_email} at {self.created_at}"
    
    def save(self, *args, **kwargs):
        if self.user and not self.user_email:
            self.user_email = self.user.email
        super().save(*args, **kwargs)


class PrivacySetting(models.Model):
    """User privacy settings and preferences."""
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.OneToOneField(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='privacy_settings'
    )
    
    # Data collection
    allow_analytics = models.BooleanField(default=True)
    allow_ai_training = models.BooleanField(default=False)
    allow_personalization = models.BooleanField(default=True)
    
    # Communication
    allow_marketing_emails = models.BooleanField(default=False)
    allow_product_updates = models.BooleanField(default=True)
    allow_tips_emails = models.BooleanField(default=True)
    
    # Visibility (for community features)
    profile_visibility = models.CharField(
        max_length=20,
        default='private',
        choices=[
            ('private', 'Private'),
            ('connections', 'Connections Only'),
            ('public', 'Public'),
        ]
    )
    show_in_leaderboards = models.BooleanField(default=True)
    allow_anonymous_posts = models.BooleanField(default=True)
    
    # Session settings
    session_timeout_minutes = models.PositiveIntegerField(default=1440)  # 24 hours
    logout_on_inactivity = models.BooleanField(default=False)
    
    # Data retention
    auto_delete_rejected_after_days = models.PositiveIntegerField(null=True, blank=True)
    
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        verbose_name = 'Privacy Setting'
    
    def __str__(self):
        return f"Privacy Settings - {self.user.email}"
