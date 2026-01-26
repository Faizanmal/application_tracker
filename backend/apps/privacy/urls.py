from django.urls import path, include
from rest_framework.routers import DefaultRouter

from .views import (
    DataExportViewSet,
    GDPRRequestViewSet,
    TwoFactorAuthView,
    TwoFactorVerifyView,
    LoginAttemptViewSet,
    EncryptedNoteViewSet,
    SecurityAuditLogViewSet,
    PrivacySettingViewSet,
)

router = DefaultRouter()
router.register(r'exports', DataExportViewSet, basename='exports')
router.register(r'gdpr', GDPRRequestViewSet, basename='gdpr')
router.register(r'login-attempts', LoginAttemptViewSet, basename='login-attempts')
router.register(r'notes', EncryptedNoteViewSet, basename='encrypted-notes')
router.register(r'audit-log', SecurityAuditLogViewSet, basename='audit-log')
router.register(r'settings', PrivacySettingViewSet, basename='privacy-settings')

urlpatterns = [
    path('', include(router.urls)),
    path('2fa/', TwoFactorAuthView.as_view(), name='two-factor-auth'),
    path('2fa/verify/', TwoFactorVerifyView.as_view(), name='two-factor-verify'),
]
