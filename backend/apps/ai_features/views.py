import openai
from django.conf import settings
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status, generics

from apps.applications.models import JobApplication
from apps.users.models import Resume
from .models import AIUsage, GeneratedContent
from .serializers import (
    AIUsageSerializer, GeneratedContentSerializer,
    GenerateFollowUpEmailSerializer, ResumeMatchSerializer,
    InterviewQuestionsSerializer, ImproveSTARSerializer,
    GenerateCoverLetterSerializer
)


class AIFeatureBaseView(APIView):
    """Base view for AI features."""
    
    def check_pro_access(self, user):
        """Check if user has Pro access for AI features."""
        if not user.is_pro:
            return Response(
                {
                    'error': 'Pro subscription required',
                    'message': 'AI features are available for Pro subscribers only.'
                },
                status=status.HTTP_403_FORBIDDEN
            )
        return None
    
    def get_openai_client(self):
        """Get OpenAI client."""
        return openai.OpenAI(api_key=settings.OPENAI_API_KEY)


class GenerateFollowUpEmailView(AIFeatureBaseView):
    """Generate follow-up email."""
    
    def post(self, request):
        # Check Pro access
        access_check = self.check_pro_access(request.user)
        if access_check:
            return access_check
        
        serializer = GenerateFollowUpEmailSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        
        try:
            application = JobApplication.objects.get(
                id=serializer.validated_data['application_id'],
                user=request.user
            )
        except JobApplication.DoesNotExist:
            return Response(
                {'error': 'Application not found'},
                status=status.HTTP_404_NOT_FOUND
            )
        
        tone = serializer.validated_data['tone']
        include_points = serializer.validated_data.get('include_points', [])
        
        prompt = f"""Generate a professional follow-up email for a job application.

Company: {application.company_name}
Position: {application.job_title}
Applied Date: {application.applied_date}
Tone: {tone}

{"Points to include: " + ", ".join(include_points) if include_points else ""}

Generate a concise, personalized follow-up email that:
1. Reiterates interest in the position
2. References something specific about the company or role
3. Asks about next steps
4. Is professional but not generic

Return only the email body, no subject line."""

        try:
            client = self.get_openai_client()
            response = client.chat.completions.create(
                model="gpt-4",
                messages=[
                    {"role": "system", "content": "You are an expert career coach helping job seekers write effective follow-up emails."},
                    {"role": "user", "content": prompt}
                ],
                max_tokens=500,
                temperature=0.7
            )
            
            generated_email = response.choices[0].message.content
            tokens_used = response.usage.total_tokens
            
            # Track usage
            AIUsage.objects.create(
                user=request.user,
                feature_type=AIUsage.FeatureType.FOLLOW_UP_EMAIL,
                tokens_used=tokens_used,
                application=application
            )
            
            # Save generated content
            content = GeneratedContent.objects.create(
                user=request.user,
                content_type='follow_up_email',
                prompt=prompt,
                generated_text=generated_email,
                tokens_used=tokens_used,
                application=application
            )
            
            return Response({
                'email': generated_email,
                'content_id': str(content.id),
                'tokens_used': tokens_used
            })
            
        except Exception as e:
            return Response(
                {'error': str(e)},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )


