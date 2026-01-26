from django.urls import path
from . import views

app_name = 'reminders'

urlpatterns = [
    # Reminders CRUD
    path('', views.ReminderListCreateView.as_view(), name='list_create'),
    path('<uuid:pk>/', views.ReminderDetailView.as_view(), name='detail'),
    
    # Reminder actions
    path('<uuid:pk>/complete/', views.CompleteReminderView.as_view(), name='complete'),
    path('<uuid:pk>/snooze/', views.SnoozeReminderView.as_view(), name='snooze'),
    path('<uuid:pk>/cancel/', views.CancelReminderView.as_view(), name='cancel'),
    
    # Lists
    path('upcoming/', views.UpcomingRemindersView.as_view(), name='upcoming'),
    path('today/', views.TodayRemindersView.as_view(), name='today'),
    path('suggestions/', views.SuggestFollowUpView.as_view(), name='suggestions'),
    
    # Templates
    path('templates/', views.ReminderTemplateListCreateView.as_view(), name='templates'),
    path('templates/<uuid:pk>/', views.ReminderTemplateDetailView.as_view(), name='template_detail'),
    
    # Notifications
    path('notifications/', views.NotificationListView.as_view(), name='notifications'),
    path('notifications/unread-count/', views.UnreadNotificationCountView.as_view(), name='unread_count'),
    path('notifications/<uuid:pk>/read/', views.MarkNotificationReadView.as_view(), name='mark_read'),
    path('notifications/mark-all-read/', views.MarkAllNotificationsReadView.as_view(), name='mark_all_read'),
]
