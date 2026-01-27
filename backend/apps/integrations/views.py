import secrets
from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from rest_framework.views import APIView
from django_filters.rest_framework import DjangoFilterBackend
from rest_framework.filters import OrderingFilter
from django.utils import timezone
from datetime import timedelta

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
from .serializers import (
    EmailIntegrationSerializer,
    TrackedEmailSerializer,
    CalendarIntegrationSerializer,
    CalendarEventSerializer,
    LinkedInIntegrationSerializer,
    LinkedInOutreachSerializer,
    AutomatedFollowUpSerializer,
    SlackIntegrationSerializer,
    DiscordIntegrationSerializer,
    ZapierWebhookSerializer,
    APIKeySerializer,
)
from .services import EmailSyncService, CalendarSyncService, WebhookService


class EmailIntegrationViewSet(viewsets.ModelViewSet):
    """ViewSet for email integrations."""
    serializer_class = EmailIntegrationSerializer
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        return EmailIntegration.objects.filter(user=self.request.user)
    
    def perform_create(self, serializer):
        serializer.save(user=self.request.user)
    
    @action(detail=False, methods=['post'])
    def connect_gmail(self, request):
        """Connect Gmail using OAuth."""
        # This would redirect to Google OAuth
        return Response({
            'auth_url': 'https://accounts.google.com/o/oauth2/v2/auth',
            'message': 'Redirect user to auth_url for OAuth flow'
        })
    
    @action(detail=False, methods=['post'])
    def connect_outlook(self, request):
        """Connect Outlook using OAuth."""
        return Response({
            'auth_url': 'https://login.microsoftonline.com/common/oauth2/v2.0/authorize',
            'message': 'Redirect user to auth_url for OAuth flow'
        })
    
    @action(detail=True, methods=['post'])
    def sync(self, request, pk=None):
        """Manually trigger email sync."""
        integration = self.get_object()
        service = EmailSyncService(integration)
        result = service.sync()
        
        integration.last_sync = timezone.now()
        integration.save()
        
        return Response({
            'synced': result.get('synced_count', 0),
            'linked': result.get('linked_count', 0),
            'last_sync': integration.last_sync
        })


class TrackedEmailViewSet(viewsets.ModelViewSet):
    """ViewSet for tracked emails."""
    serializer_class = TrackedEmailSerializer
    permission_classes = [IsAuthenticated]
    filter_backends = [DjangoFilterBackend, OrderingFilter]
    filterset_fields = ['direction', 'email_type', 'application']
    ordering = ['-received_at']
    
    def get_queryset(self):
        return TrackedEmail.objects.filter(
            integration__user=self.request.user
        ).select_related('application', 'integration')
    
    @action(detail=True, methods=['post'])
    def link_application(self, request, pk=None):
        """Link email to an application."""
        email = self.get_object()
        application_id = request.data.get('application_id')
        
        from apps.applications.models import JobApplication
        try:
            application = JobApplication.objects.get(
                id=application_id,
                user=request.user
            )
            email.application = application
            email.save()
            return Response(self.get_serializer(email).data)
        except JobApplication.DoesNotExist:
            return Response(
                {'error': 'Application not found'},
                status=status.HTTP_404_NOT_FOUND
            )


class CalendarIntegrationViewSet(viewsets.ModelViewSet):
    """ViewSet for calendar integrations."""
    serializer_class = CalendarIntegrationSerializer
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        return CalendarIntegration.objects.filter(user=self.request.user)
    
    def perform_create(self, serializer):
        serializer.save(user=self.request.user)
    
    @action(detail=False, methods=['post'])
    def connect_google(self, request):
        """Connect Google Calendar."""
        return Response({
            'auth_url': 'https://accounts.google.com/o/oauth2/v2/auth',
            'scopes': ['https://www.googleapis.com/auth/calendar'],
            'message': 'Redirect user to auth_url for OAuth flow'
        })
    
    @action(detail=True, methods=['post'])
    def sync(self, request, pk=None):
        """Manually sync calendar."""
        integration = self.get_object()
        service = CalendarSyncService(integration)
        result = service.sync()
        
        integration.last_sync = timezone.now()
        integration.save()
        
        return Response({
            'synced_events': result.get('synced_count', 0),
            'last_sync': integration.last_sync
        })
    
    @action(detail=True, methods=['post'])
    def create_event(self, request, pk=None):
        """Create a calendar event."""
        integration = self.get_object()
        service = CalendarSyncService(integration)
        
        event_data = {
            'title': request.data.get('title'),
            'description': request.data.get('description', ''),
            'start_time': request.data.get('start_time'),
            'end_time': request.data.get('end_time'),
            'location': request.data.get('location', ''),
        }
        
        result = service.create_event(event_data)
        return Response(result, status=status.HTTP_201_CREATED)


