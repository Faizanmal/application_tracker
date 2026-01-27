import uuid
from django.db import models
from django.conf import settings


class JobApplication(models.Model):
    """Model for tracking job applications."""
    
    class Status(models.TextChoices):
        WISHLIST = 'wishlist', 'Wishlist'
        APPLIED = 'applied', 'Applied'
        SCREENING = 'screening', 'Screening'
        INTERVIEWING = 'interviewing', 'Interviewing'
        OFFER = 'offer', 'Offer'
        ACCEPTED = 'accepted', 'Accepted'
        REJECTED = 'rejected', 'Rejected'
        WITHDRAWN = 'withdrawn', 'Withdrawn'
        GHOSTED = 'ghosted', 'Ghosted'
    
    class JobType(models.TextChoices):
        FULL_TIME = 'full_time', 'Full Time'
        PART_TIME = 'part_time', 'Part Time'
        CONTRACT = 'contract', 'Contract'
        INTERNSHIP = 'internship', 'Internship'
        FREELANCE = 'freelance', 'Freelance'
        REMOTE = 'remote', 'Remote'
    
    class WorkLocation(models.TextChoices):
        ONSITE = 'onsite', 'On-site'
        REMOTE = 'remote', 'Remote'
        HYBRID = 'hybrid', 'Hybrid'
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='applications'
    )
    
    # Company Information
    company_name = models.CharField(max_length=200)
    company_website = models.URLField(blank=True)
    company_logo = models.URLField(blank=True)
    company_size = models.CharField(max_length=50, blank=True)
    company_industry = models.CharField(max_length=100, blank=True)
    
    # Job Information
    job_title = models.CharField(max_length=200)
    job_link = models.URLField(blank=True)
    job_description = models.TextField(blank=True)
    job_type = models.CharField(
        max_length=20,
        choices=JobType.choices,
        default=JobType.FULL_TIME
    )
    work_location = models.CharField(
        max_length=20,
        choices=WorkLocation.choices,
        default=WorkLocation.ONSITE
    )
    location = models.CharField(max_length=200, blank=True)
    
    # Salary Information
    salary_min = models.DecimalField(max_digits=12, decimal_places=2, null=True, blank=True)
    salary_max = models.DecimalField(max_digits=12, decimal_places=2, null=True, blank=True)
    salary_currency = models.CharField(max_length=3, default='USD')
    
    # Application Status
    status = models.CharField(
        max_length=20,
        choices=Status.choices,
        default=Status.WISHLIST
    )
    status_order = models.PositiveIntegerField(default=0)  # For Kanban ordering
    
    # Dates
    applied_date = models.DateField(null=True, blank=True)
    deadline = models.DateField(null=True, blank=True)
    response_date = models.DateField(null=True, blank=True)
    
    # Resume & Cover Letter
    resume = models.ForeignKey(
        'users.Resume',
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='applications'
    )
    cover_letter = models.TextField(blank=True)
    cover_letter_file = models.FileField(upload_to='cover_letters/', null=True, blank=True)
    
    # Additional Info
    notes = models.TextField(blank=True)
    is_favorite = models.BooleanField(default=False)
    is_archived = models.BooleanField(default=False)
    
    # Contact Information
    contact_name = models.CharField(max_length=200, blank=True)
    contact_email = models.EmailField(blank=True)
    contact_phone = models.CharField(max_length=20, blank=True)
    contact_linkedin = models.URLField(blank=True)
    
    # AI Match Score (optional feature)
    match_score = models.PositiveIntegerField(null=True, blank=True)
    match_analysis = models.JSONField(null=True, blank=True)
    
    # Source tracking
    source = models.CharField(max_length=100, blank=True)  # LinkedIn, Indeed, etc.
    referral = models.CharField(max_length=200, blank=True)
    
    # Timestamps
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        ordering = ['-updated_at']
        indexes = [
            models.Index(fields=['user', 'status']),
            models.Index(fields=['user', 'created_at']),
            models.Index(fields=['user', 'is_archived']),
        ]
    
    def __str__(self):
        return f"{self.job_title} at {self.company_name}"


class ApplicationTimeline(models.Model):
    """Timeline entries for application status changes and activities."""
    
    class EventType(models.TextChoices):
        STATUS_CHANGE = 'status_change', 'Status Change'
        NOTE_ADDED = 'note_added', 'Note Added'
        INTERVIEW_SCHEDULED = 'interview_scheduled', 'Interview Scheduled'
        FOLLOW_UP = 'follow_up', 'Follow Up'
        DOCUMENT_ADDED = 'document_added', 'Document Added'
        CUSTOM = 'custom', 'Custom'
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    application = models.ForeignKey(
        JobApplication,
        on_delete=models.CASCADE,
        related_name='timeline'
    )
    
    event_type = models.CharField(
        max_length=30,
        choices=EventType.choices
    )
    title = models.CharField(max_length=200)
    description = models.TextField(blank=True)
    
    # For status changes
    old_status = models.CharField(max_length=20, blank=True)
    new_status = models.CharField(max_length=20, blank=True)
    
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        ordering = ['-created_at']
    
    def __str__(self):
        return f"{self.title} - {self.application.job_title}"


