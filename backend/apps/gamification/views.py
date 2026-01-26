from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from django_filters.rest_framework import DjangoFilterBackend
from rest_framework.filters import SearchFilter, OrderingFilter
from django.db.models import Count, Sum
from django.utils import timezone
from datetime import timedelta

from .models import (
    Achievement,
    UserAchievement,
    UserStreak,
    UserPoints,
    PointsTransaction,
    Leaderboard,
    Challenge,
    UserChallenge,
    CommunityPost,
    CommunityComment,
    PostUpvote,
)
from .serializers import (
    AchievementSerializer,
    UserAchievementSerializer,
    UserStreakSerializer,
    UserPointsSerializer,
    PointsTransactionSerializer,
    LeaderboardSerializer,
    ChallengeSerializer,
    UserChallengeSerializer,
    CommunityPostSerializer,
    CommunityCommentSerializer,
)


class AchievementViewSet(viewsets.ReadOnlyModelViewSet):
    """ViewSet for viewing achievements."""
    serializer_class = AchievementSerializer
    permission_classes = [IsAuthenticated]
    filter_backends = [DjangoFilterBackend, OrderingFilter]
    filterset_fields = ['category', 'tier']
    ordering = ['category', 'tier', 'points']
    
    def get_queryset(self):
        # Don't show hidden achievements unless earned
        user_earned = UserAchievement.objects.filter(
            user=self.request.user
        ).values_list('achievement_id', flat=True)
        
        return Achievement.objects.filter(
            models.Q(is_hidden=False) | models.Q(id__in=user_earned)
        )
    
    @action(detail=False, methods=['get'])
    def my_achievements(self, request):
        """Get user's earned achievements."""
        achievements = UserAchievement.objects.filter(
            user=request.user
        ).select_related('achievement')
        serializer = UserAchievementSerializer(achievements, many=True)
        return Response(serializer.data)
    
    @action(detail=False, methods=['get'])
    def progress(self, request):
        """Get achievement progress."""
        total = Achievement.objects.filter(is_hidden=False).count()
        earned = UserAchievement.objects.filter(user=request.user).count()
        
        by_category = Achievement.objects.filter(is_hidden=False).values(
            'category'
        ).annotate(total=Count('id'))
        
        earned_by_category = UserAchievement.objects.filter(
            user=request.user
        ).values('achievement__category').annotate(earned=Count('id'))
        
        earned_map = {item['achievement__category']: item['earned'] for item in earned_by_category}
        
        progress = []
        for cat in by_category:
            progress.append({
                'category': cat['category'],
                'total': cat['total'],
                'earned': earned_map.get(cat['category'], 0)
            })
        
        return Response({
            'total': total,
            'earned': earned,
            'percentage': int((earned / total) * 100) if total > 0 else 0,
            'by_category': progress
        })


class UserStreakViewSet(viewsets.ReadOnlyModelViewSet):
    """ViewSet for viewing user streaks."""
    serializer_class = UserStreakSerializer
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        return UserStreak.objects.filter(user=self.request.user)
    
    @action(detail=False, methods=['get'])
    def summary(self, request):
        """Get streak summary."""
        streaks = self.get_queryset()
        
        return Response({
            'active_streaks': streaks.filter(current_count__gt=0).count(),
            'longest_streak': streaks.order_by('-longest_count').first().longest_count if streaks.exists() else 0,
            'total_activities': streaks.aggregate(total=Sum('total_activities'))['total'] or 0,
            'streaks': UserStreakSerializer(streaks, many=True).data
        })


class UserPointsViewSet(viewsets.ReadOnlyModelViewSet):
    """ViewSet for viewing user points."""
    serializer_class = UserPointsSerializer
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        return UserPoints.objects.filter(user=self.request.user)
    
    def list(self, request):
        """Get user's points."""
        points, _ = UserPoints.objects.get_or_create(user=request.user)
        serializer = self.get_serializer(points)
        return Response(serializer.data)
    
    @action(detail=False, methods=['get'])
    def transactions(self, request):
        """Get points transaction history."""
        transactions = PointsTransaction.objects.filter(
            user=request.user
        ).order_by('-created_at')[:50]
        serializer = PointsTransactionSerializer(transactions, many=True)
        return Response(serializer.data)


