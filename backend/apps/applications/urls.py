from django.urls import path, include
from rest_framework.routers import DefaultRouter
from . import views
from .bulk_operations import (
    BulkDeleteView, BulkArchiveView, BulkTagView, 
    BulkStatusView, BulkFavoriteView,
    ApplicationImportView, ApplicationExportView as NewExportView
)
from .saved_search import (
    SavedSearchListCreateView, SavedSearchDetailView,
    SavedSearchExecuteView, FilterOptionsView, SearchSuggestionsView
)
from .templates_feature import (
    ApplicationTemplateListCreateView, ApplicationTemplateDetailView,
    UseTemplateView, CoverLetterTemplateListCreateView,
    CoverLetterTemplateDetailView, RenderCoverLetterView,
    ResumeVersionListCreateView, ResumeVersionDetailView,
    DuplicateResumeVersionView
)

app_name = 'applications'

router = DefaultRouter()
router.register(r'shares', views.ApplicationShareViewSet, basename='shares')
router.register(r'comments', views.ApplicationCommentViewSet, basename='comments')
router.register(r'progress-updates', views.ProgressUpdateViewSet, basename='progress-updates')

urlpatterns = [
    path('', include(router.urls)),
    
    # Applications CRUD
    path('', views.JobApplicationListCreateView.as_view(), name='list_create'),
    path('<uuid:pk>/', views.JobApplicationDetailView.as_view(), name='detail'),
    
    # Status updates
    path('<uuid:pk>/status/', views.JobApplicationStatusUpdateView.as_view(), name='status_update'),
    path('bulk-status/', views.BulkStatusUpdateView.as_view(), name='bulk_status'),
    
    # Bulk Operations
    path('bulk/status/', BulkStatusView.as_view(), name='bulk_status_new'),
    path('bulk/delete/', BulkDeleteView.as_view(), name='bulk_delete'),
    path('bulk/archive/', BulkArchiveView.as_view(), name='bulk_archive'),
    path('bulk/tag/', BulkTagView.as_view(), name='bulk_tag'),
    path('bulk/favorite/', BulkFavoriteView.as_view(), name='bulk_favorite'),
    
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
    
    # Import/Export
    path('import/', ApplicationImportView.as_view(), name='import'),
    path('export/', NewExportView.as_view(), name='export'),
    
    # Saved Searches
    path('saved-searches/', SavedSearchListCreateView.as_view(), name='saved_searches'),
    path('saved-searches/<uuid:pk>/', SavedSearchDetailView.as_view(), name='saved_search_detail'),
    path('saved-searches/<uuid:pk>/execute/', SavedSearchExecuteView.as_view(), name='saved_search_execute'),
    path('filter-options/', FilterOptionsView.as_view(), name='filter_options'),
    path('search-suggestions/', SearchSuggestionsView.as_view(), name='search_suggestions'),
    
    # Application Templates
    path('templates/', ApplicationTemplateListCreateView.as_view(), name='templates'),
    path('templates/<uuid:pk>/', ApplicationTemplateDetailView.as_view(), name='template_detail'),
    path('templates/<uuid:pk>/use/', UseTemplateView.as_view(), name='template_use'),
    
    # Cover Letter Templates
    path('cover-letter-templates/', CoverLetterTemplateListCreateView.as_view(), name='cover_letter_templates'),
    path('cover-letter-templates/<uuid:pk>/', CoverLetterTemplateDetailView.as_view(), name='cover_letter_template_detail'),
    path('cover-letter-templates/render/', RenderCoverLetterView.as_view(), name='cover_letter_render'),
    
    # Resume Versions
    path('resume-versions/', ResumeVersionListCreateView.as_view(), name='resume_versions'),
    path('resume-versions/<uuid:pk>/', ResumeVersionDetailView.as_view(), name='resume_version_detail'),
    path('resume-versions/<uuid:pk>/duplicate/', DuplicateResumeVersionView.as_view(), name='resume_version_duplicate'),
    
    # Quick Actions
    path('quick-actions/<str:action>/', views.QuickActionsView.as_view(), name='quick_actions'),
    path('rapid-create/', views.RapidApplicationCreateView.as_view(), name='rapid_create'),
]
