import uuid
from django.db import models
from django.conf import settings


class CompanyProfile(models.Model):
    """Pre-built company profiles and insights."""
    
    class CompanySize(models.TextChoices):
        STARTUP = 'startup', 'Startup (1-50)'
        SMALL = 'small', 'Small (51-200)'
        MEDIUM = 'medium', 'Medium (201-1000)'
        LARGE = 'large', 'Large (1001-5000)'
        ENTERPRISE = 'enterprise', 'Enterprise (5000+)'
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    
    # Basic info
    name = models.CharField(max_length=200, db_index=True)
    domain = models.CharField(max_length=100, unique=True)
    description = models.TextField(blank=True)
    
    # Company details
    industry = models.CharField(max_length=100, blank=True)
    sub_industry = models.CharField(max_length=100, blank=True)
    company_size = models.CharField(
        max_length=20,
        choices=CompanySize.choices,
        blank=True
    )
    employee_count = models.PositiveIntegerField(null=True, blank=True)
    founded_year = models.PositiveIntegerField(null=True, blank=True)
    
    # Location
    headquarters = models.CharField(max_length=200, blank=True)
    locations = models.JSONField(default=list, blank=True)
    
    # Financials (public info)
    is_public = models.BooleanField(default=False)
    stock_symbol = models.CharField(max_length=20, blank=True)
    estimated_revenue = models.CharField(max_length=100, blank=True)
    funding_stage = models.CharField(max_length=50, blank=True)  # Seed, Series A, etc.
    total_funding = models.CharField(max_length=100, blank=True)
    
    # Links
    website = models.URLField(blank=True)
    linkedin_url = models.URLField(blank=True)
    glassdoor_url = models.URLField(blank=True)
    careers_page = models.URLField(blank=True)
    
    # Logos
    logo_url = models.URLField(blank=True)
    
    # Ratings
    glassdoor_rating = models.DecimalField(
        max_digits=3,
        decimal_places=2,
        null=True,
        blank=True
    )
    employee_satisfaction = models.DecimalField(
        max_digits=5,
        decimal_places=2,
        null=True,
        blank=True
    )
    
    # Culture & benefits
    culture_keywords = models.JSONField(default=list, blank=True)
    benefits = models.JSONField(default=list, blank=True)
    tech_stack = models.JSONField(default=list, blank=True)
    
    # Hiring info
    is_hiring = models.BooleanField(default=True)
    open_positions_count = models.PositiveIntegerField(default=0)
    hiring_velocity = models.CharField(max_length=50, blank=True)  # Growing fast, stable, etc.
    
    # Interview process
    interview_difficulty = models.DecimalField(
        max_digits=3,
        decimal_places=2,
        null=True,
        blank=True
    )  # 1-5 scale
    typical_interview_rounds = models.PositiveIntegerField(null=True, blank=True)
    interview_process = models.JSONField(default=list, blank=True)
    
    # AI insights
    ai_summary = models.TextField(blank=True)
    ai_pros = models.JSONField(default=list, blank=True)
    ai_cons = models.JSONField(default=list, blank=True)
    
    # Data freshness
    last_updated = models.DateTimeField(auto_now=True)
    data_source = models.CharField(max_length=100, blank=True)
    
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        ordering = ['name']
        indexes = [
            models.Index(fields=['industry']),
            models.Index(fields=['company_size']),
        ]
    
    def __str__(self):
        return self.name


class SalaryData(models.Model):
    """Salary data for roles and companies."""
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    
    # Role
    job_title = models.CharField(max_length=200, db_index=True)
    normalized_title = models.CharField(max_length=200, db_index=True)
    seniority_level = models.CharField(max_length=50, blank=True)  # Junior, Mid, Senior, etc.
    
    # Company (optional - for company-specific data)
    company = models.ForeignKey(
        CompanyProfile,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='salary_data'
    )
    company_name = models.CharField(max_length=200, blank=True)
    
    # Location
    location = models.CharField(max_length=200)
    country = models.CharField(max_length=100)
    region = models.CharField(max_length=100, blank=True)
    is_remote = models.BooleanField(default=False)
    
    # Salary range
    currency = models.CharField(max_length=3, default='USD')
    salary_min = models.DecimalField(max_digits=12, decimal_places=2)
    salary_max = models.DecimalField(max_digits=12, decimal_places=2)
    salary_median = models.DecimalField(max_digits=12, decimal_places=2, null=True, blank=True)
    
    # Additional compensation
    bonus_min = models.DecimalField(max_digits=12, decimal_places=2, null=True, blank=True)
    bonus_max = models.DecimalField(max_digits=12, decimal_places=2, null=True, blank=True)
    equity_min = models.DecimalField(max_digits=12, decimal_places=2, null=True, blank=True)
    equity_max = models.DecimalField(max_digits=12, decimal_places=2, null=True, blank=True)
    
    # Total compensation
    total_comp_min = models.DecimalField(max_digits=12, decimal_places=2, null=True, blank=True)
    total_comp_max = models.DecimalField(max_digits=12, decimal_places=2, null=True, blank=True)
    
    # Industry
    industry = models.CharField(max_length=100, blank=True)
    
    # Data quality
    sample_size = models.PositiveIntegerField(default=1)
    confidence_score = models.DecimalField(
        max_digits=5,
        decimal_places=2,
        null=True,
        blank=True
    )
    data_source = models.CharField(max_length=100, blank=True)
    
    # Date
    year = models.PositiveIntegerField()
    quarter = models.PositiveIntegerField(null=True, blank=True)
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        ordering = ['-year', '-salary_median']
        indexes = [
            models.Index(fields=['normalized_title', 'location']),
            models.Index(fields=['industry', 'year']),
        ]
    
    def __str__(self):
        return f"{self.job_title} - {self.location}"


