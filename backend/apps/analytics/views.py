from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import generics
from django.utils import timezone
from django.db.models import Count, Q, Avg, F
from django.db.models.functions import TruncDate, TruncWeek, TruncMonth
from datetime import timedelta
from decimal import Decimal

from apps.applications.models import JobApplication, ApplicationTimeline
from apps.interviews.models import Interview
from .models import DailyStats, WeeklyDigest
from .serializers import DailyStatsSerializer, WeeklyDigestSerializer


class DashboardStatsView(APIView):
    """Get dashboard statistics."""
    
    def get(self, request):
        user = request.user
        now = timezone.now()
        week_ago = now - timedelta(days=7)
        
        # Total counts
        total_applications = JobApplication.objects.filter(user=user).count()
        active_applications = JobApplication.objects.filter(
            user=user,
            is_archived=False,
            status__in=['applied', 'screening', 'interviewing']
        ).count()
        
        # Interview counts
        interviews_scheduled = Interview.objects.filter(
            application__user=user,
            status=Interview.Status.SCHEDULED,
            scheduled_at__gte=now
        ).count()
        
        # Offers
        offers_received = JobApplication.objects.filter(
            user=user,
            status__in=['offer', 'accepted']
        ).count()
        
        # Calculate rates
        applications_with_response = JobApplication.objects.filter(
            user=user,
            status__in=['screening', 'interviewing', 'offer', 'accepted', 'rejected']
        ).count()
        
        applications_with_interview = JobApplication.objects.filter(
            user=user,
            status__in=['interviewing', 'offer', 'accepted']
        ).count()
        
        response_rate = Decimal('0.00')
        interview_rate = Decimal('0.00')
        
        if total_applications > 0:
            response_rate = Decimal(applications_with_response / total_applications * 100).quantize(Decimal('0.01'))
            interview_rate = Decimal(applications_with_interview / total_applications * 100).quantize(Decimal('0.01'))
        
        # Applications by status
        status_counts = JobApplication.objects.filter(
            user=user,
            is_archived=False
        ).values('status').annotate(count=Count('id'))
        
        applications_by_status = {item['status']: item['count'] for item in status_counts}
        
        # This week stats
        applications_this_week = JobApplication.objects.filter(
            user=user,
            created_at__gte=week_ago
        ).count()
        
        interviews_this_week = Interview.objects.filter(
            application__user=user,
            scheduled_at__gte=week_ago,
            scheduled_at__lte=now + timedelta(days=7)
        ).count()
        
        # Recent activity
        recent_activity = ApplicationTimeline.objects.filter(
            application__user=user
        ).select_related('application').order_by('-created_at')[:10]
        
        activity_list = [{
            'id': str(item.id),
            'title': item.title,
            'event_type': item.event_type,
            'application': {
                'id': str(item.application.id),
                'company_name': item.application.company_name,
                'job_title': item.application.job_title
            },
            'created_at': item.created_at
        } for item in recent_activity]
        
        # Weekly activity chart (last 12 weeks)
        twelve_weeks_ago = now - timedelta(weeks=12)
        weekly_data = JobApplication.objects.filter(
            user=user,
            created_at__gte=twelve_weeks_ago
        ).annotate(
            week=TruncWeek('created_at')
        ).values('week').annotate(
            count=Count('id')
        ).order_by('week')
        
        weekly_activity = [{
            'week': item['week'].isoformat() if item['week'] else None,
            'count': item['count']
        } for item in weekly_data]
        
        return Response({
            'total_applications': total_applications,
            'active_applications': active_applications,
            'interviews_scheduled': interviews_scheduled,
            'offers_received': offers_received,
            'response_rate': response_rate,
            'interview_rate': interview_rate,
            'applications_by_status': applications_by_status,
            'applications_this_week': applications_this_week,
            'interviews_this_week': interviews_this_week,
            'recent_activity': activity_list,
            'weekly_activity': weekly_activity
        })


