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
from apps.applications.models import JobApplication
from apps.interviews.models import Interview


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


class SmartRemindersView(APIView):
    """Generate smart, context-aware reminders based on application status."""
    
    def get(self, request):
        user = request.user
        now = timezone.now()
        
        smart_reminders = []
        
        # 1. Follow-up reminders for applications without response
        applied_no_response = JobApplication.objects.filter(
            user=user,
            applied_date__isnull=False,
            response_date__isnull=True,
            status__in=['applied', 'screening']
        ).exclude(
            reminders__reminder_type=Reminder.ReminderType.FOLLOW_UP,
            reminders__status__in=['pending', 'snoozed']
        )
        
        for app in applied_no_response:
            days_since_applied = (now.date() - app.applied_date).days
            if days_since_applied >= 7:  # After 1 week
                smart_reminders.append({
                    'type': 'follow_up',
                    'application_id': str(app.id),
                    'title': f'Follow up with {app.company_name}',
                    'description': f"It's been {days_since_applied} days since you applied to {app.job_title} at {app.company_name}. Consider sending a follow-up email.",
                    'suggested_schedule': now + timedelta(days=1),  # Tomorrow
                    'priority': 'medium'
                })
            elif days_since_applied >= 14:  # After 2 weeks
                smart_reminders.append({
                    'type': 'follow_up',
                    'application_id': str(app.id),
                    'title': f'Follow up with {app.company_name} (Urgent)',
                    'description': f"It's been {days_since_applied} days since you applied to {app.job_title} at {app.company_name}. This is getting urgent.",
                    'suggested_schedule': now + timedelta(hours=4),  # In 4 hours
                    'priority': 'high'
                })
        
        # 2. Interview preparation reminders
        upcoming_interviews = Interview.objects.filter(
            application__user=user,
            scheduled_at__gte=now,
            scheduled_at__lte=now + timedelta(days=7),
            status=Interview.Status.SCHEDULED
        ).exclude(
            reminders__reminder_type=Reminder.ReminderType.INTERVIEW_PREP,
            reminders__status__in=['pending', 'snoozed']
        )
        
        for interview in upcoming_interviews:
            hours_until = int((interview.scheduled_at - now).total_seconds() / 3600)
            if hours_until <= 24:  # Within 24 hours
                smart_reminders.append({
                    'type': 'interview_prep',
                    'application_id': str(interview.application.id),
                    'interview_id': str(interview.id),
                    'title': f'Prepare for interview at {interview.application.company_name}',
                    'description': f'Your interview for {interview.application.job_title} is in {hours_until} hours. Review your preparation notes.',
                    'suggested_schedule': now + timedelta(hours=2),
                    'priority': 'high'
                })
        
        # 3. Thank you note reminders
        recent_interviews = Interview.objects.filter(
            application__user=user,
            scheduled_at__lte=now,
            scheduled_at__gte=now - timedelta(days=1),
            status=Interview.Status.COMPLETED
        ).exclude(
            reminders__reminder_type=Reminder.ReminderType.SEND_THANK_YOU,
            reminders__status__in=['pending', 'snoozed']
        )
        
        for interview in recent_interviews:
            smart_reminders.append({
                'type': 'thank_you',
                'application_id': str(interview.application.id),
                'interview_id': str(interview.id),
                'title': f'Send thank you to {interview.application.company_name}',
                'description': f'Send a thank you note to {interview.interviewer_name or "the interviewer"} at {interview.application.company_name}.',
                'suggested_schedule': now + timedelta(hours=4),
                'priority': 'medium'
            })
        
        # 4. Status check reminders
        need_status_check = JobApplication.objects.filter(
            user=user,
            applied_date__isnull=False,
            response_date__isnull=True,
            status__in=['applied', 'screening'],
            updated_at__lte=now - timedelta(days=30)
        ).exclude(
            reminders__reminder_type=Reminder.ReminderType.CHECK_STATUS,
            reminders__status__in=['pending', 'snoozed']
        )
        
        for app in need_status_check:
            days_since_update = (now.date() - app.updated_at.date()).days
            smart_reminders.append({
                'type': 'status_check',
                'application_id': str(app.id),
                'title': f'Check status at {app.company_name}',
                'description': f"It's been {days_since_update} days since your last update on {app.job_title} at {app.company_name}. Check for any status updates.",
                'suggested_schedule': now + timedelta(days=3),
                'priority': 'low'
            })
        
        return Response({
            'smart_reminders': smart_reminders,
            'total_suggestions': len(smart_reminders)
        })
    
    def post(self, request):
        """Create reminders from smart suggestions."""
        user = request.user
        reminder_data = request.data
        
        # Create the reminder
        reminder = Reminder.objects.create(
            user=user,
            application_id=reminder_data.get('application_id'),
            interview_id=reminder_data.get('interview_id'),
            reminder_type=reminder_data['type'],
            title=reminder_data['title'],
            description=reminder_data['description'],
            scheduled_at=reminder_data['scheduled_at']
        )
        
        return Response(ReminderSerializer(reminder).data, status=status.HTTP_201_CREATED)
