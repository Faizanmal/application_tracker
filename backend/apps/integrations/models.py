import uuid
from django.db import models
from django.conf import settings


class EmailIntegration(models.Model):
    """Email integration for Gmail/Outlook."""
    
    class Provider(models.TextChoices):
        GMAIL = 'gmail', 'Gmail'
        OUTLOOK = 'outlook', 'Outlook'
        OTHER = 'other', 'Other IMAP'
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='email_integrations'
    )
    
    provider = models.CharField(
        max_length=20,
        choices=Provider.choices
    )
    email_address = models.EmailField()
    
    # OAuth tokens (encrypted in production)
    access_token = models.TextField(blank=True)
    refresh_token = models.TextField(blank=True)
    token_expires_at = models.DateTimeField(null=True, blank=True)
    
    # Sync settings
    is_active = models.BooleanField(default=True)
    auto_track = models.BooleanField(default=True)  # Auto-link emails to applications
    last_sync = models.DateTimeField(null=True, blank=True)
    sync_from_date = models.DateField(null=True, blank=True)
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        unique_together = ['user', 'email_address']
    
    def __str__(self):
        return f"{self.user.email} - {self.provider}"


class TrackedEmail(models.Model):
    """Emails tracked from integrations."""
    
    class Direction(models.TextChoices):
        INBOUND = 'inbound', 'Inbound'
        OUTBOUND = 'outbound', 'Outbound'
    
    class EmailType(models.TextChoices):
        APPLICATION = 'application', 'Application Confirmation'
        REJECTION = 'rejection', 'Rejection'
        INTERVIEW = 'interview', 'Interview Related'
        OFFER = 'offer', 'Offer'
        FOLLOW_UP = 'follow_up', 'Follow Up'
        OTHER = 'other', 'Other'
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    integration = models.ForeignKey(
        EmailIntegration,
        on_delete=models.CASCADE,
        related_name='tracked_emails'
    )
    
    # Email details
    message_id = models.CharField(max_length=255, unique=True)
    thread_id = models.CharField(max_length=255, blank=True)
    subject = models.CharField(max_length=500)
    sender = models.EmailField()
    recipients = models.JSONField(default=list)
    
    direction = models.CharField(
        max_length=20,
        choices=Direction.choices
    )
    email_type = models.CharField(
        max_length=20,
        choices=EmailType.choices,
        default=EmailType.OTHER
    )
    
    # Content
    body_preview = models.TextField(blank=True)  # First 500 chars
    has_attachments = models.BooleanField(default=False)
    
    # Linked application
    application = models.ForeignKey(
        'applications.JobApplication',
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='tracked_emails'
    )
    
    # AI classification confidence
    ai_confidence = models.DecimalField(
        max_digits=5,
        decimal_places=2,
        null=True,
        blank=True
    )
    
    received_at = models.DateTimeField()
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        ordering = ['-received_at']
    
    def __str__(self):
        return f"{self.subject} - {self.sender}"


class CalendarIntegration(models.Model):
    """Calendar integration for Google/Outlook calendars."""
    
    class Provider(models.TextChoices):
        GOOGLE = 'google', 'Google Calendar'
        OUTLOOK = 'outlook', 'Outlook Calendar'
        APPLE = 'apple', 'Apple Calendar'
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='calendar_integrations'
    )
    
    provider = models.CharField(
        max_length=20,
        choices=Provider.choices
    )
    calendar_id = models.CharField(max_length=255)
    calendar_name = models.CharField(max_length=200, blank=True)
    
    # OAuth tokens
    access_token = models.TextField(blank=True)
    refresh_token = models.TextField(blank=True)
    token_expires_at = models.DateTimeField(null=True, blank=True)
    
    # Sync settings
    is_active = models.BooleanField(default=True)
    sync_interviews = models.BooleanField(default=True)
    sync_reminders = models.BooleanField(default=True)
    last_sync = models.DateTimeField(null=True, blank=True)
    
    # Watch for changes (webhooks)
    watch_channel_id = models.CharField(max_length=255, blank=True)
    watch_expires_at = models.DateTimeField(null=True, blank=True)
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        unique_together = ['user', 'provider', 'calendar_id']
    
    def __str__(self):
        return f"{self.user.email} - {self.provider}"


