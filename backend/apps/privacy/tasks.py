"""Celery tasks for privacy app."""
from celery import shared_task
import logging

logger = logging.getLogger(__name__)


@shared_task
def process_data_export(export_id):
    """Process a data export request."""
    from .models import DataExportRequest
    from .services import DataExportService
    
    try:
        export = DataExportRequest.objects.get(id=export_id)
        service = DataExportService()
        service.process_export(export)
    except DataExportRequest.DoesNotExist:
        logger.error(f"Export {export_id} not found")
    except Exception as e:
        logger.error(f"Export failed: {e}")


@shared_task
def cleanup_expired_exports():
    """Clean up expired data exports."""
    from django.utils import timezone
    from .models import DataExportRequest
    import os
    
    expired = DataExportRequest.objects.filter(
        expires_at__lt=timezone.now(),
        status=DataExportRequest.ExportStatus.COMPLETED
    )
    
    for export in expired:
        # Delete file
        if export.file_path and os.path.exists(export.file_path):
            try:
                os.remove(export.file_path)
            except Exception as e:
                logger.error(f"Failed to delete export file: {e}")
        
        export.status = DataExportRequest.ExportStatus.EXPIRED
        export.save()


@shared_task
def process_gdpr_deletion_request(request_id):
    """Process a GDPR deletion request."""
    from .models import GDPRRequest
    from .services import AccountDeletionService
    
    try:
        request = GDPRRequest.objects.get(id=request_id)
        
        if request.request_type != GDPRRequest.RequestType.DATA_DELETION:
            return
        
        if request.status != GDPRRequest.RequestStatus.IN_PROGRESS:
            return
        
        if request.user:
            AccountDeletionService.delete_user_data(request.user)
        
        request.status = GDPRRequest.RequestStatus.COMPLETED
        request.completed_at = timezone.now()
        request.save()
        
    except GDPRRequest.DoesNotExist:
        logger.error(f"GDPR request {request_id} not found")
    except Exception as e:
        logger.error(f"GDPR deletion failed: {e}")


@shared_task
def auto_delete_old_rejected_applications():
    """Auto-delete rejected applications based on user preferences."""
    from .models import PrivacySetting
    from apps.applications.models import JobApplication
    from django.utils import timezone
    from datetime import timedelta
    
    settings_with_auto_delete = PrivacySetting.objects.filter(
        auto_delete_rejected_after_days__isnull=False
    )
    
    for setting in settings_with_auto_delete:
        cutoff_date = timezone.now() - timedelta(days=setting.auto_delete_rejected_after_days)
        
        deleted_count = JobApplication.objects.filter(
            user=setting.user,
            status='rejected',
            updated_at__lt=cutoff_date
        ).delete()[0]
        
        if deleted_count > 0:
            logger.info(f"Auto-deleted {deleted_count} rejected applications for user {setting.user_id}")
