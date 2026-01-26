import django_filters
from .models import JobApplication


class JobApplicationFilter(django_filters.FilterSet):
    """Filter for job applications."""
    
    status = django_filters.MultipleChoiceFilter(choices=JobApplication.Status.choices)
    job_type = django_filters.MultipleChoiceFilter(choices=JobApplication.JobType.choices)
    work_location = django_filters.MultipleChoiceFilter(choices=JobApplication.WorkLocation.choices)
    
    applied_date_from = django_filters.DateFilter(field_name='applied_date', lookup_expr='gte')
    applied_date_to = django_filters.DateFilter(field_name='applied_date', lookup_expr='lte')
    
    created_from = django_filters.DateTimeFilter(field_name='created_at', lookup_expr='gte')
    created_to = django_filters.DateTimeFilter(field_name='created_at', lookup_expr='lte')
    
    salary_min = django_filters.NumberFilter(field_name='salary_min', lookup_expr='gte')
    salary_max = django_filters.NumberFilter(field_name='salary_max', lookup_expr='lte')
    
    is_favorite = django_filters.BooleanFilter()
    is_archived = django_filters.BooleanFilter()
    
    has_interview = django_filters.BooleanFilter(method='filter_has_interview')
    
    tag = django_filters.UUIDFilter(field_name='tags__id')
    
    class Meta:
        model = JobApplication
        fields = [
            'status', 'job_type', 'work_location', 'is_favorite', 'is_archived',
            'source', 'company_name'
        ]
    
    def filter_has_interview(self, queryset, name, value):
        if value:
            return queryset.filter(interviews__isnull=False).distinct()
        return queryset.filter(interviews__isnull=True)
