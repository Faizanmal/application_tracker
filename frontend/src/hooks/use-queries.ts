'use client';

import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { AxiosError } from 'axios';
import { api } from '@/lib/api';
import type {
  User,
  JobApplication,
  ApplicationStatus,
  Interview,
  Reminder,
  CompanyResearch,
  STARResponse,
} from '@/types';
import { toast } from 'sonner';

// ============================================================================
// QUERY KEYS
// ============================================================================
export const queryKeys = {
  // Auth
  user: ['user'] as const,
  
  // Applications
  applications: ['applications'] as const,
  application: (id: string) => ['applications', id] as const,
  kanban: ['applications', 'kanban'] as const,
  
  // Tags
  tags: ['tags'] as const,
  
  // Interviews
  interviews: ['interviews'] as const,
  interview: (id: string) => ['interviews', id] as const,
  upcomingInterviews: ['interviews', 'upcoming'] as const,
  todayInterviews: ['interviews', 'today'] as const,
  interviewQuestions: (interviewId: string) => ['interviews', interviewId, 'questions'] as const,
  commonQuestions: ['interviews', 'common-questions'] as const,
  
  // Company Research
  companyResearch: (applicationId: string) => ['company-research', applicationId] as const,
  
  // Reminders
  reminders: ['reminders'] as const,
  reminder: (id: string) => ['reminders', id] as const,
  upcomingReminders: ['reminders', 'upcoming'] as const,
  
  // Notifications
  notifications: ['notifications'] as const,
  unreadCount: ['notifications', 'unread-count'] as const,
  
  // Analytics
  dashboard: ['analytics', 'dashboard'] as const,
  insights: ['analytics', 'insights'] as const,
  statusFunnel: ['analytics', 'status-funnel'] as const,
  
  // Resumes
  resumes: ['resumes'] as const,
  
  // Subscriptions
  subscription: ['subscription'] as const,
  plans: ['plans'] as const,
  
  // AI
  aiUsage: ['ai', 'usage'] as const,
};

// ============================================================================
// USER HOOKS
// ============================================================================
export function useUser() {
  return useQuery({
    queryKey: queryKeys.user,
    queryFn: () => api.auth.me(),
    staleTime: 5 * 60 * 1000, // 5 minutes
    retry: false,
  });
}

export function useChangePassword() {
  const _queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: (data: { current_password: string; new_password: string }) =>
      api.auth.changePassword(data),
    onSuccess: () => {
      toast.success('Password changed successfully');
    },
    onError: (error: AxiosError) => {
      const err = error as { response?: { data?: { detail?: string } } };
      toast.error(err.response?.data?.detail || 'Failed to change password');
    },
  });
}

export function useUpdateProfile() {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: (data: Partial<User>) => api.auth.updateProfile(data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: queryKeys.user });
      toast.success('Profile updated successfully');
    },
    onError: (error: AxiosError) => {
      const data = error.response?.data as { detail?: string };
      toast.error(data?.detail || 'Failed to update profile');
    },
  });
}

// ============================================================================
// APPLICATIONS HOOKS
// ============================================================================
export function useApplications(params?: {
  status?: string;
  is_favorite?: boolean;
  is_archived?: boolean;
  search?: string;
  ordering?: string;
  page?: number;
}) {
  return useQuery({
    queryKey: [...queryKeys.applications, params],
    queryFn: () => api.applications.list(params),
    staleTime: 30 * 1000,
  });
}

export function useApplication(id: number) {
  return useQuery({
    queryKey: queryKeys.application(id.toString()),
    queryFn: () => api.applications.get(id.toString()),
    enabled: !!id,
  });
}

export function useKanban() {
  return useQuery({
    queryKey: queryKeys.kanban,
    queryFn: () => api.applications.kanban(),
    staleTime: 30 * 1000,
  });
}

export function useCreateApplication() {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: (data: Partial<JobApplication>) => api.applications.create(data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: queryKeys.applications });
      queryClient.invalidateQueries({ queryKey: queryKeys.kanban });
      queryClient.invalidateQueries({ queryKey: queryKeys.dashboard });
      toast.success('Application created successfully');
    },
    onError: (error: AxiosError) => {
      const err = error as { response?: { data?: { detail?: string } } };
      toast.error(err.response?.data?.detail || 'Failed to create application');
    },
  });
}

