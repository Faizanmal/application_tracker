/**
 * Type definitions for JobScouter
 */

// User types
export interface User {
  id: string;
  email: string;
  first_name: string;
  last_name: string;
  full_name: string;
  avatar: string | null;
  subscription_tier: 'free' | 'pro' | 'enterprise';
  is_pro: boolean;
  email_notifications: boolean;
  push_notifications: boolean;
  user_timezone: string;
  is_verified: boolean;
  date_joined: string;
  last_login: string | null;
  profile?: UserProfile;
}

export interface UserProfile {
  target_role: string;
  target_industry: string;
  preferred_locations: string[];
  min_salary: number | null;
  max_salary: number | null;
  linkedin_url: string;
  portfolio_url: string;
  years_of_experience: number;
  current_company: string;
  current_role: string;
  bio: string;
  skills: string[];
  google_calendar_connected: boolean;
  phone?: string;
  job_title?: string;
  location?: string;
  preferred_job_type?: string;
  preferred_work_mode?: string;
  weekly_application_goal?: number;
  avatar?: string;
}

export interface Resume {
  id: number;
  name: string;
  file: string;
  version: string;
  is_default: boolean;
  skills_extracted: string[];
  created_at: string;
  updated_at: string;
  original_filename: string;
  description?: string;
  file_size: number;
  usage_count: number;
}

// Application types
export type ApplicationStatus = 
  | 'wishlist' 
  | 'applied' 
  | 'screening' 
  | 'interviewing' 
  | 'offer' 
  | 'accepted' 
  | 'rejected' 
  | 'withdrawn' 
  | 'ghosted';

export type JobType = 
  | 'full_time' 
  | 'part_time' 
  | 'contract' 
  | 'internship' 
  | 'freelance' 
  | 'remote';

export type WorkMode = 'onsite' | 'remote' | 'hybrid';

export type WorkLocation = WorkMode;

export interface ApplicationTag {
  id: string;
  name: string;
  color: string;
  created_at: string;
}

export interface JobApplication {
  id: string;
  company_name: string;
  company_website: string;
  company_logo: string;
  company_size: string;
  company_industry: string;
  job_title: string;
  job_link: string;
  job_description: string;
  job_type: JobType;
  work_location: WorkLocation;
  location: string;
  salary_min: number | null;
  salary_max: number | null;
  salary_currency: string;
  status: ApplicationStatus;
  status_order: number;
  applied_date: string | null;
  deadline: string | null;
  response_date: string | null;
  resume: string | null;
  cover_letter: string;
  cover_letter_file: string | null;
  notes: string;
  is_favorite: boolean;
  is_archived: boolean;
  contact_name: string;
  contact_email: string;
  contact_phone: string;
  contact_linkedin: string;
  match_score: number | null;
  match_analysis: Record<string, unknown> | null;
  source: string;
  referral: string;
  tags: ApplicationTag[];
  timeline?: ApplicationTimeline[];
  documents?: ApplicationDocument[];
  interview_count?: number;
  next_interview?: {
    id: string;
    scheduled_at: string;
    interview_type: string;
  } | null;
  work_mode: WorkMode;
  job_url: string;
  resume_name: string;
  created_at: string;
  updated_at: string;
}

export interface ApplicationTimeline {
  id: string;
  event_type: string;
  title: string;
  description: string;
  old_status: string;
  new_status: string;
  created_at: string;
}

export interface ApplicationDocument {
  id: string;
  name: string;
  file: string;
  doc_type: string;
  created_at: string;
}

// Interview types
export type InterviewType = 
  | 'phone' 
  | 'video' 
  | 'onsite' 
  | 'technical' 
  | 'behavioral' 
  | 'panel' 
  | 'final';

export type InterviewStatus = 
  | 'scheduled' 
  | 'completed' 
  | 'cancelled' 
  | 'rescheduled' 
  | 'no_show';

