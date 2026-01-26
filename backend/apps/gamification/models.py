import uuid
from django.db import models
from django.conf import settings


class Achievement(models.Model):
    """Achievement definitions for the gamification system."""
    
    class Category(models.TextChoices):
        APPLICATIONS = 'applications', 'Applications'
        INTERVIEWS = 'interviews', 'Interviews'
        NETWORKING = 'networking', 'Networking'
        LEARNING = 'learning', 'Learning'
        STREAK = 'streak', 'Streak'
        MILESTONE = 'milestone', 'Milestone'
        SPECIAL = 'special', 'Special'
    
    class Tier(models.TextChoices):
        BRONZE = 'bronze', 'Bronze'
        SILVER = 'silver', 'Silver'
        GOLD = 'gold', 'Gold'
        PLATINUM = 'platinum', 'Platinum'
        DIAMOND = 'diamond', 'Diamond'
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    
    name = models.CharField(max_length=100)
    description = models.TextField()
    
    category = models.CharField(
        max_length=20,
        choices=Category.choices,
        default=Category.APPLICATIONS
    )
    tier = models.CharField(
        max_length=20,
        choices=Tier.choices,
        default=Tier.BRONZE
    )
    
    # Icon/badge
    icon = models.CharField(max_length=50, default='🏆')
    badge_image = models.ImageField(upload_to='achievements/', null=True, blank=True)
    
    # Points awarded
    points = models.PositiveIntegerField(default=10)
    
    # Trigger conditions
    trigger_type = models.CharField(max_length=50)  # e.g., 'applications_count', 'interview_count'
    trigger_value = models.PositiveIntegerField(default=1)  # e.g., 10 for "Submit 10 applications"
    
    # Metadata
    is_hidden = models.BooleanField(default=False)  # Secret achievements
    is_repeatable = models.BooleanField(default=False)
    
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        ordering = ['category', 'tier', 'points']
    
    def __str__(self):
        return f"{self.icon} {self.name}"


class UserAchievement(models.Model):
    """Track user's earned achievements."""
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='achievements'
    )
    achievement = models.ForeignKey(
        Achievement,
        on_delete=models.CASCADE,
        related_name='user_achievements'
    )
    
    # For repeatable achievements
    times_earned = models.PositiveIntegerField(default=1)
    
    earned_at = models.DateTimeField(auto_now_add=True)
    last_earned_at = models.DateTimeField(auto_now=True)
    
    # Was it notified to the user?
    is_notified = models.BooleanField(default=False)
    
    class Meta:
        unique_together = ['user', 'achievement']
        ordering = ['-earned_at']
    
    def __str__(self):
        return f"{self.user.email} - {self.achievement.name}"


class UserStreak(models.Model):
    """Track user's activity streaks."""
    
    class StreakType(models.TextChoices):
        DAILY_APPLICATION = 'daily_application', 'Daily Application'
        DAILY_LOGIN = 'daily_login', 'Daily Login'
        WEEKLY_INTERVIEW = 'weekly_interview', 'Weekly Interview'
        NETWORKING = 'networking', 'Networking Activity'
        LEARNING = 'learning', 'Daily Learning'
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='streaks'
    )
    
    streak_type = models.CharField(
        max_length=30,
        choices=StreakType.choices
    )
    
    # Current streak
    current_count = models.PositiveIntegerField(default=0)
    current_start_date = models.DateField(null=True, blank=True)
    last_activity_date = models.DateField(null=True, blank=True)
    
    # Best streak
    longest_count = models.PositiveIntegerField(default=0)
    longest_start_date = models.DateField(null=True, blank=True)
    longest_end_date = models.DateField(null=True, blank=True)
    
    # Total activities
    total_activities = models.PositiveIntegerField(default=0)
    
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        unique_together = ['user', 'streak_type']
        ordering = ['-current_count']
    
    def __str__(self):
        return f"{self.user.email} - {self.streak_type}: {self.current_count} days"


class UserPoints(models.Model):
    """Track user's gamification points."""
    
    user = models.OneToOneField(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='gamification_points'
    )
    
    # Total points
    total_points = models.PositiveIntegerField(default=0)
    
    # Points by category
    application_points = models.PositiveIntegerField(default=0)
    interview_points = models.PositiveIntegerField(default=0)
    networking_points = models.PositiveIntegerField(default=0)
    learning_points = models.PositiveIntegerField(default=0)
    achievement_points = models.PositiveIntegerField(default=0)
    streak_points = models.PositiveIntegerField(default=0)
    
    # Level
    level = models.PositiveIntegerField(default=1)
    
    # Weekly/monthly stats
    points_this_week = models.PositiveIntegerField(default=0)
    points_this_month = models.PositiveIntegerField(default=0)
    
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        verbose_name_plural = 'User points'
    
    def __str__(self):
        return f"{self.user.email} - Level {self.level} ({self.total_points} pts)"
    
    def calculate_level(self):
        """Calculate level based on total points."""
        # Level thresholds: 0-100 = L1, 101-300 = L2, etc.
        thresholds = [0, 100, 300, 600, 1000, 1500, 2200, 3000, 4000, 5000]
        for i, threshold in enumerate(thresholds):
            if self.total_points < threshold:
                return i
        return len(thresholds)


