"""Market intelligence services."""
import json
import logging
from django.conf import settings

logger = logging.getLogger(__name__)


class MarketIntelService:
    """Service for fetching and processing market intelligence."""
    
    def fetch_company_profile(self, domain):
        """Fetch company profile from external sources."""
        # This would integrate with:
        # - Clearbit API
        # - LinkedIn API
        # - Glassdoor API
        # - Crunchbase API
        
        # For now, return a placeholder
        return None
    
    def estimate_salary(self, job_title, location, experience_years=0, skills=None):
        """Estimate salary for a role based on market data."""
        from .models import SalaryData
        
        skills = skills or []
        
        # Find similar salary data
        base_query = SalaryData.objects.filter(
            normalized_title__icontains=job_title.lower()
        )
        
        # Filter by location if specified
        if location:
            location_query = base_query.filter(location__icontains=location)
            if location_query.exists():
                base_query = location_query
        
        # Get latest data
        salaries = base_query.order_by('-year')[:50]
        
        if not salaries:
            # Use AI to estimate
            return self._ai_salary_estimate(job_title, location, experience_years, skills)
        
        # Calculate weighted average
        total_weight = 0
        weighted_min = 0
        weighted_max = 0
        weighted_median = 0
        
        for salary in salaries:
            weight = salary.sample_size or 1
            total_weight += weight
            weighted_min += float(salary.salary_min) * weight
            weighted_max += float(salary.salary_max) * weight
            if salary.salary_median:
                weighted_median += float(salary.salary_median) * weight
        
        if total_weight == 0:
            return self._ai_salary_estimate(job_title, location, experience_years, skills)
        
        # Adjust for experience
        experience_multiplier = 1 + (experience_years * 0.03)  # 3% per year
        
        return {
            'job_title': job_title,
            'location': location,
            'salary_min': int((weighted_min / total_weight) * experience_multiplier),
            'salary_max': int((weighted_max / total_weight) * experience_multiplier),
            'salary_median': int((weighted_median / total_weight) * experience_multiplier) if weighted_median > 0 else None,
            'currency': 'USD',
            'sample_size': total_weight,
            'confidence': 'high' if total_weight > 10 else 'medium' if total_weight > 3 else 'low'
        }
    
    def _ai_salary_estimate(self, job_title, location, experience_years, skills):
        """Use AI to estimate salary when market data is limited."""
        try:
            import openai
            client = openai.OpenAI(api_key=getattr(settings, 'OPENAI_API_KEY', ''))
            
            prompt = f"""Estimate the salary range for:
Role: {job_title}
Location: {location}
Experience: {experience_years} years
Skills: {', '.join(skills)}

Return a JSON object with:
- salary_min: integer
- salary_max: integer
- salary_median: integer
- currency: string
- notes: string explaining the estimate"""

            response = client.chat.completions.create(
                model="gpt-4",
                messages=[
                    {"role": "system", "content": "You are a salary estimation expert. Return valid JSON only."},
                    {"role": "user", "content": prompt}
                ],
                temperature=0.3
            )
            
            result = json.loads(response.choices[0].message.content)
            result['confidence'] = 'ai_estimated'
            result['job_title'] = job_title
            result['location'] = location
            return result
            
        except Exception as e:
            logger.error(f"AI salary estimation failed: {e}")
            return {
                'job_title': job_title,
                'location': location,
                'salary_min': None,
                'salary_max': None,
                'confidence': 'unavailable',
                'error': str(e)
            }


class PredictionService:
    """Service for ML-based success predictions."""
    
    def predict_success(self, application):
        """Generate success prediction for an application."""
        from .models import SuccessPrediction
        from apps.users.models import UserProfile
        
        user = application.user
        
        # Calculate component scores
        skill_score = self._calculate_skill_match(application)
        experience_score = self._calculate_experience_match(application, user)
        company_score = self._calculate_company_fit(application)
        resume_score = self._calculate_resume_quality(application)
        
        # Overall score (weighted average)
        overall = (
            skill_score * 0.35 +
            experience_score * 0.25 +
            company_score * 0.20 +
            resume_score * 0.20
        )
        
        # Probability estimates
        response_prob = min(overall * 0.8, 90)
        interview_prob = min(overall * 0.6, 70)
        offer_prob = min(overall * 0.4, 50)
        
        # Generate insights
        strengths, weaknesses, recommendations = self._generate_insights(
            application, skill_score, experience_score, company_score, resume_score
        )
        
        prediction = SuccessPrediction.objects.create(
            user=user,
            application=application,
            overall_score=overall,
            skill_match_score=skill_score,
            experience_match_score=experience_score,
            company_fit_score=company_score,
            resume_quality_score=resume_score,
            response_probability=response_prob,
            interview_probability=interview_prob,
            offer_probability=offer_prob,
            strengths=strengths,
            weaknesses=weaknesses,
            recommendations=recommendations,
            model_version='1.0'
        )
        
        return prediction
    
    def _calculate_skill_match(self, application):
        """Calculate skill match score."""
        # In production, this would parse job description and compare with user skills
        if application.match_score:
            return application.match_score
        
        # Default heuristic
        if application.job_description:
            return 65.0
        return 50.0
    
    def _calculate_experience_match(self, application, user):
        """Calculate experience match score."""
        try:
            profile = user.profile
            years = profile.years_of_experience
            
            # Estimate required experience from job title
            title_lower = application.job_title.lower()
            
            if 'senior' in title_lower or 'lead' in title_lower:
                required = 5
            elif 'junior' in title_lower or 'entry' in title_lower:
                required = 0
            elif 'mid' in title_lower:
                required = 3
            else:
                required = 2
            
            # Score based on meeting requirements
            if years >= required:
                return min(100, 70 + (years - required) * 5)
            else:
                return max(30, 70 - (required - years) * 15)
                
        except Exception:
            return 50.0
    
    def _calculate_company_fit(self, application):
        """Calculate company fit score."""
        from .models import CompanyProfile
        
        # Try to find company profile
        try:
            company = CompanyProfile.objects.filter(
                name__iexact=application.company_name
            ).first()
            
            if company and company.glassdoor_rating:
                return float(company.glassdoor_rating) * 20
        except Exception:
            pass
        
        return 60.0  # Default
    
    def _calculate_resume_quality(self, application):
        """Calculate resume quality score for this application."""
        if application.resume:
            # Has a resume attached
            if application.resume.parsed_content:
                return 75.0
            return 65.0
        return 50.0
    
    def _generate_insights(self, application, skill_score, exp_score, company_score, resume_score):
        """Generate strengths, weaknesses, and recommendations."""
        strengths = []
        weaknesses = []
        recommendations = []
        
        # Skill insights
        if skill_score >= 70:
            strengths.append("Strong skill match with job requirements")
        elif skill_score < 50:
            weaknesses.append("Skills may not fully align with requirements")
            recommendations.append("Consider highlighting transferable skills in your cover letter")
        
        # Experience insights
        if exp_score >= 70:
            strengths.append("Experience level matches the role well")
        elif exp_score < 50:
            weaknesses.append("May need more experience for this role")
            recommendations.append("Emphasize relevant projects and achievements")
        
        # Resume insights
        if resume_score >= 70:
            strengths.append("Resume is well-prepared for this application")
        else:
            weaknesses.append("Resume could be better tailored")
            recommendations.append("Customize your resume to match the job description")
        
        # Company insights
        if company_score >= 70:
            strengths.append("Good cultural fit potential")
        
        # General recommendations
        if not application.cover_letter:
            recommendations.append("Add a personalized cover letter to stand out")
        
        return strengths, weaknesses, recommendations
