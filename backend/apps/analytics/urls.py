from django.urls import path
from . import views

app_name = 'analytics'

urlpatterns = [
    path('dashboard/', views.DashboardStatsView.as_view(), name='dashboard'),
    path('insights/', views.ApplicationInsightsView.as_view(), name='insights'),
    path('daily/', views.DailyActivityView.as_view(), name='daily'),
    path('weekly/', views.WeeklyDigestListView.as_view(), name='weekly'),
    path('funnel/', views.StatusFunnelView.as_view(), name='funnel'),
    path('response-time/', views.CompanyResponseTimeView.as_view(), name='response_time'),
]