export function useUpdateApplication() {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: ({ id, data }: { id: number; data: Partial<JobApplication> }) =>
      api.applications.update(id.toString(), data),
    onSuccess: (_, { id }) => {
      queryClient.invalidateQueries({ queryKey: queryKeys.applications });
      queryClient.invalidateQueries({ queryKey: queryKeys.application(id.toString()) });
      queryClient.invalidateQueries({ queryKey: queryKeys.kanban });
      toast.success('Application updated successfully');
    },
    onError: (error: AxiosError) => {
      const err = error as { response?: { data?: { detail?: string } } };
      toast.error(err.response?.data?.detail || 'Failed to update application');
    },
  });
}

export function useDeleteApplication() {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: (id: string) => api.applications.delete(id),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: queryKeys.applications });
      queryClient.invalidateQueries({ queryKey: queryKeys.kanban });
      queryClient.invalidateQueries({ queryKey: queryKeys.dashboard });
      toast.success('Application deleted successfully');
    },
    onError: (error: AxiosError) => {
      const err = error as { response?: { data?: { detail?: string } } };
      toast.error(err.response?.data?.detail || 'Failed to delete application');
    },
  });
}

export function useInterviewsByApplication(applicationId: string) {
  return useQuery({
    queryKey: [...queryKeys.interviews, 'by-application', applicationId],
    queryFn: () => api.interviews.list({ application: applicationId }),
    enabled: !!applicationId,
  });
}

export function useRemindersByApplication(applicationId: string) {
  return useQuery({
    queryKey: [...queryKeys.reminders, 'by-application', applicationId],
    queryFn: () => api.reminders.list({ application: applicationId }),
    enabled: !!applicationId,
  });
}

export function useMatchResume() {
  return useMutation({
    mutationFn: (applicationId: string) => api.ai.getResumeMatchScore(applicationId),
  });
}

export function useUpdateKanbanOrder() {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: (data: {
      application_id: string;
      new_status: ApplicationStatus;
      new_order: number;
    }) => api.applications.updateKanbanOrder(data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: queryKeys.kanban });
      queryClient.invalidateQueries({ queryKey: queryKeys.dashboard });
    },
    onError: (error: AxiosError) => {
      queryClient.invalidateQueries({ queryKey: queryKeys.kanban });
      toast.error((error.response?.data as { detail?: string })?.detail || 'Failed to update order');
    },
  });
}

export function useToggleFavorite() {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: (id: string) => api.applications.toggleFavorite(id),
    onSuccess: (_, id) => {
      queryClient.invalidateQueries({ queryKey: queryKeys.applications });
      queryClient.invalidateQueries({ queryKey: queryKeys.application(id) });
      queryClient.invalidateQueries({ queryKey: queryKeys.kanban });
    },
  });
}

export function useBulkUpdateStatus() {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: (data: { application_ids: string[]; status: ApplicationStatus }) =>
      api.applications.bulkUpdateStatus(data),
    onSuccess: ({ updated }) => {
      queryClient.invalidateQueries({ queryKey: queryKeys.applications });
      queryClient.invalidateQueries({ queryKey: queryKeys.kanban });
      toast.success(`Updated ${updated} applications`);
    },
    onError: (error: AxiosError) => {
      toast.error((error.response?.data as { detail?: string })?.detail || 'Failed to update applications');
    },
  });
}

// ============================================================================
// TAGS HOOKS
// ============================================================================
export function useTags() {
  return useQuery({
    queryKey: queryKeys.tags,
    queryFn: () => api.tags.list(),
    staleTime: 5 * 60 * 1000,
  });
}

export function useCreateTag() {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: (data: { name: string; color: string }) => api.tags.create(data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: queryKeys.tags });
      toast.success('Tag created successfully');
    },
  });
}

// ============================================================================
// INTERVIEWS HOOKS
// ============================================================================
export function useInterviews(params?: {
  application?: string;
  status?: string;
  ordering?: string;
}) {
  return useQuery({
    queryKey: [...queryKeys.interviews, params],
    queryFn: () => api.interviews.list(params),
    staleTime: 30 * 1000,
  });
}

