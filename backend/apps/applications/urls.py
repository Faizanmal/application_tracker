from django.urls import path
from . import views

app_name = 'applications'

urlpatterns = [
    # Applications CRUD
    path('', views.JobApplicationListCreateView.as_view(), name='list_create'),
    path('<uuid:pk>/', views.JobApplicationDetailView.as_view(), name='detail'),
    
    # Status updates
    path('<uuid:pk>/status/', views.JobApplicationStatusUpdateView.as_view(), name='status_update'),
    path('bulk-status/', views.BulkStatusUpdateView.as_view(), name='bulk_status'),
    
    # Kanban
    path('kanban/', views.KanbanBoardView.as_view(), name='kanban'),
    path('kanban/order/', views.UpdateKanbanOrderView.as_view(), name='kanban_order'),
    
    # Archive & Favorite
    path('archived/', views.ArchivedApplicationsView.as_view(), name='archived'),
    path('<uuid:pk>/archive/', views.ArchiveApplicationView.as_view(), name='archive'),
    path('<uuid:pk>/favorite/', views.FavoriteApplicationView.as_view(), name='favorite'),
    
    # Timeline
    path('<uuid:application_id>/timeline/', views.ApplicationTimelineView.as_view(), name='timeline'),
    
    # Tags
    path('tags/', views.ApplicationTagListCreateView.as_view(), name='tags'),
    path('tags/<uuid:pk>/', views.ApplicationTagDetailView.as_view(), name='tag_detail'),
    
    # Documents
    path('<uuid:application_id>/documents/', views.ApplicationDocumentListCreateView.as_view(), name='documents'),
    path('documents/<uuid:pk>/', views.ApplicationDocumentDetailView.as_view(), name='document_detail'),
    
    # Export
    path('export/', views.ApplicationExportView.as_view(), name='export'),
]
