from django.contrib import admin
from .models import JobApplication, ApplicationTimeline, ApplicationTag, ApplicationDocument


@admin.register(JobApplication)
class JobApplicationAdmin(admin.ModelAdmin):
    list_display = ['job_title', 'company_name', 'user', 'status', 'applied_date', 'created_at']
    list_filter = ['status', 'job_type', 'work_location', 'is_favorite', 'is_archived', 'created_at']
    search_fields = ['job_title', 'company_name', 'user__email']
    ordering = ['-created_at']
    readonly_fields = ['id', 'created_at', 'updated_at']


@admin.register(ApplicationTimeline)
class ApplicationTimelineAdmin(admin.ModelAdmin):
    list_display = ['title', 'application', 'event_type', 'created_at']
    list_filter = ['event_type', 'created_at']
    search_fields = ['title', 'application__job_title']


@admin.register(ApplicationTag)
class ApplicationTagAdmin(admin.ModelAdmin):
    list_display = ['name', 'user', 'color', 'created_at']
    list_filter = ['created_at']
    search_fields = ['name', 'user__email']


@admin.register(ApplicationDocument)
class ApplicationDocumentAdmin(admin.ModelAdmin):
    list_display = ['name', 'application', 'doc_type', 'created_at']
    list_filter = ['doc_type', 'created_at']
    search_fields = ['name', 'application__job_title']