export function useInterview(id: number) {
  return useQuery({
    queryKey: queryKeys.interview(id.toString()),
    queryFn: () => api.interviews.get(id.toString()),
    enabled: !!id,
  });
}

export function useUpcomingInterviews() {
  return useQuery({
    queryKey: queryKeys.upcomingInterviews,
    queryFn: () => api.interviews.upcoming(),
    staleTime: 60 * 1000,
  });
}

export function useTodayInterviews() {
  return useQuery({
    queryKey: queryKeys.todayInterviews,
    queryFn: () => api.interviews.today(),
    staleTime: 60 * 1000,
    refetchInterval: 5 * 60 * 1000, // Refetch every 5 minutes
  });
}

export function useCreateInterview() {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: (data: Partial<Interview>) => api.interviews.create(data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: queryKeys.interviews });
      queryClient.invalidateQueries({ queryKey: queryKeys.upcomingInterviews });
      queryClient.invalidateQueries({ queryKey: queryKeys.dashboard });
      toast.success('Interview scheduled successfully');
    },
    onError: (error: AxiosError) => {
      toast.error((error.response?.data as { detail?: string })?.detail || 'Failed to schedule interview');
    },
  });
}

export function useUpdateInterview() {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: ({ id, data }: { id: number; data: Partial<Interview> }) =>
      api.interviews.update(id.toString(), data),
    onSuccess: (_, { id }) => {
      queryClient.invalidateQueries({ queryKey: queryKeys.interviews });
      queryClient.invalidateQueries({ queryKey: queryKeys.interview(id.toString()) });
      queryClient.invalidateQueries({ queryKey: queryKeys.upcomingInterviews });
      toast.success('Interview updated successfully');
    },
    onError: (error: AxiosError) => {
      toast.error((error.response?.data as { detail?: string })?.detail || 'Failed to update interview');
    },
  });
}

export function useCompleteInterview() {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: ({ id, data }: { id: number; data: { post_interview_notes?: string; feedback?: string; rating?: number } }) =>
      api.interviews.complete(id.toString(), data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: queryKeys.interviews });
      queryClient.invalidateQueries({ queryKey: queryKeys.upcomingInterviews });
      toast.success('Interview marked as completed');
    },
  });
}

export function useDeleteInterview() {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: (id: number) => api.interviews.delete(id.toString()),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: queryKeys.interviews });
      queryClient.invalidateQueries({ queryKey: queryKeys.upcomingInterviews });
      toast.success('Interview deleted successfully');
    },
    onError: (error: AxiosError) => {
      toast.error((error.response?.data as { detail?: string })?.detail || 'Failed to delete interview');
    },
  });
}

export function useInterviewQuestions(interviewId: number) {
  return useQuery({
    queryKey: queryKeys.interviewQuestions(interviewId.toString()),
    queryFn: () => api.questions.list(interviewId.toString()),
    enabled: !!interviewId,
  });
}

export function useStarResponses(questionId: number) {
  return useQuery({
    queryKey: [...queryKeys.interviews, questionId.toString(), 'star-responses'],
    queryFn: () => api.starResponses.list(questionId.toString()),
    enabled: !!questionId,
  });
}

export function useCreateStarResponse() {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: ({ questionId, data }: { questionId: number; data: Partial<STARResponse> }) =>
      api.starResponses.create(questionId.toString(), data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: queryKeys.interviews });
      toast.success('STAR response saved');
    },
  });
}

// ============================================================================
// COMPANY RESEARCH HOOKS
// ============================================================================
export function useCompanyResearch(applicationId: string) {
  return useQuery({
    queryKey: queryKeys.companyResearch(applicationId),
    queryFn: () => api.companyResearch.get(applicationId),
    enabled: !!applicationId,
  });
}

export function useSaveCompanyResearch() {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: ({ applicationId, data }: { applicationId: string; data: Partial<CompanyResearch> }) =>
      api.companyResearch.createOrUpdate(applicationId, data),
    onSuccess: (_, { applicationId }) => {
      queryClient.invalidateQueries({ queryKey: queryKeys.companyResearch(applicationId) });
      toast.success('Research saved successfully');
    },
  });
}

