from rest_framework import serializers
from .models import DailyStats, WeeklyDigest


class DailyStatsSerializer(serializers.ModelSerializer):
    """Serializer for daily stats."""
    
    class Meta:
        model = DailyStats
        fields = [
            'date', 'applications_added', 'applications_updated',
            'interviews_scheduled', 'interviews_completed',
            'rejections_received', 'offers_received', 'follow_ups_sent'
        ]


class WeeklyDigestSerializer(serializers.ModelSerializer):
    """Serializer for weekly digest."""
    
    class Meta:
        model = WeeklyDigest
        fields = [
            'week_start', 'week_end', 'total_applications',
            'new_applications', 'interviews_scheduled', 'interviews_completed',
            'rejections', 'offers', 'response_rate', 'interview_rate'
        ]


class DashboardStatsSerializer(serializers.Serializer):
    """Serializer for dashboard statistics."""
    
    total_applications = serializers.IntegerField()
    active_applications = serializers.IntegerField()
    interviews_scheduled = serializers.IntegerField()
    offers_received = serializers.IntegerField()
    response_rate = serializers.DecimalField(max_digits=5, decimal_places=2)
    interview_rate = serializers.DecimalField(max_digits=5, decimal_places=2)
    
    applications_by_status = serializers.DictField()
    applications_this_week = serializers.IntegerField()
    interviews_this_week = serializers.IntegerField()
    
    recent_activity = serializers.ListField()
    weekly_activity = serializers.ListField()


class ApplicationInsightsSerializer(serializers.Serializer):
    """Serializer for application insights."""
    
    best_performing_resume = serializers.DictField(allow_null=True)
    ghosting_rate = serializers.DecimalField(max_digits=5, decimal_places=2)
    average_response_days = serializers.DecimalField(max_digits=5, decimal_places=2, allow_null=True)
    most_active_sources = serializers.ListField()
    status_distribution = serializers.DictField()
    monthly_trend = serializers.ListField()
