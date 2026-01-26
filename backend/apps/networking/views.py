from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from django_filters.rest_framework import DjangoFilterBackend
from rest_framework.filters import SearchFilter, OrderingFilter
from django.db.models import Count, Q
from django.utils import timezone
from datetime import timedelta

from .models import (
    ProfessionalConnection,
    Referral,
    NetworkingEvent,
    MentorshipRelationship,
    MentorshipSession,
)
from .serializers import (
    ProfessionalConnectionSerializer,
    ReferralSerializer,
    NetworkingEventSerializer,
    MentorshipRelationshipSerializer,
    MentorshipSessionSerializer,
)


class ProfessionalConnectionViewSet(viewsets.ModelViewSet):
    """ViewSet for managing professional connections."""
    serializer_class = ProfessionalConnectionSerializer
    permission_classes = [IsAuthenticated]
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_fields = ['connection_type', 'relationship_strength', 'is_alumni', 'company']
    search_fields = ['name', 'company', 'job_title', 'email']
    ordering_fields = ['name', 'company', 'last_contact_date', 'created_at']
    ordering = ['-updated_at']
    
    def get_queryset(self):
        return ProfessionalConnection.objects.filter(user=self.request.user)
    
    def perform_create(self, serializer):
        serializer.save(user=self.request.user)
    
    @action(detail=False, methods=['get'])
    def stats(self, request):
        """Get networking statistics."""
        connections = self.get_queryset()
        
        # Count by type
        by_type = connections.values('connection_type').annotate(count=Count('id'))
        by_strength = connections.values('relationship_strength').annotate(count=Count('id'))
        
        # Follow-up needed
        today = timezone.now().date()
        follow_up_needed = connections.filter(
            next_follow_up__lte=today
        ).count()
        
        # Recent contacts
        last_30_days = today - timedelta(days=30)
        recent_contacts = connections.filter(
            last_contact_date__gte=last_30_days
        ).count()
        
        return Response({
            'total_connections': connections.count(),
            'by_type': {item['connection_type']: item['count'] for item in by_type},
            'by_strength': {item['relationship_strength']: item['count'] for item in by_strength},
            'alumni_connections': connections.filter(is_alumni=True).count(),
            'follow_up_needed': follow_up_needed,
            'recent_contacts': recent_contacts,
        })
    
    @action(detail=False, methods=['get'])
    def follow_up_needed(self, request):
        """Get connections that need follow-up."""
        today = timezone.now().date()
        connections = self.get_queryset().filter(
            Q(next_follow_up__lte=today) | 
            Q(last_contact_date__lte=today - timedelta(days=30), next_follow_up__isnull=True)
        )
        serializer = self.get_serializer(connections, many=True)
        return Response(serializer.data)
    
    @action(detail=True, methods=['post'])
    def log_contact(self, request, pk=None):
        """Log a contact with this connection."""
        connection = self.get_object()
        connection.last_contact_date = timezone.now().date()
        
        # Optionally set next follow-up
        if request.data.get('next_follow_up_days'):
            days = int(request.data['next_follow_up_days'])
            connection.next_follow_up = timezone.now().date() + timedelta(days=days)
        
        if request.data.get('notes'):
            connection.follow_up_notes = request.data['notes']
        
        connection.save()
        serializer = self.get_serializer(connection)
        return Response(serializer.data)
    
    @action(detail=False, methods=['get'])
    def by_company(self, request):
        """Get connections grouped by company."""
        company = request.query_params.get('company')
        if company:
            connections = self.get_queryset().filter(company__icontains=company)
        else:
            connections = self.get_queryset().exclude(company='')
        
        # Group by company
        companies = connections.values('company').annotate(
            count=Count('id')
        ).order_by('-count')[:20]
        
        return Response(companies)


class ReferralViewSet(viewsets.ModelViewSet):
    """ViewSet for managing referrals."""
    serializer_class = ReferralSerializer
    permission_classes = [IsAuthenticated]
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_fields = ['status', 'thank_you_sent']
    search_fields = ['referrer_name', 'application__company_name']
    ordering = ['-created_at']
    
    def get_queryset(self):
        return Referral.objects.filter(user=self.request.user).select_related(
            'referrer', 'application'
        )
    
    def perform_create(self, serializer):
        serializer.save(user=self.request.user)
    
    @action(detail=True, methods=['post'])
    def send_thank_you(self, request, pk=None):
        """Mark thank you as sent."""
        referral = self.get_object()
        referral.thank_you_sent = True
        referral.thank_you_date = timezone.now().date()
        referral.save()
        serializer = self.get_serializer(referral)
        return Response(serializer.data)
    
    @action(detail=False, methods=['get'])
    def pending_thank_yous(self, request):
        """Get referrals that need thank you messages."""
        referrals = self.get_queryset().filter(thank_you_sent=False)
        serializer = self.get_serializer(referrals, many=True)
        return Response(serializer.data)
    
    @action(detail=False, methods=['get'])
    def stats(self, request):
        """Get referral statistics."""
        referrals = self.get_queryset()
        by_status = referrals.values('status').annotate(count=Count('id'))
        
        return Response({
            'total_referrals': referrals.count(),
            'by_status': {item['status']: item['count'] for item in by_status},
            'pending_thank_yous': referrals.filter(thank_you_sent=False).count(),
            'successful_referrals': referrals.filter(status='hired').count(),
        })


