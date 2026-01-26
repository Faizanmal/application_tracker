import uuid
from django.db import models
from django.conf import settings


class ProfessionalConnection(models.Model):
    """Track professional connections made during job search."""
    
    class ConnectionType(models.TextChoices):
        LINKEDIN = 'linkedin', 'LinkedIn'
        EMAIL = 'email', 'Email'
        IN_PERSON = 'in_person', 'In Person'
        CONFERENCE = 'conference', 'Conference'
        REFERRAL = 'referral', 'Referral'
        ALUMNI = 'alumni', 'Alumni'
        OTHER = 'other', 'Other'
    
    class RelationshipStrength(models.TextChoices):
        WEAK = 'weak', 'Weak (Met once)'
        MODERATE = 'moderate', 'Moderate (Occasional contact)'
        STRONG = 'strong', 'Strong (Regular contact)'
        CLOSE = 'close', 'Close (Trusted relationship)'
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='professional_connections'
    )
    
    # Contact Information
    name = models.CharField(max_length=200)
    email = models.EmailField(blank=True)
    phone = models.CharField(max_length=20, blank=True)
    linkedin_url = models.URLField(blank=True)
    
    # Professional Details
    company = models.CharField(max_length=200, blank=True)
    job_title = models.CharField(max_length=200, blank=True)
    department = models.CharField(max_length=100, blank=True)
    
    # Connection Details
    connection_type = models.CharField(
        max_length=20,
        choices=ConnectionType.choices,
        default=ConnectionType.LINKEDIN
    )
    relationship_strength = models.CharField(
        max_length=20,
        choices=RelationshipStrength.choices,
        default=RelationshipStrength.WEAK
    )
    
    # Metadata
    met_at = models.CharField(max_length=200, blank=True)  # Event, conference, etc.
    met_date = models.DateField(null=True, blank=True)
    notes = models.TextField(blank=True)
    tags = models.JSONField(default=list, blank=True)
    
    # Alumni connection
    is_alumni = models.BooleanField(default=False)
    shared_school = models.CharField(max_length=200, blank=True)
    graduation_year = models.PositiveIntegerField(null=True, blank=True)
    
    # Follow-up tracking
    last_contact_date = models.DateField(null=True, blank=True)
    next_follow_up = models.DateField(null=True, blank=True)
    follow_up_notes = models.TextField(blank=True)
    
    # Profile picture from LinkedIn
    avatar_url = models.URLField(blank=True)
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        ordering = ['-updated_at']
        indexes = [
            models.Index(fields=['user', 'company']),
            models.Index(fields=['user', 'is_alumni']),
        ]
    
    def __str__(self):
        return f"{self.name} at {self.company}"


class Referral(models.Model):
    """Track referrals for job applications."""
    
    class Status(models.TextChoices):
        PENDING = 'pending', 'Pending'
        SUBMITTED = 'submitted', 'Submitted'
        ACKNOWLEDGED = 'acknowledged', 'Acknowledged'
        HIRED = 'hired', 'Hired (Success!)'
        CLOSED = 'closed', 'Closed'
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='referrals'
    )
    
    # Connection who referred
    referrer = models.ForeignKey(
        ProfessionalConnection,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='referrals_given'
    )
    referrer_name = models.CharField(max_length=200)  # Backup if connection deleted
    referrer_email = models.EmailField(blank=True)
    
    # Application
    application = models.ForeignKey(
        'applications.JobApplication',
        on_delete=models.CASCADE,
        related_name='referrals'
    )
    
    # Status
    status = models.CharField(
        max_length=20,
        choices=Status.choices,
        default=Status.PENDING
    )
    
    # Details
    referral_date = models.DateField(auto_now_add=True)
    referral_code = models.CharField(max_length=100, blank=True)
    notes = models.TextField(blank=True)
    
    # Thank you tracking
    thank_you_sent = models.BooleanField(default=False)
    thank_you_date = models.DateField(null=True, blank=True)
    
    # Bonus tracking (some companies give referral bonuses)
    referral_bonus_received = models.BooleanField(default=False)
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        ordering = ['-created_at']
    
    def __str__(self):
        return f"Referral from {self.referrer_name} for {self.application.company_name}"


