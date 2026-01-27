from django.db.models.signals import post_save
from django.dispatch import receiver
from django.utils import timezone
from datetime import timedelta

from .models import Interview
from apps.integrations.models import CalendarIntegration, CalendarEvent
from apps.integrations.services import CalendarSyncService


@receiver(post_save, sender=Interview)
def create_calendar_event_for_interview(sender, instance, created, **kwargs):
    """Automatically create calendar events for new interviews."""
    if not created:
        return
    
    user = instance.application.user
    
    # Check if user has active calendar integrations
    integrations = CalendarIntegration.objects.filter(
        user=user,
        is_active=True,
        sync_interviews=True
    )
    
    if not integrations.exists():
        return
    
    # Create event data
    start_time = instance.scheduled_at
    end_time = start_time + timedelta(minutes=instance.duration_minutes)
    
    event_data = {
        'title': f'Interview: {instance.application.company_name}',
        'description': f'Interview for {instance.application.job_title} position\n\n{instance.preparation_notes or ""}',
        'location': instance.location or instance.meeting_link or '',
        'start_time': start_time,
        'end_time': end_time,
    }
    
    # Create event in each active calendar
    for integration in integrations:
        try:
            service = CalendarSyncService(integration)
            result = service.create_event(event_data)
            
            if result.get('success'):
                # Create local CalendarEvent record
                CalendarEvent.objects.create(
                    integration=integration,
                    external_event_id=result['event_id'],
                    title=event_data['title'],
                    description=event_data['description'],
                    location=event_data['location'],
                    start_time=start_time,
                    end_time=end_time,
                    interview=instance
                )
        except Exception as e:
            # Log error but don't fail the interview creation
            print(f"Failed to create calendar event: {e}")
            pass