export interface Interview {
  id: string;
  application: string;
  application_company: string;
  application_job_title: string;
  interview_type: InterviewType;
  round_number: number;
  title: string;
  scheduled_at: string;
  duration_minutes: number;
  timezone: string;
  location: string;
  meeting_link: string;
  meeting_id: string;
  meeting_password: string;
  interviewer_name: string;
  interviewer_title: string;
  interviewer_email: string;
  interviewer_linkedin: string;
  interviewer_names: string;
  status: InterviewStatus;
  preparation_notes: string;
  post_interview_notes: string;
  feedback: string;
  rating: number | null;
  google_event_id: string;
  notes: string;
  questions?: InterviewQuestion[];
  created_at: string;
  updated_at: string;
}

export interface InterviewQuestion {
  id: string;
  question: string;
  question_type: string;
  is_common: boolean;
  category: string;
  suggested_answer?: string;
  star_responses: STARResponse[];
  created_at: string;
}

export interface STARResponse {
  id: string;
  interview: string;
  question: string;
  situation: string;
  task: string;
  action: string;
  result: string;
  ai_suggestions: Record<string, unknown> | null;
  created_at: string;
  updated_at: string;
}

export interface CompanyResearch {
  id: string;
  application: string;
  mission_statement: string;
  values: string[];
  recent_news: string;
  products_services: string;
  competitors: string[];
  culture_notes: string;
  key_people: Array<{ name: string; title: string; linkedin: string }>;
  questions_to_ask: string[];
  why_interested: string;
  how_you_fit: string;
  created_at: string;
  updated_at: string;
}

// Reminder types
export type ReminderType = 
  | 'follow_up' 
  | 'interview_prep' 
  | 'application_deadline' 
  | 'check_status' 
  | 'send_thank_you' 
  | 'custom';

export type ReminderStatus = 
  | 'pending' 
  | 'sent' 
  | 'completed' 
  | 'snoozed' 
  | 'cancelled';

export interface Reminder {
  id: string;
  application: string | null;
  application_company: string | null;
  application_job_title: string | null;
  interview: string | null;
  reminder_type: ReminderType;
  title: string;
  description: string;
  scheduled_at: string;
  status: ReminderStatus;
  send_email: boolean;
  send_push: boolean;
  snoozed_until: string | null;
  snooze_count: number;
  sent_at: string | null;
  completed_at: string | null;
  created_at: string;
  updated_at: string;
}

export interface Notification {
  id: string;
  notification_type: string;
  title: string;
  message: string;
  application: string | null;
  interview: string | null;
  reminder: string | null;
  action_url: string;
  is_read: boolean;
  read_at: string | null;
  created_at: string;
}

// Analytics types
export interface DashboardStats {
  total_applications: number;
  active_applications: number;
  interviews_scheduled: number;
  offers_received: number;
  response_rate: number;
  interview_rate: number;
  applications_by_status: Record<ApplicationStatus, number>;
  applications_this_week: number;
  interviews_this_week: number;
  total_interviews: number;
  offers: number;
  by_status: Record<ApplicationStatus, number>;
  by_source: Record<string, number>;
  avg_response_days: number;
  this_week: number;
  recent_activity: Array<{
    id: string;
    title: string;
    event_type: string;
    application: {
      id: string;
      company_name: string;
      job_title: string;
    };
    created_at: string;
  }>;
  weekly_activity: Array<{
    week: string;
    count: number;
  }>;
}

export interface ApplicationInsights {
  best_performing_resume: {
    id: string;
    name: string;
    total_applications: number;
    interviews: number;
    success_rate: number;
  } | null;
  ghosting_rate: number;
  average_response_days: number | null;
  most_active_sources: Array<{
    source: string;
    count: number;
  }>;
  status_distribution: Record<ApplicationStatus, number>;
  monthly_trend: Array<{
    month: string;
    applications: number;
    interviews: number;
    offers: number;
  }>;
}

