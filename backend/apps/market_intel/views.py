from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from django_filters.rest_framework import DjangoFilterBackend
from rest_framework.filters import SearchFilter, OrderingFilter
from django.db.models import Avg, Count, Q
from django.utils import timezone
from datetime import timedelta

from .models import (
    CompanyProfile,
    SalaryData,
    IndustryTrend,
    HiringSeasonData,
    JobMarketHeatmap,
    SuccessPrediction,
    JobSearchROI,
)
from .serializers import (
    CompanyProfileSerializer,
    CompanyProfileSummarySerializer,
    SalaryDataSerializer,
    IndustryTrendSerializer,
    HiringSeasonDataSerializer,
    JobMarketHeatmapSerializer,
    SuccessPredictionSerializer,
    JobSearchROISerializer,
)
from .services import MarketIntelService, PredictionService


class CompanyProfileViewSet(viewsets.ReadOnlyModelViewSet):
    """ViewSet for company profiles."""
    serializer_class = CompanyProfileSerializer
    permission_classes = [IsAuthenticated]
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_fields = ['industry', 'company_size', 'is_hiring']
    search_fields = ['name', 'domain', 'description']
    ordering_fields = ['name', 'glassdoor_rating', 'open_positions_count']
    ordering = ['name']
    
    def get_queryset(self):
        return CompanyProfile.objects.all()
    
    def get_serializer_class(self):
        if self.action == 'list':
            return CompanyProfileSummarySerializer
        return CompanyProfileSerializer
    
    @action(detail=False, methods=['get'])
    def search(self, request):
        """Search companies by name or domain."""
        query = request.query_params.get('q', '')
        if len(query) < 2:
            return Response([])
        
        companies = self.get_queryset().filter(
            Q(name__icontains=query) | Q(domain__icontains=query)
        )[:20]
        serializer = CompanyProfileSummarySerializer(companies, many=True)
        return Response(serializer.data)
    
    @action(detail=False, methods=['get'])
    def by_domain(self, request):
        """Get company by domain."""
        domain = request.query_params.get('domain', '')
        if not domain:
            return Response({'error': 'domain required'}, status=400)
        
        # Normalize domain
        domain = domain.lower().replace('www.', '').split('/')[0]
        
        try:
            company = CompanyProfile.objects.get(domain=domain)
            serializer = self.get_serializer(company)
            return Response(serializer.data)
        except CompanyProfile.DoesNotExist:
            # Try to fetch from external source
            service = MarketIntelService()
            company_data = service.fetch_company_profile(domain)
            if company_data:
                return Response(company_data)
            return Response({'error': 'Company not found'}, status=404)
    
    @action(detail=True, methods=['get'])
    def salary_data(self, request, pk=None):
        """Get salary data for a company."""
        company = self.get_object()
        salaries = SalaryData.objects.filter(company=company)
        serializer = SalaryDataSerializer(salaries, many=True)
        return Response(serializer.data)


class SalaryDataViewSet(viewsets.ReadOnlyModelViewSet):
    """ViewSet for salary data."""
    serializer_class = SalaryDataSerializer
    permission_classes = [IsAuthenticated]
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_fields = ['industry', 'country', 'seniority_level', 'is_remote', 'year']
    search_fields = ['job_title', 'normalized_title', 'company_name', 'location']
    ordering = ['-salary_median']
    
    def get_queryset(self):
        return SalaryData.objects.all().select_related('company')
    
    @action(detail=False, methods=['get'])
    def compare(self, request):
        """Compare salaries across locations or companies."""
        title = request.query_params.get('title', '')
        locations = request.query_params.getlist('locations', [])
        
        if not title:
            return Response({'error': 'title required'}, status=400)
        
        query = SalaryData.objects.filter(
            normalized_title__icontains=title.lower()
        )
        
        if locations:
            query = query.filter(location__in=locations)
        
        # Group by location
        result = query.values('location', 'country').annotate(
            avg_min=Avg('salary_min'),
            avg_max=Avg('salary_max'),
            avg_median=Avg('salary_median'),
            sample_count=Count('id')
        ).order_by('-avg_median')
        
        return Response(list(result))
    
    @action(detail=False, methods=['post'])
    def estimate(self, request):
        """Get salary estimate for a role."""
        service = MarketIntelService()
        estimate = service.estimate_salary(
            job_title=request.data.get('job_title'),
            location=request.data.get('location'),
            experience_years=request.data.get('experience_years', 0),
            skills=request.data.get('skills', [])
        )
        return Response(estimate)


class IndustryTrendViewSet(viewsets.ReadOnlyModelViewSet):
    """ViewSet for industry trends."""
    serializer_class = IndustryTrendSerializer
    permission_classes = [IsAuthenticated]
    filter_backends = [DjangoFilterBackend, OrderingFilter]
    filterset_fields = ['industry', 'year', 'quarter']
    ordering = ['-year', '-quarter']
    
    def get_queryset(self):
        return IndustryTrend.objects.all()
    
    @action(detail=False, methods=['get'])
    def current(self, request):
        """Get current trends for all industries."""
        current_year = timezone.now().year
        current_quarter = (timezone.now().month - 1) // 3 + 1
        
        trends = self.get_queryset().filter(
            year=current_year,
            quarter=current_quarter
        )
        serializer = self.get_serializer(trends, many=True)
        return Response(serializer.data)
    
    @action(detail=False, methods=['get'])
    def skills_demand(self, request):
        """Get top skills in demand across industries."""
        industry = request.query_params.get('industry')
        
        trends = self.get_queryset()
        if industry:
            trends = trends.filter(industry=industry)
        
        # Aggregate top skills
        all_skills = {}
        for trend in trends.order_by('-year', '-quarter')[:10]:
            for skill in trend.top_skills[:10]:
                if isinstance(skill, dict):
                    name = skill.get('name', str(skill))
                else:
                    name = str(skill)
                all_skills[name] = all_skills.get(name, 0) + 1
        
        sorted_skills = sorted(all_skills.items(), key=lambda x: x[1], reverse=True)[:20]
        return Response([{'skill': s[0], 'mentions': s[1]} for s in sorted_skills])


