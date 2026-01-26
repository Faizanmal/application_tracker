from rest_framework import serializers
from .models import (
    Achievement,
    UserAchievement,
    UserStreak,
    UserPoints,
    PointsTransaction,
    Leaderboard,
    Challenge,
    UserChallenge,
    CommunityPost,
    CommunityComment,
)


class AchievementSerializer(serializers.ModelSerializer):
    """Serializer for Achievement model."""
    
    class Meta:
        model = Achievement
        fields = [
            'id', 'name', 'description', 'category', 'tier',
            'icon', 'badge_image', 'points', 'is_hidden', 'is_repeatable'
        ]


class UserAchievementSerializer(serializers.ModelSerializer):
    """Serializer for UserAchievement model."""
    achievement = AchievementSerializer(read_only=True)
    
    class Meta:
        model = UserAchievement
        fields = [
            'id', 'achievement', 'times_earned',
            'earned_at', 'last_earned_at', 'is_notified'
        ]


class UserStreakSerializer(serializers.ModelSerializer):
    """Serializer for UserStreak model."""
    
    class Meta:
        model = UserStreak
        fields = [
            'id', 'streak_type', 'current_count', 'current_start_date',
            'last_activity_date', 'longest_count', 'longest_start_date',
            'longest_end_date', 'total_activities', 'updated_at'
        ]


class UserPointsSerializer(serializers.ModelSerializer):
    """Serializer for UserPoints model."""
    level_progress = serializers.SerializerMethodField()
    
    class Meta:
        model = UserPoints
        fields = [
            'total_points', 'application_points', 'interview_points',
            'networking_points', 'learning_points', 'achievement_points',
            'streak_points', 'level', 'points_this_week', 'points_this_month',
            'level_progress', 'updated_at'
        ]
    
    def get_level_progress(self, obj):
        """Get progress to next level."""
        thresholds = [0, 100, 300, 600, 1000, 1500, 2200, 3000, 4000, 5000]
        current_level = obj.level
        
        if current_level >= len(thresholds):
            return {'current': obj.total_points, 'next': None, 'percentage': 100}
        
        current_threshold = thresholds[current_level - 1] if current_level > 0 else 0
        next_threshold = thresholds[current_level] if current_level < len(thresholds) else thresholds[-1]
        
        progress_in_level = obj.total_points - current_threshold
        level_range = next_threshold - current_threshold
        
        return {
            'current': progress_in_level,
            'next': level_range,
            'percentage': min(100, int((progress_in_level / level_range) * 100)) if level_range > 0 else 100
        }


class PointsTransactionSerializer(serializers.ModelSerializer):
    """Serializer for PointsTransaction model."""
    
    class Meta:
        model = PointsTransaction
        fields = [
            'id', 'transaction_type', 'points', 'description',
            'achievement', 'created_at'
        ]


class LeaderboardSerializer(serializers.ModelSerializer):
    """Serializer for Leaderboard model."""
    
    class Meta:
        model = Leaderboard
        fields = [
            'id', 'period', 'period_start', 'period_end',
            'rankings', 'created_at'
        ]


class ChallengeSerializer(serializers.ModelSerializer):
    """Serializer for Challenge model."""
    user_progress = serializers.SerializerMethodField()
    participants_count = serializers.SerializerMethodField()
    
    class Meta:
        model = Challenge
        fields = [
            'id', 'name', 'description', 'challenge_type',
            'target_action', 'target_count', 'points_reward',
            'badge_reward', 'start_date', 'end_date', 'is_active',
            'user_progress', 'participants_count'
        ]
    
    def get_user_progress(self, obj):
        request = self.context.get('request')
        if request and request.user.is_authenticated:
            user_challenge = obj.participants.filter(user=request.user).first()
            if user_challenge:
                return {
                    'current_count': user_challenge.current_count,
                    'status': user_challenge.status,
                    'percentage': min(100, int((user_challenge.current_count / obj.target_count) * 100))
                }
        return None
    
    def get_participants_count(self, obj):
        return obj.participants.count()


class UserChallengeSerializer(serializers.ModelSerializer):
    """Serializer for UserChallenge model."""
    challenge = ChallengeSerializer(read_only=True)
    
    class Meta:
        model = UserChallenge
        fields = [
            'id', 'challenge', 'current_count', 'status',
            'joined_at', 'completed_at'
        ]


class CommunityCommentSerializer(serializers.ModelSerializer):
    """Serializer for CommunityComment model."""
    author_name = serializers.SerializerMethodField()
    replies_count = serializers.SerializerMethodField()
    has_upvoted = serializers.SerializerMethodField()
    
    class Meta:
        model = CommunityComment
        fields = [
            'id', 'post', 'content', 'is_anonymous', 'author_name',
            'upvotes', 'has_upvoted', 'parent', 'replies_count', 'created_at'
        ]
        read_only_fields = ['id', 'upvotes', 'created_at']
    
    def get_author_name(self, obj):
        if obj.is_anonymous:
            return 'Anonymous'
        return obj.user.full_name or obj.user.email.split('@')[0]
    
    def get_replies_count(self, obj):
        return obj.replies.count()
    
    def get_has_upvoted(self, obj):
        request = self.context.get('request')
        if request and request.user.is_authenticated:
            return obj.upvote_records.filter(user=request.user).exists()
        return False


class CommunityPostSerializer(serializers.ModelSerializer):
    """Serializer for CommunityPost model."""
    author_name = serializers.SerializerMethodField()
    comments_count = serializers.SerializerMethodField()
    has_upvoted = serializers.SerializerMethodField()
    recent_comments = CommunityCommentSerializer(source='comments', many=True, read_only=True)
    
    class Meta:
        model = CommunityPost
        fields = [
            'id', 'post_type', 'title', 'content', 'tags',
            'is_anonymous', 'author_name', 'upvotes', 'has_upvoted',
            'views', 'is_pinned', 'comments_count', 'recent_comments',
            'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'upvotes', 'views', 'is_pinned', 'created_at', 'updated_at']
    
    def get_author_name(self, obj):
        if obj.is_anonymous:
            return 'Anonymous'
        return obj.user.full_name or obj.user.email.split('@')[0]
    
    def get_comments_count(self, obj):
        return obj.comments.count()
    
    def get_has_upvoted(self, obj):
        request = self.context.get('request')
        if request and request.user.is_authenticated:
            return obj.upvote_records.filter(user=request.user).exists()
        return False