class NetworkingEvent(models.Model):
    """Track networking events and conferences."""
    
    class EventType(models.TextChoices):
        CONFERENCE = 'conference', 'Conference'
        MEETUP = 'meetup', 'Meetup'
        CAREER_FAIR = 'career_fair', 'Career Fair'
        WEBINAR = 'webinar', 'Webinar'
        COFFEE_CHAT = 'coffee_chat', 'Coffee Chat'
        INFORMATIONAL = 'informational', 'Informational Interview'
        OTHER = 'other', 'Other'
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='networking_events'
    )
    
    name = models.CharField(max_length=200)
    event_type = models.CharField(
        max_length=20,
        choices=EventType.choices,
        default=EventType.MEETUP
    )
    
    # Event Details
    date = models.DateTimeField()
    location = models.CharField(max_length=200, blank=True)
    virtual_link = models.URLField(blank=True)
    is_virtual = models.BooleanField(default=False)
    
    # Companies present
    companies = models.JSONField(default=list, blank=True)
    
    # Connections made
    connections_made = models.ManyToManyField(
        ProfessionalConnection,
        related_name='events_attended',
        blank=True
    )
    
    # Notes
    preparation_notes = models.TextField(blank=True)
    post_event_notes = models.TextField(blank=True)
    
    # Follow-up
    follow_up_completed = models.BooleanField(default=False)
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        ordering = ['-date']
    
    def __str__(self):
        return self.name


class MentorshipRelationship(models.Model):
    """Track mentorship connections."""
    
    class Status(models.TextChoices):
        SEEKING = 'seeking', 'Seeking Mentor'
        ACTIVE = 'active', 'Active'
        PAUSED = 'paused', 'Paused'
        COMPLETED = 'completed', 'Completed'
    
    class MeetingFrequency(models.TextChoices):
        WEEKLY = 'weekly', 'Weekly'
        BIWEEKLY = 'biweekly', 'Bi-weekly'
        MONTHLY = 'monthly', 'Monthly'
        AD_HOC = 'ad_hoc', 'As Needed'
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='mentorships'
    )
    
    # Mentor details
    mentor = models.ForeignKey(
        ProfessionalConnection,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='mentorships'
    )
    mentor_name = models.CharField(max_length=200)
    mentor_role = models.CharField(max_length=200, blank=True)
    mentor_company = models.CharField(max_length=200, blank=True)
    
    # Status
    status = models.CharField(
        max_length=20,
        choices=Status.choices,
        default=Status.SEEKING
    )
    
    # Meeting details
    meeting_frequency = models.CharField(
        max_length=20,
        choices=MeetingFrequency.choices,
        default=MeetingFrequency.MONTHLY
    )
    
    # Goals
    goals = models.JSONField(default=list, blank=True)
    focus_areas = models.JSONField(default=list, blank=True)  # Skills, interview prep, etc.
    
    # Sessions
    total_sessions = models.PositiveIntegerField(default=0)
    next_session = models.DateTimeField(null=True, blank=True)
    
    # Notes
    notes = models.TextField(blank=True)
    
    started_at = models.DateField(null=True, blank=True)
    ended_at = models.DateField(null=True, blank=True)
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        ordering = ['-updated_at']
    
    def __str__(self):
        return f"Mentorship with {self.mentor_name}"


class MentorshipSession(models.Model):
    """Track individual mentorship sessions."""
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    mentorship = models.ForeignKey(
        MentorshipRelationship,
        on_delete=models.CASCADE,
        related_name='sessions'
    )
    
    date = models.DateTimeField()
    duration_minutes = models.PositiveIntegerField(default=60)
    
    # Agenda and notes
    agenda = models.TextField(blank=True)
    notes = models.TextField(blank=True)
    
    # Action items
    action_items = models.JSONField(default=list, blank=True)
    
    # Rating (self-assessment of session value)
    rating = models.PositiveIntegerField(null=True, blank=True)  # 1-5
    
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        ordering = ['-date']
    
    def __str__(self):
        return f"Session on {self.date.date()} - {self.mentorship}"