// ============================================================================
// REMINDERS HOOKS
// ============================================================================
export function useReminders(params?: {
  status?: string;
  reminder_type?: string;
  ordering?: string;
}) {
  return useQuery({
    queryKey: [...queryKeys.reminders, params],
    queryFn: () => api.reminders.list(params),
    staleTime: 30 * 1000,
  });
}

export function useUpcomingReminders() {
  return useQuery({
    queryKey: queryKeys.upcomingReminders,
    queryFn: () => api.reminders.upcoming(),
    staleTime: 60 * 1000,
  });
}

export function useCreateReminder() {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: (data: Partial<Reminder>) => api.reminders.create(data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: queryKeys.reminders });
      queryClient.invalidateQueries({ queryKey: queryKeys.upcomingReminders });
      toast.success('Reminder created successfully');
    },
    onError: (error: AxiosError) => {
      toast.error((error.response?.data as { detail?: string })?.detail || 'Failed to create reminder');
    },
  });
}

export function useSnoozeReminder() {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: ({ id, duration }: { id: string; duration: number }) =>
      api.reminders.snooze(id, duration),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: queryKeys.reminders });
      toast.success('Reminder snoozed');
    },
  });
}

export function useCompleteReminder() {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: (id: string) => api.reminders.complete(id),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: queryKeys.reminders });
      toast.success('Reminder completed');
    },
  });
}

// ============================================================================
// NOTIFICATIONS HOOKS
// ============================================================================
export function useNotifications(params?: { is_read?: boolean }) {
  return useQuery({
    queryKey: [...queryKeys.notifications, params],
    queryFn: () => api.notifications.list(params),
    staleTime: 30 * 1000,
  });
}

export function useUnreadCount() {
  return useQuery({
    queryKey: queryKeys.unreadCount,
    queryFn: () => api.notifications.unreadCount(),
    staleTime: 30 * 1000,
    refetchInterval: 60 * 1000, // Refetch every minute
  });
}

export function useMarkNotificationRead() {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: (id: string) => api.notifications.markRead(id),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: queryKeys.notifications });
      queryClient.invalidateQueries({ queryKey: queryKeys.unreadCount });
    },
  });
}

export function useMarkAllNotificationsRead() {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: () => api.notifications.markAllRead(),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: queryKeys.notifications });
      queryClient.invalidateQueries({ queryKey: queryKeys.unreadCount });
    },
  });
}

// ============================================================================
// ANALYTICS HOOKS
// ============================================================================
export function useDashboard() {
  return useQuery({
    queryKey: queryKeys.dashboard,
    queryFn: () => api.analytics.dashboard(),
    staleTime: 60 * 1000,
  });
}

export function useInsights() {
  return useQuery({
    queryKey: queryKeys.insights,
    queryFn: () => api.analytics.insights(),
    staleTime: 5 * 60 * 1000,
  });
}

export function useStatusFunnel() {
  return useQuery({
    queryKey: queryKeys.statusFunnel,
    queryFn: () => api.analytics.statusFunnel(),
    staleTime: 5 * 60 * 1000,
  });
}

export function useAnalytics() {
  return useQuery({
    queryKey: queryKeys.dashboard,
    queryFn: () => api.analytics.dashboard(),
    staleTime: 60 * 1000,
  });
}

export function useExportApplications() {
  return useMutation({
    mutationFn: (format: 'pdf' | 'csv' = 'pdf') => api.analytics.exportReport(format),
    onSuccess: (blob) => {
      const url = window.URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = url;
      a.download = `applications.${blob.type.split('/')[1]}`;
      document.body.appendChild(a);
      a.click();
      window.URL.revokeObjectURL(url);
      document.body.removeChild(a);
    },
  });
}

// ============================================================================
// RESUMES HOOKS
// ============================================================================
export function useResumes() {
  return useQuery({
    queryKey: queryKeys.resumes,
    queryFn: () => api.resumes.list(),
    staleTime: 5 * 60 * 1000,
  });
}

