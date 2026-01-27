from django.contrib import admin
from .models import (
    Achievement,
    UserAchievement,
    UserStreak,
    UserPoints,
    PointsTransaction,
    Challenge,
    UserChallenge,
    CommunityPost,
    CommunityComment,
)


@admin.register(Achievement)
class AchievementAdmin(admin.ModelAdmin):
    list_display = ['name', 'category', 'tier', 'points', 'is_hidden']
    list_filter = ['category', 'tier', 'is_hidden']
    search_fields = ['name', 'description']


@admin.register(UserAchievement)
class UserAchievementAdmin(admin.ModelAdmin):
    list_display = ['user', 'achievement', 'times_earned', 'earned_at']
    list_filter = ['achievement__category']
    search_fields = ['user__email', 'achievement__name']


@admin.register(UserStreak)
class UserStreakAdmin(admin.ModelAdmin):
    list_display = ['user', 'streak_type', 'current_count', 'longest_count', 'last_activity_date']
    list_filter = ['streak_type']
    search_fields = ['user__email']


@admin.register(UserPoints)
class UserPointsAdmin(admin.ModelAdmin):
    list_display = ['user', 'total_points', 'level', 'updated_at']
    search_fields = ['user__email']
    ordering = ['-total_points']


@admin.register(PointsTransaction)
class PointsTransactionAdmin(admin.ModelAdmin):
    list_display = ['user', 'transaction_type', 'points', 'description', 'created_at']
    list_filter = ['transaction_type']
    search_fields = ['user__email', 'description']
    date_hierarchy = 'created_at'


@admin.register(Challenge)
class ChallengeAdmin(admin.ModelAdmin):
    list_display = ['name', 'challenge_type', 'target_count', 'points_reward', 'is_active']
    list_filter = ['challenge_type', 'is_active']
    search_fields = ['name']


@admin.register(UserChallenge)
class UserChallengeAdmin(admin.ModelAdmin):
    list_display = ['user', 'challenge', 'current_count', 'status']
    list_filter = ['status']


@admin.register(CommunityPost)
class CommunityPostAdmin(admin.ModelAdmin):
    list_display = ['title', 'user', 'post_type', 'upvotes', 'views', 'is_approved', 'is_pinned']
    list_filter = ['post_type', 'is_approved', 'is_pinned']
    search_fields = ['title', 'content']
    actions = ['approve_posts', 'pin_posts']
    
    def approve_posts(self, request, queryset):
        queryset.update(is_approved=True)
    
    def pin_posts(self, request, queryset):
        queryset.update(is_pinned=True)


@admin.register(CommunityComment)
class CommunityCommentAdmin(admin.ModelAdmin):
    list_display = ['post', 'user', 'upvotes', 'created_at']
    search_fields = ['content']
