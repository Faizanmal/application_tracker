from celery import shared_task
from django.core.mail import send_mail
from django.conf import settings
from django.utils import timezone


@shared_task
def send_reminder_email(reminder_id):
    """Send reminder email."""
    from .models import Reminder
    
    try:
        reminder = Reminder.objects.get(id=reminder_id)
        
        if reminder.status != Reminder.Status.PENDING:
            return
        
        if not reminder.user.email_notifications:
            return
        
        subject = f'Reminder: {reminder.title}'
        
        application_info = ''
        if reminder.application:
            application_info = f"""
Application: {reminder.application.job_title} at {reminder.application.company_name}
Status: {reminder.application.get_status_display()}
"""
        
        message = f"""
Hi {reminder.user.first_name or 'there'},

This is a reminder for: {reminder.title}

{reminder.description}
{application_info}

---
JobScouter - Track Your Job Search
        """
        
        send_mail(
            subject=subject,
            message=message,
            from_email=settings.DEFAULT_FROM_EMAIL,
            recipient_list=[reminder.user.email],
            fail_silently=False,
        )
        
        reminder.status = Reminder.Status.SENT
        reminder.sent_at = timezone.now()
        reminder.save()
        
    except Exception as e:
        print(f"Error sending reminder email: {e}")


@shared_task
def process_pending_reminders():
    """Process and send pending reminders."""
    from .models import Reminder, Notification
    
    now = timezone.now()
    
    # Get reminders that are due
    pending_reminders = Reminder.objects.filter(
        status=Reminder.Status.PENDING,
        scheduled_at__lte=now
    )
    
    for reminder in pending_reminders:
        # Create in-app notification
        Notification.objects.create(
            user=reminder.user,
            notification_type=Notification.NotificationType.REMINDER,
            title=reminder.title,
            message=reminder.description or f"Reminder for {reminder.get_reminder_type_display()}",
            application=reminder.application,
            interview=reminder.interview,
            reminder=reminder
        )
        
        # Send email if enabled
        if reminder.send_email:
            send_reminder_email.delay(str(reminder.id))
        else:
            reminder.status = Reminder.Status.SENT
            reminder.sent_at = now
            reminder.save()


@shared_task
def process_snoozed_reminders():
    """Re-activate snoozed reminders that are due."""
    from .models import Reminder
    
    now = timezone.now()
    
    snoozed_reminders = Reminder.objects.filter(
        status=Reminder.Status.SNOOZED,
        snoozed_until__lte=now
    )
    
    for reminder in snoozed_reminders:
        reminder.status = Reminder.Status.PENDING
        reminder.scheduled_at = now
        reminder.snoozed_until = None
        reminder.save()


@shared_task
def create_auto_reminders():
    """Create automatic follow-up reminders for applications."""
    from .models import Reminder
    from apps.applications.models import JobApplication
    from datetime import timedelta
    
    # Get applications that need follow-up reminders
    # 7 days after applying with no existing pending reminder
    
    week_ago = timezone.now() - timedelta(days=7)
    
    applications = JobApplication.objects.filter(
        status='applied',
        applied_date__lte=week_ago.date(),
        is_archived=False
    ).exclude(
        reminders__status=Reminder.Status.PENDING,
        reminders__reminder_type=Reminder.ReminderType.FOLLOW_UP
    )
    
    for app in applications:
        # Check if user has auto-reminders enabled
        if not app.user.email_notifications:
            continue
        
        Reminder.objects.create(
            user=app.user,
            application=app,
            reminder_type=Reminder.ReminderType.FOLLOW_UP,
            title=f'Follow up with {app.company_name}',
            description=f'It\'s been a week since you applied for {app.job_title}. Consider sending a follow-up email.',
            scheduled_at=timezone.now() + timedelta(hours=9)  # Send next morning
        )


@shared_task
def send_interview_reminders():
    """Send reminders for upcoming interviews."""
    from .models import Notification
    from apps.interviews.models import Interview
    from datetime import timedelta
    
    now = timezone.now()
    tomorrow = now + timedelta(days=1)
    
    # Get interviews happening tomorrow
    upcoming_interviews = Interview.objects.filter(
        status=Interview.Status.SCHEDULED,
        scheduled_at__date=tomorrow.date()
    )
    
    for interview in upcoming_interviews:
        # Check if notification already sent
        existing = Notification.objects.filter(
            interview=interview,
            notification_type=Notification.NotificationType.INTERVIEW_REMINDER,
            created_at__date=now.date()
        ).exists()
        
        if not existing:
            Notification.objects.create(
                user=interview.application.user,
                notification_type=Notification.NotificationType.INTERVIEW_REMINDER,
                title=f'Interview Tomorrow: {interview.application.company_name}',
                message=f'You have a {interview.get_interview_type_display()} scheduled for tomorrow at {interview.scheduled_at.strftime("%I:%M %p")}',
                application=interview.application,
                interview=interview
            )
