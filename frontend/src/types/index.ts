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