export function useUploadResume() {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: ({ file, name, version }: { file: File; name: string; version?: string }) =>
      api.resumes.upload(file, name, version),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: queryKeys.resumes });
      toast.success('Resume uploaded successfully');
    },
    onError: (error: AxiosError) => {
      toast.error((error.response?.data as { detail?: string })?.detail || 'Failed to upload resume');
    },
  });
}

export function useDeleteResume() {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: (id: number) => api.resumes.delete(id.toString()),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: queryKeys.resumes });
      toast.success('Resume deleted');
    },
  });
}

export function useSetDefaultResume() {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: (id: number) => api.resumes.setDefault(id.toString()),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: queryKeys.resumes });
      toast.success('Default resume updated');
    },
  });
}

// ============================================================================
// SUBSCRIPTION HOOKS
// ============================================================================
export function useSubscription() {
  return useQuery({
    queryKey: queryKeys.subscription,
    queryFn: () => api.subscriptions.current(),
    staleTime: 5 * 60 * 1000,
  });
}

export function usePricingPlans() {
  return useQuery({
    queryKey: queryKeys.plans,
    queryFn: () => api.subscriptions.plans(),
    staleTime: 10 * 60 * 1000,
  });
}

export function useCreateCheckoutSession() {
  return useMutation({
    mutationFn: (planSlug: string) => api.subscriptions.createCheckout(planSlug),
    onSuccess: ({ checkout_url }) => {
      window.location.href = checkout_url;
    },
    onError: (error: AxiosError) => {
      toast.error((error.response?.data as { detail?: string })?.detail || 'Failed to create checkout session');
    },
  });
}

export function useCreatePortalSession() {
  return useMutation({
    mutationFn: () => api.subscriptions.customerPortal(),
    onSuccess: ({ portal_url }) => {
      window.location.href = portal_url;
    },
    onError: (error: AxiosError) => {
      toast.error((error.response?.data as { detail?: string })?.detail || 'Failed to create portal session');
    },
  });
}

export function useCancelSubscription() {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: () => api.subscriptions.cancel(),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: queryKeys.subscription });
      queryClient.invalidateQueries({ queryKey: queryKeys.user });
      toast.success('Subscription cancelled');
    },
  });
}

export function useResumeSubscription() {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: () => api.subscriptions.resume(),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: queryKeys.subscription });
      queryClient.invalidateQueries({ queryKey: queryKeys.user });
      toast.success('Subscription resumed');
    },
  });
}

// ============================================================================
// AI HOOKS
// ============================================================================
export function useAIUsage() {
  return useQuery({
    queryKey: queryKeys.aiUsage,
    queryFn: () => api.ai.getUsage(),
    staleTime: 5 * 60 * 1000,
  });
}

export function useGenerateFollowUpEmail() {
  return useMutation({
    mutationFn: ({ applicationId, tone }: { applicationId: string; tone?: string }) =>
      api.ai.generateFollowUpEmail(applicationId, tone),
    onSuccess: () => {
      toast.success('Follow-up email generated');
    },
    onError: (error: AxiosError) => {
      toast.error((error.response?.data as { detail?: string })?.detail || 'Failed to generate email');
    },
  });
}

export function useResumeMatchScore() {
  return useMutation({
    mutationFn: (applicationId: string) => api.ai.getResumeMatchScore(applicationId),
  });
}

export function useGenerateInterviewQuestions() {
  return useMutation({
    mutationFn: ({ applicationId, interviewType, count }: { applicationId: string; interviewType?: string; count?: number }) =>
      api.ai.generateInterviewQuestions(applicationId, interviewType, count),
    onSuccess: () => {
      toast.success('Interview questions generated');
    },
  });
}

export function useImproveStarResponse() {
  return useMutation({
    mutationFn: (starResponseId: string) => api.ai.improveStarResponse(starResponseId),
    onSuccess: () => {
      toast.success('STAR response improved');
    },
  });
}

