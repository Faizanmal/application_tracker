"""
Saved Search and Advanced Filtering functionality.
Allows users to save and reuse complex search filters.
"""
import uuid
from django.db import models
from django.conf import settings
from rest_framework import serializers, generics, status
from rest_framework.views import APIView
from rest_framework.response import Response
import django_filters
from .models import JobApplication, ApplicationTag


# ============================================================================
# SAVED SEARCH MODEL
# ============================================================================

class SavedSearch(models.Model):
    """Model for saved search filters."""
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='saved_searches'
    )
    
    name = models.CharField(max_length=100)
    description = models.TextField(blank=True)
    
    # Filter criteria (stored as JSON)
    filters = models.JSONField(default=dict)
    
    # Metadata
    is_default = models.BooleanField(default=False)
    use_count = models.PositiveIntegerField(default=0)
    last_used = models.DateTimeField(null=True, blank=True)
    
    # Timestamps
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        ordering = ['-use_count', '-updated_at']
        unique_together = ['user', 'name']
    
    def __str__(self):
        return f"{self.name} - {self.user.email}"


# ============================================================================
# ADVANCED FILTER
# ============================================================================

class AdvancedJobApplicationFilter(django_filters.FilterSet):
    """Advanced filter for job applications with faceted search."""
    
    # Status filters
    status = django_filters.MultipleChoiceFilter(choices=JobApplication.Status.choices)
    exclude_status = django_filters.MultipleChoiceFilter(
        field_name='status',
        exclude=True,
        choices=JobApplication.Status.choices
    )
    
    # Job type filters
    job_type = django_filters.MultipleChoiceFilter(choices=JobApplication.JobType.choices)
    work_location = django_filters.MultipleChoiceFilter(choices=JobApplication.WorkLocation.choices)
    
    # Date filters
    applied_date_from = django_filters.DateFilter(field_name='applied_date', lookup_expr='gte')
    applied_date_to = django_filters.DateFilter(field_name='applied_date', lookup_expr='lte')
    created_from = django_filters.DateTimeFilter(field_name='created_at', lookup_expr='gte')
    created_to = django_filters.DateTimeFilter(field_name='created_at', lookup_expr='lte')
    deadline_from = django_filters.DateFilter(field_name='deadline', lookup_expr='gte')
    deadline_to = django_filters.DateFilter(field_name='deadline', lookup_expr='lte')
    
    # Salary filters
    salary_min = django_filters.NumberFilter(field_name='salary_min', lookup_expr='gte')
    salary_max = django_filters.NumberFilter(field_name='salary_max', lookup_expr='lte')
    salary_range_min = django_filters.NumberFilter(method='filter_salary_range_min')
    salary_range_max = django_filters.NumberFilter(method='filter_salary_range_max')
    
    # Company filters
    company_name = django_filters.CharFilter(lookup_expr='icontains')
    company_size = django_filters.MultipleChoiceFilter(choices=[
        ('1-10', '1-10 employees'),
        ('11-50', '11-50 employees'),
        ('51-200', '51-200 employees'),
        ('201-500', '201-500 employees'),
        ('501-1000', '501-1000 employees'),
        ('1001-5000', '1001-5000 employees'),
        ('5001+', '5001+ employees'),
    ])
    company_industry = django_filters.CharFilter(lookup_expr='icontains')
    
    # Location filters
    location = django_filters.CharFilter(lookup_expr='icontains')
    location_in = django_filters.CharFilter(method='filter_location_in')
    
    # Boolean filters
    is_favorite = django_filters.BooleanFilter()
    is_archived = django_filters.BooleanFilter()
    has_interview = django_filters.BooleanFilter(method='filter_has_interview')
    has_upcoming_interview = django_filters.BooleanFilter(method='filter_upcoming_interview')
    has_deadline = django_filters.BooleanFilter(method='filter_has_deadline')
    has_notes = django_filters.BooleanFilter(method='filter_has_notes')
    
    # Source and referral
    source = django_filters.CharFilter(lookup_expr='icontains')
    source_in = django_filters.CharFilter(method='filter_source_in')
    has_referral = django_filters.BooleanFilter(method='filter_has_referral')
    
    # Tag filters
    tags = django_filters.UUIDFilter(field_name='tags__id')
    tags_in = django_filters.CharFilter(method='filter_tags_in')
    tags_all = django_filters.CharFilter(method='filter_tags_all')
    
    # Match score filters
    match_score_min = django_filters.NumberFilter(field_name='match_score', lookup_expr='gte')
    match_score_max = django_filters.NumberFilter(field_name='match_score', lookup_expr='lte')
    has_match_score = django_filters.BooleanFilter(method='filter_has_match_score')
    
    # Full text search
    search = django_filters.CharFilter(method='filter_search')
    
    class Meta:
        model = JobApplication
        fields = []
    
    def filter_salary_range_min(self, queryset, name, value):
        """Filter applications where salary range includes at least this minimum."""
        return queryset.filter(
            models.Q(salary_min__gte=value) | models.Q(salary_max__gte=value)
        )
    
    def filter_salary_range_max(self, queryset, name, value):
        """Filter applications where salary range includes at most this maximum."""
        return queryset.filter(
            models.Q(salary_max__lte=value) | models.Q(salary_min__lte=value)
        )
    
    def filter_location_in(self, queryset, name, value):
        """Filter by multiple locations (comma-separated)."""
        locations = [loc.strip() for loc in value.split(',')]
        query = models.Q()
        for loc in locations:
            query |= models.Q(location__icontains=loc)
        return queryset.filter(query)
    
    def filter_source_in(self, queryset, name, value):
        """Filter by multiple sources (comma-separated)."""
        sources = [src.strip() for src in value.split(',')]
        return queryset.filter(source__in=sources)
    
    def filter_tags_in(self, queryset, name, value):
        """Filter by any of the specified tags (comma-separated UUIDs)."""
        tag_ids = [tid.strip() for tid in value.split(',')]
        return queryset.filter(tags__id__in=tag_ids).distinct()
    
    def filter_tags_all(self, queryset, name, value):
        """Filter by all of the specified tags (comma-separated UUIDs)."""
        tag_ids = [tid.strip() for tid in value.split(',')]
        for tag_id in tag_ids:
            queryset = queryset.filter(tags__id=tag_id)
        return queryset.distinct()
    
    def filter_has_interview(self, queryset, name, value):
        """Filter applications that have/don't have interviews."""
        if value:
            return queryset.filter(interviews__isnull=False).distinct()
        return queryset.filter(interviews__isnull=True)
    
    def filter_upcoming_interview(self, queryset, name, value):
        """Filter applications with upcoming interviews."""
        from django.utils import timezone
        if value:
            return queryset.filter(
                interviews__scheduled_at__gte=timezone.now()
            ).distinct()
        return queryset.exclude(
            interviews__scheduled_at__gte=timezone.now()
        ).distinct()
    
    def filter_has_deadline(self, queryset, name, value):
        """Filter applications that have/don't have deadlines."""
        if value:
            return queryset.filter(deadline__isnull=False)
        return queryset.filter(deadline__isnull=True)
    
    def filter_has_notes(self, queryset, name, value):
        """Filter applications that have/don't have notes."""
        if value:
            return queryset.exclude(notes='')
        return queryset.filter(notes='')
    
    def filter_has_referral(self, queryset, name, value):
        """Filter applications that have/don't have referrals."""
        if value:
            return queryset.exclude(referral='')
        return queryset.filter(referral='')
    
    def filter_has_match_score(self, queryset, name, value):
        """Filter applications that have/don't have match scores."""
        if value:
            return queryset.filter(match_score__isnull=False)
        return queryset.filter(match_score__isnull=True)
    
    def filter_search(self, queryset, name, value):
        """Full-text search across multiple fields."""
        return queryset.filter(
            models.Q(company_name__icontains=value) |
            models.Q(job_title__icontains=value) |
            models.Q(job_description__icontains=value) |
            models.Q(location__icontains=value) |
            models.Q(notes__icontains=value) |
            models.Q(contact_name__icontains=value) |
            models.Q(source__icontains=value)
        )


