from django.contrib import admin
from .models import (
    Skill,
    UserSkill,
    SkillGapAnalysis,
    LearningResource,
    UserLearningProgress,
    LearningPath,
    UserLearningPath,
    PortfolioProject,
    CareerGoal,
    CareerPathPlan,
)


@admin.register(Skill)
class SkillAdmin(admin.ModelAdmin):
    list_display = ['name', 'category', 'usage_count', 'created_at']
    list_filter = ['category']
    search_fields = ['name', 'normalized_name']
    ordering = ['-usage_count']


@admin.register(UserSkill)
class UserSkillAdmin(admin.ModelAdmin):
    list_display = ['user', 'skill', 'proficiency', 'years_of_experience', 'is_verified']
    list_filter = ['proficiency', 'is_verified']
    search_fields = ['user__email', 'skill__name']


@admin.register(SkillGapAnalysis)
class SkillGapAnalysisAdmin(admin.ModelAdmin):
    list_display = ['user', 'target_role', 'match_percentage', 'created_at']
    list_filter = ['target_industry']
    search_fields = ['user__email', 'target_role']
    date_hierarchy = 'created_at'


@admin.register(LearningResource)
class LearningResourceAdmin(admin.ModelAdmin):
    list_display = ['title', 'resource_type', 'platform', 'is_free', 'rating']
    list_filter = ['resource_type', 'platform', 'is_free']
    search_fields = ['title', 'description']
    filter_horizontal = ['skills']


@admin.register(UserLearningProgress)
class UserLearningProgressAdmin(admin.ModelAdmin):
    list_display = ['user', 'resource', 'status', 'progress_percentage']
    list_filter = ['status']
    search_fields = ['user__email', 'resource__title']


@admin.register(LearningPath)
class LearningPathAdmin(admin.ModelAdmin):
    list_display = ['name', 'target_role', 'estimated_weeks', 'followers_count']
    list_filter = ['is_ai_generated']
    search_fields = ['name', 'target_role']


@admin.register(UserLearningPath)
class UserLearningPathAdmin(admin.ModelAdmin):
    list_display = ['user', 'learning_path', 'status', 'progress_percentage']
    list_filter = ['status']


@admin.register(PortfolioProject)
class PortfolioProjectAdmin(admin.ModelAdmin):
    list_display = ['title', 'user', 'project_type', 'is_public', 'is_featured']
    list_filter = ['project_type', 'is_public', 'is_featured']
    search_fields = ['title', 'user__email']


@admin.register(CareerGoal)
class CareerGoalAdmin(admin.ModelAdmin):
    list_display = ['title', 'user', 'goal_type', 'time_frame', 'status', 'progress_percentage']
    list_filter = ['goal_type', 'time_frame', 'status']
    search_fields = ['title', 'user__email']


@admin.register(CareerPathPlan)
class CareerPathPlanAdmin(admin.ModelAdmin):
    list_display = ['name', 'user', 'current_role', 'target_role', 'is_active']
    list_filter = ['is_active']
    search_fields = ['name', 'user__email', 'target_role']
