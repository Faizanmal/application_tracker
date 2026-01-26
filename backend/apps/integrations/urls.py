from django.urls import path, include
from rest_framework.routers import DefaultRouter

from .views import (
    EmailIntegrationViewSet,
    TrackedEmailViewSet,
    CalendarIntegrationViewSet,
    CalendarEventViewSet,
    LinkedInIntegrationViewSet,
    LinkedInOutreachViewSet,
    AutomatedFollowUpViewSet,
    SlackIntegrationViewSet,
    DiscordIntegrationViewSet,
    ZapierWebhookViewSet,
    APIKeyViewSet,
)

router = DefaultRouter()
router.register(r'email', EmailIntegrationViewSet, basename='email-integrations')
router.register(r'tracked-emails', TrackedEmailViewSet, basename='tracked-emails')
router.register(r'calendar', CalendarIntegrationViewSet, basename='calendar-integrations')
router.register(r'calendar-events', CalendarEventViewSet, basename='calendar-events')
router.register(r'linkedin', LinkedInIntegrationViewSet, basename='linkedin-integration')
router.register(r'linkedin-outreach', LinkedInOutreachViewSet, basename='linkedin-outreach')
router.register(r'follow-ups', AutomatedFollowUpViewSet, basename='automated-followups')
router.register(r'slack', SlackIntegrationViewSet, basename='slack-integrations')
router.register(r'discord', DiscordIntegrationViewSet, basename='discord-integrations')
router.register(r'zapier', ZapierWebhookViewSet, basename='zapier-webhooks')
router.register(r'api-keys', APIKeyViewSet, basename='api-keys')

urlpatterns = [
    path('', include(router.urls)),
]