class HiringSeasonDataViewSet(viewsets.ReadOnlyModelViewSet):
    """ViewSet for hiring season data."""
    serializer_class = HiringSeasonDataSerializer
    permission_classes = [IsAuthenticated]
    filter_backends = [DjangoFilterBackend]
    filterset_fields = ['industry', 'job_category', 'year']
    
    def get_queryset(self):
        return HiringSeasonData.objects.all()
    
    @action(detail=False, methods=['get'])
    def best_time(self, request):
        """Get best time to apply for a role/industry."""
        industry = request.query_params.get('industry', 'Technology')
        
        current_year = timezone.now().year
        data = self.get_queryset().filter(
            industry=industry,
            year__gte=current_year - 2
        ).first()
        
        if data:
            serializer = self.get_serializer(data)
            return Response(serializer.data)
        
        return Response({
            'industry': industry,
            'peak_months': ['January', 'February', 'September', 'October'],
            'slow_months': ['July', 'August', 'December'],
            'best_time_to_apply': 'January and September are typically the best times to apply as companies have new hiring budgets.'
        })


class JobMarketHeatmapViewSet(viewsets.ReadOnlyModelViewSet):
    """ViewSet for job market heatmap data."""
    serializer_class = JobMarketHeatmapSerializer
    permission_classes = [IsAuthenticated]
    filter_backends = [DjangoFilterBackend, OrderingFilter]
    filterset_fields = ['country', 'industry', 'job_category', 'year']
    ordering = ['-job_count']
    
    def get_queryset(self):
        return JobMarketHeatmap.objects.all()
    
    @action(detail=False, methods=['get'])
    def by_country(self, request):
        """Get heatmap data for a country."""
        country = request.query_params.get('country', 'United States')
        industry = request.query_params.get('industry')
        
        query = self.get_queryset().filter(country=country)
        if industry:
            query = query.filter(industry=industry)
        
        serializer = self.get_serializer(query[:100], many=True)
        return Response(serializer.data)


class SuccessPredictionViewSet(viewsets.ModelViewSet):
    """ViewSet for success predictions."""
    serializer_class = SuccessPredictionSerializer
    permission_classes = [IsAuthenticated]
    ordering = ['-overall_score']
    
    def get_queryset(self):
        return SuccessPrediction.objects.filter(
            user=self.request.user
        ).select_related('application')
    
    @action(detail=False, methods=['post'])
    def predict(self, request):
        """Generate prediction for an application."""
        application_id = request.data.get('application_id')
        
        from apps.applications.models import JobApplication
        try:
            application = JobApplication.objects.get(
                id=application_id,
                user=request.user
            )
        except JobApplication.DoesNotExist:
            return Response({'error': 'Application not found'}, status=404)
        
        # Check for existing prediction
        existing = SuccessPrediction.objects.filter(application=application).first()
        if existing:
            serializer = self.get_serializer(existing)
            return Response(serializer.data)
        
        # Generate new prediction
        service = PredictionService()
        prediction = service.predict_success(application)
        
        serializer = self.get_serializer(prediction)
        return Response(serializer.data, status=status.HTTP_201_CREATED)


class JobSearchROIViewSet(viewsets.ModelViewSet):
    """ViewSet for job search ROI tracking."""
    serializer_class = JobSearchROISerializer
    permission_classes = [IsAuthenticated]
    ordering = ['-end_date']
    
    def get_queryset(self):
        return JobSearchROI.objects.filter(user=self.request.user)
    
    def perform_create(self, serializer):
        serializer.save(user=self.request.user)
    
    @action(detail=False, methods=['post'])
    def calculate(self, request):
        """Calculate ROI for a time period."""
        start_date = request.data.get('start_date')
        end_date = request.data.get('end_date', timezone.now().date())
        
        from apps.applications.models import JobApplication
        from apps.interviews.models import Interview
        
        applications = JobApplication.objects.filter(
            user=request.user,
            created_at__date__gte=start_date,
            created_at__date__lte=end_date
        )
        
        interviews = Interview.objects.filter(
            application__user=request.user,
            scheduled_at__date__gte=start_date,
            scheduled_at__date__lte=end_date
        )
        
        total_apps = applications.count()
        responses = applications.exclude(status='wishlist').exclude(status='applied').count()
        offers = applications.filter(status='offer').count() + applications.filter(status='accepted').count()
        
        roi_data = {
            'start_date': start_date,
            'end_date': end_date,
            'total_applications': total_apps,
            'responses_received': responses,
            'interviews_scheduled': interviews.count(),
            'offers_received': offers,
            'response_rate': (responses / total_apps * 100) if total_apps > 0 else 0,
            'interview_rate': (interviews.count() / total_apps * 100) if total_apps > 0 else 0,
            'offer_rate': (offers / total_apps * 100) if total_apps > 0 else 0,
        }
        
        return Response(roi_data)
