from rest_framework import serializers
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


class EmailIntegrationSerializer(serializers.ModelSerializer):
    """Serializer for EmailIntegration."""
    
    class Meta:
        model = EmailIntegration
        fields = [
            'id', 'provider', 'email_address', 'is_active',
            'auto_track', 'last_sync', 'sync_from_date',
            'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'last_sync', 'created_at', 'updated_at']


class TrackedEmailSerializer(serializers.ModelSerializer):
    """Serializer for TrackedEmail."""
    application_title = serializers.CharField(source='application.job_title', read_only=True)
    
    class Meta:
        model = TrackedEmail
        fields = [
            'id', 'integration', 'message_id', 'thread_id',
            'subject', 'sender', 'recipients', 'direction',
            'email_type', 'body_preview', 'has_attachments',
            'application', 'application_title', 'ai_confidence',
            'received_at', 'created_at'
        ]
        read_only_fields = ['id', 'created_at']


class CalendarIntegrationSerializer(serializers.ModelSerializer):
    """Serializer for CalendarIntegration."""
    events_count = serializers.SerializerMethodField()
    
    class Meta:
        model = CalendarIntegration
        fields = [
            'id', 'provider', 'calendar_id', 'calendar_name',
            'is_active', 'sync_interviews', 'sync_reminders',
            'last_sync', 'events_count', 'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'last_sync', 'created_at', 'updated_at']
    
    def get_events_count(self, obj):
        return obj.events.count()


class CalendarEventSerializer(serializers.ModelSerializer):
    """Serializer for CalendarEvent."""
    
    class Meta:
        model = CalendarEvent
        fields = [
            'id', 'integration', 'external_event_id', 'title',
            'description', 'location', 'start_time', 'end_time',
            'is_all_day', 'interview', 'reminder', 'synced_at'
        ]
        read_only_fields = ['id', 'synced_at']


class LinkedInIntegrationSerializer(serializers.ModelSerializer):
    """Serializer for LinkedInIntegration."""
    
    class Meta:
        model = LinkedInIntegration
        fields = [
            'id', 'linkedin_id', 'profile_url', 'is_active',
            'last_sync', 'connections_count', 'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'last_sync', 'connections_count', 'created_at', 'updated_at']


class LinkedInOutreachSerializer(serializers.ModelSerializer):
    """Serializer for LinkedInOutreach."""
    
    class Meta:
        model = LinkedInOutreach
        fields = [
            'id', 'target_name', 'target_profile_url', 'target_title',
            'target_company', 'status', 'connection', 'application',
            'connection_message', 'follow_up_message', 'sent_at',
            'connected_at', 'replied_at', 'notes', 'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'created_at', 'updated_at']


class AutomatedFollowUpSerializer(serializers.ModelSerializer):
    """Serializer for AutomatedFollowUp."""
    application_company = serializers.CharField(source='application.company_name', read_only=True)
    
    class Meta:
        model = AutomatedFollowUp
        fields = [
            'id', 'application', 'application_company', 'trigger_type',
            'trigger_days', 'subject', 'body', 'recipient_email',
            'recipient_name', 'status', 'scheduled_for', 'sent_at',
            'is_ai_generated', 'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'sent_at', 'created_at', 'updated_at']


class SlackIntegrationSerializer(serializers.ModelSerializer):
    """Serializer for SlackIntegration."""
    
    class Meta:
        model = SlackIntegration
        fields = [
            'id', 'workspace_id', 'workspace_name', 'channel_id',
            'channel_name', 'notify_applications', 'notify_interviews',
            'notify_status_changes', 'notify_reminders', 'is_active',
            'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'workspace_id', 'workspace_name', 'channel_id', 'channel_name', 'created_at', 'updated_at']


class DiscordIntegrationSerializer(serializers.ModelSerializer):
    """Serializer for DiscordIntegration."""
    
    class Meta:
        model = DiscordIntegration
        fields = [
            'id', 'guild_id', 'guild_name', 'channel_id', 'channel_name',
            'webhook_url', 'notify_applications', 'notify_interviews',
            'notify_status_changes', 'is_active', 'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'created_at', 'updated_at']


class ZapierWebhookSerializer(serializers.ModelSerializer):
    """Serializer for ZapierWebhook."""
    
    class Meta:
        model = ZapierWebhook
        fields = [
            'id', 'name', 'webhook_url', 'event_type', 'filters',
            'is_active', 'last_triggered', 'trigger_count',
            'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'last_triggered', 'trigger_count', 'created_at', 'updated_at']


class APIKeySerializer(serializers.ModelSerializer):
    """Serializer for APIKey."""
    
    class Meta:
        model = APIKey
        fields = [
            'id', 'name', 'key', 'can_read', 'can_write', 'can_delete',
            'allowed_endpoints', 'rate_limit_per_hour', 'last_used',
            'total_requests', 'expires_at', 'is_active', 'created_at'
        ]
        read_only_fields = ['id', 'key', 'last_used', 'total_requests', 'created_at']
    
    def to_representation(self, instance):
        data = super().to_representation(instance)
        # Mask the key after creation
        if self.context.get('hide_key', True) and 'key' in data:
            data['key'] = data['key'][:8] + '...' + data['key'][-4:]
        return data
