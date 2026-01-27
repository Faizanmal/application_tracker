from rest_framework import serializers
from django.db import transaction
from .models import (
    JobApplication, ApplicationTimeline, ApplicationTag, ApplicationDocument,
    ApplicationShare, ApplicationComment, ProgressUpdate
)
from apps.users.serializers import ResumeSerializer


class ApplicationTimelineSerializer(serializers.ModelSerializer):
    """Serializer for application timeline."""
    
    class Meta:
        model = ApplicationTimeline
        fields = [
            'id', 'event_type', 'title', 'description',
            'old_status', 'new_status', 'created_at'
        ]
        read_only_fields = ['id', 'created_at']


class ApplicationTagSerializer(serializers.ModelSerializer):
    """Serializer for application tags."""
    
    class Meta:
        model = ApplicationTag
        fields = ['id', 'name', 'color', 'created_at']
        read_only_fields = ['id', 'created_at']
    
    def create(self, validated_data):
        validated_data['user'] = self.context['request'].user
        return super().create(validated_data)


class ApplicationDocumentSerializer(serializers.ModelSerializer):
    """Serializer for application documents."""
    
    class Meta:
        model = ApplicationDocument
        fields = ['id', 'name', 'file', 'doc_type', 'created_at']
        read_only_fields = ['id', 'created_at']


