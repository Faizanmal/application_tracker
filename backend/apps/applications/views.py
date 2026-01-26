from rest_framework import generics, status, filters
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.decorators import api_view
from django_filters.rest_framework import DjangoFilterBackend
from django.db.models import Q
from django.conf import settings

from .models import JobApplication, ApplicationTimeline, ApplicationTag, ApplicationDocument
from .serializers import (
    JobApplicationListSerializer, JobApplicationDetailSerializer,
    ApplicationTimelineSerializer, ApplicationTagSerializer,
    ApplicationDocumentSerializer, ApplicationStatusUpdateSerializer,
    BulkStatusUpdateSerializer, KanbanOrderSerializer
)
from .filters import JobApplicationFilter


class JobApplicationListCreateView(generics.ListCreateAPIView):
    """List and create job applications."""
    
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_class = JobApplicationFilter
    search_fields = ['company_name', 'job_title', 'notes', 'location']
    ordering_fields = ['created_at', 'updated_at', 'applied_date', 'company_name', 'job_title']
    ordering = ['-updated_at']
    
    def get_serializer_class(self):
        if self.request.method == 'POST':
            return JobApplicationDetailSerializer
        return JobApplicationListSerializer
    
    def get_queryset(self):
        return JobApplication.objects.filter(
            user=self.request.user,
            is_archived=False
        ).prefetch_related('tags', 'interviews')
    
    def create(self, request, *args, **kwargs):
        # Check application limit for free tier
        user = request.user
        if not user.is_pro:
            app_count = JobApplication.objects.filter(user=user).count()
            if app_count >= settings.FREE_TIER_APPLICATION_LIMIT:
                return Response(
                    {
                        'error': 'Application limit reached',
                        'message': f'Free tier is limited to {settings.FREE_TIER_APPLICATION_LIMIT} applications. Upgrade to Pro for unlimited applications.'
                    },
                    status=status.HTTP_403_FORBIDDEN
                )
        
        return super().create(request, *args, **kwargs)


class JobApplicationDetailView(generics.RetrieveUpdateDestroyAPIView):
    """Get, update, or delete a job application."""
    
    serializer_class = JobApplicationDetailSerializer
    
    def get_queryset(self):
        return JobApplication.objects.filter(user=self.request.user)


class JobApplicationStatusUpdateView(APIView):
    """Update application status (for Kanban drag & drop)."""
    
    def patch(self, request, pk):
        try:
            application = JobApplication.objects.get(pk=pk, user=request.user)
        except JobApplication.DoesNotExist:
            return Response(
                {'error': 'Application not found'},
                status=status.HTTP_404_NOT_FOUND
            )
        
        serializer = ApplicationStatusUpdateSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        
        old_status = application.status
        new_status = serializer.validated_data['status']
        
        application.status = new_status
        if 'status_order' in serializer.validated_data:
            application.status_order = serializer.validated_data['status_order']
        application.save()
        
        # Create timeline entry
        if old_status != new_status:
            ApplicationTimeline.objects.create(
                application=application,
                event_type=ApplicationTimeline.EventType.STATUS_CHANGE,
                title=f'Status changed to {application.get_status_display()}',
                old_status=old_status,
                new_status=new_status
            )
        
        return Response(JobApplicationListSerializer(application).data)


class BulkStatusUpdateView(APIView):
    """Bulk update application statuses."""
    
    def post(self, request):
        serializer = BulkStatusUpdateSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        
        applications = JobApplication.objects.filter(
            id__in=serializer.validated_data['application_ids'],
            user=request.user
        )
        
        new_status = serializer.validated_data['status']
        updated_count = 0
        
        for app in applications:
            old_status = app.status
            if old_status != new_status:
                app.status = new_status
                app.save()
                
                ApplicationTimeline.objects.create(
                    application=app,
                    event_type=ApplicationTimeline.EventType.STATUS_CHANGE,
                    title=f'Status changed to {app.get_status_display()}',
                    old_status=old_status,
                    new_status=new_status
                )
                updated_count += 1
        
        return Response({'updated_count': updated_count})


class KanbanBoardView(APIView):
    """Get applications organized by status for Kanban board."""
    
    def get(self, request):
        applications = JobApplication.objects.filter(
            user=request.user,
            is_archived=False
        ).prefetch_related('tags', 'interviews').order_by('status_order', '-updated_at')
        
        # Group by status
        kanban_data = {}
        for status_choice in JobApplication.Status.choices:
            status_key = status_choice[0]
            kanban_data[status_key] = {
                'label': status_choice[1],
                'applications': []
            }
        
        for app in applications:
            serializer = JobApplicationListSerializer(app)
            kanban_data[app.status]['applications'].append(serializer.data)
        
        return Response(kanban_data)