class LeaderboardViewSet(viewsets.ReadOnlyModelViewSet):
    """ViewSet for viewing leaderboards."""
    serializer_class = LeaderboardSerializer
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        return Leaderboard.objects.all()
    
    @action(detail=False, methods=['get'])
    def current(self, request):
        """Get current leaderboards."""
        period = request.query_params.get('period', 'weekly')
        
        # Calculate rankings from UserPoints
        top_users = UserPoints.objects.select_related('user').order_by('-total_points')[:100]
        
        rankings = []
        for rank, up in enumerate(top_users, 1):
            rankings.append({
                'rank': rank,
                'user_id': str(up.user.id),
                'username': up.user.full_name or up.user.email.split('@')[0],
                'points': up.total_points,
                'level': up.level,
                'is_current_user': up.user == request.user
            })
        
        # Find current user's rank
        user_rank = None
        for r in rankings:
            if r['is_current_user']:
                user_rank = r['rank']
                break
        
        return Response({
            'period': period,
            'rankings': rankings[:20],
            'user_rank': user_rank,
            'total_participants': len(rankings)
        })


class ChallengeViewSet(viewsets.ReadOnlyModelViewSet):
    """ViewSet for viewing and joining challenges."""
    serializer_class = ChallengeSerializer
    permission_classes = [IsAuthenticated]
    filter_backends = [DjangoFilterBackend]
    filterset_fields = ['challenge_type', 'is_active']
    
    def get_queryset(self):
        return Challenge.objects.filter(
            is_active=True,
            end_date__gte=timezone.now()
        )
    
    @action(detail=True, methods=['post'])
    def join(self, request, pk=None):
        """Join a challenge."""
        challenge = self.get_object()
        user_challenge, created = UserChallenge.objects.get_or_create(
            user=request.user,
            challenge=challenge
        )
        
        return Response(UserChallengeSerializer(user_challenge).data)
    
    @action(detail=False, methods=['get'])
    def my_challenges(self, request):
        """Get user's active challenges."""
        challenges = UserChallenge.objects.filter(
            user=request.user,
            challenge__end_date__gte=timezone.now()
        ).select_related('challenge')
        serializer = UserChallengeSerializer(challenges, many=True)
        return Response(serializer.data)


class CommunityPostViewSet(viewsets.ModelViewSet):
    """ViewSet for community posts."""
    serializer_class = CommunityPostSerializer
    permission_classes = [IsAuthenticated]
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_fields = ['post_type', 'is_pinned']
    search_fields = ['title', 'content', 'tags']
    ordering = ['-is_pinned', '-upvotes', '-created_at']
    
    def get_queryset(self):
        return CommunityPost.objects.filter(is_approved=True).prefetch_related('comments')
    
    def perform_create(self, serializer):
        serializer.save(user=self.request.user)
    
    @action(detail=True, methods=['post'])
    def upvote(self, request, pk=None):
        """Toggle upvote on a post."""
        post = self.get_object()
        upvote, created = PostUpvote.objects.get_or_create(
            user=request.user,
            post=post
        )
        
        if created:
            post.upvotes += 1
        else:
            upvote.delete()
            post.upvotes = max(0, post.upvotes - 1)
        
        post.save()
        return Response({'upvotes': post.upvotes, 'has_upvoted': created})
    
    @action(detail=True, methods=['post'])
    def view(self, request, pk=None):
        """Record a view on a post."""
        post = self.get_object()
        post.views += 1
        post.save()
        return Response({'views': post.views})
    
    @action(detail=False, methods=['get'])
    def my_posts(self, request):
        """Get user's posts."""
        posts = CommunityPost.objects.filter(user=request.user)
        serializer = self.get_serializer(posts, many=True)
        return Response(serializer.data)
    
    @action(detail=False, methods=['get'])
    def trending(self, request):
        """Get trending posts."""
        week_ago = timezone.now() - timedelta(days=7)
        posts = CommunityPost.objects.filter(
            created_at__gte=week_ago,
            is_approved=True
        ).order_by('-upvotes', '-views')[:10]
        serializer = self.get_serializer(posts, many=True)
        return Response(serializer.data)


class CommunityCommentViewSet(viewsets.ModelViewSet):
    """ViewSet for community comments."""
    serializer_class = CommunityCommentSerializer
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        return CommunityComment.objects.all().select_related('post', 'user')
    
    def perform_create(self, serializer):
        serializer.save(user=self.request.user)
    
    @action(detail=True, methods=['post'])
    def upvote(self, request, pk=None):
        """Toggle upvote on a comment."""
        comment = self.get_object()
        upvote, created = PostUpvote.objects.get_or_create(
            user=request.user,
            comment=comment
        )
        
        if created:
            comment.upvotes += 1
        else:
            upvote.delete()
            comment.upvotes = max(0, comment.upvotes - 1)
        
        comment.save()
        return Response({'upvotes': comment.upvotes, 'has_upvoted': created})
