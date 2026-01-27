"""
Bulk operations for job applications.
Handles bulk status updates, deletion, archiving, and tagging.
"""
import csv
import io
import json
from datetime import datetime
from typing import List, Dict, Any, Optional
from django.db import transaction
from django.db.models import QuerySet
from rest_framework import status, serializers
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.parsers import MultiPartParser, FormParser

from .models import JobApplication, ApplicationTimeline, ApplicationTag


# ============================================================================
# SERIALIZERS FOR BULK OPERATIONS
# ============================================================================

class BulkDeleteSerializer(serializers.Serializer):
    """Serializer for bulk deletion."""
    application_ids = serializers.ListField(
        child=serializers.UUIDField(),
        min_length=1,
        max_length=100
    )


class BulkArchiveSerializer(serializers.Serializer):
    """Serializer for bulk archiving."""
    application_ids = serializers.ListField(
        child=serializers.UUIDField(),
        min_length=1,
        max_length=100
    )
    archive = serializers.BooleanField(default=True)


class BulkTagSerializer(serializers.Serializer):
    """Serializer for bulk tagging."""
    application_ids = serializers.ListField(
        child=serializers.UUIDField(),
        min_length=1,
        max_length=100
    )
    tag_ids = serializers.ListField(
        child=serializers.UUIDField(),
        min_length=1
    )
    action = serializers.ChoiceField(choices=['add', 'remove', 'set'], default='add')


class BulkStatusUpdateSerializer(serializers.Serializer):
    """Serializer for bulk status update."""
    application_ids = serializers.ListField(
        child=serializers.UUIDField(),
        min_length=1,
        max_length=100
    )
    status = serializers.ChoiceField(choices=JobApplication.Status.choices)


class BulkFavoriteSerializer(serializers.Serializer):
    """Serializer for bulk favorite toggle."""
    application_ids = serializers.ListField(
        child=serializers.UUIDField(),
        min_length=1,
        max_length=100
    )
    is_favorite = serializers.BooleanField()


# ============================================================================
# BULK OPERATION VIEWS
# ============================================================================

class BulkDeleteView(APIView):
    """Bulk delete applications."""
    
    def post(self, request):
        serializer = BulkDeleteSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        
        applications = JobApplication.objects.filter(
            id__in=serializer.validated_data['application_ids'],
            user=request.user
        )
        
        deleted_count = applications.count()
        applications.delete()
        
        return Response({
            'deleted_count': deleted_count,
            'message': f'Successfully deleted {deleted_count} applications'
        })


class BulkArchiveView(APIView):
    """Bulk archive/unarchive applications."""
    
    def post(self, request):
        serializer = BulkArchiveSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        
        archive = serializer.validated_data['archive']
        applications = JobApplication.objects.filter(
            id__in=serializer.validated_data['application_ids'],
            user=request.user
        )
        
        updated_count = applications.update(is_archived=archive)
        
        action = 'archived' if archive else 'unarchived'
        return Response({
            'updated_count': updated_count,
            'message': f'Successfully {action} {updated_count} applications'
        })


class BulkTagView(APIView):
    """Bulk add/remove/set tags on applications."""
    
    def post(self, request):
        serializer = BulkTagSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        
        action = serializer.validated_data['action']
        tag_ids = serializer.validated_data['tag_ids']
        
        applications = JobApplication.objects.filter(
            id__in=serializer.validated_data['application_ids'],
            user=request.user
        )
        
        tags = ApplicationTag.objects.filter(
            id__in=tag_ids,
            user=request.user
        )
        
        updated_count = 0
        with transaction.atomic():
            for app in applications:
                if action == 'add':
                    app.tags.add(*tags)
                elif action == 'remove':
                    app.tags.remove(*tags)
                elif action == 'set':
                    app.tags.set(tags)
                updated_count += 1
        
        return Response({
            'updated_count': updated_count,
            'message': f'Successfully updated tags for {updated_count} applications'
        })


class BulkStatusView(APIView):
    """Bulk update application statuses."""
    
    def post(self, request):
        serializer = BulkStatusUpdateSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        
        new_status = serializer.validated_data['status']
        applications = JobApplication.objects.filter(
            id__in=serializer.validated_data['application_ids'],
            user=request.user
        )
        
        updated_count = 0
        with transaction.atomic():
            for app in applications:
                old_status = app.status
                if old_status != new_status:
                    app.status = new_status
                    app.save()
                    
                    # Create timeline entry
                    ApplicationTimeline.objects.create(
                        application=app,
                        event_type=ApplicationTimeline.EventType.STATUS_CHANGE,
                        title=f'Status changed to {app.get_status_display()}',
                        description='Bulk status update',
                        old_status=old_status,
                        new_status=new_status
                    )
                    updated_count += 1
        
        return Response({
            'updated_count': updated_count,
            'message': f'Successfully updated status for {updated_count} applications'
        })


