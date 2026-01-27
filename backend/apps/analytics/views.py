from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import generics
from django.utils import timezone
from django.db.models import Count, Q, Avg, Min, Max, F
from django.db.models.functions import TruncWeek, TruncMonth
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


class ActivityHeatmapView(APIView):
    """Get activity heatmap data for calendar visualization."""
    
    def get(self, request):
        user = request.user
        year = int(request.query_params.get('year', timezone.now().year))
        
        # Get daily activity for the year
        start_date = timezone.datetime(year, 1, 1).date()
        end_date = timezone.datetime(year, 12, 31).date()
        
        # Applications created by day
        daily_applications = JobApplication.objects.filter(
            user=user,
            created_at__date__gte=start_date,
            created_at__date__lte=end_date
        ).extra(
            select={'day': 'DATE(created_at)'}
        ).values('day').annotate(
            count=Count('id')
        ).order_by('day')
        
        # Interviews by day
        daily_interviews = Interview.objects.filter(
            application__user=user,
            scheduled_at__date__gte=start_date,
            scheduled_at__date__lte=end_date
        ).extra(
            select={'day': 'DATE(scheduled_at)'}
        ).values('day').annotate(
            count=Count('id')
        ).order_by('day')
        
        # Status changes by day
        daily_status_changes = ApplicationTimeline.objects.filter(
            application__user=user,
            event_type='status_change',
            created_at__date__gte=start_date,
            created_at__date__lte=end_date
        ).extra(
            select={'day': 'DATE(created_at)'}
        ).values('day').annotate(
            count=Count('id')
        ).order_by('day')
        
        # Combine data
        heatmap_data = {}
        for item in daily_applications:
            day = item['day'].isoformat()
            heatmap_data[day] = {
                'applications': item['count'],
                'interviews': 0,
                'status_changes': 0
            }
        
        for item in daily_interviews:
            day = item['day'].isoformat()
            if day not in heatmap_data:
                heatmap_data[day] = {'applications': 0, 'interviews': 0, 'status_changes': 0}
            heatmap_data[day]['interviews'] = item['count']
        
        for item in daily_status_changes:
            day = item['day'].isoformat()
            if day not in heatmap_data:
                heatmap_data[day] = {'applications': 0, 'interviews': 0, 'status_changes': 0}
            heatmap_data[day]['status_changes'] = item['count']
        
        return Response({
            'year': year,
            'data': heatmap_data
        })


