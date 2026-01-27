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
    path('heatmap/', views.ActivityHeatmapView.as_view(), name='heatmap'),
    path('actionable-insights/', views.ActionableInsightsView.as_view(), name='actionable_insights'),
    path('trends/', views.TrendAnalysisView.as_view(), name='trends'),
    path('geographic/', views.GeographicHeatmapView.as_view(), name='geographic'),
    path('salary-analysis/', views.SalaryAnalysisView.as_view(), name='salary_analysis'),
    path('interactive-charts/', views.InteractiveChartView.as_view(), name='interactive_charts'),
]