class CalendarEventViewSet(viewsets.ModelViewSet):
    """ViewSet for calendar events."""
    serializer_class = CalendarEventSerializer
    permission_classes = [IsAuthenticated]
    filter_backends = [OrderingFilter]
    ordering = ['start_time']
    
    def get_queryset(self):
        return CalendarEvent.objects.filter(
            integration__user=self.request.user
        ).select_related('interview', 'reminder')


class UpcomingEventsView(APIView):
    """Get upcoming calendar events and application deadlines."""
    
    def get(self, request):
        user = request.user
        days = int(request.query_params.get('days', 30))
        end_date = timezone.now() + timedelta(days=days)
        
        events = []
        
        # Calendar events
        calendar_events = CalendarEvent.objects.filter(
            integration__user=user,
            integration__is_active=True,
            start_time__gte=timezone.now(),
            start_time__lte=end_date
        ).select_related('interview', 'reminder')
        
        for event in calendar_events:
            events.append({
                'id': str(event.id),
                'type': 'calendar_event',
                'title': event.title,
                'description': event.description,
                'start_time': event.start_time,
                'end_time': event.end_time,
                'location': event.location,
                'interview': {
                    'id': str(event.interview.id),
                    'company_name': event.interview.application.company_name,
                    'job_title': event.interview.application.job_title
                } if event.interview else None,
                'reminder': {
                    'id': str(event.reminder.id),
                    'title': event.reminder.title
                } if event.reminder else None
            })
        
        # Interview events (not synced to calendar)
        interviews = Interview.objects.filter(
            application__user=user,
            scheduled_at__gte=timezone.now(),
            scheduled_at__lte=end_date,
            status__in=['scheduled', 'rescheduled']
        ).select_related('application')
        
        for interview in interviews:
            # Check if already in calendar events
            if not CalendarEvent.objects.filter(interview=interview).exists():
                events.append({
                    'id': str(interview.id),
                    'type': 'interview',
                    'title': f'Interview: {interview.application.company_name}',
                    'description': interview.title or f'Interview with {interview.application.company_name}',
                    'start_time': interview.scheduled_at,
                    'end_time': interview.scheduled_at + timedelta(minutes=interview.duration_minutes),
                    'location': interview.location,
                    'interview': {
                        'id': str(interview.id),
                        'company_name': interview.application.company_name,
                        'job_title': interview.application.job_title
                    },
                    'reminder': None
                })
        
        # Application deadlines
        deadlines = JobApplication.objects.filter(
            user=user,
            deadline__gte=timezone.now(),
            deadline__lte=end_date,
            status__in=['applied', 'screening']
        )
        
        for app in deadlines:
            events.append({
                'id': str(app.id),
                'type': 'deadline',
                'title': f'Deadline: {app.company_name}',
                'description': f'Application deadline for {app.job_title} at {app.company_name}',
                'start_time': app.deadline,
                'end_time': app.deadline,
                'location': '',
                'interview': None,
                'reminder': None
            })
        
        # Sort events by start time
        events.sort(key=lambda x: x['start_time'])
        
        return Response({
            'events': events,
            'total': len(events)
        })


class LinkedInIntegrationViewSet(viewsets.ModelViewSet):
    """ViewSet for LinkedIn integration."""
    serializer_class = LinkedInIntegrationSerializer
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        return LinkedInIntegration.objects.filter(user=self.request.user)
    
    @action(detail=False, methods=['post'])
    def connect(self, request):
        """Connect LinkedIn account."""
        return Response({
            'auth_url': 'https://www.linkedin.com/oauth/v2/authorization',
            'message': 'Redirect user to auth_url for OAuth flow'
        })


class LinkedInOutreachViewSet(viewsets.ModelViewSet):
    """ViewSet for LinkedIn outreach."""
    serializer_class = LinkedInOutreachSerializer
    permission_classes = [IsAuthenticated]
    filter_backends = [DjangoFilterBackend, OrderingFilter]
    filterset_fields = ['status', 'application']
    ordering = ['-created_at']
    
    def get_queryset(self):
        return LinkedInOutreach.objects.filter(
            user=self.request.user
        ).select_related('connection', 'application')
    
    def perform_create(self, serializer):
        serializer.save(user=self.request.user)
    
    @action(detail=True, methods=['post'])
    def mark_connected(self, request, pk=None):
        """Mark as connected."""
        outreach = self.get_object()
        outreach.status = 'connected'
        outreach.connected_at = timezone.now()
        outreach.save()
        return Response(self.get_serializer(outreach).data)


