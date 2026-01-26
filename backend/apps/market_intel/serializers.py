from rest_framework import serializers
from .models import (
    CompanyProfile,
    SalaryData,
    IndustryTrend,
    HiringSeasonData,
    JobMarketHeatmap,
    SuccessPrediction,
    JobSearchROI,
)


class CompanyProfileSerializer(serializers.ModelSerializer):
    """Serializer for CompanyProfile."""
    
    class Meta:
        model = CompanyProfile
        fields = [
            'id', 'name', 'domain', 'description', 'industry', 'sub_industry',
            'company_size', 'employee_count', 'founded_year',
            'headquarters', 'locations', 'is_public', 'stock_symbol',
            'estimated_revenue', 'funding_stage', 'total_funding',
            'website', 'linkedin_url', 'glassdoor_url', 'careers_page',
            'logo_url', 'glassdoor_rating', 'employee_satisfaction',
            'culture_keywords', 'benefits', 'tech_stack',
            'is_hiring', 'open_positions_count', 'hiring_velocity',
            'interview_difficulty', 'typical_interview_rounds', 'interview_process',
            'ai_summary', 'ai_pros', 'ai_cons', 'last_updated', 'created_at'
        ]
        read_only_fields = ['id', 'last_updated', 'created_at']


class CompanyProfileSummarySerializer(serializers.ModelSerializer):
    """Lightweight serializer for company listings."""
    
    class Meta:
        model = CompanyProfile
        fields = [
            'id', 'name', 'domain', 'industry', 'company_size',
            'logo_url', 'glassdoor_rating', 'is_hiring', 'open_positions_count'
        ]


class SalaryDataSerializer(serializers.ModelSerializer):
    """Serializer for SalaryData."""
    company_details = CompanyProfileSummarySerializer(source='company', read_only=True)
    
    class Meta:
        model = SalaryData
        fields = [
            'id', 'job_title', 'normalized_title', 'seniority_level',
            'company', 'company_details', 'company_name',
            'location', 'country', 'region', 'is_remote',
            'currency', 'salary_min', 'salary_max', 'salary_median',
            'bonus_min', 'bonus_max', 'equity_min', 'equity_max',
            'total_comp_min', 'total_comp_max', 'industry',
            'sample_size', 'confidence_score', 'data_source',
            'year', 'quarter', 'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'created_at', 'updated_at']


class IndustryTrendSerializer(serializers.ModelSerializer):
    """Serializer for IndustryTrend."""
    
    class Meta:
        model = IndustryTrend
        fields = [
            'id', 'industry', 'sub_industry', 'hiring_trend', 'growth_rate',
            'open_positions', 'average_time_to_fill', 'competition_level',
            'average_salary', 'salary_growth_rate',
            'top_skills', 'emerging_skills', 'declining_skills',
            'top_hiring_companies', 'top_locations', 'remote_percentage',
            'ai_summary', 'ai_predictions', 'year', 'quarter', 'month', 'created_at'
        ]


class HiringSeasonDataSerializer(serializers.ModelSerializer):
    """Serializer for HiringSeasonData."""
    monthly_data = serializers.SerializerMethodField()
    
    class Meta:
        model = HiringSeasonData
        fields = [
            'id', 'industry', 'job_category', 'monthly_data',
            'peak_months', 'slow_months', 'best_time_to_apply', 'year'
        ]
    
    def get_monthly_data(self, obj):
        return [
            {'month': 'January', 'index': float(obj.january_index)},
            {'month': 'February', 'index': float(obj.february_index)},
            {'month': 'March', 'index': float(obj.march_index)},
            {'month': 'April', 'index': float(obj.april_index)},
            {'month': 'May', 'index': float(obj.may_index)},
            {'month': 'June', 'index': float(obj.june_index)},
            {'month': 'July', 'index': float(obj.july_index)},
            {'month': 'August', 'index': float(obj.august_index)},
            {'month': 'September', 'index': float(obj.september_index)},
            {'month': 'October', 'index': float(obj.october_index)},
            {'month': 'November', 'index': float(obj.november_index)},
            {'month': 'December', 'index': float(obj.december_index)},
        ]


class JobMarketHeatmapSerializer(serializers.ModelSerializer):
    """Serializer for JobMarketHeatmap."""
    
    class Meta:
        model = JobMarketHeatmap
        fields = [
            'id', 'city', 'state', 'country', 'latitude', 'longitude',
            'job_category', 'industry', 'job_count', 'companies_count',
            'average_salary', 'cost_of_living_index', 'adjusted_salary',
            'job_growth_rate', 'year', 'month', 'created_at'
        ]


class SuccessPredictionSerializer(serializers.ModelSerializer):
    """Serializer for SuccessPrediction."""
    application_title = serializers.CharField(source='application.job_title', read_only=True)
    application_company = serializers.CharField(source='application.company_name', read_only=True)
    
    class Meta:
        model = SuccessPrediction
        fields = [
            'id', 'application', 'application_title', 'application_company',
            'overall_score', 'skill_match_score', 'experience_match_score',
            'company_fit_score', 'resume_quality_score',
            'response_probability', 'interview_probability', 'offer_probability',
            'strengths', 'weaknesses', 'recommendations',
            'similar_applications_count', 'similar_success_rate',
            'model_version', 'created_at'
        ]
        read_only_fields = ['id', 'created_at']


class JobSearchROISerializer(serializers.ModelSerializer):
    """Serializer for JobSearchROI."""
    
    class Meta:
        model = JobSearchROI
        fields = [
            'id', 'start_date', 'end_date',
            'total_applications', 'total_hours_spent', 'resume_versions_created',
            'networking_events_attended', 'courses_completed',
            'responses_received', 'interviews_scheduled', 'interviews_completed',
            'offers_received', 'response_rate', 'interview_rate', 'offer_rate',
            'initial_salary', 'final_salary', 'salary_increase',
            'estimated_job_search_cost', 'roi_percentage',
            'efficiency_score', 'recommendations', 'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'created_at', 'updated_at']
