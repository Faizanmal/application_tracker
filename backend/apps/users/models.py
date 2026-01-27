import uuid
from django.db import models
from django.contrib.auth.models import AbstractBaseUser, PermissionsMixin, BaseUserManager
from django.utils import timezone


class UserManager(BaseUserManager):
    """Custom user manager for email-based authentication."""
    
    def create_user(self, email, password=None, **extra_fields):
        if not email:
            raise ValueError('Users must have an email address')
        email = self.normalize_email(email)
        user = self.model(email=email, **extra_fields)
        user.set_password(password)
        user.save(using=self._db)
        return user
    
    def create_superuser(self, email, password=None, **extra_fields):
        extra_fields.setdefault('is_staff', True)
        extra_fields.setdefault('is_superuser', True)
        extra_fields.setdefault('is_active', True)
        
        if extra_fields.get('is_staff') is not True:
            raise ValueError('Superuser must have is_staff=True.')
        if extra_fields.get('is_superuser') is not True:
            raise ValueError('Superuser must have is_superuser=True.')
        
        return self.create_user(email, password, **extra_fields)


class User(AbstractBaseUser, PermissionsMixin):
    """Custom user model with email as the unique identifier."""
    
    class SubscriptionTier(models.TextChoices):
        FREE = 'free', 'Free'
        PRO = 'pro', 'Pro'
        ENTERPRISE = 'enterprise', 'Enterprise'
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    email = models.EmailField(unique=True, max_length=255)
    first_name = models.CharField(max_length=100, blank=True)
    last_name = models.CharField(max_length=100, blank=True)
    avatar = models.ImageField(upload_to='avatars/', null=True, blank=True)
    
    # OAuth fields
    google_id = models.CharField(max_length=255, null=True, blank=True, unique=True)
    github_id = models.CharField(max_length=255, null=True, blank=True, unique=True)
    
    # Subscription
    subscription_tier = models.CharField(
        max_length=20,
        choices=SubscriptionTier.choices,
        default=SubscriptionTier.FREE
    )
    stripe_customer_id = models.CharField(max_length=255, null=True, blank=True)
    subscription_expires_at = models.DateTimeField(null=True, blank=True)
    
    # Preferences
    email_notifications = models.BooleanField(default=True)
    push_notifications = models.BooleanField(default=True)
    user_timezone = models.CharField(max_length=50, default='UTC')
    
    # Status
    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=False)
    is_verified = models.BooleanField(default=False)
    
    # Timestamps
    date_joined = models.DateTimeField(default=timezone.now)
    last_login = models.DateTimeField(null=True, blank=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    objects = UserManager()
    
    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = []
    
    class Meta:
        verbose_name = 'user'
        verbose_name_plural = 'users'
        ordering = ['-date_joined']
    
    def __str__(self):
        return self.email
    
    @property
    def full_name(self):
        return f"{self.first_name} {self.last_name}".strip() or self.email
    
    @property
    def is_pro(self):
        if self.subscription_tier in [self.SubscriptionTier.PRO, self.SubscriptionTier.ENTERPRISE]:
            if self.subscription_expires_at:
                return self.subscription_expires_at > timezone.now()
            return True
        return False


class UserProfile(models.Model):
    """Extended user profile for additional details."""
    
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='profile')
    
    # Job search preferences
    target_role = models.CharField(max_length=200, blank=True)
    target_industry = models.CharField(max_length=200, blank=True)
    preferred_locations = models.JSONField(default=list, blank=True)
    min_salary = models.DecimalField(max_digits=12, decimal_places=2, null=True, blank=True)
    max_salary = models.DecimalField(max_digits=12, decimal_places=2, null=True, blank=True)
    
    # Professional info
    linkedin_url = models.URLField(blank=True)
    portfolio_url = models.URLField(blank=True)
    years_of_experience = models.PositiveIntegerField(default=0)
    current_company = models.CharField(max_length=200, blank=True)
    current_role = models.CharField(max_length=200, blank=True)
    
    # Bio
    bio = models.TextField(blank=True, max_length=1000)
    skills = models.JSONField(default=list, blank=True)
    
    # Google Calendar integration
    google_calendar_connected = models.BooleanField(default=False)
    google_calendar_token = models.JSONField(null=True, blank=True)
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    def __str__(self):
        return f"Profile of {self.user.email}"