class ActionableInsightsView(APIView):
    """Get actionable insights based on application data."""
    
    def get(self, request):
        user = request.user
        insights = []
        
        # Insight 1: Best performing company sizes
        size_stats = JobApplication.objects.filter(
            user=user,
            company_size__isnull=False,
            company_size__gt=''
        ).exclude(status__in=['wishlist', 'applied']).values('company_size').annotate(
            total=Count('id'),
            successful=Count('id', filter=Q(status__in=['interviewing', 'offer', 'accepted']))
        ).order_by('-successful')
        
        if size_stats:
            best_size = size_stats[0]
            if best_size['total'] >= 3:  # Minimum sample size
                success_rate = (best_size['successful'] / best_size['total']) * 100
                if success_rate > 20:  # Above average
                    insights.append({
                        'type': 'company_size',
                        'title': f'Focus on {best_size["company_size"]} companies',
                        'description': f'You have a {success_rate:.1f}% success rate with {best_size["company_size"]} companies. Consider applying to more companies of this size.',
                        'metric': f'{success_rate:.1f}% success rate',
                        'action': f'Apply to more {best_size["company_size"]} companies'
                    })
        
        # Insight 2: Best performing sources
        source_stats = JobApplication.objects.filter(
            user=user,
            source__isnull=False,
            source__gt=''
        ).exclude(status__in=['wishlist', 'applied']).values('source').annotate(
            total=Count('id'),
            successful=Count('id', filter=Q(status__in=['interviewing', 'offer', 'accepted']))
        ).order_by('-successful')
        
        if source_stats:
            best_source = source_stats[0]
            if best_source['total'] >= 5:
                success_rate = (best_source['successful'] / best_source['total']) * 100
                if success_rate > 15:
                    insights.append({
                        'type': 'source',
                        'title': f'Use {best_source["source"]} more often',
                        'description': f'Applications from {best_source["source"]} have a {success_rate:.1f}% success rate.',
                        'metric': f'{success_rate:.1f}% success rate',
                        'action': f'Focus more applications on {best_source["source"]}'
                    })
        
        # Insight 3: Response time analysis
        responded_apps = JobApplication.objects.filter(
            user=user,
            applied_date__isnull=False,
            response_date__isnull=False
        )
        
        if responded_apps.exists():
            response_times = []
            for app in responded_apps:
                days = (app.response_date - app.applied_date).days
                response_times.append(days)
            
            avg_response = sum(response_times) / len(response_times)
            if avg_response > 14:  # Slow response
                insights.append({
                    'type': 'response_time',
                    'title': 'Companies are responding slowly',
                    'description': f'Average response time is {avg_response:.1f} days. Consider following up after 2 weeks.',
                    'metric': f'{avg_response:.1f} days average',
                    'action': 'Set reminders to follow up after 2 weeks'
                })
        
        # Insight 4: Application volume
        thirty_days_ago = timezone.now() - timedelta(days=30)
        recent_apps = JobApplication.objects.filter(
            user=user,
            created_at__gte=thirty_days_ago
        ).count()
        
        if recent_apps < 5:
            insights.append({
                'type': 'volume',
                'title': 'Increase application volume',
                'description': 'You\'ve applied to fewer than 5 positions in the last 30 days. Increasing your application volume may improve your chances.',
                'metric': f'{recent_apps} applications this month',
                'action': 'Aim for 5-10 applications per week'
            })
        
        # Insight 5: Interview conversion
        total_applied = JobApplication.objects.filter(
            user=user,
            status__in=['screening', 'interviewing', 'offer', 'accepted', 'rejected', 'ghosted']
        ).count()
        
        total_interviews = Interview.objects.filter(application__user=user).count()
        
        if total_applied > 0:
            interview_rate = (total_interviews / total_applied) * 100
            if interview_rate < 10:  # Below average
                insights.append({
                    'type': 'interview_rate',
                    'title': 'Improve interview conversion',
                    'description': f'Only {interview_rate:.1f}% of your applications lead to interviews. Focus on quality applications.',
                    'metric': f'{interview_rate:.1f}% interview rate',
                    'action': 'Review and improve your application materials'
                })
        
        return Response({
            'insights': insights
        })


class TrendAnalysisView(APIView):
    """Detailed trend analysis for success rates over time."""
    
    def get(self, request):
        user = request.user
        period = request.query_params.get('period', 'monthly')  # monthly, weekly, quarterly
        
        if period == 'monthly':
            date_trunc = TruncMonth('created_at')
            periods = 12
        elif period == 'weekly':
            date_trunc = TruncWeek('created_at')
            periods = 52
        else:  # quarterly
            # Custom quarterly truncation
            periods = 8
        
        six_months_ago = timezone.now() - timedelta(days=180)
        
        # Success rates over time
        trend_data = JobApplication.objects.filter(
            user=user,
            created_at__gte=six_months_ago
        ).annotate(
            period=date_trunc
        ).values('period').annotate(
            total_applications=Count('id'),
            interviews=Count('id', filter=Q(status__in=['interviewing', 'offer', 'accepted'])),
            offers=Count('id', filter=Q(status__in=['offer', 'accepted'])),
            accepted=Count('id', filter=Q(status='accepted'))
        ).order_by('period')
        
        trends = []
        for item in trend_data:
            total = item['total_applications']
            if total > 0:
                interview_rate = (item['interviews'] / total) * 100
                offer_rate = (item['offers'] / total) * 100
                acceptance_rate = (item['accepted'] / total) * 100
                
                trends.append({
                    'period': item['period'].isoformat() if item['period'] else None,
                    'total_applications': total,
                    'interview_rate': round(interview_rate, 2),
                    'offer_rate': round(offer_rate, 2),
                    'acceptance_rate': round(acceptance_rate, 2)
                })
        
        # Moving averages
        if len(trends) >= 3:
            for i in range(2, len(trends)):
                avg_interview = (trends[i-2]['interview_rate'] + trends[i-1]['interview_rate'] + trends[i]['interview_rate']) / 3
                trends[i]['moving_avg_interview'] = round(avg_interview, 2)
        
        return Response({
            'period': period,
            'trends': trends
        })


