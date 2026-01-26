from rest_framework import generics, status, filters
from rest_framework.views import APIView
from rest_framework.response import Response
from django_filters.rest_framework import DjangoFilterBackend
from django.utils import timezone
from datetime import timedelta

from .models import Interview, InterviewQuestion, STARResponse, CompanyResearch, CommonQuestion
from .serializers import (
    InterviewListSerializer, InterviewDetailSerializer,
    InterviewQuestionSerializer, STARResponseSerializer,
    CompanyResearchSerializer, CommonQuestionSerializer,
    UpcomingInterviewSerializer
)
from apps.applications.models import JobApplication, ApplicationTimeline


class InterviewListCreateView(generics.ListCreateAPIView):
    """List and create interviews."""
    
    filter_backends = [DjangoFilterBackend, filters.OrderingFilter]
    filterset_fields = ['status', 'interview_type', 'application']
    ordering_fields = ['scheduled_at', 'created_at']
    ordering = ['scheduled_at']
    
    def get_serializer_class(self):
        if self.request.method == 'POST':
            return InterviewDetailSerializer
        return InterviewListSerializer
    
    def get_queryset(self):
        return Interview.objects.filter(
            application__user=self.request.user
        ).select_related('application')
    
    def perform_create(self, serializer):
        interview = serializer.save()
        
        # Update application status
        application = interview.application
        if application.status in ['applied', 'screening']:
            application.status = 'interviewing'
            application.save()
        
        # Create timeline entry
        ApplicationTimeline.objects.create(
            application=application,
            event_type=ApplicationTimeline.EventType.INTERVIEW_SCHEDULED,
            title=f'{interview.get_interview_type_display()} scheduled',
            description=f'Scheduled for {interview.scheduled_at}'
        )


class InterviewDetailView(generics.RetrieveUpdateDestroyAPIView):
    """Get, update, or delete an interview."""
    
    serializer_class = InterviewDetailSerializer
    
    def get_queryset(self):
        return Interview.objects.filter(
            application__user=self.request.user
        ).select_related('application')


class UpcomingInterviewsView(generics.ListAPIView):
    """Get upcoming interviews for the next 7 days."""
    
    serializer_class = UpcomingInterviewSerializer
    
    def get_queryset(self):
        now = timezone.now()
        next_week = now + timedelta(days=7)
        
        return Interview.objects.filter(
            application__user=self.request.user,
            scheduled_at__gte=now,
            scheduled_at__lte=next_week,
            status=Interview.Status.SCHEDULED
        ).select_related('application').order_by('scheduled_at')


class TodayInterviewsView(generics.ListAPIView):
    """Get today's interviews."""
    
    serializer_class = UpcomingInterviewSerializer
    
    def get_queryset(self):
        today = timezone.now().date()
        
        return Interview.objects.filter(
            application__user=self.request.user,
            scheduled_at__date=today,
            status=Interview.Status.SCHEDULED
        ).select_related('application').order_by('scheduled_at')


class InterviewQuestionListCreateView(generics.ListCreateAPIView):
    """List and create interview questions."""
    
    serializer_class = InterviewQuestionSerializer
    
    def get_queryset(self):
        interview_id = self.kwargs.get('interview_id')
        if interview_id:
            return InterviewQuestion.objects.filter(
                interview_id=interview_id,
                interview__application__user=self.request.user
            )
        return InterviewQuestion.objects.filter(
            user=self.request.user
        )
    
    def perform_create(self, serializer):
        interview_id = self.kwargs.get('interview_id')
        interview = None
        if interview_id:
            interview = Interview.objects.get(
                id=interview_id,
                application__user=self.request.user
            )
        serializer.save(interview=interview, user=self.request.user)


class InterviewQuestionDetailView(generics.RetrieveUpdateDestroyAPIView):
    """Get, update, or delete an interview question."""
    
    serializer_class = InterviewQuestionSerializer
    
    def get_queryset(self):
        return InterviewQuestion.objects.filter(user=self.request.user)


class STARResponseListCreateView(generics.ListCreateAPIView):
    """List and create STAR responses for a question."""
    
    serializer_class = STARResponseSerializer
    
    def get_queryset(self):
        question_id = self.kwargs['question_id']
        return STARResponse.objects.filter(
            question_id=question_id,
            question__user=self.request.user
        )
    
    def perform_create(self, serializer):
        question_id = self.kwargs['question_id']
        question = InterviewQuestion.objects.get(
            id=question_id,
            user=self.request.user
        )
        serializer.save(question=question)


class STARResponseDetailView(generics.RetrieveUpdateDestroyAPIView):
    """Get, update, or delete a STAR response."""
    
    serializer_class = STARResponseSerializer
    
    def get_queryset(self):
        return STARResponse.objects.filter(question__user=self.request.user)


class CompanyResearchView(generics.RetrieveUpdateAPIView):
    """Get or update company research for an application."""
    
    serializer_class = CompanyResearchSerializer
    
    def get_object(self):
        application_id = self.kwargs['application_id']
        application = JobApplication.objects.get(
            id=application_id,
            user=self.request.user
        )
        research, created = CompanyResearch.objects.get_or_create(
            application=application
        )
        return research


class CommonQuestionListView(generics.ListAPIView):
    """List common interview questions."""
    
    serializer_class = CommonQuestionSerializer
    filter_backends = [filters.SearchFilter, DjangoFilterBackend]
    search_fields = ['question', 'category']
    filterset_fields = ['question_type', 'category']
    
    def get_queryset(self):
        queryset = CommonQuestion.objects.filter(is_active=True)
        
        # Filter by role if provided
        role = self.request.query_params.get('role')
        if role:
            queryset = queryset.filter(roles__contains=[role])
        
        return queryset


class CompleteInterviewView(APIView):
    """Mark an interview as completed and add notes."""
    
    def post(self, request, pk):
        try:
            interview = Interview.objects.get(
                pk=pk,
                application__user=request.user
            )
        except Interview.DoesNotExist:
            return Response(
                {'error': 'Interview not found'},
                status=status.HTTP_404_NOT_FOUND
            )
        
        interview.status = Interview.Status.COMPLETED
        interview.post_interview_notes = request.data.get('notes', '')
        interview.feedback = request.data.get('feedback', '')
        interview.rating = request.data.get('rating')
        interview.save()
        
        return Response(InterviewDetailSerializer(interview).data)


class CancelInterviewView(APIView):
    """Cancel an interview."""
    
    def post(self, request, pk):
        try:
            interview = Interview.objects.get(
                pk=pk,
                application__user=request.user
            )
        except Interview.DoesNotExist:
            return Response(
                {'error': 'Interview not found'},
                status=status.HTTP_404_NOT_FOUND
            )
        
        interview.status = Interview.Status.CANCELLED
        interview.save()
        
        return Response(InterviewDetailSerializer(interview).data)
