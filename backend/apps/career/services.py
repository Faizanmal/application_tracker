"""Career development AI services."""
import json
import logging
from django.conf import settings

logger = logging.getLogger(__name__)


class CareerAIService:
    """AI service for career development features."""
    
    def __init__(self):
        self.api_key = getattr(settings, 'OPENAI_API_KEY', '')
    
    def _call_openai(self, messages, temperature=0.7):
        """Call OpenAI API."""
        try:
            import openai
            client = openai.OpenAI(api_key=self.api_key)
            
            response = client.chat.completions.create(
                model="gpt-4",
                messages=messages,
                temperature=temperature
            )
            return response.choices[0].message.content
        except Exception as e:
            logger.error(f"OpenAI API error: {e}")
            return None
    
    def analyze_skill_gap(self, user_skills, target_role, job_description=''):
        """Analyze skill gap between user skills and target role."""
        current_skills = [
            {
                'skill': us.skill.name,
                'proficiency': us.proficiency,
                'years': float(us.years_of_experience)
            }
            for us in user_skills
        ]
        
        prompt = f"""Analyze the skill gap for someone targeting the role of "{target_role}".

Current Skills:
{json.dumps(current_skills, indent=2)}

{"Job Description:" + job_description if job_description else ""}

Please provide a JSON response with the following structure:
{{
    "required_skills": [
        {{"skill": "skill_name", "importance": "critical/high/medium", "level_needed": "beginner/intermediate/advanced/expert"}}
    ],
    "current_skills": [
        {{"skill": "skill_name", "current_level": "level", "meets_requirement": true/false}}
    ],
    "gap_skills": [
        {{"skill": "skill_name", "gap_severity": "high/medium/low", "recommendations": ["recommendation1", "recommendation2"]}}
    ],
    "match_percentage": 75,
    "summary": "Brief summary of the analysis",
    "recommendations": ["Top recommendation 1", "Top recommendation 2"],
    "estimated_time": "3-6 months"
}}"""
        
        response = self._call_openai([
            {"role": "system", "content": "You are a career advisor analyzing skill gaps. Always respond with valid JSON."},
            {"role": "user", "content": prompt}
        ])
        
        if response:
            try:
                # Clean response of markdown code blocks if present
                clean_response = response.strip()
                if clean_response.startswith('```'):
                    clean_response = clean_response.split('\n', 1)[1]
                if clean_response.endswith('```'):
                    clean_response = clean_response.rsplit('```', 1)[0]
                return json.loads(clean_response)
            except json.JSONDecodeError:
                logger.error("Failed to parse skill gap analysis response")
        
        # Return default structure on failure
        return {
            "required_skills": [],
            "current_skills": [{"skill": s['skill'], "current_level": s['proficiency']} for s in current_skills],
            "gap_skills": [],
            "match_percentage": 0,
            "summary": "Analysis could not be completed",
            "recommendations": [],
            "estimated_time": "Unknown"
        }
    
    def generate_learning_path(self, user, target_role):
        """Generate a personalized learning path."""
        from .models import UserSkill
        
        user_skills = UserSkill.objects.filter(user=user).select_related('skill')
        skills_list = [us.skill.name for us in user_skills]
        
        prompt = f"""Create a learning path for someone to become a {target_role}.

Their current skills are: {', '.join(skills_list) if skills_list else 'Not specified'}

Provide a JSON response with:
{{
    "description": "Description of the learning path",
    "estimated_weeks": 12,
    "phases": [
        {{
            "name": "Phase name",
            "duration_weeks": 4,
            "skills": ["skill1", "skill2"],
            "resources": [
                {{"title": "Resource name", "type": "course/book/project", "url": "optional_url"}}
            ]
        }}
    ]
}}"""
        
        response = self._call_openai([
            {"role": "system", "content": "You are a career advisor creating learning paths. Respond with valid JSON."},
            {"role": "user", "content": prompt}
        ])
        
        if response:
            try:
                clean_response = response.strip()
                if clean_response.startswith('```'):
                    clean_response = clean_response.split('\n', 1)[1]
                if clean_response.endswith('```'):
                    clean_response = clean_response.rsplit('```', 1)[0]
                return json.loads(clean_response)
            except json.JSONDecodeError:
                pass
        
        return {
            "description": f"Learning path to {target_role}",
            "estimated_weeks": 12,
            "phases": []
        }
    
    def generate_career_path(self, user, current_role, target_role, target_years=5):
        """Generate a career path plan."""
        prompt = f"""Create a career path plan from "{current_role}" to "{target_role}" over {target_years} years.

Provide a JSON response with:
{{
    "analysis": "Detailed analysis of the career transition",
    "success_probability": 75.0,
    "stages": [
        {{
            "title": "Stage title",
            "role": "Role at this stage",
            "timeline": "Year 1-2",
            "requirements": ["requirement1", "requirement2"],
            "salary_range": {{"min": 80000, "max": 100000, "currency": "USD"}}
        }}
    ],
    "market_demand": {{
        "current_demand": "high/medium/low",
        "growth_trend": "increasing/stable/decreasing",
        "top_industries": ["Industry1", "Industry2"]
    }}
}}"""
        
        response = self._call_openai([
            {"role": "system", "content": "You are a career advisor creating career path plans. Respond with valid JSON."},
            {"role": "user", "content": prompt}
        ])
        
        if response:
            try:
                clean_response = response.strip()
                if clean_response.startswith('```'):
                    clean_response = clean_response.split('\n', 1)[1]
                if clean_response.endswith('```'):
                    clean_response = clean_response.rsplit('```', 1)[0]
                return json.loads(clean_response)
            except json.JSONDecodeError:
                pass
        
        return {
            "analysis": "Analysis could not be generated",
            "success_probability": None,
            "stages": [],
            "market_demand": {}
        }
    
    def get_goal_recommendations(self, goal):
        """Get recommendations for achieving a career goal."""
        prompt = f"""Provide recommendations for achieving this career goal:

Goal: {goal.title}
Type: {goal.goal_type}
Target: {goal.target_value}
Timeline: {goal.time_frame}
Current Progress: {goal.progress_percentage}%

Provide a list of 5-7 specific, actionable recommendations as a JSON array of strings."""
        
        response = self._call_openai([
            {"role": "system", "content": "You are a career advisor. Respond with a JSON array of recommendation strings."},
            {"role": "user", "content": prompt}
        ])
        
        if response:
            try:
                clean_response = response.strip()
                if clean_response.startswith('```'):
                    clean_response = clean_response.split('\n', 1)[1]
                if clean_response.endswith('```'):
                    clean_response = clean_response.rsplit('```', 1)[0]
                return json.loads(clean_response)
            except json.JSONDecodeError:
                pass
        
        return ["Set clear milestones", "Track your progress regularly", "Seek feedback from mentors"]