class ApplicationInsightsView(APIView):
    """Get detailed application insights."""
    
    def get(self, request):
        user = request.user
        
        # Best performing resume
        resume_stats = JobApplication.objects.filter(
            user=user,
            resume__isnull=False
        ).values('resume__id', 'resume__name').annotate(
            total=Count('id'),
            interviews=Count('id', filter=Q(status__in=['interviewing', 'offer', 'accepted']))
        ).order_by('-interviews')
        
        best_resume = None
        if resume_stats:
            top = resume_stats[0]
            if top['total'] > 0:
                best_resume = {
                    'id': str(top['resume__id']),
                    'name': top['resume__name'],
                    'total_applications': top['total'],
                    'interviews': top['interviews'],
                    'success_rate': round(top['interviews'] / top['total'] * 100, 2)
                }
        
        # Ghosting rate
        total = JobApplication.objects.filter(user=user).count()
        ghosted = JobApplication.objects.filter(user=user, status='ghosted').count()
        ghosting_rate = Decimal('0.00')
        if total > 0:
            ghosting_rate = Decimal(ghosted / total * 100).quantize(Decimal('0.01'))
        
        # Average response time
        # This would require tracking response dates properly
        average_response_days = None
        
        # Most active sources
        source_stats = JobApplication.objects.filter(
            user=user,
            source__isnull=False
        ).exclude(source='').values('source').annotate(
            count=Count('id')
        ).order_by('-count')[:5]
        
        most_active_sources = [{
            'source': item['source'],
            'count': item['count']
        } for item in source_stats]
        
        # Status distribution
        status_dist = JobApplication.objects.filter(
            user=user
        ).values('status').annotate(count=Count('id'))
        
        status_distribution = {item['status']: item['count'] for item in status_dist}
        
        # Monthly trend (last 6 months)
        six_months_ago = timezone.now() - timedelta(days=180)
        monthly_data = JobApplication.objects.filter(
            user=user,
            created_at__gte=six_months_ago
        ).annotate(
            month=TruncMonth('created_at')
        ).values('month').annotate(
            applications=Count('id'),
            interviews=Count('id', filter=Q(status__in=['interviewing', 'offer', 'accepted'])),
            offers=Count('id', filter=Q(status__in=['offer', 'accepted']))
        ).order_by('month')
        
        monthly_trend = [{
            'month': item['month'].isoformat() if item['month'] else None,
            'applications': item['applications'],
            'interviews': item['interviews'],
            'offers': item['offers']
        } for item in monthly_data]
        
        return Response({
            'best_performing_resume': best_resume,
            'ghosting_rate': ghosting_rate,
            'average_response_days': average_response_days,
            'most_active_sources': most_active_sources,
            'status_distribution': status_distribution,
            'monthly_trend': monthly_trend
        })


class DailyActivityView(generics.ListAPIView):
    """Get daily activity stats."""
    
    serializer_class = DailyStatsSerializer
    
    def get_queryset(self):
        days = int(self.request.query_params.get('days', 30))
        start_date = timezone.now().date() - timedelta(days=days)
        
        return DailyStats.objects.filter(
            user=self.request.user,
            date__gte=start_date
        ).order_by('-date')


class WeeklyDigestListView(generics.ListAPIView):
    """Get weekly digests."""
    
    serializer_class = WeeklyDigestSerializer
    
    def get_queryset(self):
        return WeeklyDigest.objects.filter(
            user=self.request.user
        ).order_by('-week_start')[:12]


class StatusFunnelView(APIView):
    """Get status funnel data for visualization."""
    
    def get(self, request):
        user = request.user
        
        funnel_stages = [
            ('wishlist', 'Wishlist'),
            ('applied', 'Applied'),
            ('screening', 'Screening'),
            ('interviewing', 'Interviewing'),
            ('offer', 'Offer'),
            ('accepted', 'Accepted'),
        ]
        
        funnel_data = []
        for status_key, status_label in funnel_stages:
            count = JobApplication.objects.filter(
                user=user,
                status=status_key
            ).count()
            funnel_data.append({
                'status': status_key,
                'label': status_label,
                'count': count
            })
        
        # Add rejected and ghosted separately
        rejected = JobApplication.objects.filter(user=user, status='rejected').count()
        ghosted = JobApplication.objects.filter(user=user, status='ghosted').count()
        withdrawn = JobApplication.objects.filter(user=user, status='withdrawn').count()
        
        return Response({
            'funnel': funnel_data,
            'rejected': rejected,
            'ghosted': ghosted,
            'withdrawn': withdrawn
        })


class CompanyResponseTimeView(APIView):
    """Get average response times by company (for Pro users)."""
    
    def get(self, request):
        user = request.user
        
        if not user.is_pro:
            return Response({
                'error': 'This feature requires a Pro subscription'
            }, status=403)
        
        # This would require more detailed tracking
        # Placeholder response
        return Response({
            'average_days': [],
            'fastest_responders': [],
            'slowest_responders': []
        })