class GeographicHeatmapView(APIView):
    """Get geographic data for heatmaps."""
    
    def get(self, request):
        user = request.user
        
        # Applications by location/country
        location_data = JobApplication.objects.filter(
            user=user,
            location__isnull=False,
            location__gt=''
        ).values('location').annotate(
            count=Count('id'),
            interviews=Count('id', filter=Q(status__in=['interviewing', 'offer', 'accepted'])),
            offers=Count('id', filter=Q(status__in=['offer', 'accepted']))
        ).order_by('-count')[:50]  # Top 50 locations
        
        # Try to extract country/state info
        geographic_data = []
        for item in location_data:
            location = item['location']
            # Simple parsing - could be enhanced with geocoding
            parts = location.split(',')
            country = parts[-1].strip() if len(parts) > 1 else location
            state = parts[0].strip() if len(parts) > 1 else ''
            
            geographic_data.append({
                'location': location,
                'country': country,
                'state': state,
                'applications': item['count'],
                'interviews': item['interviews'],
                'offers': item['offers'],
                'success_rate': round(item['interviews'] / item['count'] * 100, 2) if item['count'] > 0 else 0
            })
        
        return Response({
            'geographic_data': geographic_data
        })


class SalaryAnalysisView(APIView):
    """Get salary tracking and comparison data."""
    
    def get(self, request):
        user = request.user
        
        # Salary ranges by role/industry
        salary_data = JobApplication.objects.filter(
            user=user,
            salary_min__isnull=False,
            salary_max__isnull=False
        ).values('job_title', 'company_industry').annotate(
            avg_min=Avg('salary_min'),
            avg_max=Avg('salary_max'),
            count=Count('id'),
            offers=Count('id', filter=Q(status__in=['offer', 'accepted']))
        ).order_by('-count')
        
        salary_analysis = []
        for item in salary_data:
            avg_min = item['avg_min'] or 0
            avg_max = item['avg_max'] or 0
            avg_salary = (avg_min + avg_max) / 2
            
            salary_analysis.append({
                'job_title': item['job_title'],
                'industry': item['company_industry'] or 'Unknown',
                'avg_min_salary': round(avg_min, 2),
                'avg_max_salary': round(avg_max, 2),
                'avg_salary': round(avg_salary, 2),
                'sample_size': item['count'],
                'offers_count': item['offers'],
                'currency': 'USD'  # Assuming USD, could be enhanced
            })
        
        # Salary progression over time
        salary_progression = JobApplication.objects.filter(
            user=user,
            applied_date__isnull=False,
            salary_min__isnull=False
        ).order_by('applied_date').values_list(
            'applied_date', 'salary_min', 'salary_max', 'job_title'
        )
        
        progression_data = []
        for applied_date, min_salary, max_salary, job_title in salary_progression:
            avg_salary = (min_salary + max_salary) / 2 if max_salary else min_salary
            progression_data.append({
                'date': applied_date.isoformat(),
                'salary': round(avg_salary, 2),
                'job_title': job_title
            })
        
        # Industry salary comparison
        industry_comparison = JobApplication.objects.filter(
            user=user,
            company_industry__isnull=False,
            salary_min__isnull=False
        ).values('company_industry').annotate(
            avg_salary=Avg((F('salary_min') + F('salary_max')) / 2),
            min_salary=Min('salary_min'),
            max_salary=Max('salary_max'),
            count=Count('id')
        ).filter(count__gte=2).order_by('-avg_salary')
        
        industry_data = [{
            'industry': item['company_industry'],
            'avg_salary': round(item['avg_salary'] or 0, 2),
            'min_salary': round(item['min_salary'] or 0, 2),
            'max_salary': round(item['max_salary'] or 0, 2),
            'sample_size': item['count']
        } for item in industry_comparison]
        
        return Response({
            'salary_analysis': salary_analysis,
            'salary_progression': progression_data,
            'industry_comparison': industry_data
        })