// Subscription types
export interface Subscription {
  id: string;
  plan: 'free' | 'pro_monthly' | 'pro_yearly';
  status: 'active' | 'cancelled' | 'past_due' | 'trialing' | 'expired';
  current_period_start: string | null;
  current_period_end: string | null;
  cancel_at_period_end: boolean;
  cancelled_at: string | null;
  trial_start: string | null;
  trial_end: string | null;
  stripe_price_id: string;
  created_at: string;
  updated_at: string;
}

export interface PricingPlan {
  id: string;
  name: string;
  slug: string;
  price_monthly: number;
  price_yearly: number;
  currency: string;
  features: string[];
  application_limit: number | null;
  is_active: boolean;
  is_popular: boolean;
}

// Kanban types
export interface KanbanColumn {
  label: string;
  applications: JobApplication[];
}

export type KanbanData = Record<ApplicationStatus, KanbanColumn>;

// API Response types
export interface PaginatedResponse<T> {
  count: number;
  next: string | null;
  previous: string | null;
  results: T[];
}

export interface AuthResponse {
  access: string;
  refresh: string;
  user: User;
}

// Auth types
export interface LoginCredentials {
  email: string;
  password: string;
}

export interface RegisterData {
  email: string;
  password: string;
  password2: string;
  first_name?: string;
  last_name?: string;
}

// AI Features types
export interface AIUsage {
  id: string;
  feature_type: string;
  tokens_used: number;
  input_text: string;
  output_text: string;
  created_at: string;
}

export interface GeneratedContent {
  id: string;
  application: string | null;
  content_type: string;
  prompt: string;
  generated_text: string;
  rating: number | null;
  is_used: boolean;
  created_at: string;
}

// Placeholder types for missing APIs
export interface Meeting {
  id: string;
  title: string;
  // Add other fields as needed
}

export interface ActionItem {
  id: string;
  description: string;
  completed: boolean;
  // Add other fields as needed
}

export interface Note {
  id: string;
  content: string;
  // Add other fields as needed
}

export interface Activity {
  id: string;
  type: string;
  // Add other fields as needed
}

export interface MeetingTemplate {
  id: string;
  name: string;
  // Add other fields as needed
}

export interface NotificationIntegration {
  id: string;
  type: string;
  // Add other fields as needed
}

export interface NotificationLog {
  id: string;
  message: string;
  // Add other fields as needed
}

export interface CalendarConnection {
  id: string;
  provider: string;
  // Add other fields as needed
}

export interface Workspace {
  id: string;
  name: string;
  // Add other fields as needed
}

export interface WorkspaceMember {
  id: string;
  user: string;
  role: string;
  // Add other fields as needed
}
// ============================================================================
// NETWORKING TYPES
// ============================================================================
export interface ProfessionalConnection {
  id: string;
  name: string;
  email: string;
  company: string;
  title: string;
  linkedin_url: string;
  phone: string;
  connection_type: 'colleague' | 'recruiter' | 'alumni' | 'referral' | 'mentor' | 'other';
  relationship_strength: 1 | 2 | 3 | 4 | 5;
  is_alumni: boolean;
  notes: string;
  last_contacted: string | null;
  next_followup: string | null;
  created_at: string;
}

export interface Referral {
  id: string;
  application: string;
  referrer: string;
  referrer_details?: ProfessionalConnection;
  referral_date: string;
  referral_status: 'pending' | 'submitted' | 'acknowledged' | 'interview_scheduled' | 'hired' | 'declined';
  notes: string;
}

export interface NetworkingEvent {
  id: string;
  name: string;
  event_type: 'conference' | 'meetup' | 'webinar' | 'career_fair' | 'info_session' | 'other';
  location: string;
  is_virtual: boolean;
  date: string;
  end_date: string | null;
  notes: string;
  connections_made: number;
}

