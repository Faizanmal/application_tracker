from rest_framework import serializers
from .models import AIUsage, GeneratedContent


class AIUsageSerializer(serializers.ModelSerializer):
    """Serializer for AI usage tracking."""
    
    class Meta:
        model = AIUsage
        fields = ['id', 'feature_type', 'tokens_used', 'created_at']


class GeneratedContentSerializer(serializers.ModelSerializer):
    """Serializer for generated content."""
    
    class Meta:
        model = GeneratedContent
        fields = [
            'id', 'content_type', 'generated_text', 'model_used',
            'rating', 'is_used', 'created_at'
        ]


class GenerateFollowUpEmailSerializer(serializers.Serializer):
    """Serializer for follow-up email generation."""
    
    application_id = serializers.UUIDField()
    tone = serializers.ChoiceField(
        choices=['professional', 'friendly', 'enthusiastic'],
        default='professional'
    )
    include_points = serializers.ListField(
        child=serializers.CharField(),
        required=False,
        default=list
    )


class ResumeMatchSerializer(serializers.Serializer):
    """Serializer for resume-job matching."""
    
    application_id = serializers.UUIDField()
    resume_id = serializers.UUIDField(required=False)


class InterviewQuestionsSerializer(serializers.Serializer):
    """Serializer for interview question generation."""
    
    application_id = serializers.UUIDField()
    question_types = serializers.ListField(
        child=serializers.ChoiceField(
            choices=['behavioral', 'technical', 'situational', 'general']
        ),
        required=False,
        default=['behavioral', 'technical']
    )
    count = serializers.IntegerField(min_value=1, max_value=20, default=10)


class ImproveSTARSerializer(serializers.Serializer):
    """Serializer for STAR response improvement."""
    
    situation = serializers.CharField()
    task = serializers.CharField()
    action = serializers.CharField()
    result = serializers.CharField()
    question = serializers.CharField(required=False)


class GenerateCoverLetterSerializer(serializers.Serializer):
    """Serializer for cover letter generation."""
    
    application_id = serializers.UUIDField()
    resume_id = serializers.UUIDField(required=False)
    highlights = serializers.ListField(
        child=serializers.CharField(),
        required=False,
        default=list
    )
    tone = serializers.ChoiceField(
        choices=['professional', 'creative', 'enthusiastic'],
        default='professional'
    )