# ============================================================================
# SERIALIZERS
# ============================================================================

class SavedSearchSerializer(serializers.ModelSerializer):
    """Serializer for saved searches."""
    
    class Meta:
        model = SavedSearch
        fields = [
            'id', 'name', 'description', 'filters', 'is_default',
            'use_count', 'last_used', 'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'use_count', 'last_used', 'created_at', 'updated_at']
    
    def create(self, validated_data):
        validated_data['user'] = self.context['request'].user
        
        # If this is set as default, unset other defaults
        if validated_data.get('is_default'):
            SavedSearch.objects.filter(
                user=validated_data['user'],
                is_default=True
            ).update(is_default=False)
        
        return super().create(validated_data)
    
    def update(self, instance, validated_data):
        # If setting as default, unset other defaults
        if validated_data.get('is_default') and not instance.is_default:
            SavedSearch.objects.filter(
                user=instance.user,
                is_default=True
            ).exclude(id=instance.id).update(is_default=False)
        
        return super().update(instance, validated_data)


class FilterOptionsSerializer(serializers.Serializer):
    """Serializer for available filter options."""
    statuses = serializers.ListField(child=serializers.DictField())
    job_types = serializers.ListField(child=serializers.DictField())
    work_locations = serializers.ListField(child=serializers.DictField())
    sources = serializers.ListField(child=serializers.CharField())
    locations = serializers.ListField(child=serializers.CharField())
    industries = serializers.ListField(child=serializers.CharField())
    company_sizes = serializers.ListField(child=serializers.CharField())
    tags = serializers.ListField(child=serializers.DictField())


# ============================================================================
# VIEWS
# ============================================================================

class SavedSearchListCreateView(generics.ListCreateAPIView):
    """List and create saved searches."""
    serializer_class = SavedSearchSerializer
    
    def get_queryset(self):
        return SavedSearch.objects.filter(user=self.request.user)


class SavedSearchDetailView(generics.RetrieveUpdateDestroyAPIView):
    """Get, update, or delete a saved search."""
    serializer_class = SavedSearchSerializer
    
    def get_queryset(self):
        return SavedSearch.objects.filter(user=self.request.user)


class SavedSearchExecuteView(APIView):
    """Execute a saved search and return results."""
    
    def get(self, request, pk):
        from django.utils import timezone
        from .serializers import JobApplicationListSerializer
        
        try:
            saved_search = SavedSearch.objects.get(pk=pk, user=request.user)
        except SavedSearch.DoesNotExist:
            return Response(
                {'error': 'Saved search not found'},
                status=status.HTTP_404_NOT_FOUND
            )
        
        # Update usage stats
        saved_search.use_count += 1
        saved_search.last_used = timezone.now()
        saved_search.save()
        
        # Build queryset with filters
        queryset = JobApplication.objects.filter(user=request.user)
        filter_set = AdvancedJobApplicationFilter(
            data=saved_search.filters,
            queryset=queryset
        )
        
        applications = filter_set.qs.prefetch_related('tags', 'interviews')
        serializer = JobApplicationListSerializer(applications, many=True)
        
        return Response({
            'search': SavedSearchSerializer(saved_search).data,
            'count': applications.count(),
            'results': serializer.data
        })


class FilterOptionsView(APIView):
    """Get available filter options based on user's data."""
    
    def get(self, request):
        user = request.user
        applications = JobApplication.objects.filter(user=user)
        
        # Get distinct values from user's applications
        sources = list(
            applications.exclude(source='')
            .values_list('source', flat=True)
            .distinct()
        )
        
        locations = list(
            applications.exclude(location='')
            .values_list('location', flat=True)
            .distinct()
        )
        
        industries = list(
            applications.exclude(company_industry='')
            .values_list('company_industry', flat=True)
            .distinct()
        )
        
        company_sizes = list(
            applications.exclude(company_size='')
            .values_list('company_size', flat=True)
            .distinct()
        )
        
        # Get user's tags
        tags = list(
            ApplicationTag.objects.filter(user=user)
            .values('id', 'name', 'color')
        )
        
        # Status and type options
        statuses = [
            {'value': choice[0], 'label': choice[1]}
            for choice in JobApplication.Status.choices
        ]
        
        job_types = [
            {'value': choice[0], 'label': choice[1]}
            for choice in JobApplication.JobType.choices
        ]
        
        work_locations = [
            {'value': choice[0], 'label': choice[1]}
            for choice in JobApplication.WorkLocation.choices
        ]
        
        return Response({
            'statuses': statuses,
            'job_types': job_types,
            'work_locations': work_locations,
            'sources': sources,
            'locations': locations,
            'industries': industries,
            'company_sizes': company_sizes,
            'tags': [{'id': str(t['id']), 'name': t['name'], 'color': t['color']} for t in tags]
        })


class SearchSuggestionsView(APIView):
    """Get search suggestions based on user's data."""
    
    def get(self, request):
        query = request.query_params.get('q', '')
        field = request.query_params.get('field', 'all')
        
        if len(query) < 2:
            return Response({'suggestions': []})
        
        user = request.user
        applications = JobApplication.objects.filter(user=user)
        suggestions = set()
        
        if field in ['all', 'company']:
            companies = applications.filter(
                company_name__icontains=query
            ).values_list('company_name', flat=True)[:10]
            suggestions.update(companies)
        
        if field in ['all', 'title']:
            titles = applications.filter(
                job_title__icontains=query
            ).values_list('job_title', flat=True)[:10]
            suggestions.update(titles)
        
        if field in ['all', 'location']:
            locs = applications.filter(
                location__icontains=query
            ).values_list('location', flat=True)[:10]
            suggestions.update(locs)
        
        return Response({
            'suggestions': list(suggestions)[:15]
        })
