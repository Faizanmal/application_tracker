from django.urls import path
from . import views

app_name = 'users'

urlpatterns = [
    # Authentication
    path('register/', views.RegisterView.as_view(), name='register'),
    path('login/', views.LoginView.as_view(), name='login'),
    path('logout/', views.LogoutView.as_view(), name='logout'),
    path('token/refresh/', views.CustomTokenRefreshView.as_view(), name='token_refresh'),
    
    # Password management
    path('password/change/', views.ChangePasswordView.as_view(), name='change_password'),
    path('password/forgot/', views.ForgotPasswordView.as_view(), name='forgot_password'),
    path('password/reset/', views.ResetPasswordView.as_view(), name='reset_password'),
    
    # Email verification
    path('verify-email/', views.VerifyEmailView.as_view(), name='verify_email'),
    
    # OAuth
    path('google/', views.GoogleAuthView.as_view(), name='google_auth'),
    path('github/', views.GitHubAuthView.as_view(), name='github_auth'),
    
    # User profile
    path('me/', views.MeView.as_view(), name='me'),
    
    # Resumes
    path('resumes/', views.ResumeListCreateView.as_view(), name='resume_list'),
    path('resumes/<uuid:pk>/', views.ResumeDetailView.as_view(), name='resume_detail'),
    
    # Onboarding
    path('tutorial-progress/', views.TutorialProgressViewSet.as_view(), name='tutorial_progress'),
    path('tutorial-progress/<str:tutorial_type>/', views.TutorialProgressViewSet.as_view(), name='tutorial_progress_detail'),
    path('help-tooltips/', views.HelpTooltipsView.as_view(), name='help_tooltips'),
    path('generate-sample-data/', views.GenerateSampleDataView.as_view(), name='generate_sample_data'),
]
