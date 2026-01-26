from celery import shared_task
from django.core.mail import send_mail
from django.conf import settings
from django.template.loader import render_to_string


@shared_task
def send_password_reset_email(user_id, token):
    """Send password reset email."""
    from .models import User
    
    try:
        user = User.objects.get(id=user_id)
        reset_url = f"{settings.FRONTEND_URL}/reset-password?token={token}"
        
        subject = 'Reset Your JobScouter Password'
        message = f"""
Hello {user.first_name or 'there'},

You requested to reset your password. Click the link below to reset it:

{reset_url}

This link will expire in 1 hour.

If you didn't request this, please ignore this email.

Best,
The JobScouter Team
        """
        
        send_mail(
            subject=subject,
            message=message,
            from_email=settings.DEFAULT_FROM_EMAIL,
            recipient_list=[user.email],
            fail_silently=False,
        )
    except Exception as e:
        print(f"Error sending password reset email: {e}")


@shared_task
def send_verification_email(user_id, token):
    """Send email verification."""
    from .models import User
    
    try:
        user = User.objects.get(id=user_id)
        verify_url = f"{settings.FRONTEND_URL}/verify-email?token={token}"
        
        subject = 'Verify Your JobScouter Email'
        message = f"""
Hello {user.first_name or 'there'},

Welcome to JobScouter! Please verify your email by clicking the link below:

{verify_url}

This link will expire in 24 hours.

Best,
The JobScouter Team
        """
        
        send_mail(
            subject=subject,
            message=message,
            from_email=settings.DEFAULT_FROM_EMAIL,
            recipient_list=[user.email],
            fail_silently=False,
        )
    except Exception as e:
        print(f"Error sending verification email: {e}")


@shared_task
def send_welcome_email(user_id):
    """Send welcome email to new users."""
    from .models import User
    
    try:
        user = User.objects.get(id=user_id)
        
        subject = 'Welcome to JobScouter!'
        message = f"""
Hello {user.first_name or 'there'},

Welcome to JobScouter! We're excited to have you on board.

Here are some things you can do to get started:

1. Add your first job application
2. Set up follow-up reminders
3. Prepare for interviews with our tools
4. Track your progress on the dashboard

If you have any questions, feel free to reach out.

Happy job hunting!

Best,
The JobScouter Team
        """
        
        send_mail(
            subject=subject,
            message=message,
            from_email=settings.DEFAULT_FROM_EMAIL,
            recipient_list=[user.email],
            fail_silently=False,
        )
    except Exception as e:
        print(f"Error sending welcome email: {e}")
