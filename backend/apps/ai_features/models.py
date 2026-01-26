import uuid
from django.db import models
from django.conf import settings


class AIUsage(models.Model):
    """Track AI feature usage."""
    
    class FeatureType(models.TextChoices):
        FOLLOW_UP_EMAIL = 'follow_up_email', 'Follow Up Email'
        RESUME_MATCH = 'resume_match', 'Resume Match'
        INTERVIEW_QUESTIONS = 'interview_questions', 'Interview Questions'
        STAR_IMPROVEMENT = 'star_improvement', 'STAR Improvement'
        COVER_LETTER = 'cover_letter', 'Cover Letter'
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='ai_usage'
    )
    
    feature_type = models.CharField(max_length=30, choices=FeatureType.choices)
    tokens_used = models.PositiveIntegerField(default=0)
    
    # Related objects
    application = models.ForeignKey(
        'applications.JobApplication',
        on_delete=models.CASCADE,
        null=True,
        blank=True
    )
    
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        ordering = ['-created_at']
    
    def __str__(self):
        return f"{self.user.email} - {self.feature_type}"


class GeneratedContent(models.Model):
    """Store AI-generated content."""
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='generated_content'
    )
    
    content_type = models.CharField(max_length=30)
    prompt = models.TextField()
    generated_text = models.TextField()
    
    # Metadata
    model_used = models.CharField(max_length=50, default='gpt-4')
    tokens_used = models.PositiveIntegerField(default=0)
    
    # Related
    application = models.ForeignKey(
        'applications.JobApplication',
        on_delete=models.CASCADE,
        null=True,
        blank=True
    )
    
    # User feedback
    rating = models.PositiveIntegerField(null=True, blank=True)  # 1-5
    is_used = models.BooleanField(default=False)
    
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        ordering = ['-created_at']
    
    def __str__(self):
        return f"{self.content_type} - {self.user.email}"
