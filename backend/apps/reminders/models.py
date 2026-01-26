import uuid
from django.db import models
from django.conf import settings


class Reminder(models.Model):
    """Model for follow-up reminders."""
    
    class ReminderType(models.TextChoices):
        FOLLOW_UP = 'follow_up', 'Follow Up'
        INTERVIEW_PREP = 'interview_prep', 'Interview Prep'
        APPLICATION_DEADLINE = 'application_deadline', 'Application Deadline'
        CHECK_STATUS = 'check_status', 'Check Status'
        SEND_THANK_YOU = 'send_thank_you', 'Send Thank You'
        CUSTOM = 'custom', 'Custom'
    
    class Status(models.TextChoices):
        PENDING = 'pending', 'Pending'
        SENT = 'sent', 'Sent'
        COMPLETED = 'completed', 'Completed'
        SNOOZED = 'snoozed', 'Snoozed'
        CANCELLED = 'cancelled', 'Cancelled'
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='reminders'
    )
    application = models.ForeignKey(
        'applications.JobApplication',
        on_delete=models.CASCADE,
        related_name='reminders',
        null=True,
        blank=True
    )
    interview = models.ForeignKey(
        'interviews.Interview',
        on_delete=models.CASCADE,
        related_name='reminders',
        null=True,
        blank=True
    )
    
    # Reminder Details
    reminder_type = models.CharField(
        max_length=30,
        choices=ReminderType.choices,
        default=ReminderType.FOLLOW_UP
    )
    title = models.CharField(max_length=200)
    description = models.TextField(blank=True)
    
    # Scheduling
    scheduled_at = models.DateTimeField()
    
    # Status
    status = models.CharField(
        max_length=20,
        choices=Status.choices,
        default=Status.PENDING
    )
    
    # Notification preferences
    send_email = models.BooleanField(default=True)
    send_push = models.BooleanField(default=True)
    
    # Snooze
    snoozed_until = models.DateTimeField(null=True, blank=True)
    snooze_count = models.PositiveIntegerField(default=0)
    
    # Timestamps
    sent_at = models.DateTimeField(null=True, blank=True)
    completed_at = models.DateTimeField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        ordering = ['scheduled_at']
        indexes = [
            models.Index(fields=['user', 'status', 'scheduled_at']),
        ]
    
    def __str__(self):
        return f"{self.title} - {self.scheduled_at}"


class Notification(models.Model):
    """In-app notifications."""
    
    class NotificationType(models.TextChoices):
        REMINDER = 'reminder', 'Reminder'
        APPLICATION_UPDATE = 'application_update', 'Application Update'
        INTERVIEW_REMINDER = 'interview_reminder', 'Interview Reminder'
        SYSTEM = 'system', 'System'
        TIP = 'tip', 'Tip'
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='notifications'
    )
    
    notification_type = models.CharField(
        max_length=30,
        choices=NotificationType.choices
    )
    title = models.CharField(max_length=200)
    message = models.TextField()
    
    # Related objects
    application = models.ForeignKey(
        'applications.JobApplication',
        on_delete=models.CASCADE,
        null=True,
        blank=True
    )
    interview = models.ForeignKey(
        'interviews.Interview',
        on_delete=models.CASCADE,
        null=True,
        blank=True
    )
    reminder = models.ForeignKey(
        Reminder,
        on_delete=models.CASCADE,
        null=True,
        blank=True
    )
    
    # Link
    action_url = models.CharField(max_length=500, blank=True)
    
    # Status
    is_read = models.BooleanField(default=False)
    read_at = models.DateTimeField(null=True, blank=True)
    
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        ordering = ['-created_at']
    
    def __str__(self):
        return f"{self.title} - {self.user.email}"


class ReminderTemplate(models.Model):
    """Templates for auto-generating reminders."""
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='reminder_templates',
        null=True,
        blank=True
    )
    
    name = models.CharField(max_length=100)
    reminder_type = models.CharField(
        max_length=30,
        choices=Reminder.ReminderType.choices
    )
    
    # Trigger
    trigger_event = models.CharField(max_length=50)  # 'after_apply', 'after_interview', etc.
    days_offset = models.IntegerField(default=7)  # Days after trigger
    
    # Template
    title_template = models.CharField(max_length=200)
    description_template = models.TextField(blank=True)
    
    # Settings
    is_active = models.BooleanField(default=True)
    is_default = models.BooleanField(default=False)  # System defaults
    
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        ordering = ['name']
    
    def __str__(self):
        return self.name
