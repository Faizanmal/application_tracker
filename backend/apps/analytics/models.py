import uuid
from django.db import models
from django.conf import settings


class DailyStats(models.Model):
    """Daily statistics for user activity."""
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='daily_stats'
    )
    date = models.DateField()
    
    # Application stats
    applications_added = models.PositiveIntegerField(default=0)
    applications_updated = models.PositiveIntegerField(default=0)
    
    # Interview stats
    interviews_scheduled = models.PositiveIntegerField(default=0)
    interviews_completed = models.PositiveIntegerField(default=0)
    
    # Status changes
    rejections_received = models.PositiveIntegerField(default=0)
    offers_received = models.PositiveIntegerField(default=0)
    
    # Engagement
    follow_ups_sent = models.PositiveIntegerField(default=0)
    
    class Meta:
        unique_together = ['user', 'date']
        ordering = ['-date']
    
    def __str__(self):
        return f"{self.user.email} - {self.date}"


class WeeklyDigest(models.Model):
    """Weekly digest summary for users."""
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='weekly_digests'
    )
    
    week_start = models.DateField()
    week_end = models.DateField()
    
    # Summary
    total_applications = models.PositiveIntegerField(default=0)
    new_applications = models.PositiveIntegerField(default=0)
    interviews_scheduled = models.PositiveIntegerField(default=0)
    interviews_completed = models.PositiveIntegerField(default=0)
    rejections = models.PositiveIntegerField(default=0)
    offers = models.PositiveIntegerField(default=0)
    
    # Rates
    response_rate = models.DecimalField(max_digits=5, decimal_places=2, null=True, blank=True)
    interview_rate = models.DecimalField(max_digits=5, decimal_places=2, null=True, blank=True)
    
    # Email sent
    sent_at = models.DateTimeField(null=True, blank=True)
    
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        unique_together = ['user', 'week_start']
        ordering = ['-week_start']
    
    def __str__(self):
        return f"{self.user.email} - Week of {self.week_start}"