export interface MentorshipRelationship {
  id: string;
  mentor: string;
  mentor_details?: ProfessionalConnection;
  relationship_type: 'formal' | 'informal' | 'peer';
  status: 'active' | 'paused' | 'completed';
  goals: string[];
  meeting_frequency: string;
  total_sessions: number;
}

// ============================================================================
// CAREER DEVELOPMENT TYPES
// ============================================================================
export interface Skill {
  id: string;
  name: string;
  category: string;
  is_verified: boolean;
}

export interface UserSkill {
  id: string;
  skill: string;
  skill_details?: Skill;
  proficiency_level: 1 | 2 | 3 | 4 | 5;
  years_experience: number | null;
  is_verified: boolean;
  last_used: string | null;
}

export interface SkillGapAnalysis {
  id: string;
  job_title: string;
  target_company: string;
  match_percentage: number;
  missing_skills: string[];
  skills_to_improve: string[];
  strong_skills: string[];
  recommendations: string[];
  created_at: string;
}

export interface LearningResource {
  id: string;
  title: string;
  platform: string;
  resource_type: 'course' | 'book' | 'article' | 'video' | 'tutorial' | 'certification';
  url: string;
  duration_hours: number | null;
  difficulty_level: string;
  is_free: boolean;
  price: number | null;
}

export interface UserLearningProgress {
  id: string;
  resource: string;
  resource_details?: LearningResource;
  status: 'not_started' | 'in_progress' | 'completed' | 'dropped';
  progress_percentage: number;
  hours_spent: number;
  completed_at: string | null;
}

export interface PortfolioProject {
  id: string;
  title: string;
  description: string;
  project_url: string;
  github_url: string;
  technologies: string[];
  featured_image: string;
  is_featured: boolean;
  start_date: string | null;
  end_date: string | null;
}

export interface CareerGoal {
  id: string;
  title: string;
  description: string;
  goal_type: 'skill' | 'role' | 'salary' | 'company' | 'project' | 'certification';
  target_date: string | null;
  status: 'not_started' | 'in_progress' | 'completed' | 'abandoned';
  progress_percentage: number;
  milestones: Array<{ title: string; completed: boolean; completed_at?: string }>;
}

// ============================================================================
// GAMIFICATION TYPES
// ============================================================================
export interface Achievement {
  id: string;
  name: string;
  description: string;
  icon: string;
  category: string;
  tier: 'bronze' | 'silver' | 'gold' | 'platinum' | 'diamond';
  points: number;
  criteria: Record<string, unknown>;
}

export interface UserAchievement {
  id: string;
  achievement: string;
  achievement_details?: Achievement;
  progress: number;
  earned_at: string | null;
}

export interface UserStreak {
  id: string;
  streak_type: 'daily_login' | 'daily_application' | 'weekly_goal' | 'learning';
  current_streak: number;
  longest_streak: number;
  last_activity_date: string;
}

export interface UserPoints {
  id: string;
  total_points: number;
  application_points: number;
  interview_points: number;
  networking_points: number;
  learning_points: number;
  level: number;
}

export interface LeaderboardEntry {
  id: string;
  level: number;
  points: number;
}

export interface Challenge {
  id: string;
  title: string;
  description: string;
  challenge_type: string;
  target_count: number;
  points_reward: number;
  start_date: string;
  end_date: string;
  is_active: boolean;
}

export interface UserChallenge {
  id: string;
  challenge: string;
  challenge_details?: Challenge;
  progress: number;
  completed: boolean;
  completed_at: string | null;
}

export interface CommunityPost {
  id: string;
  title: string;
  content: string;
  post_type: 'success_story' | 'tip' | 'question' | 'discussion' | 'resource';
  is_anonymous: boolean;
  upvotes_count: number;
  comments_count: number;
  created_at: string;
}

