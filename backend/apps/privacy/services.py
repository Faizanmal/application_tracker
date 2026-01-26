"""Privacy and security services."""
import json
import csv
import io
import logging
from datetime import timedelta
from django.utils import timezone
from django.conf import settings

logger = logging.getLogger(__name__)


class DataExportService:
    """Service for exporting user data."""
    
    def process_export(self, export):
        """Process a data export request."""
        from .models import DataExportRequest
        
        try:
            export.status = DataExportRequest.ExportStatus.PROCESSING
            export.save()
            
            user = export.user
            data = {}
            
            # Collect data based on options
            if export.include_applications:
                data['applications'] = self._export_applications(user)
            
            if export.include_interviews:
                data['interviews'] = self._export_interviews(user)
            
            if export.include_contacts:
                data['contacts'] = self._export_contacts(user)
            
            if export.include_notes:
                data['notes'] = self._export_notes(user)
            
            if export.include_analytics:
                data['analytics'] = self._export_analytics(user)
            
            # Add user profile
            data['profile'] = self._export_profile(user)
            
            # Format data
            if export.format == DataExportRequest.ExportFormat.JSON:
                content = self._to_json(data)
                filename = f"data_export_{user.id}.json"
            elif export.format == DataExportRequest.ExportFormat.CSV:
                content = self._to_csv(data)
                filename = f"data_export_{user.id}.zip"
            else:
                content = self._to_json(data)
                filename = f"data_export_{user.id}.json"
            
            # Save file (in production, use cloud storage)
            file_path = self._save_file(content, filename)
            
            export.status = DataExportRequest.ExportStatus.COMPLETED
            export.file_path = file_path
            export.file_size = len(content) if isinstance(content, bytes) else len(content.encode())
            export.expires_at = timezone.now() + timedelta(days=7)
            export.completed_at = timezone.now()
            export.save()
            
            return True
            
        except Exception as e:
            logger.error(f"Export failed: {e}")
            export.status = DataExportRequest.ExportStatus.FAILED
            export.error_message = str(e)
            export.save()
            return False
    
    def _export_applications(self, user):
        """Export job applications."""
        from apps.applications.models import JobApplication
        
        applications = JobApplication.objects.filter(user=user)
        return [
            {
                'id': str(app.id),
                'job_title': app.job_title,
                'company_name': app.company_name,
                'status': app.status,
                'applied_at': str(app.applied_at) if app.applied_at else None,
                'job_url': app.job_url,
                'salary_min': str(app.salary_min) if app.salary_min else None,
                'salary_max': str(app.salary_max) if app.salary_max else None,
                'notes': app.notes,
                'created_at': str(app.created_at),
            }
            for app in applications
        ]
    
    def _export_interviews(self, user):
        """Export interviews."""
        from apps.interviews.models import Interview
        
        interviews = Interview.objects.filter(application__user=user)
        return [
            {
                'id': str(interview.id),
                'application_company': interview.application.company_name,
                'interview_type': interview.interview_type,
                'scheduled_at': str(interview.scheduled_at),
                'notes': interview.notes,
            }
            for interview in interviews
        ]
    
    def _export_contacts(self, user):
        """Export networking contacts."""
        try:
            from apps.networking.models import ProfessionalConnection
            
            contacts = ProfessionalConnection.objects.filter(user=user)
            return [
                {
                    'id': str(c.id),
                    'name': c.name,
                    'company': c.company,
                    'title': c.title,
                    'email': c.email,
                    'linkedin_url': c.linkedin_url,
                    'notes': c.notes,
                }
                for c in contacts
            ]
        except:
            return []
    
    def _export_notes(self, user):
        """Export notes (non-encrypted)."""
        from .models import EncryptedNote
        
        notes = EncryptedNote.objects.filter(user=user)
        return [
            {
                'id': str(n.id),
                'title': n.title,
                'encrypted_content': n.encrypted_content,  # User must decrypt
                'category': n.category,
                'tags': n.tags,
                'created_at': str(n.created_at),
            }
            for n in notes
        ]
    
    def _export_analytics(self, user):
        """Export analytics data."""
        from apps.applications.models import JobApplication
        
        apps = JobApplication.objects.filter(user=user)
        return {
            'total_applications': apps.count(),
            'by_status': dict(apps.values_list('status').annotate(count=models.Count('id'))),
        }
    
    def _export_profile(self, user):
        """Export user profile."""
        return {
            'email': user.email,
            'first_name': user.first_name,
            'last_name': user.last_name,
            'date_joined': str(user.date_joined),
        }
    
    def _to_json(self, data):
        """Convert to JSON."""
        return json.dumps(data, indent=2, default=str)
    
    def _to_csv(self, data):
        """Convert to CSV (returns bytes for zip)."""
        # For simplicity, return JSON for now
        # In production, create separate CSVs per entity
        return json.dumps(data, indent=2, default=str)
    
    def _save_file(self, content, filename):
        """Save export file."""
        # In production, use S3/GCS
        import os
        export_dir = os.path.join(settings.MEDIA_ROOT, 'exports')
        os.makedirs(export_dir, exist_ok=True)
        
        file_path = os.path.join(export_dir, filename)
        
        if isinstance(content, str):
            with open(file_path, 'w') as f:
                f.write(content)
        else:
            with open(file_path, 'wb') as f:
                f.write(content)
        
        return file_path
    
    def get_download_url(self, export):
        """Get download URL for export."""
        # In production, generate signed URL for cloud storage
        return f"/api/v1/privacy/exports/{export.id}/file/"