export function useGenerateCoverLetter() {
  return useMutation({
    mutationFn: ({ applicationId, style }: { applicationId: string; style?: string }) =>
      api.ai.generateCoverLetter(applicationId, style),
    onSuccess: () => {
      toast.success('Cover letter generated');
    },
    onError: (error: AxiosError) => {
      toast.error((error.response?.data as { detail?: string })?.detail || 'Failed to generate cover letter');
    },
  });
}
// ============================================================================
// NETWORKING HOOKS
// ============================================================================
export const networkingKeys = {
  connections: ['networking', 'connections'] as const,
  connection: (id: string) => ['networking', 'connections', id] as const,
  referrals: ['networking', 'referrals'] as const,
  events: ['networking', 'events'] as const,
  mentorships: ['networking', 'mentorships'] as const,
};

export function useConnections() {
  return useQuery({
    queryKey: networkingKeys.connections,
    queryFn: () => api.networking.listConnections(),
  });
}

export function useCreateConnection() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (data: Record<string, unknown>) => api.networking.createConnection(data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: networkingKeys.connections });
      toast.success('Connection added');
    },
  });
}

export function useUpdateConnection() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: ({ id, data }: { id: string; data: Record<string, unknown> }) => api.networking.updateConnection(id, data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: networkingKeys.connections });
      toast.success('Connection updated');
    },
  });
}

export function useDeleteConnection() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (id: string) => api.networking.deleteConnection(id),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: networkingKeys.connections });
      toast.success('Connection deleted');
    },
  });
}

export function useReferrals() {
  return useQuery({
    queryKey: networkingKeys.referrals,
    queryFn: () => api.networking.listReferrals(),
  });
}

export function useNetworkingEvents() {
  return useQuery({
    queryKey: networkingKeys.events,
    queryFn: () => api.networking.listEvents(),
  });
}

export function useMentorships() {
  return useQuery({
    queryKey: networkingKeys.mentorships,
    queryFn: () => api.networking.listMentorships(),
  });
}

// ============================================================================
// CAREER HOOKS
// ============================================================================
export const careerKeys = {
  skills: ['career', 'skills'] as const,
  userSkills: ['career', 'user-skills'] as const,
  skillGaps: ['career', 'skill-gaps'] as const,
  learningResources: ['career', 'learning-resources'] as const,
  learningProgress: ['career', 'learning-progress'] as const,
  learningPaths: ['career', 'learning-paths'] as const,
  projects: ['career', 'projects'] as const,
  goals: ['career', 'goals'] as const,
};

export function useSkills() {
  return useQuery({
    queryKey: careerKeys.skills,
    queryFn: () => api.career.listSkills(),
  });
}

export function useUserSkills() {
  return useQuery({
    queryKey: careerKeys.userSkills,
    queryFn: () => api.career.listUserSkills(),
  });
}

export function useAddUserSkill() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (data: Record<string, unknown>) => api.career.addUserSkill(data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: careerKeys.userSkills });
      toast.success('Skill added');
    },
  });
}

export function useSkillGapAnalysis() {
  return useQuery({
    queryKey: careerKeys.skillGaps,
    queryFn: () => api.career.listSkillGaps(),
  });
}

export function useAnalyzeSkillGap() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (data: Record<string, unknown>) => api.career.analyzeSkillGap(data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: careerKeys.skillGaps });
      toast.success('Skill gap analysis completed');
    },
  });
}

export function useLearningResources() {
  return useQuery({
    queryKey: careerKeys.learningResources,
    queryFn: () => api.career.listLearningResources(),
  });
}

export function useLearningProgress() {
  return useQuery({
    queryKey: careerKeys.learningProgress,
    queryFn: () => api.career.listUserProgress(),
  });
}

export function useLearningPaths() {
  return useQuery({
    queryKey: careerKeys.learningPaths,
    queryFn: () => api.career.listLearningPaths(),
  });
}

export function useGenerateLearningPath() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (data: Record<string, unknown>) => api.career.generateLearningPath(data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: careerKeys.learningPaths });
      toast.success('Learning path generated');
    },
  });
}

export function usePortfolioProjects() {
  return useQuery({
    queryKey: careerKeys.projects,
    queryFn: () => api.career.listProjects(),
  });
}

export function useCreateProject() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (data: Record<string, unknown>) => api.career.createProject(data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: careerKeys.projects });
      toast.success('Project added');
    },
  });
}