class NetworkingEventViewSet(viewsets.ModelViewSet):
    """ViewSet for managing networking events."""
    serializer_class = NetworkingEventSerializer
    permission_classes = [IsAuthenticated]
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_fields = ['event_type', 'is_virtual', 'follow_up_completed']
    search_fields = ['name', 'location']
    ordering = ['-date']
    
    def get_queryset(self):
        return NetworkingEvent.objects.filter(user=self.request.user).prefetch_related(
            'connections_made'
        )
    
    def perform_create(self, serializer):
        serializer.save(user=self.request.user)
    
    @action(detail=False, methods=['get'])
    def upcoming(self, request):
        """Get upcoming networking events."""
        events = self.get_queryset().filter(date__gte=timezone.now())
        serializer = self.get_serializer(events, many=True)
        return Response(serializer.data)
    
    @action(detail=False, methods=['get'])
    def needs_follow_up(self, request):
        """Get events that need follow-up."""
        events = self.get_queryset().filter(
            follow_up_completed=False,
            date__lt=timezone.now()
        )
        serializer = self.get_serializer(events, many=True)
        return Response(serializer.data)
    
    @action(detail=True, methods=['post'])
    def add_connection(self, request, pk=None):
        """Add a connection made at this event."""
        event = self.get_object()
        connection_id = request.data.get('connection_id')
        
        if connection_id:
            try:
                connection = ProfessionalConnection.objects.get(
                    id=connection_id,
                    user=request.user
                )
                event.connections_made.add(connection)
                return Response({'status': 'Connection added'})
            except ProfessionalConnection.DoesNotExist:
                return Response(
                    {'error': 'Connection not found'},
                    status=status.HTTP_404_NOT_FOUND
                )
        return Response(
            {'error': 'connection_id required'},
            status=status.HTTP_400_BAD_REQUEST
        )


class MentorshipRelationshipViewSet(viewsets.ModelViewSet):
    """ViewSet for managing mentorship relationships."""
    serializer_class = MentorshipRelationshipSerializer
    permission_classes = [IsAuthenticated]
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_fields = ['status', 'meeting_frequency']
    search_fields = ['mentor_name', 'mentor_company']
    ordering = ['-updated_at']
    
    def get_queryset(self):
        return MentorshipRelationship.objects.filter(user=self.request.user).prefetch_related(
            'sessions'
        ).select_related('mentor')
    
    def perform_create(self, serializer):
        serializer.save(user=self.request.user)
    
    @action(detail=True, methods=['post'])
    def add_session(self, request, pk=None):
        """Add a session to this mentorship."""
        mentorship = self.get_object()
        
        session_data = {
            'mentorship': mentorship.id,
            'date': request.data.get('date', timezone.now()),
            'duration_minutes': request.data.get('duration_minutes', 60),
            'agenda': request.data.get('agenda', ''),
            'notes': request.data.get('notes', ''),
            'action_items': request.data.get('action_items', []),
            'rating': request.data.get('rating'),
        }
        
        serializer = MentorshipSessionSerializer(data=session_data)
        if serializer.is_valid():
            serializer.save()
            mentorship.total_sessions += 1
            mentorship.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    @action(detail=False, methods=['get'])
    def active(self, request):
        """Get active mentorships."""
        mentorships = self.get_queryset().filter(status='active')
        serializer = self.get_serializer(mentorships, many=True)
        return Response(serializer.data)


class MentorshipSessionViewSet(viewsets.ModelViewSet):
    """ViewSet for managing mentorship sessions."""
    serializer_class = MentorshipSessionSerializer
    permission_classes = [IsAuthenticated]
    filter_backends = [OrderingFilter]
    ordering = ['-date']
    
    def get_queryset(self):
        return MentorshipSession.objects.filter(
            mentorship__user=self.request.user
        ).select_related('mentorship')
    
    def perform_create(self, serializer):
        session = serializer.save()
        # Update mentorship session count
        session.mentorship.total_sessions += 1
        session.mentorship.save()
