from rest_framework import serializers
from .models import Interview, InterviewQuestion, STARResponse, CompanyResearch, CommonQuestion


class STARResponseSerializer(serializers.ModelSerializer):
    """Serializer for STAR responses."""
    
    class Meta:
        model = STARResponse
        fields = [
            'id', 'situation', 'task', 'action', 'result',
            'ai_suggestions', 'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'ai_suggestions', 'created_at', 'updated_at']


class InterviewQuestionSerializer(serializers.ModelSerializer):
    """Serializer for interview questions."""
    
    star_responses = STARResponseSerializer(many=True, read_only=True)
    
    class Meta:
        model = InterviewQuestion
        fields = [
            'id', 'question', 'question_type', 'is_common',
            'category', 'star_responses', 'created_at'
        ]
        read_only_fields = ['id', 'created_at']
    
    def create(self, validated_data):
        validated_data['user'] = self.context['request'].user
        return super().create(validated_data)


class InterviewListSerializer(serializers.ModelSerializer):
    """Serializer for listing interviews."""
    
    application_company = serializers.CharField(source='application.company_name', read_only=True)
    application_job_title = serializers.CharField(source='application.job_title', read_only=True)
    
    class Meta:
        model = Interview
        fields = [
            'id', 'application', 'application_company', 'application_job_title',
            'interview_type', 'round_number', 'title', 'scheduled_at',
            'duration_minutes', 'status', 'meeting_link', 'interviewer_name',
            'created_at'
        ]
        read_only_fields = ['id', 'created_at']


class InterviewDetailSerializer(serializers.ModelSerializer):
    """Serializer for interview details."""
    
    application_company = serializers.CharField(source='application.company_name', read_only=True)
    application_job_title = serializers.CharField(source='application.job_title', read_only=True)
    questions = InterviewQuestionSerializer(many=True, read_only=True)
    
    class Meta:
        model = Interview
        fields = [
            'id', 'application', 'application_company', 'application_job_title',
            'interview_type', 'round_number', 'title', 'scheduled_at',
            'duration_minutes', 'timezone', 'location', 'meeting_link',
            'meeting_id', 'meeting_password', 'interviewer_name',
            'interviewer_title', 'interviewer_email', 'interviewer_linkedin',
            'status', 'preparation_notes', 'post_interview_notes',
            'feedback', 'rating', 'google_event_id', 'questions',
            'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'google_event_id', 'created_at', 'updated_at']
    
    def validate_application(self, value):
        if value.user != self.context['request'].user:
            raise serializers.ValidationError("Application not found.")
        return value


class CompanyResearchSerializer(serializers.ModelSerializer):
    """Serializer for company research."""
    
    class Meta:
        model = CompanyResearch
        fields = [
            'id', 'application', 'mission_statement', 'values',
            'recent_news', 'products_services', 'competitors',
            'culture_notes', 'key_people', 'questions_to_ask',
            'why_interested', 'how_you_fit', 'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'created_at', 'updated_at']
    
    def validate_application(self, value):
        if value.user != self.context['request'].user:
            raise serializers.ValidationError("Application not found.")
        return value


class CommonQuestionSerializer(serializers.ModelSerializer):
    """Serializer for common interview questions."""
    
    class Meta:
        model = CommonQuestion
        fields = [
            'id', 'question', 'category', 'question_type',
            'roles', 'tips', 'sample_answer'
        ]


class UpcomingInterviewSerializer(serializers.ModelSerializer):
    """Serializer for upcoming interviews widget."""
    
    company_name = serializers.CharField(source='application.company_name')
    job_title = serializers.CharField(source='application.job_title')
    company_logo = serializers.CharField(source='application.company_logo')
    
    class Meta:
        model = Interview
        fields = [
            'id', 'company_name', 'job_title', 'company_logo',
            'interview_type', 'scheduled_at', 'duration_minutes',
            'meeting_link', 'status'
        ]
