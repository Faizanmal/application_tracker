from django.contrib import admin
from .models import AIUsage, GeneratedContent


@admin.register(AIUsage)
class AIUsageAdmin(admin.ModelAdmin):
    list_display = ['user', 'feature_type', 'tokens_used', 'created_at']
    list_filter = ['feature_type', 'created_at']
    search_fields = ['user__email']
    ordering = ['-created_at']


@admin.register(GeneratedContent)
class GeneratedContentAdmin(admin.ModelAdmin):
    list_display = ['user', 'content_type', 'model_used', 'rating', 'is_used', 'created_at']
    list_filter = ['content_type', 'model_used', 'is_used', 'created_at']
    search_fields = ['user__email']
    ordering = ['-created_at']
