from django.urls import path
from . import views

app_name = 'interviews'

urlpatterns = [
    # Interviews CRUD
    path('', views.InterviewListCreateView.as_view(), name='list_create'),
    path('<uuid:pk>/', views.InterviewDetailView.as_view(), name='detail'),
    
    # Interview status
    path('<uuid:pk>/complete/', views.CompleteInterviewView.as_view(), name='complete'),
    path('<uuid:pk>/cancel/', views.CancelInterviewView.as_view(), name='cancel'),
    
    # Upcoming interviews
    path('upcoming/', views.UpcomingInterviewsView.as_view(), name='upcoming'),
    path('today/', views.TodayInterviewsView.as_view(), name='today'),
    
    # Questions
    path('questions/', views.InterviewQuestionListCreateView.as_view(), name='questions'),
    path('<uuid:interview_id>/questions/', views.InterviewQuestionListCreateView.as_view(), name='interview_questions'),
    path('questions/<uuid:pk>/', views.InterviewQuestionDetailView.as_view(), name='question_detail'),
    
    # STAR Responses
    path('questions/<uuid:question_id>/star/', views.STARResponseListCreateView.as_view(), name='star_responses'),
    path('star/<uuid:pk>/', views.STARResponseDetailView.as_view(), name='star_detail'),
    
    # Company Research
    path('research/<uuid:application_id>/', views.CompanyResearchView.as_view(), name='company_research'),
    
    # Common Questions
    path('common-questions/', views.CommonQuestionListView.as_view(), name='common_questions'),
]
