import uuid
from django.db import models
from django.conf import settings


class Interview(models.Model):
    """Model for tracking interviews."""
    
    class InterviewType(models.TextChoices):
        PHONE_SCREEN = 'phone_screen', 'Phone Screen'
        VIDEO_CALL = 'video_call', 'Video Call'
        ONSITE = 'onsite', 'On-site'
        TECHNICAL = 'technical', 'Technical'
        BEHAVIORAL = 'behavioral', 'Behavioral'
        CASE_STUDY = 'case_study', 'Case Study'
        PANEL = 'panel', 'Panel'
        FINAL = 'final', 'Final Round'
        OTHER = 'other', 'Other'
    
    class Status(models.TextChoices):
        SCHEDULED = 'scheduled', 'Scheduled'
        COMPLETED = 'completed', 'Completed'
        CANCELLED = 'cancelled', 'Cancelled'
        RESCHEDULED = 'rescheduled', 'Rescheduled'
        NO_SHOW = 'no_show', 'No Show'
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    application = models.ForeignKey(
        'applications.JobApplication',
        on_delete=models.CASCADE,
        related_name='interviews'
    )
    
    # Interview Details
    interview_type = models.CharField(
        max_length=20,
        choices=InterviewType.choices,
        default=InterviewType.VIDEO_CALL
    )
    round_number = models.PositiveIntegerField(default=1)
    title = models.CharField(max_length=200, blank=True)
    
    # Scheduling
    scheduled_at = models.DateTimeField()
    duration_minutes = models.PositiveIntegerField(default=60)
    timezone = models.CharField(max_length=50, default='UTC')
    
    # Location / Meeting Info
    location = models.CharField(max_length=500, blank=True)
    meeting_link = models.URLField(blank=True)
    meeting_id = models.CharField(max_length=100, blank=True)
    meeting_password = models.CharField(max_length=50, blank=True)
    
    # Interviewer Info
    interviewer_name = models.CharField(max_length=200, blank=True)
    interviewer_title = models.CharField(max_length=200, blank=True)
    interviewer_email = models.EmailField(blank=True)
    interviewer_linkedin = models.URLField(blank=True)
    
    # Status
    status = models.CharField(
        max_length=20,
        choices=Status.choices,
        default=Status.SCHEDULED
    )
    
    # Notes and Preparation
    preparation_notes = models.TextField(blank=True)
    post_interview_notes = models.TextField(blank=True)
    feedback = models.TextField(blank=True)
    rating = models.PositiveIntegerField(null=True, blank=True)  # 1-5 self-rating
    
    # Calendar Integration
    google_event_id = models.CharField(max_length=255, blank=True)
    
    # Timestamps
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        ordering = ['scheduled_at']
        indexes = [
            models.Index(fields=['application', 'scheduled_at']),
            models.Index(fields=['status', 'scheduled_at']),
        ]
    
    def __str__(self):
        return f"{self.get_interview_type_display()} - {self.application.company_name}"


class InterviewQuestion(models.Model):
    """Interview questions for preparation."""
    
    class QuestionType(models.TextChoices):
        BEHAVIORAL = 'behavioral', 'Behavioral'
        TECHNICAL = 'technical', 'Technical'
        SITUATIONAL = 'situational', 'Situational'
        COMPETENCY = 'competency', 'Competency'
        BRAIN_TEASER = 'brain_teaser', 'Brain Teaser'
        CASE = 'case', 'Case'
        OTHER = 'other', 'Other'
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    interview = models.ForeignKey(
        Interview,
        on_delete=models.CASCADE,
        related_name='questions',
        null=True,
        blank=True
    )
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='interview_questions'
    )
    
    question = models.TextField()
    question_type = models.CharField(
        max_length=20,
        choices=QuestionType.choices,
        default=QuestionType.BEHAVIORAL
    )
    
    # For common questions library
    is_common = models.BooleanField(default=False)
    category = models.CharField(max_length=100, blank=True)
    
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        ordering = ['-created_at']
    
    def __str__(self):
        return self.question[:100]


class STARResponse(models.Model):
    """STAR method responses for behavioral questions."""
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    question = models.ForeignKey(
        InterviewQuestion,
        on_delete=models.CASCADE,
        related_name='star_responses'
    )
    
    situation = models.TextField(help_text="Describe the situation or context")
    task = models.TextField(help_text="Explain the task you needed to accomplish")
    action = models.TextField(help_text="Describe the actions you took")
    result = models.TextField(help_text="Share the results of your actions")
    
    # Optional AI-generated improvements
    ai_suggestions = models.JSONField(null=True, blank=True)
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        ordering = ['-updated_at']
    
    def __str__(self):
        return f"STAR Response for: {self.question.question[:50]}"


class CompanyResearch(models.Model):
    """Company research notes for interview preparation."""
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    application = models.OneToOneField(
        'applications.JobApplication',
        on_delete=models.CASCADE,
        related_name='company_research'
    )
    
    # Company Information
    mission_statement = models.TextField(blank=True)
    values = models.JSONField(default=list, blank=True)
    recent_news = models.TextField(blank=True)
    products_services = models.TextField(blank=True)
    competitors = models.JSONField(default=list, blank=True)
    culture_notes = models.TextField(blank=True)
    
    # Key People
    key_people = models.JSONField(default=list, blank=True)  # [{name, title, linkedin}]
    
    # Questions to Ask
    questions_to_ask = models.JSONField(default=list, blank=True)
    
    # Why This Company
    why_interested = models.TextField(blank=True)
    how_you_fit = models.TextField(blank=True)
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    def __str__(self):
        return f"Research for {self.application.company_name}"


class CommonQuestion(models.Model):
    """Pre-populated common interview questions."""
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    
    question = models.TextField()
    category = models.CharField(max_length=100)
    question_type = models.CharField(
        max_length=20,
        choices=InterviewQuestion.QuestionType.choices
    )
    
    # For role-specific questions
    roles = models.JSONField(default=list, blank=True)  # ['software engineer', 'product manager']
    
    # Tips for answering
    tips = models.TextField(blank=True)
    sample_answer = models.TextField(blank=True)
    
    is_active = models.BooleanField(default=True)
    
    class Meta:
        ordering = ['category', 'question_type']
    
    def __str__(self):
        return self.question[:100]