class IndustryTrend(models.Model):
    """Industry-level trends and insights."""
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    
    industry = models.CharField(max_length=100, db_index=True)
    sub_industry = models.CharField(max_length=100, blank=True)
    
    # Hiring trends
    hiring_trend = models.CharField(max_length=50)  # Growing, Stable, Declining
    growth_rate = models.DecimalField(
        max_digits=5,
        decimal_places=2,
        null=True,
        blank=True
    )  # Percentage
    
    # Job market
    open_positions = models.PositiveIntegerField(default=0)
    average_time_to_fill = models.PositiveIntegerField(null=True, blank=True)  # Days
    competition_level = models.CharField(max_length=50, blank=True)  # Low, Medium, High
    
    # Salary trends
    average_salary = models.DecimalField(max_digits=12, decimal_places=2, null=True, blank=True)
    salary_growth_rate = models.DecimalField(
        max_digits=5,
        decimal_places=2,
        null=True,
        blank=True
    )
    
    # Top skills in demand
    top_skills = models.JSONField(default=list)
    emerging_skills = models.JSONField(default=list)
    declining_skills = models.JSONField(default=list)
    
    # Top companies hiring
    top_hiring_companies = models.JSONField(default=list)
    
    # Location trends
    top_locations = models.JSONField(default=list)
    remote_percentage = models.DecimalField(
        max_digits=5,
        decimal_places=2,
        null=True,
        blank=True
    )
    
    # AI insights
    ai_summary = models.TextField(blank=True)
    ai_predictions = models.JSONField(default=list)
    
    # Date
    year = models.PositiveIntegerField()
    quarter = models.PositiveIntegerField(null=True, blank=True)
    month = models.PositiveIntegerField(null=True, blank=True)
    
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        ordering = ['-year', '-quarter']
    
    def __str__(self):
        return f"{self.industry} Trends - Q{self.quarter} {self.year}"


class HiringSeasonData(models.Model):
    """Historical hiring patterns by month/quarter."""
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    
    industry = models.CharField(max_length=100, db_index=True)
    job_category = models.CharField(max_length=100, blank=True)
    
    # Monthly hiring index (100 = average)
    january_index = models.DecimalField(max_digits=6, decimal_places=2, default=100)
    february_index = models.DecimalField(max_digits=6, decimal_places=2, default=100)
    march_index = models.DecimalField(max_digits=6, decimal_places=2, default=100)
    april_index = models.DecimalField(max_digits=6, decimal_places=2, default=100)
    may_index = models.DecimalField(max_digits=6, decimal_places=2, default=100)
    june_index = models.DecimalField(max_digits=6, decimal_places=2, default=100)
    july_index = models.DecimalField(max_digits=6, decimal_places=2, default=100)
    august_index = models.DecimalField(max_digits=6, decimal_places=2, default=100)
    september_index = models.DecimalField(max_digits=6, decimal_places=2, default=100)
    october_index = models.DecimalField(max_digits=6, decimal_places=2, default=100)
    november_index = models.DecimalField(max_digits=6, decimal_places=2, default=100)
    december_index = models.DecimalField(max_digits=6, decimal_places=2, default=100)
    
    # Best times to apply
    peak_months = models.JSONField(default=list)
    slow_months = models.JSONField(default=list)
    
    # AI recommendations
    best_time_to_apply = models.TextField(blank=True)
    
    year = models.PositiveIntegerField()
    
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        unique_together = ['industry', 'job_category', 'year']
    
    def __str__(self):
        return f"Hiring Seasons - {self.industry} {self.year}"


