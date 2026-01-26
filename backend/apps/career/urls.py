from django.urls import path, include
from rest_framework.routers import DefaultRouter

from .views import (
    SkillViewSet,
    UserSkillViewSet,
    SkillGapAnalysisViewSet,
    LearningResourceViewSet,
    UserLearningProgressViewSet,
    LearningPathViewSet,
    UserLearningPathViewSet,
    PortfolioProjectViewSet,
    CareerGoalViewSet,
    CareerPathPlanViewSet,
)

router = DefaultRouter()
router.register(r'skills', SkillViewSet, basename='skills')
router.register(r'user-skills', UserSkillViewSet, basename='user-skills')
router.register(r'skill-gaps', SkillGapAnalysisViewSet, basename='skill-gaps')
router.register(r'learning-resources', LearningResourceViewSet, basename='learning-resources')
router.register(r'learning-progress', UserLearningProgressViewSet, basename='learning-progress')
router.register(r'learning-paths', LearningPathViewSet, basename='learning-paths')
router.register(r'my-learning-paths', UserLearningPathViewSet, basename='my-learning-paths')
router.register(r'portfolio', PortfolioProjectViewSet, basename='portfolio')
router.register(r'goals', CareerGoalViewSet, basename='goals')
router.register(r'career-plans', CareerPathPlanViewSet, basename='career-plans')

urlpatterns = [
    path('', include(router.urls)),
]
