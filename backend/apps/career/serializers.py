from rest_framework import serializers
from .models import (
    Skill,
    UserSkill,
    SkillGapAnalysis,
    LearningResource,
    UserLearningProgress,
    LearningPath,
    LearningPathResource,
    UserLearningPath,
    PortfolioProject,
    CareerGoal,
    CareerPathPlan,
)


class SkillSerializer(serializers.ModelSerializer):
    """Serializer for Skill model."""
    
    class Meta:
        model = Skill
        fields = ['id', 'name', 'category', 'usage_count', 'created_at']
        read_only_fields = ['id', 'normalized_name', 'usage_count', 'created_at']


class UserSkillSerializer(serializers.ModelSerializer):
    """Serializer for UserSkill model."""
    skill_details = SkillSerializer(source='skill', read_only=True)
    skill_name = serializers.CharField(write_only=True, required=False)
    
    class Meta:
        model = UserSkill
        fields = [
            'id', 'skill', 'skill_details', 'skill_name',
            'proficiency', 'years_of_experience', 'is_verified',
            'last_used', 'ai_assessed_level', 'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'ai_assessed_level', 'created_at', 'updated_at']
    
    def create(self, validated_data):
        skill_name = validated_data.pop('skill_name', None)
        if skill_name and 'skill' not in validated_data:
            skill, _ = Skill.objects.get_or_create(
                normalized_name=skill_name.lower().strip(),
                defaults={'name': skill_name}
            )
            skill.usage_count += 1
            skill.save()
            validated_data['skill'] = skill
        return super().create(validated_data)


class SkillGapAnalysisSerializer(serializers.ModelSerializer):
    """Serializer for SkillGapAnalysis model."""
    
    class Meta:
        model = SkillGapAnalysis
        fields = [
            'id', 'target_role', 'target_company', 'target_industry',
            'required_skills', 'current_skills', 'gap_skills',
            'match_percentage', 'summary', 'recommendations',
            'estimated_time_to_bridge', 'application', 'created_at'
        ]
        read_only_fields = [
            'id', 'required_skills', 'current_skills', 'gap_skills',
            'match_percentage', 'summary', 'recommendations',
            'estimated_time_to_bridge', 'created_at'
        ]


class LearningResourceSerializer(serializers.ModelSerializer):
    """Serializer for LearningResource model."""
    skills_list = SkillSerializer(source='skills', many=True, read_only=True)
    user_progress = serializers.SerializerMethodField()
    
    class Meta:
        model = LearningResource
        fields = [
            'id', 'title', 'description', 'url',
            'resource_type', 'platform', 'skills', 'skills_list',
            'duration_hours', 'difficulty_level', 'is_free', 'price',
            'rating', 'reviews_count', 'is_ai_recommended',
            'user_progress', 'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'created_at', 'updated_at']
    
    def get_user_progress(self, obj):
        request = self.context.get('request')
        if request and request.user.is_authenticated:
            progress = obj.user_progress.filter(user=request.user).first()
            if progress:
                return {
                    'status': progress.status,
                    'progress_percentage': progress.progress_percentage
                }
        return None


class UserLearningProgressSerializer(serializers.ModelSerializer):
    """Serializer for UserLearningProgress model."""
    resource_details = LearningResourceSerializer(source='resource', read_only=True)
    
    class Meta:
        model = UserLearningProgress
        fields = [
            'id', 'resource', 'resource_details', 'status', 'progress_percentage',
            'started_at', 'completed_at', 'total_time_spent_minutes',
            'notes', 'user_rating', 'user_review', 'certificate_url',
            'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'created_at', 'updated_at']


class LearningPathResourceSerializer(serializers.ModelSerializer):
    """Serializer for LearningPathResource through model."""
    resource = LearningResourceSerializer(read_only=True)
    
    class Meta:
        model = LearningPathResource
        fields = ['resource', 'order', 'is_required']


class LearningPathSerializer(serializers.ModelSerializer):
    """Serializer for LearningPath model."""
    resources_list = LearningPathResourceSerializer(
        source='learningpathresource_set',
        many=True,
        read_only=True
    )
    skills_list = SkillSerializer(source='skills', many=True, read_only=True)
    user_enrollment = serializers.SerializerMethodField()
    
    class Meta:
        model = LearningPath
        fields = [
            'id', 'name', 'description', 'target_role', 'target_level',
            'resources_list', 'skills', 'skills_list',
            'estimated_weeks', 'total_hours', 'followers_count',
            'is_ai_generated', 'user_enrollment', 'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'followers_count', 'created_at', 'updated_at']
    
    def get_user_enrollment(self, obj):
        request = self.context.get('request')
        if request and request.user.is_authenticated:
            enrollment = obj.enrolled_users.filter(user=request.user).first()
            if enrollment:
                return {
                    'status': enrollment.status,
                    'progress_percentage': enrollment.progress_percentage
                }
        return None


class UserLearningPathSerializer(serializers.ModelSerializer):
    """Serializer for UserLearningPath model."""
    learning_path_details = LearningPathSerializer(source='learning_path', read_only=True)
    
    class Meta:
        model = UserLearningPath
        fields = [
            'id', 'learning_path', 'learning_path_details',
            'status', 'progress_percentage', 'started_at', 'completed_at'
        ]
        read_only_fields = ['id', 'started_at']


class PortfolioProjectSerializer(serializers.ModelSerializer):
    """Serializer for PortfolioProject model."""
    skills_list = SkillSerializer(source='skills_demonstrated', many=True, read_only=True)
    
    class Meta:
        model = PortfolioProject
        fields = [
            'id', 'title', 'description', 'project_type',
            'live_url', 'github_url', 'demo_video_url',
            'thumbnail', 'images', 'technologies',
            'skills_demonstrated', 'skills_list',
            'challenges', 'outcomes', 'is_public', 'is_featured',
            'start_date', 'end_date', 'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'created_at', 'updated_at']


class CareerGoalSerializer(serializers.ModelSerializer):
    """Serializer for CareerGoal model."""
    
    class Meta:
        model = CareerGoal
        fields = [
            'id', 'title', 'description', 'goal_type', 'time_frame', 'status',
            'target_value', 'target_date', 'progress_percentage', 'milestones',
            'ai_recommendations', 'achieved_at', 'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'ai_recommendations', 'achieved_at', 'created_at', 'updated_at']


class CareerPathPlanSerializer(serializers.ModelSerializer):
    """Serializer for CareerPathPlan model."""
    
    class Meta:
        model = CareerPathPlan
        fields = [
            'id', 'name', 'current_role', 'current_level', 'current_salary',
            'target_role', 'target_level', 'target_salary', 'target_timeline_years',
            'stages', 'ai_analysis', 'success_probability', 'market_demand',
            'is_active', 'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'ai_analysis', 'success_probability', 'market_demand', 'created_at', 'updated_at']
