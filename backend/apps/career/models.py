import uuid
from django.db import models
from django.conf import settings


class Skill(models.Model):
    """Skills database with categorization."""
    
    class Category(models.TextChoices):
        TECHNICAL = 'technical', 'Technical'
        SOFT = 'soft', 'Soft Skills'
        LANGUAGE = 'language', 'Language'
        TOOLS = 'tools', 'Tools & Software'
        FRAMEWORK = 'framework', 'Framework'
        CERTIFICATION = 'certification', 'Certification'
        OTHER = 'other', 'Other'
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    name = models.CharField(max_length=100, unique=True)
    normalized_name = models.CharField(max_length=100, db_index=True)
    category = models.CharField(
        max_length=20,
        choices=Category.choices,
        default=Category.TECHNICAL
    )
    
    # Related skills
    related_skills = models.ManyToManyField('self', blank=True)
    
    # Popularity for autocomplete
    usage_count = models.PositiveIntegerField(default=0)
    
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        ordering = ['-usage_count', 'name']
    
    def save(self, *args, **kwargs):
        self.normalized_name = self.name.lower().strip()
        super().save(*args, **kwargs)
    
    def __str__(self):
        return self.name


class UserSkill(models.Model):
    """User's skills with proficiency levels."""
    
    class ProficiencyLevel(models.TextChoices):
        BEGINNER = 'beginner', 'Beginner'
        INTERMEDIATE = 'intermediate', 'Intermediate'
        ADVANCED = 'advanced', 'Advanced'
        EXPERT = 'expert', 'Expert'
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='user_skills'
    )
    skill = models.ForeignKey(
        Skill,
        on_delete=models.CASCADE,
        related_name='user_skills'
    )
    
    proficiency = models.CharField(
        max_length=20,
        choices=ProficiencyLevel.choices,
        default=ProficiencyLevel.INTERMEDIATE
    )
    years_of_experience = models.DecimalField(
        max_digits=4,
        decimal_places=1,
        default=0
    )
    
    # Endorsements or validations
    is_verified = models.BooleanField(default=False)  # Through certification
    last_used = models.DateField(null=True, blank=True)
    
    # AI confidence score
    ai_assessed_level = models.CharField(max_length=20, blank=True)
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        unique_together = ['user', 'skill']
        ordering = ['-proficiency', '-years_of_experience']
    
    def __str__(self):
        return f"{self.user.email} - {self.skill.name}"


class SkillGapAnalysis(models.Model):
    """AI-generated skill gap analysis for target roles."""
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='skill_gap_analyses'
    )
    
    # Target role
    target_role = models.CharField(max_length=200)
    target_company = models.CharField(max_length=200, blank=True)
    target_industry = models.CharField(max_length=100, blank=True)
    
    # Analysis results
    required_skills = models.JSONField(default=list)  # [{skill, importance, level_needed}]
    current_skills = models.JSONField(default=list)   # [{skill, current_level}]
    gap_skills = models.JSONField(default=list)       # [{skill, gap_severity, recommendations}]
    
    # Matching score
    match_percentage = models.DecimalField(
        max_digits=5,
        decimal_places=2,
        default=0
    )
    
    # AI insights
    summary = models.TextField(blank=True)
    recommendations = models.JSONField(default=list)
    estimated_time_to_bridge = models.CharField(max_length=100, blank=True)  # e.g., "3-6 months"
    
    # From job application
    application = models.ForeignKey(
        'applications.JobApplication',
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='skill_analyses'
    )
    
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        ordering = ['-created_at']
    
    def __str__(self):
        return f"Skill Gap Analysis for {self.target_role} - {self.user.email}"


class LearningResource(models.Model):
    """Learning resources for skill development."""
    
    class ResourceType(models.TextChoices):
        COURSE = 'course', 'Online Course'
        BOOK = 'book', 'Book'
        TUTORIAL = 'tutorial', 'Tutorial'
        CERTIFICATION = 'certification', 'Certification'
        BOOTCAMP = 'bootcamp', 'Bootcamp'
        WORKSHOP = 'workshop', 'Workshop'
        PROJECT = 'project', 'Practice Project'
        OTHER = 'other', 'Other'
    
    class Platform(models.TextChoices):
        COURSERA = 'coursera', 'Coursera'
        UDEMY = 'udemy', 'Udemy'
        LINKEDIN = 'linkedin', 'LinkedIn Learning'
        PLURALSIGHT = 'pluralsight', 'Pluralsight'
        UDACITY = 'udacity', 'Udacity'
        EDEX = 'edx', 'edX'
        YOUTUBE = 'youtube', 'YouTube'
        FREECODECAMP = 'freecodecamp', 'freeCodeCamp'
        OTHER = 'other', 'Other'
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    
    title = models.CharField(max_length=300)
    description = models.TextField(blank=True)
    url = models.URLField()
    
    resource_type = models.CharField(
        max_length=20,
        choices=ResourceType.choices,
        default=ResourceType.COURSE
    )
    platform = models.CharField(
        max_length=20,
        choices=Platform.choices,
        default=Platform.OTHER
    )
    
    # Skills covered
    skills = models.ManyToManyField(Skill, related_name='learning_resources')
    
    # Details
    duration_hours = models.DecimalField(
        max_digits=6,
        decimal_places=1,
        null=True,
        blank=True
    )
    difficulty_level = models.CharField(max_length=20, blank=True)
    is_free = models.BooleanField(default=False)
    price = models.DecimalField(max_digits=8, decimal_places=2, null=True, blank=True)
    
    # Ratings
    rating = models.DecimalField(max_digits=3, decimal_places=2, null=True, blank=True)
    reviews_count = models.PositiveIntegerField(default=0)
    
    # AI recommended
    is_ai_recommended = models.BooleanField(default=False)
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        ordering = ['-rating', '-reviews_count']
    
    def __str__(self):
        return self.title