class InteractiveChartView(APIView):
    """Get data for interactive charts with drill-down capabilities."""
    
    def get(self, request):
        user = request.user
        chart_type = request.query_params.get('type', 'status_funnel')
        drill_down = request.query_params.get('drill_down')
        
        if chart_type == 'status_funnel':
            return self._get_status_funnel(user, drill_down)
        elif chart_type == 'timeline':
            return self._get_timeline_chart(user, drill_down)
        elif chart_type == 'source_effectiveness':
            return self._get_source_effectiveness(user, drill_down)
        else:
            return Response({'error': 'Invalid chart type'}, status=400)
    
    def _get_status_funnel(self, user, drill_down):
        """Status funnel with drill-down by time period or source."""
        base_query = JobApplication.objects.filter(user=user)
        
        if drill_down == 'this_month':
            from django.utils import timezone
            from datetime import timedelta
            last_month = timezone.now() - timedelta(days=30)
            base_query = base_query.filter(created_at__gte=last_month)
        elif drill_down == 'last_3_months':
            from django.utils import timezone
            from datetime import timedelta
            three_months_ago = timezone.now() - timedelta(days=90)
            base_query = base_query.filter(created_at__gte=three_months_ago)
        
        funnel_data = []
        statuses = [
            ('wishlist', 'Wishlist'),
            ('applied', 'Applied'),
            ('screening', 'Screening'),
            ('interviewing', 'Interviewing'),
            ('offer', 'Offer'),
            ('accepted', 'Accepted'),
        ]
        
        for status_key, status_label in statuses:
            count = base_query.filter(status=status_key).count()
            funnel_data.append({
                'status': status_key,
                'label': status_label,
                'count': count,
                'percentage': 0  # Will calculate after
            })
        
        # Calculate percentages
        total = funnel_data[0]['count'] if funnel_data else 0
        for item in funnel_data:
            item['percentage'] = round((item['count'] / total * 100), 2) if total > 0 else 0
        
        return Response({
            'chart_type': 'funnel',
            'data': funnel_data,
            'drill_down_options': ['all_time', 'this_month', 'last_3_months']
        })
    
    def _get_timeline_chart(self, user, drill_down):
        """Timeline chart with drill-down by status."""
        period = drill_down or 'monthly'
        
        if period == 'weekly':
            date_trunc = TruncWeek('created_at')
            periods_count = 12
        else:
            date_trunc = TruncMonth('created_at')
            periods_count = 6
        
        timeline_data = JobApplication.objects.filter(
            user=user
        ).annotate(
            period=date_trunc
        ).values('period', 'status').annotate(
            count=Count('id')
        ).order_by('period', 'status')
        
        # Group by period
        periods = {}
        for item in timeline_data:
            period_key = item['period'].isoformat() if item['period'] else 'unknown'
            if period_key not in periods:
                periods[period_key] = {'period': period_key, 'statuses': {}}
            periods[period_key]['statuses'][item['status']] = item['count']
        
        return Response({
            'chart_type': 'timeline',
            'data': list(periods.values()),
            'drill_down_options': ['weekly', 'monthly']
        })
    
    def _get_source_effectiveness(self, user, drill_down):
        """Source effectiveness with drill-down by time."""
        base_query = JobApplication.objects.filter(
            user=user,
            source__isnull=False,
            source__gt=''
        )
        
        if drill_down == 'recent':
            from django.utils import timezone
            from datetime import timedelta
            six_months_ago = timezone.now() - timedelta(days=180)
            base_query = base_query.filter(created_at__gte=six_months_ago)
        
        source_data = base_query.values('source').annotate(
            total=Count('id'),
            interviews=Count('id', filter=Q(status__in=['interviewing', 'offer', 'accepted'])),
            offers=Count('id', filter=Q(status__in=['offer', 'accepted']))
        ).order_by('-total')
        
        effectiveness_data = []
        for item in source_data:
            total = item['total']
            if total >= 3:  # Minimum sample size
                interview_rate = round(item['interviews'] / total * 100, 2)
                offer_rate = round(item['offers'] / total * 100, 2)
                
                effectiveness_data.append({
                    'source': item['source'],
                    'total_applications': total,
                    'interview_rate': interview_rate,
                    'offer_rate': offer_rate
                })
        
        return Response({
            'chart_type': 'source_effectiveness',
            'data': effectiveness_data,
            'drill_down_options': ['all_time', 'recent']
        })
