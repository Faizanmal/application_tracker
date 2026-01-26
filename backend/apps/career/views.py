from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from django_filters.rest_framework import DjangoFilterBackend
from rest_framework.filters import SearchFilter, OrderingFilter
from django.db.models import Count, Avg
from django.utils import timezone

from .models import (
    Skill,
    UserSkill,
    SkillGapAnalysis,
    LearningResource,
    UserLearningProgress,
    LearningPath,
    UserLearningPath,
    PortfolioProject,
    CareerGoal,
    CareerPathPlan,
)
from .serializers import (
    SkillSerializer,
    UserSkillSerializer,
    SkillGapAnalysisSerializer,
    LearningResourceSerializer,
    UserLearningProgressSerializer,
    LearningPathSerializer,
    UserLearningPathSerializer,
    PortfolioProjectSerializer,
    CareerGoalSerializer,
    CareerPathPlanSerializer,
)
from .services import CareerAIService


class SkillViewSet(viewsets.ModelViewSet):
    """ViewSet for managing skills."""
    queryset = Skill.objects.all()
    serializer_class = SkillSerializer
    permission_classes = [IsAuthenticated]
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_fields = ['category']
    search_fields = ['name', 'normalized_name']
    ordering_fields = ['name', 'usage_count']
    ordering = ['-usage_count']
    
    @action(detail=False, methods=['get'])
    def popular(self, request):
        """Get popular skills."""
        skills = self.get_queryset()[:50]
        serializer = self.get_serializer(skills, many=True)
        return Response(serializer.data)
    
    @action(detail=False, methods=['get'])
    def by_category(self, request):
        """Get skills grouped by category."""
        skills = Skill.objects.values('category').annotate(
            count=Count('id')
        ).order_by('-count')
        return Response(skills)


class UserSkillViewSet(viewsets.ModelViewSet):
    """ViewSet for managing user skills."""
    serializer_class = UserSkillSerializer
    permission_classes = [IsAuthenticated]
    filter_backends = [DjangoFilterBackend, OrderingFilter]
    filterset_fields = ['proficiency', 'is_verified']
    ordering = ['-proficiency', '-years_of_experience']
    
    def get_queryset(self):
        return UserSkill.objects.filter(user=self.request.user).select_related('skill')
    
    def perform_create(self, serializer):
        serializer.save(user=self.request.user)
    
    @action(detail=False, methods=['get'])
    def summary(self, request):
        """Get skills summary."""
        skills = self.get_queryset()
        by_proficiency = skills.values('proficiency').annotate(count=Count('id'))
        by_category = skills.values('skill__category').annotate(count=Count('id'))
        
        return Response({
            'total_skills': skills.count(),
            'by_proficiency': {item['proficiency']: item['count'] for item in by_proficiency},
            'by_category': {item['skill__category']: item['count'] for item in by_category},
        })
    
    @action(detail=False, methods=['post'])
    def bulk_add(self, request):
        """Add multiple skills at once."""
        skills_data = request.data.get('skills', [])
        created = []
        
        for skill_data in skills_data:
            skill_name = skill_data.get('name')
            if skill_name:
                skill, _ = Skill.objects.get_or_create(
                    normalized_name=skill_name.lower().strip(),
                    defaults={'name': skill_name}
                )
                user_skill, was_created = UserSkill.objects.get_or_create(
                    user=request.user,
                    skill=skill,
                    defaults={
                        'proficiency': skill_data.get('proficiency', 'intermediate'),
                        'years_of_experience': skill_data.get('years', 0)
                    }
                )
                if was_created:
                    created.append(UserSkillSerializer(user_skill).data)
        
        return Response({'created': created}, status=status.HTTP_201_CREATED)