class PointsTransaction(models.Model):
    """Track individual point transactions."""
    
    class TransactionType(models.TextChoices):
        EARNED = 'earned', 'Earned'
        BONUS = 'bonus', 'Bonus'
        ACHIEVEMENT = 'achievement', 'Achievement'
        STREAK = 'streak', 'Streak Bonus'
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='points_transactions'
    )
    
    transaction_type = models.CharField(
        max_length=20,
        choices=TransactionType.choices,
        default=TransactionType.EARNED
    )
    
    points = models.IntegerField()  # Can be negative for deductions
    description = models.CharField(max_length=200)
    
    # Optional references
    achievement = models.ForeignKey(
        Achievement,
        on_delete=models.SET_NULL,
        null=True,
        blank=True
    )
    
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        ordering = ['-created_at']
    
    def __str__(self):
        return f"{self.user.email} - {self.points:+d} pts - {self.description}"


class Leaderboard(models.Model):
    """Weekly/monthly leaderboard snapshots."""
    
    class Period(models.TextChoices):
        WEEKLY = 'weekly', 'Weekly'
        MONTHLY = 'monthly', 'Monthly'
        ALL_TIME = 'all_time', 'All Time'
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    
    period = models.CharField(
        max_length=20,
        choices=Period.choices
    )
    period_start = models.DateField()
    period_end = models.DateField()
    
    # Rankings (stored as JSON for efficiency)
    rankings = models.JSONField(default=list)  # [{user_id, username, points, rank}]
    
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        ordering = ['-period_start']
        unique_together = ['period', 'period_start']
    
    def __str__(self):
        return f"{self.period} Leaderboard - {self.period_start}"


class Challenge(models.Model):
    """Time-limited challenges for users."""
    
    class ChallengeType(models.TextChoices):
        DAILY = 'daily', 'Daily Challenge'
        WEEKLY = 'weekly', 'Weekly Challenge'
        MONTHLY = 'monthly', 'Monthly Challenge'
        SPECIAL = 'special', 'Special Event'
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    
    name = models.CharField(max_length=100)
    description = models.TextField()
    
    challenge_type = models.CharField(
        max_length=20,
        choices=ChallengeType.choices,
        default=ChallengeType.WEEKLY
    )
    
    # Challenge requirements
    target_action = models.CharField(max_length=50)  # e.g., 'submit_applications'
    target_count = models.PositiveIntegerField(default=5)
    
    # Rewards
    points_reward = models.PositiveIntegerField(default=50)
    badge_reward = models.ForeignKey(
        Achievement,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='challenge_rewards'
    )
    
    # Duration
    start_date = models.DateTimeField()
    end_date = models.DateTimeField()
    
    is_active = models.BooleanField(default=True)
    
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        ordering = ['-start_date']
    
    def __str__(self):
        return self.name


class UserChallenge(models.Model):
    """Track user's challenge progress."""
    
    class Status(models.TextChoices):
        IN_PROGRESS = 'in_progress', 'In Progress'
        COMPLETED = 'completed', 'Completed'
        FAILED = 'failed', 'Failed'
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='challenges'
    )
    challenge = models.ForeignKey(
        Challenge,
        on_delete=models.CASCADE,
        related_name='participants'
    )
    
    current_count = models.PositiveIntegerField(default=0)
    status = models.CharField(
        max_length=20,
        choices=Status.choices,
        default=Status.IN_PROGRESS
    )
    
    joined_at = models.DateTimeField(auto_now_add=True)
    completed_at = models.DateTimeField(null=True, blank=True)
    
    class Meta:
        unique_together = ['user', 'challenge']
        ordering = ['-joined_at']
    
    def __str__(self):
        return f"{self.user.email} - {self.challenge.name}"


class CommunityPost(models.Model):
    """Community posts for sharing experiences and tips."""
    
    class PostType(models.TextChoices):
        TIP = 'tip', 'Tip'
        EXPERIENCE = 'experience', 'Experience'
        QUESTION = 'question', 'Question'
        SUCCESS = 'success', 'Success Story'
        RESOURCE = 'resource', 'Resource Share'
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='community_posts'
    )
    
    post_type = models.CharField(
        max_length=20,
        choices=PostType.choices,
        default=PostType.TIP
    )
    
    title = models.CharField(max_length=200)
    content = models.TextField()
    
    # Tags
    tags = models.JSONField(default=list, blank=True)
    
    # Anonymity
    is_anonymous = models.BooleanField(default=False)
    
    # Engagement
    upvotes = models.PositiveIntegerField(default=0)
    views = models.PositiveIntegerField(default=0)
    
    is_pinned = models.BooleanField(default=False)
    is_approved = models.BooleanField(default=True)
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        ordering = ['-is_pinned', '-upvotes', '-created_at']
    
    def __str__(self):
        return self.title


class CommunityComment(models.Model):
    """Comments on community posts."""
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    post = models.ForeignKey(
        CommunityPost,
        on_delete=models.CASCADE,
        related_name='comments'
    )
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='community_comments'
    )
    
    content = models.TextField()
    is_anonymous = models.BooleanField(default=False)
    
    upvotes = models.PositiveIntegerField(default=0)
    
    parent = models.ForeignKey(
        'self',
        on_delete=models.CASCADE,
        null=True,
        blank=True,
        related_name='replies'
    )
    
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        ordering = ['-upvotes', 'created_at']
    
    def __str__(self):
        return f"Comment on {self.post.title}"


class PostUpvote(models.Model):
    """Track upvotes on posts and comments."""
    
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='post_upvotes'
    )
    post = models.ForeignKey(
        CommunityPost,
        on_delete=models.CASCADE,
        null=True,
        blank=True,
        related_name='upvote_records'
    )
    comment = models.ForeignKey(
        CommunityComment,
        on_delete=models.CASCADE,
        null=True,
        blank=True,
        related_name='upvote_records'
    )
    
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        unique_together = [
            ['user', 'post'],
            ['user', 'comment'],
        ]
