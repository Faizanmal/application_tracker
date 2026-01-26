from django.urls import path, include
from rest_framework.routers import DefaultRouter

from .views import (
    ProfessionalConnectionViewSet,
    ReferralViewSet,
    NetworkingEventViewSet,
    MentorshipRelationshipViewSet,
    MentorshipSessionViewSet,
)

router = DefaultRouter()
router.register(r'connections', ProfessionalConnectionViewSet, basename='connections')
router.register(r'referrals', ReferralViewSet, basename='referrals')
router.register(r'events', NetworkingEventViewSet, basename='networking-events')
router.register(r'mentorships', MentorshipRelationshipViewSet, basename='mentorships')
router.register(r'mentorship-sessions', MentorshipSessionViewSet, basename='mentorship-sessions')

urlpatterns = [
    path('', include(router.urls)),
]
