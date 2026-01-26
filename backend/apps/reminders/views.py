from rest_framework import generics, status
from rest_framework.views import APIView
from rest_framework.response import Response
from django_filters.rest_framework import DjangoFilterBackend
from django.utils import timezone
from datetime import timedelta

from .models import Reminder, Notification, ReminderTemplate
from .serializers import (
    ReminderSerializer, NotificationSerializer, ReminderTemplateSerializer,
    SnoozeReminderSerializer, BulkNotificationUpdateSerializer
)


class ReminderListCreateView(generics.ListCreateAPIView):
    """List and create reminders."""
    
    serializer_class = ReminderSerializer
    filter_backends = [DjangoFilterBackend]
    filterset_fields = ['status', 'reminder_type', 'application']
    
    def get_queryset(self):
        return Reminder.objects.filter(
            user=self.request.user
        ).select_related('application')


class ReminderDetailView(generics.RetrieveUpdateDestroyAPIView):
    """Get, update, or delete a reminder."""
    
    serializer_class = ReminderSerializer
    
    def get_queryset(self):
        return Reminder.objects.filter(user=self.request.user)


class UpcomingRemindersView(generics.ListAPIView):
    """Get upcoming reminders for the next 7 days."""
    
    serializer_class = ReminderSerializer
    
    def get_queryset(self):
        now = timezone.now()
        next_week = now + timedelta(days=7)
        
        return Reminder.objects.filter(
            user=self.request.user,
            scheduled_at__gte=now,
            scheduled_at__lte=next_week,
            status=Reminder.Status.PENDING
        ).select_related('application').order_by('scheduled_at')


class TodayRemindersView(generics.ListAPIView):
    """Get today's reminders."""
    
    serializer_class = ReminderSerializer
    
    def get_queryset(self):
        today = timezone.now().date()
        
        return Reminder.objects.filter(
            user=self.request.user,
            scheduled_at__date=today,
            status__in=[Reminder.Status.PENDING, Reminder.Status.SNOOZED]
        ).select_related('application').order_by('scheduled_at')


class CompleteReminderView(APIView):
    """Mark a reminder as completed."""
    
    def post(self, request, pk):
        try:
            reminder = Reminder.objects.get(pk=pk, user=request.user)
        except Reminder.DoesNotExist:
            return Response(
                {'error': 'Reminder not found'},
                status=status.HTTP_404_NOT_FOUND
            )
        
        reminder.status = Reminder.Status.COMPLETED
        reminder.completed_at = timezone.now()
        reminder.save()
        
        return Response(ReminderSerializer(reminder).data)


class SnoozeReminderView(APIView):
    """Snooze a reminder."""
    
    def post(self, request, pk):
        try:
            reminder = Reminder.objects.get(pk=pk, user=request.user)
        except Reminder.DoesNotExist:
            return Response(
                {'error': 'Reminder not found'},
                status=status.HTTP_404_NOT_FOUND
            )
        
        serializer = SnoozeReminderSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        
        reminder.status = Reminder.Status.SNOOZED
        reminder.snoozed_until = serializer.validated_data['snooze_until']
        reminder.snooze_count += 1
        reminder.save()
        
        return Response(ReminderSerializer(reminder).data)


class CancelReminderView(APIView):
    """Cancel a reminder."""
    
    def post(self, request, pk):
        try:
            reminder = Reminder.objects.get(pk=pk, user=request.user)
        except Reminder.DoesNotExist:
            return Response(
                {'error': 'Reminder not found'},
                status=status.HTTP_404_NOT_FOUND
            )
        
        reminder.status = Reminder.Status.CANCELLED
        reminder.save()
        
        return Response(ReminderSerializer(reminder).data)


class SuggestFollowUpView(APIView):
    """Suggest follow-up reminders for applications without recent activity."""
    
    def get(self, request):
        # Get applications that were applied 7+ days ago with no follow-up
        from apps.applications.models import JobApplication
        
        week_ago = timezone.now() - timedelta(days=7)
        
        applications = JobApplication.objects.filter(
            user=request.user,
            status__in=['applied', 'screening'],
            applied_date__lte=week_ago.date(),
            is_archived=False
        ).exclude(
            reminders__status=Reminder.Status.PENDING
        )[:10]
        
        suggestions = []
        for app in applications:
            suggestions.append({
                'application_id': str(app.id),
                'company_name': app.company_name,
                'job_title': app.job_title,
                'applied_date': app.applied_date,
                'days_since_applied': (timezone.now().date() - app.applied_date).days if app.applied_date else None,
                'suggested_action': 'follow_up',
                'suggested_date': timezone.now() + timedelta(days=1)
            })
        
        return Response(suggestions)


class NotificationListView(generics.ListAPIView):
    """List notifications."""
    
    serializer_class = NotificationSerializer
    
    def get_queryset(self):
        return Notification.objects.filter(
            user=self.request.user
        ).order_by('-created_at')[:50]


class UnreadNotificationCountView(APIView):
    """Get count of unread notifications."""
    
    def get(self, request):
        count = Notification.objects.filter(
            user=request.user,
            is_read=False
        ).count()
        
        return Response({'unread_count': count})


class MarkNotificationReadView(APIView):
    """Mark a notification as read."""
    
    def post(self, request, pk):
        try:
            notification = Notification.objects.get(pk=pk, user=request.user)
        except Notification.DoesNotExist:
            return Response(
                {'error': 'Notification not found'},
                status=status.HTTP_404_NOT_FOUND
            )
        
        notification.is_read = True
        notification.read_at = timezone.now()
        notification.save()
        
        return Response(NotificationSerializer(notification).data)


class MarkAllNotificationsReadView(APIView):
    """Mark all notifications as read."""
    
    def post(self, request):
        serializer = BulkNotificationUpdateSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        
        if serializer.validated_data.get('mark_all'):
            Notification.objects.filter(
                user=request.user,
                is_read=False
            ).update(is_read=True, read_at=timezone.now())
        elif serializer.validated_data.get('notification_ids'):
            Notification.objects.filter(
                id__in=serializer.validated_data['notification_ids'],
                user=request.user,
                is_read=False
            ).update(is_read=True, read_at=timezone.now())
        
        return Response({'success': True})


class ReminderTemplateListCreateView(generics.ListCreateAPIView):
    """List and create reminder templates."""
    
    serializer_class = ReminderTemplateSerializer
    
    def get_queryset(self):
        # Get user templates and default templates
        from django.db.models import Q
        return ReminderTemplate.objects.filter(
            Q(user=self.request.user) | Q(is_default=True)
        )


class ReminderTemplateDetailView(generics.RetrieveUpdateDestroyAPIView):
    """Get, update, or delete a reminder template."""
    
    serializer_class = ReminderTemplateSerializer
    
    def get_queryset(self):
        return ReminderTemplate.objects.filter(user=self.request.user)
