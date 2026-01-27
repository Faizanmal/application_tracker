"""
Application Templates functionality.
Allows users to create and reuse templates for common application types.
"""
import uuid
from django.db import models
from django.conf import settings
from rest_framework import serializers, generics, status
from rest_framework.views import APIView
from rest_framework.response import Response


# ============================================================================
# TEMPLATE MODELS
# ============================================================================

class ApplicationTemplate(models.Model):
    """Template for creating job applications quickly."""
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='application_templates'
    )
    
    # Template info
    name = models.CharField(max_length=100)
    description = models.TextField(blank=True)
    category = models.CharField(max_length=50, blank=True)  # e.g., "Tech", "Marketing", etc.
    
    # Default values for applications
    job_type = models.CharField(max_length=20, blank=True)
    work_location = models.CharField(max_length=20, blank=True)
    
    # Default cover letter template
    cover_letter_template = models.TextField(blank=True)
    
    # Default notes template
    notes_template = models.TextField(blank=True)
    
    # Resume to use
    default_resume = models.ForeignKey(
        'users.Resume',
        on_delete=models.SET_NULL,
        null=True,
        blank=True
    )
    
    # Default tags
    default_tags = models.ManyToManyField(
        'applications.ApplicationTag',
        blank=True,
        related_name='templates'
    )
    
    # Checklist items for applications of this type
    checklist = models.JSONField(default=list)
    
    # Usage stats
    use_count = models.PositiveIntegerField(default=0)
    is_favorite = models.BooleanField(default=False)
    
    # Timestamps
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        ordering = ['-use_count', '-updated_at']
        unique_together = ['user', 'name']
    
    def __str__(self):
        return f"{self.name} - {self.user.email}"


class CoverLetterTemplate(models.Model):
    """Reusable cover letter templates."""
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='cover_letter_templates'
    )
    
    name = models.CharField(max_length=100)
    description = models.TextField(blank=True)
    
    # Template content with placeholders
    # Placeholders: {{company_name}}, {{job_title}}, {{hiring_manager}}, etc.
    content = models.TextField()
    
    # Category for organization
    category = models.CharField(max_length=50, blank=True)
    
    # Track usage
    use_count = models.PositiveIntegerField(default=0)
    is_default = models.BooleanField(default=False)
    
    # Timestamps
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        ordering = ['-use_count', '-updated_at']
        unique_together = ['user', 'name']
    
    def __str__(self):
        return f"{self.name} - {self.user.email}"
    
    def render(self, context: dict) -> str:
        """Render template with context variables."""
        content = self.content
        for key, value in context.items():
            placeholder = '{{' + key + '}}'
            content = content.replace(placeholder, str(value) if value else '')
        return content


class ResumeVersion(models.Model):
    """Track different versions of resumes."""
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='resume_versions'
    )
    
    name = models.CharField(max_length=100)
    description = models.TextField(blank=True)
    
    # Resume file
    file = models.FileField(upload_to='resumes/')
    original_filename = models.CharField(max_length=255)
    
    # Categorization
    target_role = models.CharField(max_length=100, blank=True)
    target_industry = models.CharField(max_length=100, blank=True)
    
    # Version tracking
    version_number = models.CharField(max_length=20, default='1.0')
    parent_version = models.ForeignKey(
        'self',
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='child_versions'
    )
    
    # Skills extracted (for matching)
    skills = models.JSONField(default=list)
    
    # Usage stats
    use_count = models.PositiveIntegerField(default=0)
    is_default = models.BooleanField(default=False)
    
    # Timestamps
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        ordering = ['-is_default', '-use_count', '-created_at']
    
    def __str__(self):
        return f"{self.name} v{self.version_number}"


# ============================================================================
# SERIALIZERS
# ============================================================================