// ============================================================================
// MARKET INTELLIGENCE TYPES
// ============================================================================
export interface CompanyProfile {
  id: string;
  name: string;
  domain: string;
  description: string;
  industry: string;
  company_size: string;
  employee_count: number | null;
  headquarters: string;
  logo_url: string;
  glassdoor_rating: number | null;
  is_hiring: boolean;
  open_positions_count: number;
  tech_stack: string[];
  culture_keywords: string[];
  benefits: string[];
}

export interface SalaryData {
  id: string;
  job_title: string;
  location: string;
  salary_min: number;
  salary_max: number;
  salary_median: number | null;
  currency: string;
  seniority_level: string;
  industry: string;
  sample_size: number;
  year: number;
}

export interface IndustryTrend {
  id: string;
  industry: string;
  hiring_trend: 'growing' | 'stable' | 'declining';
  growth_rate: number | null;
  top_skills: string[];
  emerging_skills: string[];
  remote_percentage: number | null;
  year: number;
  quarter: number;
}

export interface SuccessPrediction {
  id: string;
  application: string;
  overall_score: number;
  skill_match_score: number | null;
  experience_match_score: number | null;
  company_fit_score: number | null;
  strengths: string[];
  weaknesses: string[];
  recommendations: string[];
  response_probability: number | null;
  interview_probability: number | null;
  offer_probability: number | null;
}

export interface JobSearchROI {
  id: string;
  start_date: string;
  end_date: string;
  total_applications: number;
  responses_received: number;
  interviews_scheduled: number;
  offers_received: number;
  response_rate: number | null;
  interview_rate: number | null;
  offer_rate: number | null;
}

// ============================================================================
// PRIVACY & SECURITY TYPES
// ============================================================================
export interface DataExportRequest {
  id: string;
  status: 'pending' | 'processing' | 'completed' | 'failed' | 'expired';
  format: 'json' | 'csv' | 'pdf';
  file_size: number | null;
  download_url: string;
  expires_at: string | null;
  created_at: string;
  completed_at: string | null;
}

export interface TwoFactorAuth {
  id: string;
  is_enabled: boolean;
  primary_method: 'totp' | 'sms' | 'email';
  totp_confirmed: boolean;
  backup_codes_remaining: number;
  last_used_at: string | null;
}

export interface LoginAttempt {
  id: string;
  ip_address: string;
  user_agent: string;
  successful: boolean;
  is_suspicious: boolean;
  suspicious_reason: string;
  country: string;
  city: string;
  created_at: string;
}

export interface EncryptedNote {
  id: string;
  application: string | null;
  title: string;
  encrypted_content: string;
  category: string;
  tags: string[];
  is_pinned: boolean;
  created_at: string;
  updated_at: string;
}

export interface AuditLog {
  id: string;
  event_type: string;
  event_type_display: string;
  description: string;
  severity: 'critical' | 'warning' | 'info';
  ip_address: string;
  user_agent: string;
  created_at: string;
}

// ============================================================================
// INTEGRATIONS TYPES
// ============================================================================
export interface EmailIntegration {
  id: string;
  provider: 'gmail' | 'outlook';
  email_address: string;
  is_connected: boolean;
  last_synced: string | null;
  auto_track_applications: boolean;
}

export interface CalendarIntegration {
  id: string;
  provider: 'google' | 'outlook' | 'apple';
  calendar_id: string;
  is_connected: boolean;
  sync_interviews: boolean;
  sync_reminders: boolean;
}

export interface LinkedInIntegration {
  id: string;
  linkedin_url: string;
  is_connected: boolean;
  connection_count: number | null;
  last_synced: string | null;
}

export interface SlackIntegration {
  id: string;
  workspace_name: string;
  channel_id: string;
  is_active: boolean;
  notify_on_status_change: boolean;
  notify_on_interview: boolean;
}

export interface APIKey {
  id: string;
  name: string;
  key_prefix: string;
  permissions: string[];
  last_used: string | null;
  expires_at: string | null;
  is_active: boolean;
  created_at: string;
}