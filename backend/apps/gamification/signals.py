"""Gamification signals for automatic achievement/streak tracking."""
from django.db.models.signals import post_save
from django.dispatch import receiver
from django.utils import timezone
from datetime import timedelta

from apps.applications.models import JobApplication
from .models import (
    Achievement,
    UserAchievement,
    UserStreak,
    UserPoints,
    PointsTransaction,
)


def award_achievement(user, achievement):
    """Award an achievement to a user."""
    user_achievement, created = UserAchievement.objects.get_or_create(
        user=user,
        achievement=achievement
    )
    
    if created or achievement.is_repeatable:
        if not created:
            user_achievement.times_earned += 1
            user_achievement.save()
        
        # Award points
        user_points, _ = UserPoints.objects.get_or_create(user=user)
        user_points.total_points += achievement.points
        user_points.achievement_points += achievement.points
        user_points.level = user_points.calculate_level()
        user_points.save()
        
        # Log transaction
        PointsTransaction.objects.create(
            user=user,
            transaction_type='achievement',
            points=achievement.points,
            description=f"Earned achievement: {achievement.name}",
            achievement=achievement
        )
    
    return user_achievement


def update_streak(user, streak_type):
    """Update a user's streak."""
    today = timezone.now().date()
    streak, _ = UserStreak.objects.get_or_create(
        user=user,
        streak_type=streak_type
    )
    
    if streak.last_activity_date:
        days_diff = (today - streak.last_activity_date).days
        
        if days_diff == 0:
            # Already logged today
            return streak
        elif days_diff == 1:
            # Consecutive day
            streak.current_count += 1
        else:
            # Streak broken
            streak.current_count = 1
            streak.current_start_date = today
    else:
        # First activity
        streak.current_count = 1
        streak.current_start_date = today
    
    streak.last_activity_date = today
    streak.total_activities += 1
    
    # Update longest if current is better
    if streak.current_count > streak.longest_count:
        streak.longest_count = streak.current_count
        streak.longest_start_date = streak.current_start_date
        streak.longest_end_date = today
    
    streak.save()
    
    # Award streak points
    if streak.current_count in [7, 14, 30, 60, 90, 180, 365]:
        user_points, _ = UserPoints.objects.get_or_create(user=user)
        bonus = streak.current_count * 2
        user_points.total_points += bonus
        user_points.streak_points += bonus
        user_points.save()
        
        PointsTransaction.objects.create(
            user=user,
            transaction_type='streak',
            points=bonus,
            description=f"{streak.current_count}-day {streak_type} streak!"
        )
    
    return streak


def check_application_achievements(user):
    """Check and award application-related achievements."""
    from apps.applications.models import JobApplication
    
    app_count = JobApplication.objects.filter(user=user).count()
    
    # Define milestones
    milestones = [
        (1, 'First Application', 'first_application'),
        (5, 'Getting Started', 'apps_5'),
        (10, 'Job Seeker', 'apps_10'),
        (25, 'Active Applicant', 'apps_25'),
        (50, 'Dedicated Hunter', 'apps_50'),
        (100, 'Century Club', 'apps_100'),
    ]
    
    for count, name, trigger in milestones:
        if app_count >= count:
            achievement = Achievement.objects.filter(
                trigger_type=trigger,
                trigger_value=count
            ).first()
            
            if achievement:
                award_achievement(user, achievement)


@receiver(post_save, sender=JobApplication)
def on_application_created(sender, instance, created, **kwargs):
    """Handle new application creation."""
    if created:
        user = instance.user
        
        # Award points for application
        user_points, _ = UserPoints.objects.get_or_create(user=user)
        user_points.total_points += 5
        user_points.application_points += 5
        user_points.points_this_week += 5
        user_points.points_this_month += 5
        user_points.save()
        
        PointsTransaction.objects.create(
            user=user,
            transaction_type='earned',
            points=5,
            description='Submitted a job application'
        )
        
        # Update daily application streak
        update_streak(user, 'daily_application')
        
        # Check for achievements
        check_application_achievements(user)
