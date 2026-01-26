/* eslint-disable @typescript-eslint/no-explicit-any */
/**
 * API Client for JobScouter
 */
import axios, { AxiosInstance, AxiosError, AxiosRequestConfig } from 'axios';
import Cookies from 'js-cookie';
import type {
  User,
  JobApplication,
  ApplicationStatus,
  ApplicationTag,
  Interview,
  Reminder,
  Notification,
  DashboardStats,
  ApplicationInsights,
  Subscription,
  PricingPlan,
  Resume,
  CompanyResearch,
  STARResponse,
  InterviewQuestion,
  PaginatedResponse,
  AuthResponse,
  LoginCredentials,
  RegisterData,
  GeneratedContent,
} from '@/types';

const API_BASE_URL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:8000/api/v1';

// Create axios instance
export const apiClient: AxiosInstance = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
  timeout: 30000,
});

// Request interceptor to add auth token
apiClient.interceptors.request.use(
  (config) => {
    const token = Cookies.get('access_token');
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => Promise.reject(error)
);

// Response interceptor for token refresh
apiClient.interceptors.response.use(
  (response) => response,
  async (error: AxiosError) => {
    const originalRequest = error.config as AxiosRequestConfig & { _retry?: boolean };

    if (error.response?.status === 401 && !originalRequest._retry) {
      originalRequest._retry = true;

      const refreshToken = Cookies.get('refresh_token');
      if (refreshToken) {
        try {
          const response = await axios.post(`${API_BASE_URL}/auth/token/refresh/`, {
            refresh: refreshToken,
          });
          const { access } = response.data;
          
          Cookies.set('access_token', access, { expires: 1 });
          if (!originalRequest.headers) {
            originalRequest.headers = {};
          }
          originalRequest.headers.Authorization = `Bearer ${access}`;
          
          return apiClient(originalRequest);
        } catch (refreshError) {
          Cookies.remove('access_token');
          Cookies.remove('refresh_token');
          if (typeof window !== 'undefined') {
            window.location.href = '/login';
          }
          return Promise.reject(refreshError);
        }
      }
    }
    return Promise.reject(error);
  }
);

// ============================================================================
// AUTH API
// ============================================================================
export const authApi = {
  login: async (credentials: LoginCredentials): Promise<AuthResponse> => {
    const response = await apiClient.post('/auth/login/', credentials);
    const { access, refresh, user: _user } = response.data;
    Cookies.set('access_token', access, { expires: 1 });
    Cookies.set('refresh_token', refresh, { expires: 7 });
    return response.data;
  },

  register: async (data: RegisterData): Promise<AuthResponse> => {
    const response = await apiClient.post('/auth/register/', data);
    const { access, refresh } = response.data;
    Cookies.set('access_token', access, { expires: 1 });
    Cookies.set('refresh_token', refresh, { expires: 7 });
    return response.data;
  },

  logout: async (): Promise<void> => {
    const refreshToken = Cookies.get('refresh_token');
    try {
      await apiClient.post('/auth/logout/', { refresh: refreshToken });
    } finally {
      Cookies.remove('access_token');
      Cookies.remove('refresh_token');
    }
  },

  me: async (): Promise<User> => {
    const response = await apiClient.get('/users/me/');
    return response.data;
  },

  updateProfile: async (data: Partial<User>): Promise<User> => {
    const response = await apiClient.patch('/users/profile/', data);
    return response.data;
  },

  changePassword: async (data: { current_password: string; new_password: string }): Promise<void> => {
    await apiClient.post('/users/change-password/', data);
  },

  forgotPassword: async (email: string): Promise<void> => {
    await apiClient.post('/auth/password-reset/', { email });
  },

  resetPassword: async (data: { token: string; password: string }): Promise<void> => {
    await apiClient.post('/auth/password-reset/confirm/', data);
  },

  verifyEmail: async (token: string): Promise<void> => {
    await apiClient.post('/auth/verify-email/', { token });
  },

  resendVerification: async (): Promise<void> => {
    await apiClient.post('/auth/resend-verification/');
  },

  googleAuth: async (code: string): Promise<AuthResponse> => {
    const response = await apiClient.post('/auth/google/', { code });
    const { access, refresh } = response.data;
    Cookies.set('access_token', access, { expires: 1 });
    Cookies.set('refresh_token', refresh, { expires: 7 });
    return response.data;
  },

  githubAuth: async (code: string): Promise<AuthResponse> => {
    const response = await apiClient.post('/auth/github/', { code });
    const { access, refresh } = response.data;
    Cookies.set('access_token', access, { expires: 1 });
    Cookies.set('refresh_token', refresh, { expires: 7 });
    return response.data;
  },
};

// ============================================================================
// APPLICATIONS API
// ============================================================================
export const applicationsApi = {
  list: async (params?: {
    status?: string;
    is_favorite?: boolean;
    is_archived?: boolean;
    search?: string;
    ordering?: string;
    page?: number;
  }): Promise<PaginatedResponse<JobApplication>> => {
    const response = await apiClient.get('/applications/', { params });
    return response.data;
  },

  get: async (id: string): Promise<JobApplication> => {
    const response = await apiClient.get(`/applications/${id}/`);
    return response.data;
  },

  create: async (data: Partial<JobApplication>): Promise<JobApplication> => {
    const response = await apiClient.post('/applications/', data);
    return response.data;
  },

  update: async (id: string, data: Partial<JobApplication>): Promise<JobApplication> => {
    const response = await apiClient.patch(`/applications/${id}/`, data);
    return response.data;
  },

  delete: async (id: string): Promise<void> => {
    await apiClient.delete(`/applications/${id}/`);
  },

  kanban: async (): Promise<Record<ApplicationStatus, { label: string; applications: JobApplication[] }>> => {
    const response = await apiClient.get('/applications/kanban/');
    return response.data;
  },

  updateKanbanOrder: async (data: {
    application_id: string;
    new_status: ApplicationStatus;
    new_order: number;
  }): Promise<void> => {
    await apiClient.post('/applications/update-kanban-order/', data);
  },

  bulkUpdateStatus: async (data: {
    application_ids: string[];
    status: ApplicationStatus;
  }): Promise<{ updated: number }> => {
    const response = await apiClient.post('/applications/bulk-update-status/', data);
    return response.data;
  },

  bulkDelete: async (applicationIds: string[]): Promise<{ deleted: number }> => {
    const response = await apiClient.post('/applications/bulk-delete/', {
      application_ids: applicationIds,
    });
    return response.data;
  },

  bulkArchive: async (applicationIds: string[]): Promise<{ archived: number }> => {
    const response = await apiClient.post('/applications/bulk-archive/', {
      application_ids: applicationIds,
    });
    return response.data;
  },

  export: async (format: 'csv' | 'json' = 'csv'): Promise<Blob> => {
    const response = await apiClient.get('/applications/export/', {
      params: { format },
      responseType: 'blob',
    });
    return response.data;
  },

  toggleFavorite: async (id: string): Promise<JobApplication> => {
    const response = await apiClient.post(`/applications/${id}/toggle-favorite/`);
    return response.data;
  },

  archive: async (id: string): Promise<JobApplication> => {
    const response = await apiClient.post(`/applications/${id}/archive/`);
    return response.data;
  },

  unarchive: async (id: string): Promise<JobApplication> => {
    const response = await apiClient.post(`/applications/${id}/unarchive/`);
    return response.data;
  },

  getTimeline: async (id: string): Promise<any[]> => {
    const response = await apiClient.get(`/applications/${id}/timeline/`);
    return response.data;
  },

  addDocument: async (id: string, file: File, docType: string): Promise<any> => {
    const formData = new FormData();
    formData.append('file', file);
    formData.append('doc_type', docType);
    const response = await apiClient.post(`/applications/${id}/documents/`, formData, {
      headers: { 'Content-Type': 'multipart/form-data' },
    });
    return response.data;
  },
};

// ============================================================================
// TAGS API
// ============================================================================
export const tagsApi = {
  list: async (): Promise<ApplicationTag[]> => {
    const response = await apiClient.get('/applications/tags/');
    return response.data;
  },

  create: async (data: { name: string; color: string }): Promise<ApplicationTag> => {
    const response = await apiClient.post('/applications/tags/', data);
    return response.data;
  },

  update: async (id: string, data: Partial<ApplicationTag>): Promise<ApplicationTag> => {
    const response = await apiClient.patch(`/applications/tags/${id}/`, data);
    return response.data;
  },

  delete: async (id: string): Promise<void> => {
    await apiClient.delete(`/applications/tags/${id}/`);
  },
};

// ============================================================================
// INTERVIEWS API
// ============================================================================
export const interviewsApi = {
  list: async (params?: {
    application?: string;
    status?: string;
    ordering?: string;
  }): Promise<PaginatedResponse<Interview>> => {
    const response = await apiClient.get('/interviews/', { params });
    return response.data;
  },

  get: async (id: string): Promise<Interview> => {
    const response = await apiClient.get(`/interviews/${id}/`);
    return response.data;
  },

  create: async (data: Partial<Interview>): Promise<Interview> => {
    const response = await apiClient.post('/interviews/', data);
    return response.data;
  },

  update: async (id: string, data: Partial<Interview>): Promise<Interview> => {
    const response = await apiClient.patch(`/interviews/${id}/`, data);
    return response.data;
  },

  delete: async (id: string): Promise<void> => {
    await apiClient.delete(`/interviews/${id}/`);
  },

  upcoming: async (): Promise<Interview[]> => {
    const response = await apiClient.get('/interviews/upcoming/');
    return response.data;
  },

  today: async (): Promise<Interview[]> => {
    const response = await apiClient.get('/interviews/today/');
    return response.data;
  },

  complete: async (id: string, data: {
    post_interview_notes?: string;
    feedback?: string;
    rating?: number;
  }): Promise<Interview> => {
    const response = await apiClient.post(`/interviews/${id}/complete/`, data);
    return response.data;
  },

  syncCalendar: async (id: string): Promise<{ google_event_id: string }> => {
    const response = await apiClient.post(`/interviews/${id}/sync-calendar/`);
    return response.data;
  },
};

// ============================================================================
// INTERVIEW QUESTIONS API
// ============================================================================
export const questionsApi = {
  list: async (interviewId: string): Promise<InterviewQuestion[]> => {
    const response = await apiClient.get(`/interviews/${interviewId}/questions/`);
    return response.data;
  },

  create: async (interviewId: string, data: Partial<InterviewQuestion>): Promise<InterviewQuestion> => {
    const response = await apiClient.post(`/interviews/${interviewId}/questions/`, data);
    return response.data;
  },

  update: async (id: string, data: Partial<InterviewQuestion>): Promise<InterviewQuestion> => {
    const response = await apiClient.patch(`/interviews/questions/${id}/`, data);
    return response.data;
  },

  delete: async (id: string): Promise<void> => {
    await apiClient.delete(`/interviews/questions/${id}/`);
  },

  commonQuestions: async (category?: string): Promise<any[]> => {
    const response = await apiClient.get('/interviews/common-questions/', {
      params: { category },
    });
    return response.data;
  },
};

// ============================================================================
// STAR RESPONSES API
// ============================================================================
export const starResponsesApi = {
  list: async (questionId: string): Promise<STARResponse[]> => {
    const response = await apiClient.get(`/interviews/questions/${questionId}/star-responses/`);
    return response.data;
  },

  create: async (questionId: string, data: Partial<STARResponse>): Promise<STARResponse> => {
    const response = await apiClient.post(`/interviews/questions/${questionId}/star-responses/`, data);
    return response.data;
  },

  update: async (id: string, data: Partial<STARResponse>): Promise<STARResponse> => {
    const response = await apiClient.patch(`/interviews/star-responses/${id}/`, data);
    return response.data;
  },

  delete: async (id: string): Promise<void> => {
    await apiClient.delete(`/interviews/star-responses/${id}/`);
  },
};

// ============================================================================
// COMPANY RESEARCH API
// ============================================================================
export const companyResearchApi = {
  get: async (applicationId: string): Promise<CompanyResearch> => {
    const response = await apiClient.get(`/interviews/company-research/${applicationId}/`);
    return response.data;
  },

  createOrUpdate: async (applicationId: string, data: Partial<CompanyResearch>): Promise<CompanyResearch> => {
    const response = await apiClient.post(`/interviews/company-research/${applicationId}/`, data);
    return response.data;
  },
};

// ============================================================================
// REMINDERS API
// ============================================================================
export const remindersApi = {
  list: async (params?: {
    application?: string;
    status?: string;
    reminder_type?: string;
    ordering?: string;
  }): Promise<PaginatedResponse<Reminder>> => {
    const response = await apiClient.get('/reminders/', { params });
    return response.data;
  },

  get: async (id: string): Promise<Reminder> => {
    const response = await apiClient.get(`/reminders/${id}/`);
    return response.data;
  },

  create: async (data: Partial<Reminder>): Promise<Reminder> => {
    const response = await apiClient.post('/reminders/', data);
    return response.data;
  },

  update: async (id: string, data: Partial<Reminder>): Promise<Reminder> => {
    const response = await apiClient.patch(`/reminders/${id}/`, data);
    return response.data;
  },

  delete: async (id: string): Promise<void> => {
    await apiClient.delete(`/reminders/${id}/`);
  },

  snooze: async (id: string, duration: number): Promise<Reminder> => {
    const response = await apiClient.post(`/reminders/${id}/snooze/`, { duration });
    return response.data;
  },

  complete: async (id: string): Promise<Reminder> => {
    const response = await apiClient.post(`/reminders/${id}/complete/`);
    return response.data;
  },

  upcoming: async (): Promise<Reminder[]> => {
    const response = await apiClient.get('/reminders/upcoming/');
    return response.data;
  },
};

// ============================================================================
// NOTIFICATIONS API
// ============================================================================
export const notificationsApi = {
  list: async (params?: { is_read?: boolean }): Promise<PaginatedResponse<Notification>> => {
    const response = await apiClient.get('/reminders/notifications/', { params });
    return response.data;
  },

  markRead: async (id: string): Promise<Notification> => {
    const response = await apiClient.post(`/reminders/notifications/${id}/mark-read/`);
    return response.data;
  },

  markAllRead: async (): Promise<{ updated: number }> => {
    const response = await apiClient.post('/reminders/notifications/mark-all-read/');
    return response.data;
  },

  unreadCount: async (): Promise<{ count: number }> => {
    const response = await apiClient.get('/reminders/notifications/unread-count/');
    return response.data;
  },
};

// ============================================================================
// ANALYTICS API
// ============================================================================
export const analyticsApi = {
  dashboard: async (): Promise<DashboardStats> => {
    const response = await apiClient.get('/analytics/dashboard/');
    return response.data;
  },

  insights: async (): Promise<ApplicationInsights> => {
    const response = await apiClient.get('/analytics/insights/');
    return response.data;
  },

  statusFunnel: async (): Promise<any> => {
    const response = await apiClient.get('/analytics/status-funnel/');
    return response.data;
  },

  exportReport: async (format: 'pdf' | 'csv' = 'pdf'): Promise<Blob> => {
    const response = await apiClient.get('/analytics/export-report/', {
      params: { format },
      responseType: 'blob',
    });
    return response.data;
  },
};

// ============================================================================
// RESUMES API
// ============================================================================
export const resumesApi = {
  list: async (): Promise<PaginatedResponse<Resume>> => {
    const response = await apiClient.get('/users/resumes/');
    return response.data;
  },

  get: async (id: string): Promise<Resume> => {
    const response = await apiClient.get(`/users/resumes/${id}/`);
    return response.data;
  },

  upload: async (file: File, name: string, version?: string): Promise<Resume> => {
    const formData = new FormData();
    formData.append('file', file);
    formData.append('name', name);
    if (version) formData.append('version', version);
    
    const response = await apiClient.post('/users/resumes/', formData, {
      headers: { 'Content-Type': 'multipart/form-data' },
    });
    return response.data;
  },

  delete: async (id: string): Promise<void> => {
    await apiClient.delete(`/users/resumes/${id}/`);
  },

  setDefault: async (id: string): Promise<Resume> => {
    const response = await apiClient.post(`/users/resumes/${id}/set-default/`);
    return response.data;
  },
};

// ============================================================================
// SUBSCRIPTIONS API
// ============================================================================
export const subscriptionsApi = {
  current: async (): Promise<Subscription> => {
    const response = await apiClient.get('/subscriptions/current/');
    return response.data;
  },

  plans: async (): Promise<PricingPlan[]> => {
    const response = await apiClient.get('/subscriptions/plans/');
    return response.data;
  },

  createCheckout: async (planSlug: string): Promise<{ checkout_url: string }> => {
    const response = await apiClient.post('/subscriptions/create-checkout/', { plan: planSlug });
    return response.data;
  },

  customerPortal: async (): Promise<{ portal_url: string }> => {
    const response = await apiClient.get('/subscriptions/customer-portal/');
    return response.data;
  },

  cancel: async (): Promise<Subscription> => {
    const response = await apiClient.post('/subscriptions/cancel/');
    return response.data;
  },

  resume: async (): Promise<Subscription> => {
    const response = await apiClient.post('/subscriptions/resume/');
    return response.data;
  },
};

// ============================================================================
// AI FEATURES API
// ============================================================================
export const aiApi = {
  generateFollowUpEmail: async (applicationId: string, tone?: string): Promise<GeneratedContent> => {
    const response = await apiClient.post('/ai/generate-follow-up-email/', {
      application_id: applicationId,
      tone,
    });
    return response.data;
  },

  getResumeMatchScore: async (applicationId: string): Promise<{
    score: number;
    analysis: unknown;
    suggestions: string[];
  }> => {
    const response = await apiClient.post('/ai/resume-match-score/', {
      application_id: applicationId,
    });
    return response.data;
  },

  generateInterviewQuestions: async (
    applicationId: string,
    interviewType?: string,
    count?: number
  ): Promise<{ questions: unknown[] }> => {
    const response = await apiClient.post('/ai/generate-interview-questions/', {
      application_id: applicationId,
      interview_type: interviewType,
      count,
    });
    return response.data;
  },

  improveStarResponse: async (starResponseId: string): Promise<{
    suggestions: unknown;
    improved_response: unknown;
  }> => {
    const response = await apiClient.post('/ai/improve-star-response/', {
      star_response_id: starResponseId,
    });
    return response.data;
  },

  generateCoverLetter: async (applicationId: string, style?: string): Promise<GeneratedContent> => {
    const response = await apiClient.post('/ai/generate-cover-letter/', {
      application_id: applicationId,
      style,
    });
    return response.data;
  },

  getUsage: async (): Promise<{
    used_this_month: number;
    limit: number;
    features_used: Record<string, number>;
  }> => {
    const response = await apiClient.get('/ai/usage/');
    return response.data;
  },
};

// ============================================================================
// MEETINGS API (Placeholder - may need backend implementation)
// ============================================================================
export const meetingsApi = {
  list: async (_params?: unknown): Promise<any> => {
    // Placeholder - implement when backend is ready
    throw new Error('Meetings API not implemented');
  },

  get: async (_id: string): Promise<any> => {
    throw new Error('Meetings API not implemented');
  },

  getStats: async (): Promise<any> => {
    throw new Error('Meetings API not implemented');
  },

  getAnalytics: async (_days: number): Promise<any> => {
    throw new Error('Meetings API not implemented');
  },

  create: async (_formData: FormData): Promise<any> => {
    throw new Error('Meetings API not implemented');
  },

  update: async (_id: string, _data: any): Promise<any> => {
    throw new Error('Meetings API not implemented');
  },

  delete: async (_id: string): Promise<void> => {
    throw new Error('Meetings API not implemented');
  },

  share: async (_id: string): Promise<any> => {
    throw new Error('Meetings API not implemented');
  },

  toggleFavorite: async (_id: string): Promise<any> => {
    throw new Error('Meetings API not implemented');
  },

  getFavorites: async (): Promise<any> => {
    throw new Error('Meetings API not implemented');
  },
};

// ============================================================================
// ACTION ITEMS API (Placeholder)
// ============================================================================
export const actionItemsApi = {
  list: async (_params?: any): Promise<any> => {
    throw new Error('Action Items API not implemented');
  },

  get: async (_id: string): Promise<any> => {
    throw new Error('Action Items API not implemented');
  },

  create: async (_data: Partial<any>): Promise<any> => {
    throw new Error('Action Items API not implemented');
  },

  update: async (_id: string, _data: any): Promise<any> => {
    throw new Error('Action Items API not implemented');
  },

  complete: async (_id: string): Promise<any> => {
    throw new Error('Action Items API not implemented');
  },

  delete: async (_id: string): Promise<void> => {
    throw new Error('Action Items API not implemented');
  },
};

// ============================================================================
// NOTES API (Placeholder)
// ============================================================================
export const notesApi = {
  list: async (_meetingId?: string): Promise<any> => {
    throw new Error('Notes API not implemented');
  },

  create: async (_data: any): Promise<any> => {
    throw new Error('Notes API not implemented');
  },

  delete: async (_id: string): Promise<void> => {
    throw new Error('Notes API not implemented');
  },
};

// ============================================================================
// ACTIVITIES API (Placeholder)
// ============================================================================
export const activitiesApi = {
  list: async (_limit?: number): Promise<any> => {
    throw new Error('Activities API not implemented');
  },

  get: async (_id: string): Promise<any> => {
    throw new Error('Activities API not implemented');
  },
};

// ============================================================================
// TEMPLATES API (Placeholder)
// ============================================================================
export const templatesApi = {
  list: async (): Promise<any> => {
    throw new Error('Templates API not implemented');
  },

  get: async (_id: string): Promise<any> => {
    throw new Error('Templates API not implemented');
  },

  create: async (_data: Partial<any>): Promise<any> => {
    throw new Error('Templates API not implemented');
  },

  update: async (_id: string, _data: any): Promise<any> => {
    throw new Error('Templates API not implemented');
  },

  delete: async (_id: string): Promise<void> => {
    throw new Error('Templates API not implemented');
  },
};

// ============================================================================
// INTEGRATIONS API (Placeholder)
// ============================================================================
export const integrationsApi = {
  list: async (): Promise<any> => {
    throw new Error('Integrations API not implemented');
  },

  get: async (_id: string): Promise<any> => {
    throw new Error('Integrations API not implemented');
  },

  create: async (_data: Partial<any>): Promise<any> => {
    throw new Error('Integrations API not implemented');
  },

  update: async (_id: string, _data: any): Promise<any> => {
    throw new Error('Integrations API not implemented');
  },

  delete: async (_id: string): Promise<void> => {
    throw new Error('Integrations API not implemented');
  },

  test: async (_id: string, _testMessage?: string): Promise<any> => {
    throw new Error('Integrations API not implemented');
  },
};

// ============================================================================
// NOTIFICATION LOGS API (Placeholder)
// ============================================================================
export const notificationLogsApi = {
  list: async (): Promise<any> => {
    throw new Error('Notification Logs API not implemented');
  },
};

// ============================================================================
// CALENDAR API (Placeholder)
// ============================================================================
export const calendarApi = {
  listConnections: async (): Promise<any> => {
    throw new Error('Calendar API not implemented');
  },

  getConnection: async (_id: string): Promise<any> => {
    throw new Error('Calendar API not implemented');
  },

  createConnection: async (_data: Partial<any>): Promise<any> => {
    throw new Error('Calendar API not implemented');
  },

  updateConnection: async (_id: string, _data: any): Promise<any> => {
    throw new Error('Calendar API not implemented');
  },

  deleteConnection: async (_id: string): Promise<void> => {
    throw new Error('Calendar API not implemented');
  },

  syncConnection: async (_id: string): Promise<any> => {
    throw new Error('Calendar API not implemented');
  },

  listEvents: async (): Promise<any> => {
    throw new Error('Calendar API not implemented');
  },

  listSyncLogs: async (): Promise<any> => {
    throw new Error('Calendar API not implemented');
  },
};

// ============================================================================
// WORKSPACES API (Placeholder)
// ============================================================================
export const workspacesApi = {
  list: async (): Promise<any> => {
    throw new Error('Workspaces API not implemented');
  },

  get: async (_id: string): Promise<any> => {
    throw new Error('Workspaces API not implemented');
  },

  create: async (_data: Partial<any>): Promise<any> => {
    throw new Error('Workspaces API not implemented');
  },

  update: async (_id: string, _data: any): Promise<any> => {
    throw new Error('Workspaces API not implemented');
  },

  delete: async (_id: string): Promise<void> => {
    throw new Error('Workspaces API not implemented');
  },

  listMembers: async (): Promise<any> => {
    throw new Error('Workspaces API not implemented');
  },

  updateMember: async (_id: string, _data: any): Promise<any> => {
    throw new Error('Workspaces API not implemented');
  },

  removeMember: async (_id: string): Promise<void> => {
    throw new Error('Workspaces API not implemented');
  },

  listInvitations: async (): Promise<any> => {
    throw new Error('Workspaces API not implemented');
  },

  createInvitation: async (_data: any): Promise<any> => {
    throw new Error('Workspaces API not implemented');
  },

  acceptInvitation: async (_id: string): Promise<any> => {
    throw new Error('Workspaces API not implemented');
  },

  declineInvitation: async (_id: string): Promise<any> => {
    throw new Error('Workspaces API not implemented');
  },
};

// ============================================================================
// NETWORKING API
// ============================================================================
export const networkingApi = {
  // Connections
  listConnections: async (): Promise<any[]> => {
    const response = await apiClient.get('/networking/connections/');
    return response.data;
  },

  getConnection: async (id: string): Promise<any> => {
    const response = await apiClient.get(`/networking/connections/${id}/`);
    return response.data;
  },

  createConnection: async (data: any): Promise<any> => {
    const response = await apiClient.post('/networking/connections/', data);
    return response.data;
  },

  updateConnection: async (id: string, data: any): Promise<any> => {
    const response = await apiClient.patch(`/networking/connections/${id}/`, data);
    return response.data;
  },

  deleteConnection: async (id: string): Promise<void> => {
    await apiClient.delete(`/networking/connections/${id}/`);
  },

  // Referrals
  listReferrals: async (): Promise<any[]> => {
    const response = await apiClient.get('/networking/referrals/');
    return response.data;
  },

  createReferral: async (data: any): Promise<any> => {
    const response = await apiClient.post('/networking/referrals/', data);
    return response.data;
  },

  // Events
  listEvents: async (): Promise<any[]> => {
    const response = await apiClient.get('/networking/events/');
    return response.data;
  },

  createEvent: async (data: any): Promise<any> => {
    const response = await apiClient.post('/networking/events/', data);
    return response.data;
  },

  // Mentorship
  listMentorships: async (): Promise<any[]> => {
    const response = await apiClient.get('/networking/mentorships/');
    return response.data;
  },

  createMentorship: async (data: any): Promise<any> => {
    const response = await apiClient.post('/networking/mentorships/', data);
    return response.data;
  },
};

// ============================================================================
// CAREER API
// ============================================================================
export const careerApi = {
  // Skills
  listSkills: async (): Promise<any[]> => {
    const response = await apiClient.get('/career/skills/');
    return response.data;
  },

  listUserSkills: async (): Promise<any[]> => {
    const response = await apiClient.get('/career/user-skills/');
    return response.data;
  },

  addUserSkill: async (data: any): Promise<any> => {
    const response = await apiClient.post('/career/user-skills/', data);
    return response.data;
  },

  updateUserSkill: async (id: string, data: any): Promise<any> => {
    const response = await apiClient.patch(`/career/user-skills/${id}/`, data);
    return response.data;
  },

  // Skill Gap Analysis
  listSkillGaps: async (): Promise<any[]> => {
    const response = await apiClient.get('/career/skill-gaps/');
    return response.data;
  },

  analyzeSkillGap: async (data: any): Promise<any> => {
    const response = await apiClient.post('/career/skill-gaps/analyze/', data);
    return response.data;
  },

  // Learning Resources
  listLearningResources: async (): Promise<any[]> => {
    const response = await apiClient.get('/career/learning-resources/');
    return response.data;
  },

  listUserProgress: async (): Promise<any[]> => {
    const response = await apiClient.get('/career/user-progress/');
    return response.data;
  },

  updateProgress: async (id: string, data: any): Promise<any> => {
    const response = await apiClient.patch(`/career/user-progress/${id}/`, data);
    return response.data;
  },

  // Learning Paths
  listLearningPaths: async (): Promise<any[]> => {
    const response = await apiClient.get('/career/learning-paths/');
    return response.data;
  },

  generateLearningPath: async (data: any): Promise<any> => {
    const response = await apiClient.post('/career/learning-paths/generate/', data);
    return response.data;
  },

  // Portfolio Projects
  listProjects: async (): Promise<any[]> => {
    const response = await apiClient.get('/career/projects/');
    return response.data;
  },

  createProject: async (data: any): Promise<any> => {
    const response = await apiClient.post('/career/projects/', data);
    return response.data;
  },

  updateProject: async (id: string, data: any): Promise<any> => {
    const response = await apiClient.patch(`/career/projects/${id}/`, data);
    return response.data;
  },

  deleteProject: async (id: string): Promise<void> => {
    await apiClient.delete(`/career/projects/${id}/`);
  },

  // Career Goals
  listGoals: async (): Promise<any[]> => {
    const response = await apiClient.get('/career/goals/');
    return response.data;
  },

  createGoal: async (data: any): Promise<any> => {
    const response = await apiClient.post('/career/goals/', data);
    return response.data;
  },

  updateGoal: async (id: string, data: any): Promise<any> => {
    const response = await apiClient.patch(`/career/goals/${id}/`, data);
    return response.data;
  },
};

// ============================================================================
// GAMIFICATION API
// ============================================================================
export const gamificationApi = {
  // Achievements
  listAchievements: async (): Promise<any[]> => {
    const response = await apiClient.get('/gamification/achievements/');
    return response.data;
  },

  listUserAchievements: async (): Promise<any[]> => {
    const response = await apiClient.get('/gamification/user-achievements/');
    return response.data;
  },

  // Points & Streaks
  getPoints: async (): Promise<any> => {
    const response = await apiClient.get('/gamification/points/');
    return response.data;
  },

  getStreaks: async (): Promise<any[]> => {
    const response = await apiClient.get('/gamification/streaks/');
    return response.data;
  },

  // Leaderboard
  getLeaderboard: async (period: string = 'weekly'): Promise<any> => {
    const response = await apiClient.get(`/gamification/leaderboard/?period=${period}`);
    return response.data;
  },

  // Challenges
  listChallenges: async (): Promise<any[]> => {
    const response = await apiClient.get('/gamification/challenges/');
    return response.data;
  },

  listUserChallenges: async (): Promise<any[]> => {
    const response = await apiClient.get('/gamification/user-challenges/');
    return response.data;
  },

  joinChallenge: async (challengeId: string): Promise<any> => {
    const response = await apiClient.post('/gamification/user-challenges/', { challenge: challengeId });
    return response.data;
  },

  // Community
  listPosts: async (): Promise<any[]> => {
    const response = await apiClient.get('/gamification/community/posts/');
    return response.data;
  },

  createPost: async (data: any): Promise<any> => {
    const response = await apiClient.post('/gamification/community/posts/', data);
    return response.data;
  },

  upvotePost: async (postId: string): Promise<any> => {
    const response = await apiClient.post(`/gamification/community/posts/${postId}/upvote/`);
    return response.data;
  },
};

// ============================================================================
// MARKET INTELLIGENCE API
// ============================================================================
export const marketIntelApi = {
  // Companies
  listCompanies: async (search?: string): Promise<any[]> => {
    const response = await apiClient.get('/market-intel/companies/', { params: { search } });
    return response.data;
  },

  getCompany: async (id: string): Promise<any> => {
    const response = await apiClient.get(`/market-intel/companies/${id}/`);
    return response.data;
  },

  getCompanyByDomain: async (domain: string): Promise<any> => {
    const response = await apiClient.get('/market-intel/companies/by_domain/', { params: { domain } });
    return response.data;
  },

  // Salary Data
  listSalaries: async (params?: any): Promise<any[]> => {
    const response = await apiClient.get('/market-intel/salaries/', { params });
    return response.data;
  },

  estimateSalary: async (data: any): Promise<any> => {
    const response = await apiClient.post('/market-intel/salaries/estimate/', data);
    return response.data;
  },

  // Industry Trends
  listTrends: async (industry?: string): Promise<any[]> => {
    const response = await apiClient.get('/market-intel/industry-trends/', { params: { industry } });
    return response.data;
  },

  getCurrentTrends: async (): Promise<any[]> => {
    const response = await apiClient.get('/market-intel/industry-trends/current/');
    return response.data;
  },

  // Hiring Seasons
  getHiringSeasons: async (industry?: string): Promise<any> => {
    const response = await apiClient.get('/market-intel/hiring-seasons/best_time/', { params: { industry } });
    return response.data;
  },

  // Heatmap
  getHeatmap: async (country?: string, industry?: string): Promise<any[]> => {
    const response = await apiClient.get('/market-intel/heatmap/by_country/', { params: { country, industry } });
    return response.data;
  },

  // Predictions
  getPrediction: async (applicationId: string): Promise<any> => {
    const response = await apiClient.post('/market-intel/predictions/predict/', { application_id: applicationId });
    return response.data;
  },

  // ROI
  listROI: async (): Promise<any[]> => {
    const response = await apiClient.get('/market-intel/roi/');
    return response.data;
  },

  calculateROI: async (startDate: string, endDate: string): Promise<any> => {
    const response = await apiClient.post('/market-intel/roi/calculate/', { start_date: startDate, end_date: endDate });
    return response.data;
  },
};

// ============================================================================
// PRIVACY & SECURITY API
// ============================================================================
export const privacyApi = {
  // Data Export
  listExports: async (): Promise<any[]> => {
    const response = await apiClient.get('/privacy/exports/');
    return response.data;
  },

  requestExport: async (data: any): Promise<any> => {
    const response = await apiClient.post('/privacy/exports/', data);
    return response.data;
  },

  downloadExport: async (id: string): Promise<any> => {
    const response = await apiClient.get(`/privacy/exports/${id}/download/`);
    return response.data;
  },

  // 2FA
  get2FAStatus: async (): Promise<any> => {
    const response = await apiClient.get('/privacy/2fa/');
    return response.data;
  },

  setup2FA: async (data: any): Promise<any> => {
    const response = await apiClient.post('/privacy/2fa/', data);
    return response.data;
  },

  verify2FA: async (code: string, useBackup?: boolean): Promise<any> => {
    const response = await apiClient.post('/privacy/2fa/verify/', { code, use_backup: useBackup });
    return response.data;
  },

  disable2FA: async (): Promise<void> => {
    await apiClient.delete('/privacy/2fa/');
  },

  // Login Attempts
  listLoginAttempts: async (): Promise<any[]> => {
    const response = await apiClient.get('/privacy/login-attempts/');
    return response.data;
  },

  // Encrypted Notes
  listEncryptedNotes: async (): Promise<any[]> => {
    const response = await apiClient.get('/privacy/notes/');
    return response.data;
  },

  createEncryptedNote: async (data: any): Promise<any> => {
    const response = await apiClient.post('/privacy/notes/', data);
    return response.data;
  },

  updateEncryptedNote: async (id: string, data: any): Promise<any> => {
    const response = await apiClient.patch(`/privacy/notes/${id}/`, data);
    return response.data;
  },

  deleteEncryptedNote: async (id: string): Promise<void> => {
    await apiClient.delete(`/privacy/notes/${id}/`);
  },

  // Audit Log
  listAuditLogs: async (): Promise<any[]> => {
    const response = await apiClient.get('/privacy/audit-log/');
    return response.data;
  },

  // Privacy Settings
  getPrivacySettings: async (): Promise<any> => {
    const response = await apiClient.get('/privacy/settings/');
    return response.data;
  },

  updatePrivacySettings: async (data: any): Promise<any> => {
    const response = await apiClient.patch('/privacy/settings/', data);
    return response.data;
  },
};

// ============================================================================
// EXPORT ALL APIS
// ============================================================================
export const api = {
  auth: authApi,
  applications: applicationsApi,
  tags: tagsApi,
  interviews: interviewsApi,
  questions: questionsApi,
  starResponses: starResponsesApi,
  companyResearch: companyResearchApi,
  reminders: remindersApi,
  notifications: notificationsApi,
  analytics: analyticsApi,
  resumes: resumesApi,
  subscriptions: subscriptionsApi,
  ai: aiApi,
  meetings: meetingsApi,
  actionItems: actionItemsApi,
  notes: notesApi,
  activities: activitiesApi,
  templates: templatesApi,
  integrations: integrationsApi,
  notificationLogs: notificationLogsApi,
  calendar: calendarApi,
  workspaces: workspacesApi,
  networking: networkingApi,
  career: careerApi,
  gamification: gamificationApi,
  marketIntel: marketIntelApi,
  privacy: privacyApi,
};