class UserLearningProgress(models.Model):
    """Track user's learning progress."""
    
    class Status(models.TextChoices):
        NOT_STARTED = 'not_started', 'Not Started'
        IN_PROGRESS = 'in_progress', 'In Progress'
        COMPLETED = 'completed', 'Completed'
        DROPPED = 'dropped', 'Dropped'
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='learning_progress'
    )
    resource = models.ForeignKey(
        LearningResource,
        on_delete=models.CASCADE,
        related_name='user_progress'
    )
    
    status = models.CharField(
        max_length=20,
        choices=Status.choices,
        default=Status.NOT_STARTED
    )
    progress_percentage = models.PositiveIntegerField(default=0)
    
    # Time tracking
    started_at = models.DateTimeField(null=True, blank=True)
    completed_at = models.DateTimeField(null=True, blank=True)
    total_time_spent_minutes = models.PositiveIntegerField(default=0)
    
    # Notes
    notes = models.TextField(blank=True)
    
    # Rating and review
    user_rating = models.PositiveIntegerField(null=True, blank=True)  # 1-5
    user_review = models.TextField(blank=True)
    
    # Certificate
    certificate_url = models.URLField(blank=True)
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        unique_together = ['user', 'resource']
        ordering = ['-updated_at']
    
    def __str__(self):
        return f"{self.user.email} - {self.resource.title}"


class LearningPath(models.Model):
    """Curated learning paths for career goals."""
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    
    name = models.CharField(max_length=200)
    description = models.TextField()
    
    # Target role
    target_role = models.CharField(max_length=200)
    target_level = models.CharField(max_length=50, blank=True)  # Junior, Senior, etc.
    
    # Resources in order
    resources = models.ManyToManyField(
        LearningResource,
        through='LearningPathResource',
        related_name='learning_paths'
    )
    
    # Skills covered
    skills = models.ManyToManyField(Skill, related_name='learning_paths')
    
    # Estimated completion
    estimated_weeks = models.PositiveIntegerField(default=12)
    total_hours = models.PositiveIntegerField(default=0)
    
    # Popularity
    followers_count = models.PositiveIntegerField(default=0)
    
    # AI generated
    is_ai_generated = models.BooleanField(default=False)
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        ordering = ['-followers_count']
    
    def __str__(self):
        return self.name


class LearningPathResource(models.Model):
    """Ordered resources within a learning path."""
    
    learning_path = models.ForeignKey(LearningPath, on_delete=models.CASCADE)
    resource = models.ForeignKey(LearningResource, on_delete=models.CASCADE)
    order = models.PositiveIntegerField(default=0)
    is_required = models.BooleanField(default=True)
    
    class Meta:
        ordering = ['order']
        unique_together = ['learning_path', 'resource']


class UserLearningPath(models.Model):
    """User's enrolled learning paths."""
    
    class Status(models.TextChoices):
        ACTIVE = 'active', 'Active'
        PAUSED = 'paused', 'Paused'
        COMPLETED = 'completed', 'Completed'
        DROPPED = 'dropped', 'Dropped'
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='learning_paths'
    )
    learning_path = models.ForeignKey(
        LearningPath,
        on_delete=models.CASCADE,
        related_name='enrolled_users'
    )
    
    status = models.CharField(
        max_length=20,
        choices=Status.choices,
        default=Status.ACTIVE
    )
    progress_percentage = models.PositiveIntegerField(default=0)
    
    started_at = models.DateTimeField(auto_now_add=True)
    completed_at = models.DateTimeField(null=True, blank=True)
    
    class Meta:
        unique_together = ['user', 'learning_path']
        ordering = ['-started_at']
    
    def __str__(self):
        return f"{self.user.email} - {self.learning_path.name}"