class UpdateKanbanOrderView(APIView):
    """Update Kanban board ordering."""
    
    def post(self, request):
        serializer = KanbanOrderSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        
        for item in serializer.validated_data['applications']:
            try:
                app = JobApplication.objects.get(
                    id=item['id'],
                    user=request.user
                )
                old_status = app.status
                app.status = item['status']
                app.status_order = int(item['order'])
                app.save()
                
                if old_status != item['status']:
                    ApplicationTimeline.objects.create(
                        application=app,
                        event_type=ApplicationTimeline.EventType.STATUS_CHANGE,
                        title=f'Status changed to {app.get_status_display()}',
                        old_status=old_status,
                        new_status=item['status']
                    )
            except JobApplication.DoesNotExist:
                continue
        
        return Response({'success': True})


class ArchivedApplicationsView(generics.ListAPIView):
    """List archived applications."""
    
    serializer_class = JobApplicationListSerializer
    
    def get_queryset(self):
        return JobApplication.objects.filter(
            user=self.request.user,
            is_archived=True
        ).prefetch_related('tags')


class ArchiveApplicationView(APIView):
    """Archive or unarchive an application."""
    
    def post(self, request, pk):
        try:
            application = JobApplication.objects.get(pk=pk, user=request.user)
        except JobApplication.DoesNotExist:
            return Response(
                {'error': 'Application not found'},
                status=status.HTTP_404_NOT_FOUND
            )
        
        application.is_archived = not application.is_archived
        application.save()
        
        return Response({
            'is_archived': application.is_archived,
            'message': 'Application archived' if application.is_archived else 'Application unarchived'
        })


class FavoriteApplicationView(APIView):
    """Toggle application favorite status."""
    
    def post(self, request, pk):
        try:
            application = JobApplication.objects.get(pk=pk, user=request.user)
        except JobApplication.DoesNotExist:
            return Response(
                {'error': 'Application not found'},
                status=status.HTTP_404_NOT_FOUND
            )
        
        application.is_favorite = not application.is_favorite
        application.save()
        
        return Response({
            'is_favorite': application.is_favorite
        })


class ApplicationTimelineView(generics.ListCreateAPIView):
    """List and create timeline entries for an application."""
    
    serializer_class = ApplicationTimelineSerializer
    
    def get_queryset(self):
        application_id = self.kwargs['application_id']
        return ApplicationTimeline.objects.filter(
            application__id=application_id,
            application__user=self.request.user
        )
    
    def perform_create(self, serializer):
        application_id = self.kwargs['application_id']
        application = JobApplication.objects.get(
            id=application_id,
            user=self.request.user
        )
        serializer.save(application=application)


class ApplicationTagListCreateView(generics.ListCreateAPIView):
    """List and create application tags."""
    
    serializer_class = ApplicationTagSerializer
    
    def get_queryset(self):
        return ApplicationTag.objects.filter(user=self.request.user)


class ApplicationTagDetailView(generics.RetrieveUpdateDestroyAPIView):
    """Get, update, or delete an application tag."""
    
    serializer_class = ApplicationTagSerializer
    
    def get_queryset(self):
        return ApplicationTag.objects.filter(user=self.request.user)


class ApplicationDocumentListCreateView(generics.ListCreateAPIView):
    """List and create documents for an application."""
    
    serializer_class = ApplicationDocumentSerializer
    
    def get_queryset(self):
        application_id = self.kwargs['application_id']
        return ApplicationDocument.objects.filter(
            application__id=application_id,
            application__user=self.request.user
        )
    
    def perform_create(self, serializer):
        application_id = self.kwargs['application_id']
        application = JobApplication.objects.get(
            id=application_id,
            user=self.request.user
        )
        serializer.save(application=application)


class ApplicationDocumentDetailView(generics.RetrieveDestroyAPIView):
    """Get or delete an application document."""
    
    serializer_class = ApplicationDocumentSerializer
    
    def get_queryset(self):
        return ApplicationDocument.objects.filter(
            application__user=self.request.user
        )


class ApplicationExportView(APIView):
    """Export applications to CSV or PDF."""
    
    def get(self, request):
        import csv
        from django.http import HttpResponse
        
        format_type = request.query_params.get('format', 'csv')
        
        applications = JobApplication.objects.filter(
            user=request.user
        ).order_by('-created_at')
        
        if format_type == 'csv':
            response = HttpResponse(content_type='text/csv')
            response['Content-Disposition'] = 'attachment; filename="applications.csv"'
            
            writer = csv.writer(response)
            writer.writerow([
                'Company', 'Job Title', 'Status', 'Applied Date',
                'Location', 'Job Type', 'Salary Min', 'Salary Max',
                'Job Link', 'Source', 'Notes'
            ])
            
            for app in applications:
                writer.writerow([
                    app.company_name,
                    app.job_title,
                    app.get_status_display(),
                    app.applied_date,
                    app.location,
                    app.get_job_type_display(),
                    app.salary_min,
                    app.salary_max,
                    app.job_link,
                    app.source,
                    app.notes
                ])
            
            return response
        
        return Response({'error': 'Invalid format'}, status=status.HTTP_400_BAD_REQUEST)
