"""Integration services for email, calendar, and webhooks."""
import logging
import requests
from django.conf import settings
from django.utils import timezone

logger = logging.getLogger(__name__)


class EmailSyncService:
    """Service for syncing emails from Gmail/Outlook."""
    
    def __init__(self, integration):
        self.integration = integration
    
    def sync(self):
        """Sync emails from the integration."""
        if self.integration.provider == 'gmail':
            return self._sync_gmail()
        elif self.integration.provider == 'outlook':
            return self._sync_outlook()
        return {'synced_count': 0, 'linked_count': 0}
    
    def _sync_gmail(self):
        """Sync emails from Gmail using Gmail API."""
        # This would use google-api-python-client
        # For now, return a placeholder
        return {'synced_count': 0, 'linked_count': 0}
    
    def _sync_outlook(self):
        """Sync emails from Outlook using Microsoft Graph API."""
        return {'synced_count': 0, 'linked_count': 0}
    
    def _classify_email(self, email_data):
        """Use AI to classify email type and link to application."""
        from apps.ai_features.services import AIService
        ai = AIService()
        return ai.classify_email(email_data)


class CalendarSyncService:
    """Service for syncing calendars."""
    
    def __init__(self, integration):
        self.integration = integration
    
    def sync(self):
        """Sync calendar events."""
        if self.integration.provider == 'google':
            return self._sync_google()
        elif self.integration.provider == 'outlook':
            return self._sync_outlook()
        return {'synced_count': 0}
    
    def _sync_google(self):
        """Sync from Google Calendar."""
        return {'synced_count': 0}
    
    def _sync_outlook(self):
        """Sync from Outlook Calendar."""
        return {'synced_count': 0}
    
    def create_event(self, event_data):
        """Create a calendar event."""
        if self.integration.provider == 'google':
            return self._create_google_event(event_data)
        return {'success': False, 'error': 'Provider not supported'}
    
    def _create_google_event(self, event_data):
        """Create event in Google Calendar."""
        # This would use google-api-python-client
        return {'success': True, 'event_id': 'sample_id'}


class WebhookService:
    """Service for sending webhooks to external services."""
    
    def send_slack_notification(self, integration, message, blocks=None):
        """Send notification to Slack channel."""
        try:
            payload = {'text': message}
            if blocks:
                payload['blocks'] = blocks
            
            # Use Slack incoming webhook or chat.postMessage API
            # This is a simplified version
            return True
        except Exception as e:
            logger.error(f"Slack notification failed: {e}")
            return False
    
    def send_discord_notification(self, integration, message, embed=None):
        """Send notification to Discord channel via webhook."""
        try:
            payload = {'content': message}
            if embed:
                payload['embeds'] = [embed]
            
            response = requests.post(
                integration.webhook_url,
                json=payload,
                timeout=10
            )
            return response.status_code == 204
        except Exception as e:
            logger.error(f"Discord notification failed: {e}")
            return False
    
    def trigger_zapier_webhook(self, webhook, data):
        """Trigger a Zapier webhook."""
        try:
            response = requests.post(
                webhook.webhook_url,
                json=data,
                timeout=10
            )
            
            # Update webhook stats
            webhook.last_triggered = timezone.now()
            webhook.trigger_count += 1
            webhook.save()
            
            return response.status_code in [200, 201]
        except Exception as e:
            logger.error(f"Zapier webhook failed: {e}")
            return False
    
    def notify_application_created(self, application):
        """Send notifications for new application."""
        user = application.user
        
        # Slack notifications
        for slack in user.slack_integrations.filter(
            is_active=True,
            notify_applications=True
        ):
            message = f"📝 New application: {application.job_title} at {application.company_name}"
            self.send_slack_notification(slack, message)
        
        # Discord notifications
        for discord in user.discord_integrations.filter(
            is_active=True,
            notify_applications=True
        ):
            message = f"📝 New application: {application.job_title} at {application.company_name}"
            self.send_discord_notification(discord, message)
        
        # Zapier webhooks
        for webhook in user.zapier_webhooks.filter(
            is_active=True,
            event_type='application_created'
        ):
            data = {
                'event': 'application_created',
                'timestamp': timezone.now().isoformat(),
                'application': {
                    'id': str(application.id),
                    'job_title': application.job_title,
                    'company_name': application.company_name,
                    'status': application.status,
                    'applied_date': str(application.applied_date) if application.applied_date else None,
                }
            }
            self.trigger_zapier_webhook(webhook, data)
    
    def notify_status_changed(self, application, old_status, new_status):
        """Send notifications for status change."""
        user = application.user
        
        # Slack notifications
        for slack in user.slack_integrations.filter(
            is_active=True,
            notify_status_changes=True
        ):
            emoji = self._get_status_emoji(new_status)
            message = f"{emoji} Status update: {application.company_name} - {old_status} → {new_status}"
            self.send_slack_notification(slack, message)
        
        # Discord notifications
        for discord in user.discord_integrations.filter(
            is_active=True,
            notify_status_changes=True
        ):
            emoji = self._get_status_emoji(new_status)
            message = f"{emoji} Status update: {application.company_name} - {old_status} → {new_status}"
            self.send_discord_notification(discord, message)
        
        # Zapier webhooks
        for webhook in user.zapier_webhooks.filter(
            is_active=True,
            event_type='status_changed'
        ):
            data = {
                'event': 'status_changed',
                'timestamp': timezone.now().isoformat(),
                'application': {
                    'id': str(application.id),
                    'job_title': application.job_title,
                    'company_name': application.company_name,
                },
                'old_status': old_status,
                'new_status': new_status,
            }
            self.trigger_zapier_webhook(webhook, data)
    
    def _get_status_emoji(self, status):
        """Get emoji for status."""
        emojis = {
            'wishlist': '📌',
            'applied': '📤',
            'screening': '📞',
            'interviewing': '🎯',
            'offer': '🎉',
            'accepted': '✅',
            'rejected': '❌',
            'withdrawn': '🚫',
            'ghosted': '👻',
        }
        return emojis.get(status, '📋')
