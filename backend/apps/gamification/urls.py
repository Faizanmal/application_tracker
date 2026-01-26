from django.urls import path, include
from rest_framework.routers import DefaultRouter

from .views import (
    AchievementViewSet,
    UserStreakViewSet,
    UserPointsViewSet,
    LeaderboardViewSet,
    ChallengeViewSet,
    CommunityPostViewSet,
    CommunityCommentViewSet,
)

router = DefaultRouter()
router.register(r'achievements', AchievementViewSet, basename='achievements')
router.register(r'streaks', UserStreakViewSet, basename='streaks')
router.register(r'points', UserPointsViewSet, basename='points')
router.register(r'leaderboard', LeaderboardViewSet, basename='leaderboard')
router.register(r'challenges', ChallengeViewSet, basename='challenges')
router.register(r'community/posts', CommunityPostViewSet, basename='community-posts')
router.register(r'community/comments', CommunityCommentViewSet, basename='community-comments')

urlpatterns = [
    path('', include(router.urls)),
]
