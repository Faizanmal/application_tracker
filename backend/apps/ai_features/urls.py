from django.urls import path
from . import views

app_name = 'ai_features'

urlpatterns = [
    # AI Generation
    path('follow-up-email/', views.GenerateFollowUpEmailView.as_view(), name='follow_up_email'),
    path('resume-match/', views.ResumeMatchScoreView.as_view(), name='resume_match'),
    path('interview-questions/', views.GenerateInterviewQuestionsView.as_view(), name='interview_questions'),
    path('improve-star/', views.ImproveSTARResponseView.as_view(), name='improve_star'),
    path('cover-letter/', views.GenerateCoverLetterView.as_view(), name='cover_letter'),
    
    # History
    path('usage/', views.AIUsageHistoryView.as_view(), name='usage'),
    path('content/', views.GeneratedContentListView.as_view(), name='content'),
    path('content/<uuid:pk>/rate/', views.RateGeneratedContentView.as_view(), name='rate_content'),
]