class Resume(models.Model):
    """User resume versions for tracking which version was used for each application."""
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='resumes')
    
    name = models.CharField(max_length=200)
    file = models.FileField(upload_to='resumes/')
    version = models.CharField(max_length=50, blank=True)
    is_default = models.BooleanField(default=False)
    
    # Parsed content (for AI features)
    parsed_content = models.TextField(blank=True)
    skills_extracted = models.JSONField(default=list, blank=True)
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        ordering = ['-created_at']
    
    def __str__(self):
        return f"{self.name} - {self.user.email}"
    
    def save(self, *args, **kwargs):
        if self.is_default:
            Resume.objects.filter(user=self.user, is_default=True).update(is_default=False)
        super().save(*args, **kwargs)


class PasswordResetToken(models.Model):
    """Password reset token for users."""
    
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='password_reset_tokens')
    token = models.CharField(max_length=255, unique=True)
    expires_at = models.DateTimeField()
    used = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)
    
    def is_valid(self):
        return not self.used and self.expires_at > timezone.now()


class EmailVerificationToken(models.Model):
    """Email verification token for users."""
    
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='email_verification_tokens')
    token = models.CharField(max_length=255, unique=True)
    expires_at = models.DateTimeField()
    used = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)
    
    def is_valid(self):
        return not self.used and self.expires_at > timezone.now()


class TutorialProgress(models.Model):
    """Track user progress through tutorials."""
    
    class TutorialType(models.TextChoices):
        APPLICATION_TRACKING = 'application_tracking', 'Application Tracking'
        ANALYTICS_DASHBOARD = 'analytics_dashboard', 'Analytics Dashboard'
        CALENDAR_INTEGRATION = 'calendar_integration', 'Calendar Integration'
        REMINDERS_SYSTEM = 'reminders_system', 'Reminders System'
    
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='tutorial_progress')
    tutorial_type = models.CharField(
        max_length=30,
        choices=TutorialType.choices
    )
    current_step = models.PositiveIntegerField(default=1)
    completed_steps = models.JSONField(default=list)  # List of completed step IDs
    is_completed = models.BooleanField(default=False)
    completed_at = models.DateTimeField(null=True, blank=True)
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        unique_together = ['user', 'tutorial_type']
    
    def __str__(self):
        return f"{self.user.email} - {self.tutorial_type}"


class HelpTooltip(models.Model):
    """Contextual help tooltips."""
    
    class TooltipType(models.TextChoices):
        APPLICATION_FORM = 'application_form', 'Application Form'
        DASHBOARD = 'dashboard', 'Dashboard'
        ANALYTICS = 'analytics', 'Analytics'
        REMINDERS = 'reminders', 'Reminders'
        SETTINGS = 'settings', 'Settings'
    
    identifier = models.CharField(max_length=100, unique=True)  # e.g., 'dashboard.stats'
    tooltip_type = models.CharField(
        max_length=20,
        choices=TooltipType.choices
    )
    title = models.CharField(max_length=200)
    content = models.TextField()
    placement = models.CharField(max_length=20, default='top')  # top, bottom, left, right
    is_active = models.BooleanField(default=True)
    
    # Targeting
    show_to_new_users = models.BooleanField(default=True)
    show_after_days = models.PositiveIntegerField(null=True, blank=True)  # Show after X days
    
    created_at = models.DateTimeField(auto_now_add=True)
    
    def __str__(self):
        return self.identifier


class SampleDataRequest(models.Model):
    """Track requests for sample data generation."""
    
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='sample_data_request')
    is_completed = models.BooleanField(default=False)
    applications_created = models.PositiveIntegerField(default=0)
    completed_at = models.DateTimeField(null=True, blank=True)
    
    created_at = models.DateTimeField(auto_now_add=True)
    
    def __str__(self):
        return f"Sample data for {self.user.email}"