class CalendarEvent(models.Model):
    """Synced calendar events."""
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    integration = models.ForeignKey(
        CalendarIntegration,
        on_delete=models.CASCADE,
        related_name='events'
    )
    
    # External event ID
    external_event_id = models.CharField(max_length=255)
    
    # Event details
    title = models.CharField(max_length=500)
    description = models.TextField(blank=True)
    location = models.CharField(max_length=500, blank=True)
    
    start_time = models.DateTimeField()
    end_time = models.DateTimeField()
    is_all_day = models.BooleanField(default=False)
    
    # Linked entities
    interview = models.ForeignKey(
        'interviews.Interview',
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='calendar_events'
    )
    reminder = models.ForeignKey(
        'reminders.Reminder',
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='calendar_events'
    )
    
    # Sync metadata
    synced_at = models.DateTimeField(auto_now=True)
    external_updated_at = models.DateTimeField(null=True, blank=True)
    
    class Meta:
        unique_together = ['integration', 'external_event_id']
        ordering = ['start_time']
    
    def __str__(self):
        return self.title


class LinkedInIntegration(models.Model):
    """LinkedIn integration for connections and outreach tracking."""
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.OneToOneField(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='linkedin_integration'
    )
    
    linkedin_id = models.CharField(max_length=100)
    profile_url = models.URLField()
    
    # OAuth tokens
    access_token = models.TextField(blank=True)
    token_expires_at = models.DateTimeField(null=True, blank=True)
    
    # Sync settings
    is_active = models.BooleanField(default=True)
    last_sync = models.DateTimeField(null=True, blank=True)
    connections_count = models.PositiveIntegerField(default=0)
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    def __str__(self):
        return f"LinkedIn - {self.user.email}"


class LinkedInOutreach(models.Model):
    """Track LinkedIn outreach activities."""
    
    class Status(models.TextChoices):
        PENDING = 'pending', 'Pending'
        SENT = 'sent', 'Sent'
        CONNECTED = 'connected', 'Connected'
        REPLIED = 'replied', 'Replied'
        NO_RESPONSE = 'no_response', 'No Response'
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='linkedin_outreach'
    )
    
    # Target person
    target_name = models.CharField(max_length=200)
    target_profile_url = models.URLField()
    target_title = models.CharField(max_length=200, blank=True)
    target_company = models.CharField(max_length=200, blank=True)
    
    # Status
    status = models.CharField(
        max_length=20,
        choices=Status.choices,
        default=Status.PENDING
    )
    
    # Connection to networking
    connection = models.ForeignKey(
        'networking.ProfessionalConnection',
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='linkedin_outreach'
    )
    
    # Application context
    application = models.ForeignKey(
        'applications.JobApplication',
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='linkedin_outreach'
    )
    
    # Messages
    connection_message = models.TextField(blank=True)
    follow_up_message = models.TextField(blank=True)
    
    # Dates
    sent_at = models.DateTimeField(null=True, blank=True)
    connected_at = models.DateTimeField(null=True, blank=True)
    replied_at = models.DateTimeField(null=True, blank=True)
    
    notes = models.TextField(blank=True)
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        ordering = ['-created_at']
    
    def __str__(self):
        return f"Outreach to {self.target_name}"


class AutomatedFollowUp(models.Model):
    """Automated follow-up scheduling."""
    
    class Status(models.TextChoices):
        SCHEDULED = 'scheduled', 'Scheduled'
        SENT = 'sent', 'Sent'
        CANCELLED = 'cancelled', 'Cancelled'
        FAILED = 'failed', 'Failed'
    
    class TriggerType(models.TextChoices):
        DAYS_AFTER_APPLICATION = 'days_after_app', 'Days After Application'
        DAYS_AFTER_INTERVIEW = 'days_after_interview', 'Days After Interview'
        NO_RESPONSE = 'no_response', 'No Response Timeout'
        CUSTOM_DATE = 'custom_date', 'Custom Date'
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='automated_followups'
    )
    
    # Linked application
    application = models.ForeignKey(
        'applications.JobApplication',
        on_delete=models.CASCADE,
        related_name='automated_followups'
    )
    
    # Trigger
    trigger_type = models.CharField(
        max_length=30,
        choices=TriggerType.choices
    )
    trigger_days = models.PositiveIntegerField(default=7)
    
    # Email content
    subject = models.CharField(max_length=200)
    body = models.TextField()
    
    # Recipient
    recipient_email = models.EmailField()
    recipient_name = models.CharField(max_length=200, blank=True)
    
    # Status
    status = models.CharField(
        max_length=20,
        choices=Status.choices,
        default=Status.SCHEDULED
    )
    scheduled_for = models.DateTimeField()
    sent_at = models.DateTimeField(null=True, blank=True)
    
    # AI generated
    is_ai_generated = models.BooleanField(default=False)
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        ordering = ['scheduled_for']
    
    def __str__(self):
        return f"Follow-up for {self.application.company_name}"