class BulkFavoriteView(APIView):
    """Bulk favorite/unfavorite applications."""
    
    def post(self, request):
        serializer = BulkFavoriteSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        
        is_favorite = serializer.validated_data['is_favorite']
        applications = JobApplication.objects.filter(
            id__in=serializer.validated_data['application_ids'],
            user=request.user
        )
        
        updated_count = applications.update(is_favorite=is_favorite)
        
        action = 'favorited' if is_favorite else 'unfavorited'
        return Response({
            'updated_count': updated_count,
            'message': f'Successfully {action} {updated_count} applications'
        })


# ============================================================================
# IMPORT FUNCTIONALITY
# ============================================================================

class ImportSerializer(serializers.Serializer):
    """Serializer for import settings."""
    file = serializers.FileField()
    source = serializers.ChoiceField(
        choices=['csv', 'linkedin', 'indeed', 'glassdoor', 'json'],
        default='csv'
    )
    update_existing = serializers.BooleanField(default=False)


class ApplicationImportView(APIView):
    """Import applications from various sources."""
    parser_classes = (MultiPartParser, FormParser)
    
    # Column mappings for different sources
    COLUMN_MAPPINGS = {
        'csv': {
            'company': 'company_name',
            'company_name': 'company_name',
            'job_title': 'job_title',
            'title': 'job_title',
            'position': 'job_title',
            'status': 'status',
            'location': 'location',
            'url': 'job_link',
            'link': 'job_link',
            'job_url': 'job_link',
            'job_link': 'job_link',
            'applied_date': 'applied_date',
            'date_applied': 'applied_date',
            'salary': 'salary_min',
            'salary_min': 'salary_min',
            'salary_max': 'salary_max',
            'notes': 'notes',
            'source': 'source',
        },
        'linkedin': {
            'Company Name': 'company_name',
            'Job Title': 'job_title',
            'Application Date': 'applied_date',
            'Status': 'status',
            'Job URL': 'job_link',
            'Location': 'location',
        },
        'indeed': {
            'Employer': 'company_name',
            'Job Title': 'job_title',
            'Date Applied': 'applied_date',
            'Status': 'status',
            'Job URL': 'job_link',
            'Location': 'location',
        },
    }
    
    STATUS_MAPPINGS = {
        # LinkedIn statuses
        'applied': 'applied',
        'viewed': 'screening',
        'in progress': 'interviewing',
        'not selected': 'rejected',
        'hired': 'accepted',
        # Indeed statuses
        'pending': 'applied',
        'reviewed': 'screening',
        'interviewing': 'interviewing',
        'offer': 'offer',
        'rejected': 'rejected',
        # Generic
        'wishlist': 'wishlist',
        'screening': 'screening',
        'offer': 'offer',
        'accepted': 'accepted',
        'withdrawn': 'withdrawn',
        'ghosted': 'ghosted',
    }
    
    def post(self, request):
        serializer = ImportSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        
        file = serializer.validated_data['file']
        source = serializer.validated_data['source']
        update_existing = serializer.validated_data['update_existing']
        
        try:
            if source == 'json':
                result = self._import_json(request.user, file, update_existing)
            else:
                result = self._import_csv(
                    request.user, file, source, update_existing
                )
            
            return Response(result)
        except Exception as e:
            return Response(
                {'error': str(e)},
                status=status.HTTP_400_BAD_REQUEST
            )
    
    def _import_csv(
        self, 
        user, 
        file, 
        source: str, 
        update_existing: bool
    ) -> Dict[str, Any]:
        """Import applications from CSV file."""
        content = file.read().decode('utf-8')
        reader = csv.DictReader(io.StringIO(content))
        
        mappings = self.COLUMN_MAPPINGS.get(source, self.COLUMN_MAPPINGS['csv'])
        
        created_count = 0
        updated_count = 0
        skipped_count = 0
        errors = []
        
        for row_num, row in enumerate(reader, start=2):
            try:
                app_data = self._map_row_to_application(row, mappings)
                
                if not app_data.get('company_name') or not app_data.get('job_title'):
                    skipped_count += 1
                    continue
                
                # Map status
                if 'status' in app_data:
                    status_lower = str(app_data['status']).lower()
                    app_data['status'] = self.STATUS_MAPPINGS.get(
                        status_lower, 'applied'
                    )
                else:
                    app_data['status'] = 'applied'
                
                # Parse dates
                if app_data.get('applied_date'):
                    app_data['applied_date'] = self._parse_date(
                        app_data['applied_date']
                    )
                
                # Check for existing
                existing = JobApplication.objects.filter(
                    user=user,
                    company_name__iexact=app_data['company_name'],
                    job_title__iexact=app_data['job_title']
                ).first()
                
                if existing:
                    if update_existing:
                        for key, value in app_data.items():
                            if value:
                                setattr(existing, key, value)
                        existing.save()
                        updated_count += 1
                    else:
                        skipped_count += 1
                else:
                    app_data['user'] = user
                    if source != 'csv':
                        app_data['source'] = source.capitalize()
                    JobApplication.objects.create(**app_data)
                    created_count += 1
                    
            except Exception as e:
                errors.append(f'Row {row_num}: {str(e)}')
        
        return {
            'created_count': created_count,
            'updated_count': updated_count,
            'skipped_count': skipped_count,
            'errors': errors[:10],  # Limit errors
            'message': f'Import complete: {created_count} created, {updated_count} updated, {skipped_count} skipped'
        }
    
    def _import_json(
        self, 
        user, 
        file, 
        update_existing: bool
    ) -> Dict[str, Any]:
        """Import applications from JSON file."""
        content = file.read().decode('utf-8')
        data = json.loads(content)
        
        applications = data if isinstance(data, list) else data.get('applications', [])
        
        created_count = 0
        updated_count = 0
        skipped_count = 0
        errors = []
        
        for idx, app_data in enumerate(applications):
            try:
                # Normalize field names
                normalized = {}
                for key, value in app_data.items():
                    normalized_key = key.lower().replace(' ', '_')
                    normalized[normalized_key] = value
                
                if not normalized.get('company_name') or not normalized.get('job_title'):
                    skipped_count += 1
                    continue
                
                # Prepare data
                create_data = {
                    'company_name': normalized.get('company_name'),
                    'job_title': normalized.get('job_title'),
                    'status': normalized.get('status', 'applied'),
                    'location': normalized.get('location', ''),
                    'job_link': normalized.get('job_link', normalized.get('job_url', '')),
                    'notes': normalized.get('notes', ''),
                    'source': normalized.get('source', 'JSON Import'),
                }
                
                # Parse dates
                if normalized.get('applied_date'):
                    create_data['applied_date'] = self._parse_date(
                        normalized['applied_date']
                    )
                
                # Handle salary
                if normalized.get('salary_min'):
                    create_data['salary_min'] = normalized['salary_min']
                if normalized.get('salary_max'):
                    create_data['salary_max'] = normalized['salary_max']
                
                # Check existing
                existing = JobApplication.objects.filter(
                    user=user,
                    company_name__iexact=create_data['company_name'],
                    job_title__iexact=create_data['job_title']
                ).first()
                
                if existing:
                    if update_existing:
                        for key, value in create_data.items():
                            if value:
                                setattr(existing, key, value)
                        existing.save()
                        updated_count += 1
                    else:
                        skipped_count += 1
                else:
                    create_data['user'] = user
                    JobApplication.objects.create(**create_data)
                    created_count += 1
                    
            except Exception as e:
                errors.append(f'Item {idx + 1}: {str(e)}')
        
        return {
            'created_count': created_count,
            'updated_count': updated_count,
            'skipped_count': skipped_count,
            'errors': errors[:10],
            'message': f'Import complete: {created_count} created, {updated_count} updated, {skipped_count} skipped'
        }
    
    def _map_row_to_application(
        self, 
        row: Dict[str, str], 
        mappings: Dict[str, str]
    ) -> Dict[str, Any]:
        """Map CSV row to application fields."""
        result = {}
        for csv_col, app_field in mappings.items():
            for key in row:
                if key.lower().replace(' ', '_') == csv_col.lower().replace(' ', '_'):
                    if row[key]:
                        result[app_field] = row[key]
                    break
        return result
    
    def _parse_date(self, date_str: str) -> Optional[datetime]:
        """Parse various date formats."""
        if not date_str:
            return None
        
        formats = [
            '%Y-%m-%d',
            '%m/%d/%Y',
            '%d/%m/%Y',
            '%Y/%m/%d',
            '%B %d, %Y',
            '%b %d, %Y',
            '%d %B %Y',
            '%d %b %Y',
        ]
        
        for fmt in formats:
            try:
                return datetime.strptime(date_str.strip(), fmt).date()
            except ValueError:
                continue
        
        return None