class ApplicationTag(models.Model):
    """Tags for organizing applications."""
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='application_tags'
    )
    name = models.CharField(max_length=50)
    color = models.CharField(max_length=7, default='#3B82F6')  # Hex color
    
    applications = models.ManyToManyField(
        JobApplication,
        related_name='tags',
        blank=True
    )
    
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        unique_together = ['user', 'name']
        ordering = ['name']
    
    def __str__(self):
        return self.name


class ApplicationDocument(models.Model):
    """Documents attached to applications."""
    
    class DocType(models.TextChoices):
        RESUME = 'resume', 'Resume'
        COVER_LETTER = 'cover_letter', 'Cover Letter'
        PORTFOLIO = 'portfolio', 'Portfolio'
        REFERENCE = 'reference', 'Reference'
        OTHER = 'other', 'Other'
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    application = models.ForeignKey(
        JobApplication,
        on_delete=models.CASCADE,
        related_name='documents'
    )
    
    name = models.CharField(max_length=200)
    file = models.FileField(upload_to='application_documents/')
    doc_type = models.CharField(
        max_length=20,
        choices=DocType.choices,
        default=DocType.OTHER
    )
    
    created_at = models.DateTimeField(auto_now_add=True)
    
    def __str__(self):
        return f"{self.name} - {self.application.job_title}"


class ApplicationShare(models.Model):
    """Sharing applications with mentors or accountability partners."""
    
    class ShareType(models.TextChoices):
        MENTOR = 'mentor', 'Mentor'
        ACCOUNTABILITY = 'accountability', 'Accountability Partner'
        NETWORKING = 'networking', 'Networking'
    
    class PermissionLevel(models.TextChoices):
        VIEW = 'view', 'View Only'
        COMMENT = 'comment', 'View and Comment'
        EDIT = 'edit', 'Full Edit'
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    application = models.ForeignKey(
        JobApplication,
        on_delete=models.CASCADE,
        related_name='shares'
    )
    
    # Who shared
    shared_by = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='shared_applications'
    )
    
    # Who it's shared with
    shared_with_email = models.EmailField()
    shared_with_user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        null=True,
        blank=True,
        related_name='received_application_shares'
    )
    
    share_type = models.CharField(
        max_length=20,
        choices=ShareType.choices,
        default=ShareType.MENTOR
    )
    permission_level = models.CharField(
        max_length=20,
        choices=PermissionLevel.choices,
        default=PermissionLevel.VIEW
    )
    
    # Share settings
    can_view_progress = models.BooleanField(default=True)
    can_view_notes = models.BooleanField(default=True)
    expires_at = models.DateTimeField(null=True, blank=True)
    
    # Status
    is_accepted = models.BooleanField(default=False)
    accepted_at = models.DateTimeField(null=True, blank=True)
    is_active = models.BooleanField(default=True)
    
    # Message
    message = models.TextField(blank=True)
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        unique_together = ['application', 'shared_with_email']
        ordering = ['-created_at']
    
    def __str__(self):
        return f"{self.application.job_title} shared with {self.shared_with_email}"


class ApplicationComment(models.Model):
    """Comments on shared applications."""
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    application = models.ForeignKey(
        JobApplication,
        on_delete=models.CASCADE,
        related_name='comments'
    )
    share = models.ForeignKey(
        ApplicationShare,
        on_delete=models.CASCADE,
        related_name='comments'
    )
    
    author = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='application_comments'
    )
    
    content = models.TextField()
    
    # Parent comment for threading
    parent = models.ForeignKey(
        'self',
        on_delete=models.CASCADE,
        null=True,
        blank=True,
        related_name='replies'
    )
    
    # Metadata
    is_private = models.BooleanField(default=False)  # Only visible to sharer and commenter
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        ordering = ['created_at']
    
    def __str__(self):
        return f"Comment by {self.author.email} on {self.application.job_title}"


class ProgressUpdate(models.Model):
    """Progress updates for shared applications."""
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    application = models.ForeignKey(
        JobApplication,
        on_delete=models.CASCADE,
        related_name='progress_updates'
    )
    
    author = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='progress_updates'
    )
    
    title = models.CharField(max_length=200)
    content = models.TextField()
    
    # Progress metrics
    status_change = models.CharField(max_length=20, blank=True)
    days_since_last_update = models.PositiveIntegerField(default=0)
    
    # Visibility
    is_public = models.BooleanField(default=True)  # Visible to all shares
    
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        ordering = ['-created_at']
    
    def __str__(self):
        return f"Progress: {self.title} - {self.application.job_title}"
