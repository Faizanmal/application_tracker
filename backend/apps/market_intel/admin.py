from django.contrib import admin
from .models import (
    CompanyProfile,
    SalaryData,
    IndustryTrend,
    HiringSeasonData,
    JobMarketHeatmap,
    SuccessPrediction,
    JobSearchROI,
)


@admin.register(CompanyProfile)
class CompanyProfileAdmin(admin.ModelAdmin):
    list_display = ['name', 'industry', 'company_size', 'glassdoor_rating', 'is_hiring', 'open_positions_count']
    list_filter = ['industry', 'company_size', 'is_hiring', 'is_public']
    search_fields = ['name', 'domain', 'description']
    ordering = ['name']


@admin.register(SalaryData)
class SalaryDataAdmin(admin.ModelAdmin):
    list_display = ['job_title', 'location', 'salary_median', 'currency', 'year', 'sample_size']
    list_filter = ['industry', 'country', 'seniority_level', 'year']
    search_fields = ['job_title', 'normalized_title', 'company_name']


@admin.register(IndustryTrend)
class IndustryTrendAdmin(admin.ModelAdmin):
    list_display = ['industry', 'hiring_trend', 'growth_rate', 'year', 'quarter']
    list_filter = ['industry', 'hiring_trend', 'year']


@admin.register(HiringSeasonData)
class HiringSeasonDataAdmin(admin.ModelAdmin):
    list_display = ['industry', 'job_category', 'year']
    list_filter = ['industry', 'year']


@admin.register(JobMarketHeatmap)
class JobMarketHeatmapAdmin(admin.ModelAdmin):
    list_display = ['city', 'country', 'job_count', 'average_salary', 'year']
    list_filter = ['country', 'industry', 'year']
    search_fields = ['city', 'state']


@admin.register(SuccessPrediction)
class SuccessPredictionAdmin(admin.ModelAdmin):
    list_display = ['application', 'user', 'overall_score', 'created_at']
    list_filter = ['model_version']
    search_fields = ['user__email', 'application__company_name']


@admin.register(JobSearchROI)
class JobSearchROIAdmin(admin.ModelAdmin):
    list_display = ['user', 'start_date', 'end_date', 'total_applications', 'offers_received', 'roi_percentage']
    search_fields = ['user__email']
    date_hierarchy = 'end_date'
