from django.contrib import admin
from .models import DailyStats, WeeklyDigest


@admin.register(DailyStats)
class DailyStatsAdmin(admin.ModelAdmin):
    list_display = ['user', 'date', 'applications_added', 'interviews_scheduled', 'offers_received']
    list_filter = ['date']
    search_fields = ['user__email']
    ordering = ['-date']


@admin.register(WeeklyDigest)
class WeeklyDigestAdmin(admin.ModelAdmin):
    list_display = ['user', 'week_start', 'week_end', 'new_applications', 'interviews_scheduled', 'offers']
    list_filter = ['week_start']
    search_fields = ['user__email']
    ordering = ['-week_start']
