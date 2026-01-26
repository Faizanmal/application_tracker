from rest_framework import serializers
from .models import (
    ProfessionalConnection,
    Referral,
    NetworkingEvent,
    MentorshipRelationship,
    MentorshipSession,
)


class ProfessionalConnectionSerializer(serializers.ModelSerializer):
    """Serializer for ProfessionalConnection model."""
    
    class Meta:
        model = ProfessionalConnection
        fields = [
            'id', 'name', 'email', 'phone', 'linkedin_url',
            'company', 'job_title', 'department',
            'connection_type', 'relationship_strength',
            'met_at', 'met_date', 'notes', 'tags',
            'is_alumni', 'shared_school', 'graduation_year',
            'last_contact_date', 'next_follow_up', 'follow_up_notes',
            'avatar_url', 'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'created_at', 'updated_at']


class ReferralSerializer(serializers.ModelSerializer):
    """Serializer for Referral model."""
    referrer_details = ProfessionalConnectionSerializer(source='referrer', read_only=True)
    application_title = serializers.CharField(source='application.job_title', read_only=True)
    application_company = serializers.CharField(source='application.company_name', read_only=True)
    
    class Meta:
        model = Referral
        fields = [
            'id', 'referrer', 'referrer_details', 'referrer_name', 'referrer_email',
            'application', 'application_title', 'application_company',
            'status', 'referral_date', 'referral_code', 'notes',
            'thank_you_sent', 'thank_you_date', 'referral_bonus_received',
            'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'referral_date', 'created_at', 'updated_at']


class NetworkingEventSerializer(serializers.ModelSerializer):
    """Serializer for NetworkingEvent model."""
    connections_count = serializers.SerializerMethodField()
    
    class Meta:
        model = NetworkingEvent
        fields = [
            'id', 'name', 'event_type', 'date', 'location', 'virtual_link',
            'is_virtual', 'companies', 'connections_made', 'connections_count',
            'preparation_notes', 'post_event_notes', 'follow_up_completed',
            'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'created_at', 'updated_at']
    
    def get_connections_count(self, obj):
        return obj.connections_made.count()


class MentorshipSessionSerializer(serializers.ModelSerializer):
    """Serializer for MentorshipSession model."""
    
    class Meta:
        model = MentorshipSession
        fields = [
            'id', 'mentorship', 'date', 'duration_minutes',
            'agenda', 'notes', 'action_items', 'rating', 'created_at'
        ]
        read_only_fields = ['id', 'created_at']


class MentorshipRelationshipSerializer(serializers.ModelSerializer):
    """Serializer for MentorshipRelationship model."""
    mentor_details = ProfessionalConnectionSerializer(source='mentor', read_only=True)
    recent_sessions = MentorshipSessionSerializer(source='sessions', many=True, read_only=True)
    
    class Meta:
        model = MentorshipRelationship
        fields = [
            'id', 'mentor', 'mentor_details', 'mentor_name', 'mentor_role',
            'mentor_company', 'status', 'meeting_frequency',
            'goals', 'focus_areas', 'total_sessions', 'next_session',
            'notes', 'started_at', 'ended_at', 'recent_sessions',
            'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'total_sessions', 'created_at', 'updated_at']