# ============================================================================
# EXPORT FUNCTIONALITY
# ============================================================================

class ExportSerializer(serializers.Serializer):
    """Serializer for export settings."""
    format = serializers.ChoiceField(
        choices=['csv', 'json', 'excel'],
        default='csv'
    )
    include_archived = serializers.BooleanField(default=False)
    status = serializers.MultipleChoiceField(
        choices=JobApplication.Status.choices,
        required=False
    )
    date_from = serializers.DateField(required=False)
    date_to = serializers.DateField(required=False)


class ApplicationExportView(APIView):
    """Export applications to various formats."""
    
    def get(self, request):
        format_type = request.query_params.get('format', 'csv')
        include_archived = request.query_params.get('include_archived', 'false').lower() == 'true'
        
        # Build queryset
        queryset = JobApplication.objects.filter(user=request.user)
        
        if not include_archived:
            queryset = queryset.filter(is_archived=False)
        
        # Status filter
        statuses = request.query_params.getlist('status')
        if statuses:
            queryset = queryset.filter(status__in=statuses)
        
        # Date filters
        date_from = request.query_params.get('date_from')
        date_to = request.query_params.get('date_to')
        
        if date_from:
            queryset = queryset.filter(created_at__date__gte=date_from)
        if date_to:
            queryset = queryset.filter(created_at__date__lte=date_to)
        
        queryset = queryset.order_by('-created_at')
        
        if format_type == 'json':
            return self._export_json(queryset)
        else:
            return self._export_csv(queryset)
    
    def _export_csv(self, queryset: QuerySet) -> Response:
        """Export to CSV format."""
        from django.http import HttpResponse
        
        response = HttpResponse(content_type='text/csv')
        response['Content-Disposition'] = f'attachment; filename="applications_{datetime.now().strftime("%Y%m%d")}.csv"'
        
        writer = csv.writer(response)
        writer.writerow([
            'Company', 'Job Title', 'Status', 'Location', 'Job Type',
            'Work Location', 'Salary Min', 'Salary Max', 'Currency',
            'Applied Date', 'Deadline', 'Job Link', 'Source', 'Notes',
            'Is Favorite', 'Created At', 'Updated At', 'Tags'
        ])
        
        for app in queryset.prefetch_related('tags'):
            tags = ', '.join([tag.name for tag in app.tags.all()])
            writer.writerow([
                app.company_name,
                app.job_title,
                app.get_status_display(),
                app.location,
                app.get_job_type_display() if app.job_type else '',
                app.get_work_location_display() if app.work_location else '',
                app.salary_min,
                app.salary_max,
                app.salary_currency,
                app.applied_date,
                app.deadline,
                app.job_link,
                app.source,
                app.notes,
                app.is_favorite,
                app.created_at.strftime('%Y-%m-%d %H:%M:%S'),
                app.updated_at.strftime('%Y-%m-%d %H:%M:%S'),
                tags
            ])
        
        return response
    
    def _export_json(self, queryset: QuerySet) -> Response:
        """Export to JSON format."""
        from django.http import JsonResponse
        
        applications = []
        for app in queryset.prefetch_related('tags'):
            applications.append({
                'id': str(app.id),
                'company_name': app.company_name,
                'job_title': app.job_title,
                'status': app.status,
                'status_display': app.get_status_display(),
                'location': app.location,
                'job_type': app.job_type,
                'work_location': app.work_location,
                'salary_min': float(app.salary_min) if app.salary_min else None,
                'salary_max': float(app.salary_max) if app.salary_max else None,
                'salary_currency': app.salary_currency,
                'applied_date': str(app.applied_date) if app.applied_date else None,
                'deadline': str(app.deadline) if app.deadline else None,
                'job_link': app.job_link,
                'job_description': app.job_description,
                'source': app.source,
                'notes': app.notes,
                'is_favorite': app.is_favorite,
                'is_archived': app.is_archived,
                'contact_name': app.contact_name,
                'contact_email': app.contact_email,
                'contact_phone': app.contact_phone,
                'company_website': app.company_website,
                'company_size': app.company_size,
                'company_industry': app.company_industry,
                'created_at': app.created_at.isoformat(),
                'updated_at': app.updated_at.isoformat(),
                'tags': [{'id': str(t.id), 'name': t.name, 'color': t.color} for t in app.tags.all()]
            })
        
        response = JsonResponse({
            'export_date': datetime.now().isoformat(),
            'count': len(applications),
            'applications': applications
        })
        response['Content-Disposition'] = f'attachment; filename="applications_{datetime.now().strftime("%Y%m%d")}.json"'
        return response