class PortfolioProject(models.Model):
    """User portfolio projects."""
    
    class ProjectType(models.TextChoices):
        WEB = 'web', 'Web Application'
        MOBILE = 'mobile', 'Mobile App'
        API = 'api', 'API/Backend'
        DATA = 'data', 'Data Science'
        ML = 'ml', 'Machine Learning'
        DESIGN = 'design', 'Design'
        WRITING = 'writing', 'Writing/Content'
        OTHER = 'other', 'Other'
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='portfolio_projects'
    )
    
    title = models.CharField(max_length=200)
    description = models.TextField()
    
    project_type = models.CharField(
        max_length=20,
        choices=ProjectType.choices,
        default=ProjectType.WEB
    )
    
    # Links
    live_url = models.URLField(blank=True)
    github_url = models.URLField(blank=True)
    demo_video_url = models.URLField(blank=True)
    
    # Media
    thumbnail = models.ImageField(upload_to='portfolio/thumbnails/', null=True, blank=True)
    images = models.JSONField(default=list, blank=True)  # List of image URLs
    
    # Technical details
    technologies = models.JSONField(default=list)  # List of tech used
    skills_demonstrated = models.ManyToManyField(Skill, related_name='portfolio_projects', blank=True)
    
    # Details
    challenges = models.TextField(blank=True)
    outcomes = models.TextField(blank=True)
    
    # Visibility
    is_public = models.BooleanField(default=True)
    is_featured = models.BooleanField(default=False)
    
    # Dates
    start_date = models.DateField(null=True, blank=True)
    end_date = models.DateField(null=True, blank=True)
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        ordering = ['-is_featured', '-created_at']
    
    def __str__(self):
        return self.title


class CareerGoal(models.Model):
    """User's career goals and milestones."""
    
    class GoalType(models.TextChoices):
        ROLE = 'role', 'Target Role'
        SALARY = 'salary', 'Salary Target'
        SKILL = 'skill', 'Skill Acquisition'
        CERTIFICATION = 'certification', 'Certification'
        COMPANY = 'company', 'Target Company'
        INDUSTRY = 'industry', 'Industry Change'
        CUSTOM = 'custom', 'Custom Goal'
    
    class TimeFrame(models.TextChoices):
        SHORT = 'short', 'Short Term (0-6 months)'
        MEDIUM = 'medium', 'Medium Term (6-18 months)'
        LONG = 'long', 'Long Term (18+ months)'
    
    class Status(models.TextChoices):
        NOT_STARTED = 'not_started', 'Not Started'
        IN_PROGRESS = 'in_progress', 'In Progress'
        ACHIEVED = 'achieved', 'Achieved'
        DEFERRED = 'deferred', 'Deferred'
        ABANDONED = 'abandoned', 'Abandoned'
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='career_goals'
    )
    
    title = models.CharField(max_length=200)
    description = models.TextField(blank=True)
    
    goal_type = models.CharField(
        max_length=20,
        choices=GoalType.choices,
        default=GoalType.ROLE
    )
    time_frame = models.CharField(
        max_length=20,
        choices=TimeFrame.choices,
        default=TimeFrame.MEDIUM
    )
    status = models.CharField(
        max_length=20,
        choices=Status.choices,
        default=Status.NOT_STARTED
    )
    
    # Target details
    target_value = models.CharField(max_length=200, blank=True)  # Role name, salary, etc.
    target_date = models.DateField(null=True, blank=True)
    
    # Progress
    progress_percentage = models.PositiveIntegerField(default=0)
    milestones = models.JSONField(default=list)  # [{title, completed, date}]
    
    # AI insights
    ai_recommendations = models.JSONField(default=list)
    
    achieved_at = models.DateTimeField(null=True, blank=True)
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        ordering = ['-created_at']
    
    def __str__(self):
        return f"{self.title} - {self.user.email}"


class CareerPathPlan(models.Model):
    """Long-term career trajectory planning."""
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='career_plans'
    )
    
    name = models.CharField(max_length=200)
    
    # Current state
    current_role = models.CharField(max_length=200)
    current_level = models.CharField(max_length=50, blank=True)
    current_salary = models.DecimalField(max_digits=12, decimal_places=2, null=True, blank=True)
    
    # Target state
    target_role = models.CharField(max_length=200)
    target_level = models.CharField(max_length=50, blank=True)
    target_salary = models.DecimalField(max_digits=12, decimal_places=2, null=True, blank=True)
    target_timeline_years = models.PositiveIntegerField(default=5)
    
    # Career stages
    stages = models.JSONField(default=list)  # [{role, timeline, requirements, salary_range}]
    
    # AI analysis
    ai_analysis = models.TextField(blank=True)
    success_probability = models.DecimalField(max_digits=5, decimal_places=2, null=True, blank=True)
    
    # Market data
    market_demand = models.JSONField(default=dict)  # Industry trends for target role
    
    is_active = models.BooleanField(default=True)
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        ordering = ['-updated_at']
    
    def __str__(self):
        return f"{self.name} - {self.user.email}"