class ApplicationTemplateSerializer(serializers.ModelSerializer):
    """Serializer for application templates."""
    
    default_tag_ids = serializers.ListField(
        child=serializers.UUIDField(),
        write_only=True,
        required=False
    )
    
    class Meta:
        model = ApplicationTemplate
        fields = [
            'id', 'name', 'description', 'category',
            'job_type', 'work_location', 'cover_letter_template',
            'notes_template', 'default_resume', 'default_tags',
            'default_tag_ids', 'checklist', 'use_count', 'is_favorite',
            'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'use_count', 'created_at', 'updated_at']
    
    def create(self, validated_data):
        tag_ids = validated_data.pop('default_tag_ids', [])
        validated_data['user'] = self.context['request'].user
        
        template = super().create(validated_data)
        
        if tag_ids:
            from .models import ApplicationTag
            tags = ApplicationTag.objects.filter(
                id__in=tag_ids,
                user=self.context['request'].user
            )
            template.default_tags.set(tags)
        
        return template
    
    def update(self, instance, validated_data):
        tag_ids = validated_data.pop('default_tag_ids', None)
        
        instance = super().update(instance, validated_data)
        
        if tag_ids is not None:
            from .models import ApplicationTag
            tags = ApplicationTag.objects.filter(
                id__in=tag_ids,
                user=self.context['request'].user
            )
            instance.default_tags.set(tags)
        
        return instance


class CoverLetterTemplateSerializer(serializers.ModelSerializer):
    """Serializer for cover letter templates."""
    
    class Meta:
        model = CoverLetterTemplate
        fields = [
            'id', 'name', 'description', 'content', 'category',
            'use_count', 'is_default', 'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'use_count', 'created_at', 'updated_at']
    
    def create(self, validated_data):
        validated_data['user'] = self.context['request'].user
        
        # If this is set as default, unset other defaults
        if validated_data.get('is_default'):
            CoverLetterTemplate.objects.filter(
                user=validated_data['user'],
                is_default=True
            ).update(is_default=False)
        
        return super().create(validated_data)


class ResumeVersionSerializer(serializers.ModelSerializer):
    """Serializer for resume versions."""
    
    class Meta:
        model = ResumeVersion
        fields = [
            'id', 'name', 'description', 'file', 'original_filename',
            'target_role', 'target_industry', 'version_number',
            'parent_version', 'skills', 'use_count', 'is_default',
            'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'use_count', 'created_at', 'updated_at']
    
    def create(self, validated_data):
        validated_data['user'] = self.context['request'].user
        
        # Set original filename
        if 'file' in validated_data:
            validated_data['original_filename'] = validated_data['file'].name
        
        # If this is set as default, unset other defaults
        if validated_data.get('is_default'):
            ResumeVersion.objects.filter(
                user=validated_data['user'],
                is_default=True
            ).update(is_default=False)
        
        return super().create(validated_data)


class RenderCoverLetterSerializer(serializers.Serializer):
    """Serializer for rendering cover letter."""
    template_id = serializers.UUIDField()
    context = serializers.DictField()


# ============================================================================
# VIEWS
# ============================================================================

class ApplicationTemplateListCreateView(generics.ListCreateAPIView):
    """List and create application templates."""
    serializer_class = ApplicationTemplateSerializer
    
    def get_queryset(self):
        return ApplicationTemplate.objects.filter(user=self.request.user)


class ApplicationTemplateDetailView(generics.RetrieveUpdateDestroyAPIView):
    """Get, update, or delete an application template."""
    serializer_class = ApplicationTemplateSerializer
    
    def get_queryset(self):
        return ApplicationTemplate.objects.filter(user=self.request.user)


class UseTemplateView(APIView):
    """Create an application from a template."""
    
    def post(self, request, pk):
        from .models import JobApplication, ApplicationTimeline
        from .serializers import JobApplicationDetailSerializer
        
        try:
            template = ApplicationTemplate.objects.get(pk=pk, user=request.user)
        except ApplicationTemplate.DoesNotExist:
            return Response(
                {'error': 'Template not found'},
                status=status.HTTP_404_NOT_FOUND
            )
        
        # Get application data from request
        app_data = request.data.copy()
        
        # Apply template defaults
        if template.job_type and not app_data.get('job_type'):
            app_data['job_type'] = template.job_type
        if template.work_location and not app_data.get('work_location'):
            app_data['work_location'] = template.work_location
        if template.cover_letter_template and not app_data.get('cover_letter'):
            # Render cover letter with context
            context = {
                'company_name': app_data.get('company_name', ''),
                'job_title': app_data.get('job_title', ''),
                'hiring_manager': app_data.get('contact_name', ''),
            }
            app_data['cover_letter'] = self._render_template(
                template.cover_letter_template, context
            )
        if template.notes_template and not app_data.get('notes'):
            app_data['notes'] = template.notes_template
        if template.default_resume and not app_data.get('resume_id'):
            app_data['resume_id'] = str(template.default_resume.id)
        
        # Add default tags
        if template.default_tags.exists():
            existing_tags = app_data.get('tag_ids', [])
            default_tag_ids = list(template.default_tags.values_list('id', flat=True))
            app_data['tag_ids'] = list(set(existing_tags + [str(t) for t in default_tag_ids]))
        
        # Create application
        serializer = JobApplicationDetailSerializer(
            data=app_data,
            context={'request': request}
        )
        serializer.is_valid(raise_exception=True)
        application = serializer.save()
        
        # Update template usage
        template.use_count += 1
        template.save()
        
        return Response(
            JobApplicationDetailSerializer(application).data,
            status=status.HTTP_201_CREATED
        )
    
    def _render_template(self, template: str, context: dict) -> str:
        """Render template with context variables."""
        result = template
        for key, value in context.items():
            placeholder = '{{' + key + '}}'
            result = result.replace(placeholder, str(value) if value else '')
        return result


class CoverLetterTemplateListCreateView(generics.ListCreateAPIView):
    """List and create cover letter templates."""
    serializer_class = CoverLetterTemplateSerializer
    
    def get_queryset(self):
        return CoverLetterTemplate.objects.filter(user=self.request.user)


class CoverLetterTemplateDetailView(generics.RetrieveUpdateDestroyAPIView):
    """Get, update, or delete a cover letter template."""
    serializer_class = CoverLetterTemplateSerializer
    
    def get_queryset(self):
        return CoverLetterTemplate.objects.filter(user=self.request.user)


class RenderCoverLetterView(APIView):
    """Render a cover letter template with context."""
    
    def post(self, request):
        serializer = RenderCoverLetterSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        
        try:
            template = CoverLetterTemplate.objects.get(
                pk=serializer.validated_data['template_id'],
                user=request.user
            )
        except CoverLetterTemplate.DoesNotExist:
            return Response(
                {'error': 'Template not found'},
                status=status.HTTP_404_NOT_FOUND
            )
        
        rendered = template.render(serializer.validated_data['context'])
        
        # Update usage count
        template.use_count += 1
        template.save()
        
        return Response({
            'rendered': rendered,
            'template_id': str(template.id)
        })


class ResumeVersionListCreateView(generics.ListCreateAPIView):
    """List and create resume versions."""
    serializer_class = ResumeVersionSerializer
    
    def get_queryset(self):
        return ResumeVersion.objects.filter(user=self.request.user)


class ResumeVersionDetailView(generics.RetrieveUpdateDestroyAPIView):
    """Get, update, or delete a resume version."""
    serializer_class = ResumeVersionSerializer
    
    def get_queryset(self):
        return ResumeVersion.objects.filter(user=self.request.user)


class DuplicateResumeVersionView(APIView):
    """Create a new version from an existing resume."""
    
    def post(self, request, pk):
        try:
            original = ResumeVersion.objects.get(pk=pk, user=request.user)
        except ResumeVersion.DoesNotExist:
            return Response(
                {'error': 'Resume not found'},
                status=status.HTTP_404_NOT_FOUND
            )
        
        # Parse version number
        try:
            major, minor = original.version_number.split('.')
            new_version = f"{major}.{int(minor) + 1}"
        except:
            new_version = f"{original.version_number}.1"
        
        # Create new version
        new_resume = ResumeVersion.objects.create(
            user=request.user,
            name=request.data.get('name', f"{original.name} (Copy)"),
            description=request.data.get('description', original.description),
            file=original.file,
            original_filename=original.original_filename,
            target_role=original.target_role,
            target_industry=original.target_industry,
            version_number=new_version,
            parent_version=original,
            skills=original.skills.copy() if original.skills else []
        )
        
        return Response(
            ResumeVersionSerializer(new_resume).data,
            status=status.HTTP_201_CREATED
        )
