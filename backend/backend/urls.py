"""
URL configuration for backend project.
"""
from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static
from drf_spectacular.views import SpectacularAPIView, SpectacularSwaggerView, SpectacularRedocView

urlpatterns = [
    # Admin
    path("admin/", admin.site.urls),
    
    # API Documentation
    path("api/schema/", SpectacularAPIView.as_view(), name="schema"),
    path("api/docs/", SpectacularSwaggerView.as_view(url_name="schema"), name="swagger-ui"),
    path("api/redoc/", SpectacularRedocView.as_view(url_name="schema"), name="redoc"),
    
    # API v1 Routes
    path("api/v1/auth/", include("apps.users.urls")),
    path("api/v1/applications/", include("apps.applications.urls")),
    path("api/v1/interviews/", include("apps.interviews.urls")),
    path("api/v1/reminders/", include("apps.reminders.urls")),
    path("api/v1/analytics/", include("apps.analytics.urls")),
    path("api/v1/subscriptions/", include("apps.subscriptions.urls")),
    path("api/v1/ai/", include("apps.ai_features.urls")),
    path("api/v1/networking/", include("apps.networking.urls")),
    path("api/v1/career/", include("apps.career.urls")),
    path("api/v1/gamification/", include("apps.gamification.urls")),
    path("api/v1/integrations/", include("apps.integrations.urls")),
    path("api/v1/market-intel/", include("apps.market_intel.urls")),
    path("api/v1/privacy/", include("apps.privacy.urls")),
]

# Serve media files in development
if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)