class ResumeMatchScoreView(AIFeatureBaseView):
    """Calculate resume-job match score."""
    
    def post(self, request):
        access_check = self.check_pro_access(request.user)
        if access_check:
            return access_check
        
        serializer = ResumeMatchSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        
        try:
            application = JobApplication.objects.get(
                id=serializer.validated_data['application_id'],
                user=request.user
            )
        except JobApplication.DoesNotExist:
            return Response(
                {'error': 'Application not found'},
                status=status.HTTP_404_NOT_FOUND
            )
        
        # Get resume
        resume = None
        resume_id = serializer.validated_data.get('resume_id')
        if resume_id:
            try:
                resume = Resume.objects.get(id=resume_id, user=request.user)
            except Resume.DoesNotExist:
                pass
        elif application.resume:
            resume = application.resume
        
        if not resume or not resume.parsed_content:
            return Response(
                {'error': 'No resume content available for matching'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        if not application.job_description:
            return Response(
                {'error': 'No job description available for matching'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        prompt = f"""Analyze the match between this resume and job description.

RESUME:
{resume.parsed_content[:3000]}

JOB DESCRIPTION:
{application.job_description[:3000]}

Provide a detailed analysis in JSON format:
{{
    "match_score": <0-100>,
    "matching_skills": ["skill1", "skill2"],
    "missing_skills": ["skill1", "skill2"],
    "experience_match": "<strong/moderate/weak>",
    "recommendations": ["recommendation1", "recommendation2"],
    "summary": "<2-3 sentence summary>"
}}"""

        try:
            client = self.get_openai_client()
            response = client.chat.completions.create(
                model="gpt-4",
                messages=[
                    {"role": "system", "content": "You are an expert recruiter analyzing resume-job fit. Return only valid JSON."},
                    {"role": "user", "content": prompt}
                ],
                max_tokens=1000,
                temperature=0.3
            )
            
            import json
            result = json.loads(response.choices[0].message.content)
            tokens_used = response.usage.total_tokens
            
            # Update application with match score
            application.match_score = result.get('match_score')
            application.match_analysis = result
            application.save()
            
            # Track usage
            AIUsage.objects.create(
                user=request.user,
                feature_type=AIUsage.FeatureType.RESUME_MATCH,
                tokens_used=tokens_used,
                application=application
            )
            
            return Response({
                'analysis': result,
                'tokens_used': tokens_used
            })
            
        except Exception as e:
            return Response(
                {'error': str(e)},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )


class GenerateInterviewQuestionsView(AIFeatureBaseView):
    """Generate interview questions for a job."""
    
    def post(self, request):
        access_check = self.check_pro_access(request.user)
        if access_check:
            return access_check
        
        serializer = InterviewQuestionsSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        
        try:
            application = JobApplication.objects.get(
                id=serializer.validated_data['application_id'],
                user=request.user
            )
        except JobApplication.DoesNotExist:
            return Response(
                {'error': 'Application not found'},
                status=status.HTTP_404_NOT_FOUND
            )
        
        question_types = serializer.validated_data['question_types']
        count = serializer.validated_data['count']
        
        prompt = f"""Generate {count} interview questions for this position.

Company: {application.company_name}
Position: {application.job_title}
Job Description: {application.job_description[:2000] if application.job_description else 'Not available'}

Question types to include: {', '.join(question_types)}

Return as a JSON array of objects:
[
    {{
        "question": "...",
        "type": "behavioral|technical|situational|general",
        "tips": "Brief tip for answering",
        "sample_answer_outline": "Key points to cover"
    }}
]"""

        try:
            client = self.get_openai_client()
            response = client.chat.completions.create(
                model="gpt-4",
                messages=[
                    {"role": "system", "content": "You are an expert interviewer generating relevant interview questions. Return only valid JSON."},
                    {"role": "user", "content": prompt}
                ],
                max_tokens=2000,
                temperature=0.7
            )
            
            import json
            questions = json.loads(response.choices[0].message.content)
            tokens_used = response.usage.total_tokens
            
            # Track usage
            AIUsage.objects.create(
                user=request.user,
                feature_type=AIUsage.FeatureType.INTERVIEW_QUESTIONS,
                tokens_used=tokens_used,
                application=application
            )
            
            return Response({
                'questions': questions,
                'tokens_used': tokens_used
            })
            
        except Exception as e:
            return Response(
                {'error': str(e)},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )


class ImproveSTARResponseView(AIFeatureBaseView):
    """Improve a STAR response."""
    
    def post(self, request):
        access_check = self.check_pro_access(request.user)
        if access_check:
            return access_check
        
        serializer = ImproveSTARSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        
        data = serializer.validated_data
        
        prompt = f"""Improve this STAR method interview response.

Question: {data.get('question', 'Behavioral interview question')}

Current Response:
Situation: {data['situation']}
Task: {data['task']}
Action: {data['action']}
Result: {data['result']}

Provide improved versions in JSON format:
{{
    "improved_situation": "...",
    "improved_task": "...",
    "improved_action": "...",
    "improved_result": "...",
    "suggestions": ["suggestion1", "suggestion2"],
    "strengths": ["strength1", "strength2"],
    "score": <1-10>
}}

Focus on:
1. Making it more specific and quantifiable
2. Highlighting impact and results
3. Demonstrating relevant skills
4. Being concise but comprehensive"""

        try:
            client = self.get_openai_client()
            response = client.chat.completions.create(
                model="gpt-4",
                messages=[
                    {"role": "system", "content": "You are an expert career coach helping improve interview responses. Return only valid JSON."},
                    {"role": "user", "content": prompt}
                ],
                max_tokens=1500,
                temperature=0.7
            )
            
            import json
            improvements = json.loads(response.choices[0].message.content)
            tokens_used = response.usage.total_tokens
            
            # Track usage
            AIUsage.objects.create(
                user=request.user,
                feature_type=AIUsage.FeatureType.STAR_IMPROVEMENT,
                tokens_used=tokens_used
            )
            
            return Response({
                'improvements': improvements,
                'tokens_used': tokens_used
            })
            
        except Exception as e:
            return Response(
                {'error': str(e)},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )


class GenerateCoverLetterView(AIFeatureBaseView):
    """Generate cover letter."""
    
    def post(self, request):
        access_check = self.check_pro_access(request.user)
        if access_check:
            return access_check
        
        serializer = GenerateCoverLetterSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        
        try:
            application = JobApplication.objects.get(
                id=serializer.validated_data['application_id'],
                user=request.user
            )
        except JobApplication.DoesNotExist:
            return Response(
                {'error': 'Application not found'},
                status=status.HTTP_404_NOT_FOUND
            )
        
        # Get resume
        resume_content = ""
        resume_id = serializer.validated_data.get('resume_id')
        if resume_id:
            try:
                resume = Resume.objects.get(id=resume_id, user=request.user)
                resume_content = resume.parsed_content[:2000]
            except Resume.DoesNotExist:
                pass
        elif application.resume:
            resume_content = application.resume.parsed_content[:2000]
        
        highlights = serializer.validated_data.get('highlights', [])
        tone = serializer.validated_data['tone']
        
        prompt = f"""Generate a cover letter for this job application.

Company: {application.company_name}
Position: {application.job_title}
Job Description: {application.job_description[:2000] if application.job_description else 'Not available'}

Resume Summary: {resume_content if resume_content else 'Not available'}

Highlights to include: {', '.join(highlights) if highlights else 'None specified'}
Tone: {tone}

Generate a compelling cover letter that:
1. Shows genuine interest in the company and role
2. Highlights relevant experience and skills
3. Demonstrates cultural fit
4. Has a strong opening and closing
5. Is appropriately formatted with paragraphs

Return only the cover letter text."""

        try:
            client = self.get_openai_client()
            response = client.chat.completions.create(
                model="gpt-4",
                messages=[
                    {"role": "system", "content": "You are an expert career coach helping job seekers write compelling cover letters."},
                    {"role": "user", "content": prompt}
                ],
                max_tokens=1000,
                temperature=0.7
            )
            
            cover_letter = response.choices[0].message.content
            tokens_used = response.usage.total_tokens
            
            # Track usage
            AIUsage.objects.create(
                user=request.user,
                feature_type=AIUsage.FeatureType.COVER_LETTER,
                tokens_used=tokens_used,
                application=application
            )
            
            # Save generated content
            content = GeneratedContent.objects.create(
                user=request.user,
                content_type='cover_letter',
                prompt=prompt,
                generated_text=cover_letter,
                tokens_used=tokens_used,
                application=application
            )
            
            return Response({
                'cover_letter': cover_letter,
                'content_id': str(content.id),
                'tokens_used': tokens_used
            })
            
        except Exception as e:
            return Response(
                {'error': str(e)},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )


class AIUsageHistoryView(generics.ListAPIView):
    """Get AI usage history."""
    
    serializer_class = AIUsageSerializer
    
    def get_queryset(self):
        return AIUsage.objects.filter(user=self.request.user)


class GeneratedContentListView(generics.ListAPIView):
    """Get generated content history."""
    
    serializer_class = GeneratedContentSerializer
    
    def get_queryset(self):
        return GeneratedContent.objects.filter(user=self.request.user)


class RateGeneratedContentView(APIView):
    """Rate generated content."""
    
    def post(self, request, pk):
        try:
            content = GeneratedContent.objects.get(pk=pk, user=request.user)
        except GeneratedContent.DoesNotExist:
            return Response(
                {'error': 'Content not found'},
                status=status.HTTP_404_NOT_FOUND
            )
        
        rating = request.data.get('rating')
        is_used = request.data.get('is_used')
        
        if rating is not None:
            content.rating = min(max(1, int(rating)), 5)
        if is_used is not None:
            content.is_used = bool(is_used)
        
        content.save()
        
        return Response(GeneratedContentSerializer(content).data)