class SecurityService:
    """Service for security-related operations."""
    
    @staticmethod
    def log_event(user, event_type, description, request=None, details=None, severity='info'):
        """Log a security event."""
        from .models import SecurityAuditLog
        
        ip_address = None
        user_agent = ''
        
        if request:
            ip_address = SecurityService.get_client_ip(request)
            user_agent = request.META.get('HTTP_USER_AGENT', '')
        
        SecurityAuditLog.objects.create(
            user=user,
            user_email=user.email if user else '',
            event_type=event_type,
            description=description,
            details=details or {},
            ip_address=ip_address,
            user_agent=user_agent,
            severity=severity
        )
    
    @staticmethod
    def get_client_ip(request):
        """Get client IP from request."""
        x_forwarded_for = request.META.get('HTTP_X_FORWARDED_FOR')
        if x_forwarded_for:
            return x_forwarded_for.split(',')[0].strip()
        return request.META.get('REMOTE_ADDR')
    
    @staticmethod
    def log_login_attempt(email, successful, request, failure_reason=''):
        """Log a login attempt."""
        from .models import LoginAttempt
        from django.contrib.auth import get_user_model
        
        User = get_user_model()
        
        ip_address = SecurityService.get_client_ip(request)
        user_agent = request.META.get('HTTP_USER_AGENT', '')
        
        # Get user if exists
        user = None
        try:
            user = User.objects.get(email=email)
        except User.DoesNotExist:
            pass
        
        # Check for suspicious activity
        is_suspicious = False
        suspicious_reason = ''
        
        # Check for too many failed attempts
        recent_failures = LoginAttempt.objects.filter(
            ip_address=ip_address,
            successful=False,
            created_at__gte=timezone.now() - timedelta(hours=1)
        ).count()
        
        if recent_failures >= 5:
            is_suspicious = True
            suspicious_reason = 'Multiple failed login attempts'
        
        LoginAttempt.objects.create(
            email=email,
            user=user,
            ip_address=ip_address,
            user_agent=user_agent,
            successful=successful,
            failure_reason=failure_reason,
            is_suspicious=is_suspicious,
            suspicious_reason=suspicious_reason
        )
        
        return not is_suspicious  # Return False if blocked


class AccountDeletionService:
    """Service for handling account deletion."""
    
    @staticmethod
    def delete_user_data(user):
        """Delete all user data (GDPR right to be forgotten)."""
        from apps.applications.models import JobApplication
        from apps.interviews.models import Interview
        from apps.reminders.models import Reminder
        
        # Delete applications and related data
        JobApplication.objects.filter(user=user).delete()
        
        # Delete reminders
        Reminder.objects.filter(user=user).delete()
        
        # Delete networking data
        try:
            from apps.networking.models import ProfessionalConnection, Referral
            ProfessionalConnection.objects.filter(user=user).delete()
            Referral.objects.filter(user=user).delete()
        except:
            pass
        
        # Delete career data
        try:
            from apps.career.models import UserSkill, CareerGoal, PortfolioProject
            UserSkill.objects.filter(user=user).delete()
            CareerGoal.objects.filter(user=user).delete()
            PortfolioProject.objects.filter(user=user).delete()
        except:
            pass
        
        # Delete gamification data
        try:
            from apps.gamification.models import UserAchievement, UserPoints, UserStreak
            UserAchievement.objects.filter(user=user).delete()
            UserPoints.objects.filter(user=user).delete()
            UserStreak.objects.filter(user=user).delete()
        except:
            pass
        
        # Anonymize user
        user.email = f"deleted_{user.id}@deleted.local"
        user.first_name = "Deleted"
        user.last_name = "User"
        user.is_active = False
        user.save()
        
        return True


# Import models for type hints
from django.db import models
