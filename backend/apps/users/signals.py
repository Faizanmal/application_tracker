from django.db.models.signals import post_save
from django.dispatch import receiver
from .models import User, UserProfile
from .tasks import send_welcome_email


@receiver(post_save, sender=User)
def create_user_profile(sender, instance, created, **kwargs):
    """Create user profile when user is created."""
    if created:
        UserProfile.objects.get_or_create(user=instance)


@receiver(post_save, sender=User)
def send_welcome_email_signal(sender, instance, created, **kwargs):
    """Send welcome email when user is created."""
    if created and instance.is_verified:
        try:
            send_welcome_email.delay(str(instance.id))
        except Exception:
            pass  # Don't fail if email fails
