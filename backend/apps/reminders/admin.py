from django.contrib import admin
from .models import Reminder, Notification, ReminderTemplate


@admin.register(Reminder)
class ReminderAdmin(admin.ModelAdmin):
    list_display = ['title', 'user', 'reminder_type', 'status', 'scheduled_at']
    list_filter = ['reminder_type', 'status', 'scheduled_at']
    search_fields = ['title', 'user__email']
    ordering = ['-scheduled_at']


@admin.register(Notification)
class NotificationAdmin(admin.ModelAdmin):
    list_display = ['title', 'user', 'notification_type', 'is_read', 'created_at']
    list_filter = ['notification_type', 'is_read', 'created_at']
    search_fields = ['title', 'user__email']
    ordering = ['-created_at']


@admin.register(ReminderTemplate)
class ReminderTemplateAdmin(admin.ModelAdmin):
    list_display = ['name', 'reminder_type', 'trigger_event', 'days_offset', 'is_active', 'is_default']
    list_filter = ['reminder_type', 'is_active', 'is_default']
    search_fields = ['name']
