from django.contrib import admin
from .models import (
    EmailIntegration,
    TrackedEmail,
    CalendarIntegration,
    CalendarEvent,
    LinkedInIntegration,
    LinkedInOutreach,
    AutomatedFollowUp,
    SlackIntegration,
    DiscordIntegration,
    ZapierWebhook,
    APIKey,
)


@admin.register(EmailIntegration)
class EmailIntegrationAdmin(admin.ModelAdmin):
    list_display = ['user', 'provider', 'email_address', 'is_active', 'last_sync']
    list_filter = ['provider', 'is_active']
    search_fields = ['user__email', 'email_address']


@admin.register(TrackedEmail)
class TrackedEmailAdmin(admin.ModelAdmin):
    list_display = ['subject', 'sender', 'direction', 'email_type', 'received_at']
    list_filter = ['direction', 'email_type']
    search_fields = ['subject', 'sender']
    date_hierarchy = 'received_at'


@admin.register(CalendarIntegration)
class CalendarIntegrationAdmin(admin.ModelAdmin):
    list_display = ['user', 'provider', 'calendar_name', 'is_active', 'last_sync']
    list_filter = ['provider', 'is_active']


@admin.register(CalendarEvent)
class CalendarEventAdmin(admin.ModelAdmin):
    list_display = ['title', 'start_time', 'end_time', 'interview', 'reminder']
    date_hierarchy = 'start_time'


@admin.register(LinkedInIntegration)
class LinkedInIntegrationAdmin(admin.ModelAdmin):
    list_display = ['user', 'linkedin_id', 'is_active', 'connections_count', 'last_sync']


@admin.register(LinkedInOutreach)
class LinkedInOutreachAdmin(admin.ModelAdmin):
    list_display = ['target_name', 'target_company', 'status', 'user', 'created_at']
    list_filter = ['status']
    search_fields = ['target_name', 'target_company']


@admin.register(AutomatedFollowUp)
class AutomatedFollowUpAdmin(admin.ModelAdmin):
    list_display = ['application', 'status', 'scheduled_for', 'is_ai_generated']
    list_filter = ['status', 'is_ai_generated']
    date_hierarchy = 'scheduled_for'


@admin.register(SlackIntegration)
class SlackIntegrationAdmin(admin.ModelAdmin):
    list_display = ['user', 'workspace_name', 'channel_name', 'is_active']
    list_filter = ['is_active']


@admin.register(DiscordIntegration)
class DiscordIntegrationAdmin(admin.ModelAdmin):
    list_display = ['user', 'guild_name', 'channel_name', 'is_active']
    list_filter = ['is_active']


@admin.register(ZapierWebhook)
class ZapierWebhookAdmin(admin.ModelAdmin):
    list_display = ['name', 'event_type', 'is_active', 'trigger_count', 'last_triggered']
    list_filter = ['event_type', 'is_active']


@admin.register(APIKey)
class APIKeyAdmin(admin.ModelAdmin):
    list_display = ['name', 'user', 'is_active', 'last_used', 'total_requests']
    list_filter = ['is_active']
    search_fields = ['name', 'user__email']