class SlackIntegration(models.Model):
    """Slack workspace integration."""
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='slack_integrations'
    )
    
    workspace_id = models.CharField(max_length=100)
    workspace_name = models.CharField(max_length=200)
    channel_id = models.CharField(max_length=100)
    channel_name = models.CharField(max_length=200)
    
    # OAuth
    access_token = models.TextField()
    bot_user_id = models.CharField(max_length=100, blank=True)
    
    # Notification settings
    notify_applications = models.BooleanField(default=True)
    notify_interviews = models.BooleanField(default=True)
    notify_status_changes = models.BooleanField(default=True)
    notify_reminders = models.BooleanField(default=True)
    
    is_active = models.BooleanField(default=True)
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        unique_together = ['user', 'workspace_id', 'channel_id']
    
    def __str__(self):
        return f"{self.workspace_name} - #{self.channel_name}"


class DiscordIntegration(models.Model):
    """Discord server integration."""
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='discord_integrations'
    )
    
    guild_id = models.CharField(max_length=100)
    guild_name = models.CharField(max_length=200)
    channel_id = models.CharField(max_length=100)
    channel_name = models.CharField(max_length=200)
    
    # Webhook
    webhook_url = models.URLField()
    
    # Notification settings
    notify_applications = models.BooleanField(default=True)
    notify_interviews = models.BooleanField(default=True)
    notify_status_changes = models.BooleanField(default=True)
    
    is_active = models.BooleanField(default=True)
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    def __str__(self):
        return f"{self.guild_name} - #{self.channel_name}"


class ZapierWebhook(models.Model):
    """Zapier webhook integrations."""
    
    class EventType(models.TextChoices):
        APPLICATION_CREATED = 'application_created', 'Application Created'
        STATUS_CHANGED = 'status_changed', 'Status Changed'
        INTERVIEW_SCHEDULED = 'interview_scheduled', 'Interview Scheduled'
        OFFER_RECEIVED = 'offer_received', 'Offer Received'
        CUSTOM = 'custom', 'Custom Event'
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='zapier_webhooks'
    )
    
    name = models.CharField(max_length=200)
    webhook_url = models.URLField()
    
    event_type = models.CharField(
        max_length=30,
        choices=EventType.choices
    )
    
    # Optional filters
    filters = models.JSONField(default=dict, blank=True)  # e.g., {"status": "offer"}
    
    is_active = models.BooleanField(default=True)
    last_triggered = models.DateTimeField(null=True, blank=True)
    trigger_count = models.PositiveIntegerField(default=0)
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    def __str__(self):
        return f"{self.name} - {self.event_type}"


class APIKey(models.Model):
    """API keys for third-party integrations."""
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='api_keys'
    )
    
    name = models.CharField(max_length=100)
    key = models.CharField(max_length=64, unique=True)
    
    # Permissions
    can_read = models.BooleanField(default=True)
    can_write = models.BooleanField(default=False)
    can_delete = models.BooleanField(default=False)
    
    # Allowed endpoints (empty = all)
    allowed_endpoints = models.JSONField(default=list, blank=True)
    
    # Rate limiting
    rate_limit_per_hour = models.PositiveIntegerField(default=1000)
    
    # Usage tracking
    last_used = models.DateTimeField(null=True, blank=True)
    total_requests = models.PositiveIntegerField(default=0)
    
    # Expiration
    expires_at = models.DateTimeField(null=True, blank=True)
    is_active = models.BooleanField(default=True)
    
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        ordering = ['-created_at']
    
    def __str__(self):
        return f"{self.name} - {self.user.email}"
