from rest_framework import serializers
from .models import Reminder, Notification, ReminderTemplate


class ReminderSerializer(serializers.ModelSerializer):
    """Serializer for reminders."""
    
    application_company = serializers.CharField(
        source='application.company_name',
        read_only=True,
        allow_null=True
    )
    application_job_title = serializers.CharField(
        source='application.job_title',
        read_only=True,
        allow_null=True
    )
    
    class Meta:
        model = Reminder
        fields = [
            'id', 'application', 'application_company', 'application_job_title',
            'interview', 'reminder_type', 'title', 'description',
            'scheduled_at', 'status', 'send_email', 'send_push',
            'snoozed_until', 'snooze_count', 'sent_at', 'completed_at',
            'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'sent_at', 'completed_at', 'created_at', 'updated_at']
    
    def validate_application(self, value):
        if value and value.user != self.context['request'].user:
            raise serializers.ValidationError("Application not found.")
        return value
    
    def create(self, validated_data):
        validated_data['user'] = self.context['request'].user
        return super().create(validated_data)


class NotificationSerializer(serializers.ModelSerializer):
    """Serializer for notifications."""
    
    class Meta:
        model = Notification
        fields = [
            'id', 'notification_type', 'title', 'message',
            'application', 'interview', 'reminder', 'action_url',
            'is_read', 'read_at', 'created_at'
        ]
        read_only_fields = ['id', 'created_at']


class ReminderTemplateSerializer(serializers.ModelSerializer):
    """Serializer for reminder templates."""
    
    class Meta:
        model = ReminderTemplate
        fields = [
            'id', 'name', 'reminder_type', 'trigger_event',
            'days_offset', 'title_template', 'description_template',
            'is_active', 'is_default', 'created_at'
        ]
        read_only_fields = ['id', 'is_default', 'created_at']
    
    def create(self, validated_data):
        validated_data['user'] = self.context['request'].user
        return super().create(validated_data)


class SnoozeReminderSerializer(serializers.Serializer):
    """Serializer for snoozing reminders."""
    
    snooze_until = serializers.DateTimeField()


class BulkNotificationUpdateSerializer(serializers.Serializer):
    """Serializer for bulk marking notifications as read."""
    
    notification_ids = serializers.ListField(
        child=serializers.UUIDField(),
        required=False
    )
    mark_all = serializers.BooleanField(default=False)