class JobApplicationListSerializer(serializers.ModelSerializer):
    """Serializer for listing job applications."""
    
    tags = ApplicationTagSerializer(many=True, read_only=True)
    interview_count = serializers.SerializerMethodField()
    next_interview = serializers.SerializerMethodField()
    
    class Meta:
        model = JobApplication
        fields = [
            'id', 'company_name', 'company_logo', 'job_title', 'job_link',
            'location', 'job_type', 'work_location', 'status', 'status_order',
            'applied_date', 'deadline', 'salary_min', 'salary_max', 'salary_currency',
            'is_favorite', 'is_archived', 'match_score', 'source',
            'tags', 'interview_count', 'next_interview', 'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'created_at', 'updated_at']
    
    def get_interview_count(self, obj):
        return obj.interviews.count() if hasattr(obj, 'interviews') else 0
    
    def get_next_interview(self, obj):
        from django.utils import timezone
        
        next_interview = obj.interviews.filter(
            scheduled_at__gte=timezone.now()
        ).order_by('scheduled_at').first()
        
        if next_interview:
            return {
                'id': str(next_interview.id),
                'scheduled_at': next_interview.scheduled_at,
                'interview_type': next_interview.interview_type
            }
        return None


class JobApplicationDetailSerializer(serializers.ModelSerializer):
    """Serializer for job application details."""
    
    tags = ApplicationTagSerializer(many=True, read_only=True)
    tag_ids = serializers.ListField(
        child=serializers.UUIDField(),
        write_only=True,
        required=False
    )
    resume = ResumeSerializer(read_only=True)
    resume_id = serializers.UUIDField(write_only=True, required=False, allow_null=True)
    timeline = ApplicationTimelineSerializer(many=True, read_only=True)
    documents = ApplicationDocumentSerializer(many=True, read_only=True)
    
    class Meta:
        model = JobApplication
        fields = [
            'id', 'company_name', 'company_website', 'company_logo',
            'company_size', 'company_industry', 'job_title', 'job_link',
            'job_description', 'job_type', 'work_location', 'location',
            'salary_min', 'salary_max', 'salary_currency', 'status', 'status_order',
            'applied_date', 'deadline', 'response_date', 'resume', 'resume_id',
            'cover_letter', 'cover_letter_file', 'notes', 'is_favorite', 'is_archived',
            'contact_name', 'contact_email', 'contact_phone', 'contact_linkedin',
            'match_score', 'match_analysis', 'source', 'referral',
            'tags', 'tag_ids', 'timeline', 'documents', 'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'created_at', 'updated_at', 'match_score', 'match_analysis']
    
    def create(self, validated_data):
        tag_ids = validated_data.pop('tag_ids', [])
        resume_id = validated_data.pop('resume_id', None)
        
        validated_data['user'] = self.context['request'].user
        
        if resume_id:
            from apps.users.models import Resume
            try:
                validated_data['resume'] = Resume.objects.get(
                    id=resume_id,
                    user=self.context['request'].user
                )
            except Resume.DoesNotExist:
                pass
        
        with transaction.atomic():
            application = super().create(validated_data)
            
            # Add tags
            if tag_ids:
                tags = ApplicationTag.objects.filter(
                    id__in=tag_ids,
                    user=self.context['request'].user
                )
                application.tags.set(tags)
            
            # Create timeline entry
            ApplicationTimeline.objects.create(
                application=application,
                event_type=ApplicationTimeline.EventType.STATUS_CHANGE,
                title='Application created',
                new_status=application.status
            )
        
        return application
    
    def update(self, instance, validated_data):
        tag_ids = validated_data.pop('tag_ids', None)
        resume_id = validated_data.pop('resume_id', None)
        old_status = instance.status
        
        if resume_id:
            from apps.users.models import Resume
            try:
                validated_data['resume'] = Resume.objects.get(
                    id=resume_id,
                    user=self.context['request'].user
                )
            except Resume.DoesNotExist:
                pass
        
        with transaction.atomic():
            instance = super().update(instance, validated_data)
            
            # Update tags if provided
            if tag_ids is not None:
                tags = ApplicationTag.objects.filter(
                    id__in=tag_ids,
                    user=self.context['request'].user
                )
                instance.tags.set(tags)
            
            # Create timeline entry for status change
            if old_status != instance.status:
                ApplicationTimeline.objects.create(
                    application=instance,
                    event_type=ApplicationTimeline.EventType.STATUS_CHANGE,
                    title=f'Status changed to {instance.get_status_display()}',
                    old_status=old_status,
                    new_status=instance.status
                )
        
        return instance


class ApplicationStatusUpdateSerializer(serializers.Serializer):
    """Serializer for updating application status."""
    
    status = serializers.ChoiceField(choices=JobApplication.Status.choices)
    status_order = serializers.IntegerField(required=False)


class BulkStatusUpdateSerializer(serializers.Serializer):
    """Serializer for bulk status update."""
    
    application_ids = serializers.ListField(child=serializers.UUIDField())
    status = serializers.ChoiceField(choices=JobApplication.Status.choices)


class KanbanOrderSerializer(serializers.Serializer):
    """Serializer for Kanban board ordering."""
    
    applications = serializers.ListField(
        child=serializers.DictField(
            child=serializers.CharField()
        )
    )


class ApplicationShareSerializer(serializers.ModelSerializer):
    """Serializer for application sharing."""
    
    shared_by_name = serializers.CharField(source='shared_by.get_full_name', read_only=True)
    application_title = serializers.CharField(source='application.job_title', read_only=True)
    company_name = serializers.CharField(source='application.company_name', read_only=True)
    
    class Meta:
        model = ApplicationShare
        fields = [
            'id', 'application', 'application_title', 'company_name',
            'shared_by', 'shared_by_name', 'shared_with_email', 'shared_with_user',
            'share_type', 'permission_level', 'can_view_progress', 'can_view_notes',
            'expires_at', 'is_accepted', 'accepted_at', 'is_active', 'message',
            'created_at'
        ]
        read_only_fields = ['id', 'shared_by', 'created_at', 'accepted_at']
    
    def create(self, validated_data):
        validated_data['shared_by'] = self.context['request'].user
        return super().create(validated_data)


class ApplicationCommentSerializer(serializers.ModelSerializer):
    """Serializer for application comments."""
    
    author_name = serializers.CharField(source='author.get_full_name', read_only=True)
    replies = serializers.SerializerMethodField()
    
    class Meta:
        model = ApplicationComment
        fields = [
            'id', 'application', 'share', 'author', 'author_name',
            'content', 'parent', 'replies', 'is_private', 'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'author', 'created_at', 'updated_at']
    
    def get_replies(self, obj):
        if obj.replies.exists():
            return ApplicationCommentSerializer(obj.replies.all(), many=True, context=self.context).data
        return []
    
    def create(self, validated_data):
        validated_data['author'] = self.context['request'].user
        return super().create(validated_data)


class ProgressUpdateSerializer(serializers.ModelSerializer):
    """Serializer for progress updates."""
    
    author_name = serializers.CharField(source='author.get_full_name', read_only=True)
    
    class Meta:
        model = ProgressUpdate
        fields = [
            'id', 'application', 'author', 'author_name', 'title', 'content',
            'status_change', 'days_since_last_update', 'is_public', 'created_at'
        ]
        read_only_fields = ['id', 'author', 'created_at']