class JobMarketHeatmap(models.Model):
    """Geographic job opportunity data."""
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    
    # Location
    city = models.CharField(max_length=100)
    state = models.CharField(max_length=100, blank=True)
    country = models.CharField(max_length=100)
    latitude = models.DecimalField(max_digits=9, decimal_places=6, null=True, blank=True)
    longitude = models.DecimalField(max_digits=9, decimal_places=6, null=True, blank=True)
    
    # Job data
    job_category = models.CharField(max_length=100, blank=True)
    industry = models.CharField(max_length=100, blank=True)
    
    # Metrics
    job_count = models.PositiveIntegerField(default=0)
    companies_count = models.PositiveIntegerField(default=0)
    average_salary = models.DecimalField(max_digits=12, decimal_places=2, null=True, blank=True)
    cost_of_living_index = models.DecimalField(max_digits=6, decimal_places=2, null=True, blank=True)
    
    # Adjusted salary (accounting for COL)
    adjusted_salary = models.DecimalField(max_digits=12, decimal_places=2, null=True, blank=True)
    
    # Growth
    job_growth_rate = models.DecimalField(
        max_digits=5,
        decimal_places=2,
        null=True,
        blank=True
    )
    
    year = models.PositiveIntegerField()
    month = models.PositiveIntegerField(null=True, blank=True)
    
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        ordering = ['-job_count']
    
    def __str__(self):
        return f"{self.city}, {self.country} - {self.job_count} jobs"


class SuccessPrediction(models.Model):
    """ML-based success predictions for applications."""
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='success_predictions'
    )
    application = models.OneToOneField(
        'applications.JobApplication',
        on_delete=models.CASCADE,
        related_name='prediction'
    )
    
    # Prediction scores (0-100)
    overall_score = models.DecimalField(max_digits=5, decimal_places=2)
    
    # Component scores
    skill_match_score = models.DecimalField(max_digits=5, decimal_places=2, null=True)
    experience_match_score = models.DecimalField(max_digits=5, decimal_places=2, null=True)
    company_fit_score = models.DecimalField(max_digits=5, decimal_places=2, null=True)
    resume_quality_score = models.DecimalField(max_digits=5, decimal_places=2, null=True)
    
    # Predictions
    response_probability = models.DecimalField(max_digits=5, decimal_places=2, null=True)
    interview_probability = models.DecimalField(max_digits=5, decimal_places=2, null=True)
    offer_probability = models.DecimalField(max_digits=5, decimal_places=2, null=True)
    
    # Insights
    strengths = models.JSONField(default=list)
    weaknesses = models.JSONField(default=list)
    recommendations = models.JSONField(default=list)
    
    # Comparable data
    similar_applications_count = models.PositiveIntegerField(default=0)
    similar_success_rate = models.DecimalField(
        max_digits=5,
        decimal_places=2,
        null=True,
        blank=True
    )
    
    # Model info
    model_version = models.CharField(max_length=50)
    
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        ordering = ['-overall_score']
    
    def __str__(self):
        return f"Prediction for {self.application} - {self.overall_score}%"


class JobSearchROI(models.Model):
    """Track ROI of job search efforts."""
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='job_search_roi'
    )
    
    # Time period
    start_date = models.DateField()
    end_date = models.DateField()
    
    # Effort metrics
    total_applications = models.PositiveIntegerField(default=0)
    total_hours_spent = models.DecimalField(max_digits=8, decimal_places=2, default=0)
    resume_versions_created = models.PositiveIntegerField(default=0)
    networking_events_attended = models.PositiveIntegerField(default=0)
    courses_completed = models.PositiveIntegerField(default=0)
    
    # Results
    responses_received = models.PositiveIntegerField(default=0)
    interviews_scheduled = models.PositiveIntegerField(default=0)
    interviews_completed = models.PositiveIntegerField(default=0)
    offers_received = models.PositiveIntegerField(default=0)
    
    # Rates
    response_rate = models.DecimalField(max_digits=5, decimal_places=2, null=True, blank=True)
    interview_rate = models.DecimalField(max_digits=5, decimal_places=2, null=True, blank=True)
    offer_rate = models.DecimalField(max_digits=5, decimal_places=2, null=True, blank=True)
    
    # Financials (if offer accepted)
    initial_salary = models.DecimalField(max_digits=12, decimal_places=2, null=True, blank=True)
    final_salary = models.DecimalField(max_digits=12, decimal_places=2, null=True, blank=True)
    salary_increase = models.DecimalField(max_digits=12, decimal_places=2, null=True, blank=True)
    
    # ROI calculation
    estimated_job_search_cost = models.DecimalField(
        max_digits=12,
        decimal_places=2,
        null=True,
        blank=True
    )  # Time * hourly rate
    roi_percentage = models.DecimalField(
        max_digits=10,
        decimal_places=2,
        null=True,
        blank=True
    )
    
    # AI insights
    efficiency_score = models.DecimalField(max_digits=5, decimal_places=2, null=True, blank=True)
    recommendations = models.JSONField(default=list)
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        ordering = ['-end_date']
    
    def __str__(self):
        return f"ROI Report {self.start_date} - {self.end_date}"