export function useCareerGoals() {
  return useQuery({
    queryKey: careerKeys.goals,
    queryFn: () => api.career.listGoals(),
  });
}

export function useCreateCareerGoal() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (data: Record<string, unknown>) => api.career.createGoal(data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: careerKeys.goals });
      toast.success('Goal created');
    },
  });
}

// ============================================================================
// GAMIFICATION HOOKS
// ============================================================================
export const gamificationKeys = {
  achievements: ['gamification', 'achievements'] as const,
  userAchievements: ['gamification', 'user-achievements'] as const,
  points: ['gamification', 'points'] as const,
  streaks: ['gamification', 'streaks'] as const,
  leaderboard: (period: string) => ['gamification', 'leaderboard', period] as const,
  challenges: ['gamification', 'challenges'] as const,
  userChallenges: ['gamification', 'user-challenges'] as const,
  communityPosts: ['gamification', 'community-posts'] as const,
};

export function useAchievements() {
  return useQuery({
    queryKey: gamificationKeys.achievements,
    queryFn: () => api.gamification.listAchievements(),
  });
}

export function useUserAchievements() {
  return useQuery({
    queryKey: gamificationKeys.userAchievements,
    queryFn: () => api.gamification.listUserAchievements(),
  });
}

export function usePoints() {
  return useQuery({
    queryKey: gamificationKeys.points,
    queryFn: () => api.gamification.getPoints(),
  });
}

export function useStreaks() {
  return useQuery({
    queryKey: gamificationKeys.streaks,
    queryFn: () => api.gamification.getStreaks(),
  });
}

export function useLeaderboard(period: string = 'weekly') {
  return useQuery({
    queryKey: gamificationKeys.leaderboard(period),
    queryFn: () => api.gamification.getLeaderboard(period),
  });
}

export function useChallenges() {
  return useQuery({
    queryKey: gamificationKeys.challenges,
    queryFn: () => api.gamification.listChallenges(),
  });
}

export function useUserChallenges() {
  return useQuery({
    queryKey: gamificationKeys.userChallenges,
    queryFn: () => api.gamification.listUserChallenges(),
  });
}

export function useJoinChallenge() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (challengeId: string) => api.gamification.joinChallenge(challengeId),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: gamificationKeys.userChallenges });
      toast.success('Challenge joined!');
    },
  });
}

export function useCommunityPosts() {
  return useQuery({
    queryKey: gamificationKeys.communityPosts,
    queryFn: () => api.gamification.listPosts(),
  });
}

export function useCreatePost() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (data: Record<string, unknown>) => api.gamification.createPost(data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: gamificationKeys.communityPosts });
      toast.success('Post created');
    },
  });
}

export function useUpvotePost() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (postId: string) => api.gamification.upvotePost(postId),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: gamificationKeys.communityPosts });
    },
  });
}

// ============================================================================
// MARKET INTELLIGENCE HOOKS
// ============================================================================
export const marketIntelKeys = {
  companies: ['market-intel', 'companies'] as const,
  company: (id: string) => ['market-intel', 'companies', id] as const,
  salaries: ['market-intel', 'salaries'] as const,
  trends: ['market-intel', 'trends'] as const,
  hiringSeasons: ['market-intel', 'hiring-seasons'] as const,
  heatmap: ['market-intel', 'heatmap'] as const,
  predictions: ['market-intel', 'predictions'] as const,
  roi: ['market-intel', 'roi'] as const,
};

export function useCompanies(search?: string) {
  return useQuery({
    queryKey: [...marketIntelKeys.companies, search],
    queryFn: () => api.marketIntel.listCompanies(search),
    enabled: !search || search.length >= 2,
  });
}

export function useCompany(id: string) {
  return useQuery({
    queryKey: marketIntelKeys.company(id),
    queryFn: () => api.marketIntel.getCompany(id),
    enabled: !!id,
  });
}

export function useSalaryData(params?: Record<string, unknown>) {
  return useQuery({
    queryKey: [...marketIntelKeys.salaries, params],
    queryFn: () => api.marketIntel.listSalaries(params),
  });
}