class SkillGapAnalysisViewSet(viewsets.ModelViewSet):
    """ViewSet for skill gap analysis."""
    serializer_class = SkillGapAnalysisSerializer
    permission_classes = [IsAuthenticated]
    ordering = ['-created_at']
    
    def get_queryset(self):
        return SkillGapAnalysis.objects.filter(user=self.request.user)
    
    def perform_create(self, serializer):
        serializer.save(user=self.request.user)
    
    @action(detail=False, methods=['post'])
    def analyze(self, request):
        """Run AI skill gap analysis."""
        target_role = request.data.get('target_role')
        job_description = request.data.get('job_description', '')
        application_id = request.data.get('application_id')
        
        if not target_role:
            return Response(
                {'error': 'target_role is required'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        # Get user skills
        user_skills = UserSkill.objects.filter(user=request.user).select_related('skill')
        
        # Run AI analysis
        service = CareerAIService()
        analysis = service.analyze_skill_gap(
            user_skills=user_skills,
            target_role=target_role,
            job_description=job_description
        )
        
        # Save analysis
        gap_analysis = SkillGapAnalysis.objects.create(
            user=request.user,
            target_role=target_role,
            target_company=request.data.get('target_company', ''),
            target_industry=request.data.get('target_industry', ''),
            required_skills=analysis.get('required_skills', []),
            current_skills=analysis.get('current_skills', []),
            gap_skills=analysis.get('gap_skills', []),
            match_percentage=analysis.get('match_percentage', 0),
            summary=analysis.get('summary', ''),
            recommendations=analysis.get('recommendations', []),
            estimated_time_to_bridge=analysis.get('estimated_time', ''),
            application_id=application_id
        )
        
        serializer = self.get_serializer(gap_analysis)
        return Response(serializer.data, status=status.HTTP_201_CREATED)


class LearningResourceViewSet(viewsets.ModelViewSet):
    """ViewSet for learning resources."""
    serializer_class = LearningResourceSerializer
    permission_classes = [IsAuthenticated]
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_fields = ['resource_type', 'platform', 'is_free', 'is_ai_recommended']
    search_fields = ['title', 'description']
    ordering_fields = ['rating', 'reviews_count', 'created_at']
    ordering = ['-rating']
    
    def get_queryset(self):
        return LearningResource.objects.all().prefetch_related('skills')
    
    @action(detail=False, methods=['get'])
    def recommended(self, request):
        """Get AI-recommended resources based on skill gaps."""
        # Get user's skill gaps
        latest_analysis = SkillGapAnalysis.objects.filter(
            user=request.user
        ).order_by('-created_at').first()
        
        if not latest_analysis:
            # Return top-rated resources
            resources = self.get_queryset().filter(is_ai_recommended=True)[:10]
        else:
            # Get resources for gap skills
            gap_skill_names = [s.get('skill') for s in latest_analysis.gap_skills]
            resources = self.get_queryset().filter(
                skills__name__in=gap_skill_names
            ).distinct()[:10]
        
        serializer = self.get_serializer(resources, many=True)
        return Response(serializer.data)
    
    @action(detail=True, methods=['post'])
    def start(self, request, pk=None):
        """Start learning a resource."""
        resource = self.get_object()
        progress, created = UserLearningProgress.objects.get_or_create(
            user=request.user,
            resource=resource,
            defaults={
                'status': 'in_progress',
                'started_at': timezone.now()
            }
        )
        if not created and progress.status == 'not_started':
            progress.status = 'in_progress'
            progress.started_at = timezone.now()
            progress.save()
        
        return Response(UserLearningProgressSerializer(progress).data)


class UserLearningProgressViewSet(viewsets.ModelViewSet):
    """ViewSet for user learning progress."""
    serializer_class = UserLearningProgressSerializer
    permission_classes = [IsAuthenticated]
    filter_backends = [DjangoFilterBackend, OrderingFilter]
    filterset_fields = ['status']
    ordering = ['-updated_at']
    
    def get_queryset(self):
        return UserLearningProgress.objects.filter(
            user=self.request.user
        ).select_related('resource')
    
    def perform_create(self, serializer):
        serializer.save(user=self.request.user)
    
    @action(detail=True, methods=['post'])
    def update_progress(self, request, pk=None):
        """Update progress percentage."""
        progress = self.get_object()
        percentage = request.data.get('percentage', progress.progress_percentage)
        progress.progress_percentage = min(100, max(0, int(percentage)))
        
        if progress.progress_percentage == 100:
            progress.status = 'completed'
            progress.completed_at = timezone.now()
        elif progress.progress_percentage > 0:
            progress.status = 'in_progress'
        
        progress.save()
        serializer = self.get_serializer(progress)
        return Response(serializer.data)
    
    @action(detail=False, methods=['get'])
    def stats(self, request):
        """Get learning statistics."""
        progress = self.get_queryset()
        
        return Response({
            'total_resources': progress.count(),
            'completed': progress.filter(status='completed').count(),
            'in_progress': progress.filter(status='in_progress').count(),
            'total_time_spent': progress.aggregate(
                total=models.Sum('total_time_spent_minutes')
            )['total'] or 0,
        })


class LearningPathViewSet(viewsets.ModelViewSet):
    """ViewSet for learning paths."""
    serializer_class = LearningPathSerializer
    permission_classes = [IsAuthenticated]
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_fields = ['is_ai_generated']
    search_fields = ['name', 'target_role']
    ordering = ['-followers_count']
    
    def get_queryset(self):
        return LearningPath.objects.all().prefetch_related(
            'resources', 'skills', 'learningpathresource_set'
        )
    
    @action(detail=True, methods=['post'])
    def enroll(self, request, pk=None):
        """Enroll in a learning path."""
        path = self.get_object()
        enrollment, created = UserLearningPath.objects.get_or_create(
            user=request.user,
            learning_path=path,
            defaults={'status': 'active'}
        )
        
        if created:
            path.followers_count += 1
            path.save()
        
        return Response(UserLearningPathSerializer(enrollment).data)
    
    @action(detail=False, methods=['post'])
    def generate(self, request):
        """Generate a personalized learning path using AI."""
        target_role = request.data.get('target_role')
        if not target_role:
            return Response(
                {'error': 'target_role is required'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        service = CareerAIService()
        path_data = service.generate_learning_path(
            user=request.user,
            target_role=target_role
        )
        
        # Create learning path
        path = LearningPath.objects.create(
            name=f"AI Path to {target_role}",
            description=path_data.get('description', ''),
            target_role=target_role,
            estimated_weeks=path_data.get('estimated_weeks', 12),
            is_ai_generated=True
        )
        
        serializer = self.get_serializer(path)
        return Response(serializer.data, status=status.HTTP_201_CREATED)


class UserLearningPathViewSet(viewsets.ModelViewSet):
    """ViewSet for user learning path enrollments."""
    serializer_class = UserLearningPathSerializer
    permission_classes = [IsAuthenticated]
    filter_backends = [DjangoFilterBackend]
    filterset_fields = ['status']
    
    def get_queryset(self):
        return UserLearningPath.objects.filter(
            user=self.request.user
        ).select_related('learning_path')


class PortfolioProjectViewSet(viewsets.ModelViewSet):
    """ViewSet for portfolio projects."""
    serializer_class = PortfolioProjectSerializer
    permission_classes = [IsAuthenticated]
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_fields = ['project_type', 'is_public', 'is_featured']
    search_fields = ['title', 'description']
    ordering = ['-is_featured', '-created_at']
    
    def get_queryset(self):
        return PortfolioProject.objects.filter(
            user=self.request.user
        ).prefetch_related('skills_demonstrated')
    
    def perform_create(self, serializer):
        serializer.save(user=self.request.user)
    
    @action(detail=False, methods=['get'])
    def public(self, request):
        """Get public portfolio for sharing."""
        user_id = request.query_params.get('user_id', request.user.id)
        projects = PortfolioProject.objects.filter(
            user_id=user_id,
            is_public=True
        )
        serializer = self.get_serializer(projects, many=True)
        return Response(serializer.data)


class CareerGoalViewSet(viewsets.ModelViewSet):
    """ViewSet for career goals."""
    serializer_class = CareerGoalSerializer
    permission_classes = [IsAuthenticated]
    filter_backends = [DjangoFilterBackend, OrderingFilter]
    filterset_fields = ['goal_type', 'time_frame', 'status']
    ordering = ['-created_at']
    
    def get_queryset(self):
        return CareerGoal.objects.filter(user=self.request.user)
    
    def perform_create(self, serializer):
        serializer.save(user=self.request.user)
    
    @action(detail=True, methods=['post'])
    def update_progress(self, request, pk=None):
        """Update goal progress."""
        goal = self.get_object()
        goal.progress_percentage = request.data.get('progress', goal.progress_percentage)
        
        if goal.progress_percentage >= 100:
            goal.status = 'achieved'
            goal.achieved_at = timezone.now()
        
        goal.save()
        serializer = self.get_serializer(goal)
        return Response(serializer.data)
    
    @action(detail=True, methods=['post'])
    def complete_milestone(self, request, pk=None):
        """Mark a milestone as complete."""
        goal = self.get_object()
        milestone_index = request.data.get('milestone_index')
        
        if milestone_index is not None and 0 <= milestone_index < len(goal.milestones):
            goal.milestones[milestone_index]['completed'] = True
            goal.milestones[milestone_index]['completed_at'] = timezone.now().isoformat()
            
            # Update overall progress
            completed = sum(1 for m in goal.milestones if m.get('completed'))
            goal.progress_percentage = int((completed / len(goal.milestones)) * 100)
            
            goal.save()
        
        serializer = self.get_serializer(goal)
        return Response(serializer.data)
    
    @action(detail=True, methods=['post'])
    def get_recommendations(self, request, pk=None):
        """Get AI recommendations for achieving this goal."""
        goal = self.get_object()
        service = CareerAIService()
        
        recommendations = service.get_goal_recommendations(goal)
        goal.ai_recommendations = recommendations
        goal.save()
        
        serializer = self.get_serializer(goal)
        return Response(serializer.data)


class CareerPathPlanViewSet(viewsets.ModelViewSet):
    """ViewSet for career path planning."""
    serializer_class = CareerPathPlanSerializer
    permission_classes = [IsAuthenticated]
    filter_backends = [DjangoFilterBackend]
    filterset_fields = ['is_active']
    
    def get_queryset(self):
        return CareerPathPlan.objects.filter(user=self.request.user)
    
    def perform_create(self, serializer):
        serializer.save(user=self.request.user)
    
    @action(detail=False, methods=['post'])
    def generate(self, request):
        """Generate an AI career path plan."""
        current_role = request.data.get('current_role')
        target_role = request.data.get('target_role')
        
        if not current_role or not target_role:
            return Response(
                {'error': 'current_role and target_role are required'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        service = CareerAIService()
        plan_data = service.generate_career_path(
            user=request.user,
            current_role=current_role,
            target_role=target_role,
            target_years=request.data.get('target_years', 5)
        )
        
        plan = CareerPathPlan.objects.create(
            user=request.user,
            name=f"Path from {current_role} to {target_role}",
            current_role=current_role,
            target_role=target_role,
            target_timeline_years=request.data.get('target_years', 5),
            stages=plan_data.get('stages', []),
            ai_analysis=plan_data.get('analysis', ''),
            success_probability=plan_data.get('success_probability'),
            market_demand=plan_data.get('market_demand', {})
        )
        
        serializer = self.get_serializer(plan)
        return Response(serializer.data, status=status.HTTP_201_CREATED)