class AutomatedFollowUpViewSet(viewsets.ModelViewSet):
    """ViewSet for automated follow-ups."""
    serializer_class = AutomatedFollowUpSerializer
    permission_classes = [IsAuthenticated]
    filter_backends = [DjangoFilterBackend, OrderingFilter]
    filterset_fields = ['status', 'application']
    ordering = ['scheduled_for']
    
    def get_queryset(self):
        return AutomatedFollowUp.objects.filter(
            user=self.request.user
        ).select_related('application')
    
    def perform_create(self, serializer):
        serializer.save(user=self.request.user)
    
    @action(detail=True, methods=['post'])
    def cancel(self, request, pk=None):
        """Cancel a scheduled follow-up."""
        followup = self.get_object()
        if followup.status == 'scheduled':
            followup.status = 'cancelled'
            followup.save()
        return Response(self.get_serializer(followup).data)
    
    @action(detail=False, methods=['post'])
    def generate(self, request):
        """Generate AI follow-up email."""
        from apps.ai_features.services import AIService
        
        application_id = request.data.get('application_id')
        if not application_id:
            return Response(
                {'error': 'application_id required'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        from apps.applications.models import JobApplication
        try:
            application = JobApplication.objects.get(
                id=application_id,
                user=request.user
            )
        except JobApplication.DoesNotExist:
            return Response(
                {'error': 'Application not found'},
                status=status.HTTP_404_NOT_FOUND
            )
        
        ai_service = AIService()
        email = ai_service.generate_follow_up_email(application)
        
        return Response({
            'subject': email.get('subject'),
            'body': email.get('body'),
            'is_ai_generated': True
        })


class SlackIntegrationViewSet(viewsets.ModelViewSet):
    """ViewSet for Slack integrations."""
    serializer_class = SlackIntegrationSerializer
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        return SlackIntegration.objects.filter(user=self.request.user)
    
    @action(detail=False, methods=['post'])
    def connect(self, request):
        """Connect Slack workspace."""
        return Response({
            'auth_url': 'https://slack.com/oauth/v2/authorize',
            'message': 'Redirect user to Slack OAuth'
        })
    
    @action(detail=True, methods=['post'])
    def test(self, request, pk=None):
        """Send test notification."""
        integration = self.get_object()
        service = WebhookService()
        result = service.send_slack_notification(
            integration,
            "🧪 Test notification from JobScouter!"
        )
        return Response({'success': result})


class DiscordIntegrationViewSet(viewsets.ModelViewSet):
    """ViewSet for Discord integrations."""
    serializer_class = DiscordIntegrationSerializer
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        return DiscordIntegration.objects.filter(user=self.request.user)
    
    def perform_create(self, serializer):
        serializer.save(user=self.request.user)
    
    @action(detail=True, methods=['post'])
    def test(self, request, pk=None):
        """Send test notification."""
        integration = self.get_object()
        service = WebhookService()
        result = service.send_discord_notification(
            integration,
            "🧪 Test notification from JobScouter!"
        )
        return Response({'success': result})


class ZapierWebhookViewSet(viewsets.ModelViewSet):
    """ViewSet for Zapier webhooks."""
    serializer_class = ZapierWebhookSerializer
    permission_classes = [IsAuthenticated]
    filter_backends = [DjangoFilterBackend]
    filterset_fields = ['event_type', 'is_active']
    
    def get_queryset(self):
        return ZapierWebhook.objects.filter(user=self.request.user)
    
    def perform_create(self, serializer):
        serializer.save(user=self.request.user)
    
    @action(detail=True, methods=['post'])
    def test(self, request, pk=None):
        """Test webhook with sample data."""
        webhook = self.get_object()
        service = WebhookService()
        
        sample_data = {
            'event': webhook.event_type,
            'timestamp': timezone.now().isoformat(),
            'data': {
                'company': 'Test Company',
                'job_title': 'Test Position',
                'status': 'applied'
            }
        }
        
        result = service.trigger_zapier_webhook(webhook, sample_data)
        return Response({'success': result})


class APIKeyViewSet(viewsets.ModelViewSet):
    """ViewSet for API keys."""
    serializer_class = APIKeySerializer
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        return APIKey.objects.filter(user=self.request.user)
    
    def perform_create(self, serializer):
        # Generate a secure API key
        key = secrets.token_urlsafe(48)
        serializer.save(user=self.request.user, key=key)
    
    def get_serializer_context(self):
        context = super().get_serializer_context()
        # Show full key only on creation
        context['hide_key'] = self.action != 'create'
        return context
    
    @action(detail=True, methods=['post'])
    def regenerate(self, request, pk=None):
        """Regenerate API key."""
        api_key = self.get_object()
        api_key.key = secrets.token_urlsafe(48)
        api_key.save()
        
        serializer = self.get_serializer(api_key, context={'hide_key': False})
        return Response(serializer.data)
    
    @action(detail=True, methods=['post'])
    def revoke(self, request, pk=None):
        """Revoke an API key."""
        api_key = self.get_object()
        api_key.is_active = False
        api_key.save()
        return Response({'status': 'revoked'})