export function useEstimateSalary() {
  return useMutation({
    mutationFn: (data: Record<string, unknown>) => api.marketIntel.estimateSalary(data),
  });
}

export function useIndustryTrends(industry?: string) {
  return useQuery({
    queryKey: [...marketIntelKeys.trends, industry],
    queryFn: () => api.marketIntel.listTrends(industry),
  });
}

export function useHiringSeasons(industry?: string) {
  return useQuery({
    queryKey: [...marketIntelKeys.hiringSeasons, industry],
    queryFn: () => api.marketIntel.getHiringSeasons(industry),
  });
}

export function useJobHeatmap(country?: string, industry?: string) {
  return useQuery({
    queryKey: [...marketIntelKeys.heatmap, country, industry],
    queryFn: () => api.marketIntel.getHeatmap(country, industry),
  });
}

export function useSuccessPrediction() {
  return useMutation({
    mutationFn: (applicationId: string) => api.marketIntel.getPrediction(applicationId),
  });
}

export function useJobSearchROI() {
  return useQuery({
    queryKey: marketIntelKeys.roi,
    queryFn: () => api.marketIntel.listROI(),
  });
}

export function useCalculateROI() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: ({ startDate, endDate }: { startDate: string; endDate: string }) => 
      api.marketIntel.calculateROI(startDate, endDate),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: marketIntelKeys.roi });
    },
  });
}

// ============================================================================
// PRIVACY & SECURITY HOOKS
// ============================================================================
export const privacyKeys = {
  exports: ['privacy', 'exports'] as const,
  twoFA: ['privacy', '2fa'] as const,
  loginAttempts: ['privacy', 'login-attempts'] as const,
  encryptedNotes: ['privacy', 'notes'] as const,
  auditLogs: ['privacy', 'audit-logs'] as const,
  settings: ['privacy', 'settings'] as const,
};

export function useDataExports() {
  return useQuery({
    queryKey: privacyKeys.exports,
    queryFn: () => api.privacy.listExports(),
  });
}

export function useRequestExport() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (data: Record<string, unknown>) => api.privacy.requestExport(data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: privacyKeys.exports });
      toast.success('Export requested');
    },
  });
}

export function useTwoFAStatus() {
  return useQuery({
    queryKey: privacyKeys.twoFA,
    queryFn: () => api.privacy.get2FAStatus(),
  });
}

export function useSetup2FA() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (data: Record<string, unknown>) => api.privacy.setup2FA(data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: privacyKeys.twoFA });
    },
  });
}

export function useVerify2FA() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: ({ code, useBackup }: { code: string; useBackup?: boolean }) => 
      api.privacy.verify2FA(code, useBackup),
    onSuccess: (data) => {
      queryClient.invalidateQueries({ queryKey: privacyKeys.twoFA });
      if (data.enabled) {
        toast.success('Two-factor authentication enabled');
      }
    },
  });
}

export function useDisable2FA() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: () => api.privacy.disable2FA(),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: privacyKeys.twoFA });
      toast.success('Two-factor authentication disabled');
    },
  });
}

export function useLoginAttempts() {
  return useQuery({
    queryKey: privacyKeys.loginAttempts,
    queryFn: () => api.privacy.listLoginAttempts(),
  });
}

export function useEncryptedNotes() {
  return useQuery({
    queryKey: privacyKeys.encryptedNotes,
    queryFn: () => api.privacy.listEncryptedNotes(),
  });
}

export function useCreateEncryptedNote() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (data: Record<string, unknown>) => api.privacy.createEncryptedNote(data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: privacyKeys.encryptedNotes });
      toast.success('Note saved');
    },
  });
}

export function useAuditLogs() {
  return useQuery({
    queryKey: privacyKeys.auditLogs,
    queryFn: () => api.privacy.listAuditLogs(),
  });
}

export function usePrivacySettings() {
  return useQuery({
    queryKey: privacyKeys.settings,
    queryFn: () => api.privacy.getPrivacySettings(),
  });
}

export function useUpdatePrivacySettings() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (data: Record<string, unknown>) => api.privacy.updatePrivacySettings(data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: privacyKeys.settings });
      toast.success('Privacy settings updated');
    },
  });
}