from django.contrib import admin
from .models import Interview, InterviewQuestion, STARResponse, CompanyResearch, CommonQuestion


@admin.register(Interview)
class InterviewAdmin(admin.ModelAdmin):
    list_display = ['application', 'interview_type', 'round_number', 'scheduled_at', 'status']
    list_filter = ['interview_type', 'status', 'scheduled_at']
    search_fields = ['application__company_name', 'application__job_title']
    ordering = ['-scheduled_at']


@admin.register(InterviewQuestion)
class InterviewQuestionAdmin(admin.ModelAdmin):
    list_display = ['question', 'question_type', 'user', 'is_common', 'created_at']
    list_filter = ['question_type', 'is_common']
    search_fields = ['question']


@admin.register(STARResponse)
class STARResponseAdmin(admin.ModelAdmin):
    list_display = ['question', 'created_at']
    search_fields = ['situation', 'task', 'action', 'result']


@admin.register(CompanyResearch)
class CompanyResearchAdmin(admin.ModelAdmin):
    list_display = ['application', 'created_at', 'updated_at']
    search_fields = ['application__company_name']


@admin.register(CommonQuestion)
class CommonQuestionAdmin(admin.ModelAdmin):
    list_display = ['question', 'category', 'question_type', 'is_active']
    list_filter = ['category', 'question_type', 'is_active']
    search_fields = ['question']
