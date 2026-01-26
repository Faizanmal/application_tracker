from django.contrib import admin
from .models import (
    ProfessionalConnection,
    Referral,
    NetworkingEvent,
    MentorshipRelationship,
    MentorshipSession,
)


@admin.register(ProfessionalConnection)
class ProfessionalConnectionAdmin(admin.ModelAdmin):
    list_display = ['name', 'company', 'job_title', 'connection_type', 'user', 'created_at']
    list_filter = ['connection_type', 'relationship_strength', 'is_alumni']
    search_fields = ['name', 'company', 'email']
    date_hierarchy = 'created_at'


@admin.register(Referral)
class ReferralAdmin(admin.ModelAdmin):
    list_display = ['referrer_name', 'application', 'status', 'referral_date', 'user']
    list_filter = ['status', 'thank_you_sent']
    search_fields = ['referrer_name', 'application__company_name']
    date_hierarchy = 'referral_date'


@admin.register(NetworkingEvent)
class NetworkingEventAdmin(admin.ModelAdmin):
    list_display = ['name', 'event_type', 'date', 'is_virtual', 'user']
    list_filter = ['event_type', 'is_virtual']
    search_fields = ['name', 'location']
    date_hierarchy = 'date'


@admin.register(MentorshipRelationship)
class MentorshipRelationshipAdmin(admin.ModelAdmin):
    list_display = ['mentor_name', 'status', 'meeting_frequency', 'total_sessions', 'user']
    list_filter = ['status', 'meeting_frequency']
    search_fields = ['mentor_name', 'mentor_company']


@admin.register(MentorshipSession)
class MentorshipSessionAdmin(admin.ModelAdmin):
    list_display = ['mentorship', 'date', 'duration_minutes', 'rating']
    list_filter = ['rating']
    date_hierarchy = 'date'
