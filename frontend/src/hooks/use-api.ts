'use client';

import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { 
  meetingsApi,
  actionItemsApi,
  notesApi,
  activitiesApi,
  templatesApi,
  integrationsApi,
  notificationLogsApi,
  calendarApi,
  workspacesApi
} from '@/lib/api';
import type {
  Meeting,
  ActionItem,
  Note,
  Activity,
  MeetingTemplate,
  NotificationIntegration,
  NotificationLog,
  CalendarConnection,
  Workspace,
  WorkspaceMember,
} from '@/types';

// Meetings
export function useMeetings(params?: {
  search?: string;
  status?: string;
  ordering?: string;
  page?: number;
}) {
  return useQuery({
    queryKey: ['meetings', params],
    queryFn: () => meetingsApi.list(params),
  });
}

export function useMeeting(id: string) {
  return useQuery({
    queryKey: ['meetings', id],
    queryFn: () => meetingsApi.get(id),
    enabled: !!id,
  });
}

export function useMeetingStats() {
  return useQuery({
    queryKey: ['meetings', 'stats'],
    queryFn: () => meetingsApi.getStats(),
  });
}

export function useAnalytics(days: number = 30) {
  return useQuery({
    queryKey: ['meetings', 'analytics', days],
    queryFn: () => meetingsApi.getAnalytics(days),
  });
}

export function useUploadMeeting() {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: (formData: FormData) => meetingsApi.create(formData),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['meetings'] });
      queryClient.invalidateQueries({ queryKey: ['meetings', 'stats'] });
    },
  });
}

export function useUpdateMeeting() {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: ({ id, data }: { id: string; data: Partial<Meeting> }) =>
      meetingsApi.update(id, data),
    onSuccess: (_, variables) => {
      queryClient.invalidateQueries({ queryKey: ['meetings'] });
      queryClient.invalidateQueries({ queryKey: ['meetings', variables.id] });
    },
  });
}

export function useDeleteMeeting() {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: (id: string) => meetingsApi.delete(id),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['meetings'] });
      queryClient.invalidateQueries({ queryKey: ['meetings', 'stats'] });
    },
  });
}

export function useShareMeeting() {
  return useMutation({
    mutationFn: (id: string) => meetingsApi.share(id),
  });
}

// Action Items
export function useActionItems(params?: {
  search?: string;
  status?: string;
  priority?: string;
  meeting?: string;
  ordering?: string;
  page?: number;
}) {
  return useQuery({
    queryKey: ['action-items', params],
    queryFn: () => actionItemsApi.list(params),
  });
}

export function useActionItem(id: string) {
  return useQuery({
    queryKey: ['action-items', id],
    queryFn: () => actionItemsApi.get(id),
    enabled: !!id,
  });
}

export function useCreateActionItem() {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: (data: Partial<ActionItem>) => actionItemsApi.create(data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['action-items'] });
      queryClient.invalidateQueries({ queryKey: ['meetings', 'stats'] });
    },
  });
}

export function useUpdateActionItem() {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: ({ id, data }: { id: string; data: Partial<ActionItem> }) =>
      actionItemsApi.update(id, data),
    onSuccess: (_, variables) => {
      queryClient.invalidateQueries({ queryKey: ['action-items'] });
      queryClient.invalidateQueries({ queryKey: ['action-items', variables.id] });
      queryClient.invalidateQueries({ queryKey: ['meetings', 'stats'] });
    },
  });
}

export function useCompleteActionItem() {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: (id: string) => actionItemsApi.complete(id),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['action-items'] });
      queryClient.invalidateQueries({ queryKey: ['meetings', 'stats'] });
    },
  });
}

export function useDeleteActionItem() {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: (id: string) => actionItemsApi.delete(id),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['action-items'] });
      queryClient.invalidateQueries({ queryKey: ['meetings', 'stats'] });
    },
  });
}

// Meeting Notes
export function useMeetingNotes(meetingId?: string) {
  return useQuery({
    queryKey: ['notes', meetingId],
    queryFn: () => notesApi.list(meetingId),
    enabled: !!meetingId,
  });
}

export function useCreateNote() {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: (data: { meeting: string; content: string; timestamp?: number }) =>
      notesApi.create(data),
    onSuccess: (_, variables) => {
      queryClient.invalidateQueries({ queryKey: ['notes', variables.meeting] });
    },
  });
}

export function useDeleteNote() {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: (id: string) => notesApi.delete(id),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['notes'] });
    },
  });
}

// Favorites
export function useToggleFavorite() {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: (id: string) => meetingsApi.toggleFavorite(id),
    onSuccess: (_, id) => {
      queryClient.invalidateQueries({ queryKey: ['meetings'] });
      queryClient.invalidateQueries({ queryKey: ['meetings', id] });
    },
  });
}

export function useFavorites() {
  return useQuery({
    queryKey: ['meetings', 'favorites'],
    queryFn: () => meetingsApi.getFavorites(),
  });
}

// Activities
export function useActivities(limit?: number) {
  return useQuery({
    queryKey: ['activities', limit],
    queryFn: () => activitiesApi.list(limit),
  });
}

export function useActivity(id: string) {
  return useQuery({
    queryKey: ['activities', id],
    queryFn: () => activitiesApi.get(id),
    enabled: !!id,
  });
}

// Templates
export function useTemplates() {
  return useQuery({
    queryKey: ['templates'],
    queryFn: () => templatesApi.list(),
  });
}

export function useTemplate(id: string) {
  return useQuery({
    queryKey: ['templates', id],
    queryFn: () => templatesApi.get(id),
    enabled: !!id,
  });
}

export function useCreateTemplate() {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: (data: Partial<MeetingTemplate>) => templatesApi.create(data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['templates'] });
    },
  });
}

export function useUpdateTemplate() {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: ({ id, data }: { id: string; data: Partial<MeetingTemplate> }) =>
      templatesApi.update(id, data),
    onSuccess: (_, variables) => {
      queryClient.invalidateQueries({ queryKey: ['templates'] });
      queryClient.invalidateQueries({ queryKey: ['templates', variables.id] });
    },
  });
}

export function useDeleteTemplate() {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: (id: string) => templatesApi.delete(id),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['templates'] });
    },
  });
}

// Integrations
export function useIntegrations() {
  return useQuery({
    queryKey: ['integrations'],
    queryFn: () => integrationsApi.list(),
  });
}

export function useIntegration(id: string) {
  return useQuery({
    queryKey: ['integrations', id],
    queryFn: () => integrationsApi.get(id),
    enabled: !!id,
  });
}

export function useCreateIntegration() {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: (data: Partial<NotificationIntegration>) => integrationsApi.create(data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['integrations'] });
    },
  });
}

export function useUpdateIntegration() {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: ({ id, data }: { id: string; data: Partial<NotificationIntegration> }) =>
      integrationsApi.update(id, data),
    onSuccess: (_, variables) => {
      queryClient.invalidateQueries({ queryKey: ['integrations'] });
      queryClient.invalidateQueries({ queryKey: ['integrations', variables.id] });
    },
  });
}

export function useDeleteIntegration() {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: (id: string) => integrationsApi.delete(id),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['integrations'] });
    },
  });
}

export function useTestIntegration() {
  return useMutation({
    mutationFn: ({ id, testMessage }: { id: string; testMessage?: string }) =>
      integrationsApi.test(id, testMessage),
  });
}

// Notification Logs
export function useNotificationLogs() {
  return useQuery({
    queryKey: ['notification-logs'],
    queryFn: () => notificationLogsApi.list(),
  });
}

// Calendar Connections
export function useCalendarConnections() {
  return useQuery({
    queryKey: ['calendar-connections'],
    queryFn: () => calendarApi.listConnections(),
  });
}

export function useCalendarConnection(id: string) {
  return useQuery({
    queryKey: ['calendar-connections', id],
    queryFn: () => calendarApi.getConnection(id),
    enabled: !!id,
  });
}

export function useCreateCalendarConnection() {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: (data: Partial<CalendarConnection>) => calendarApi.createConnection(data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['calendar-connections'] });
    },
  });
}

export function useUpdateCalendarConnection() {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: ({ id, data }: { id: string; data: Partial<CalendarConnection> }) =>
      calendarApi.updateConnection(id, data),
    onSuccess: (_, variables) => {
      queryClient.invalidateQueries({ queryKey: ['calendar-connections'] });
      queryClient.invalidateQueries({ queryKey: ['calendar-connections', variables.id] });
    },
  });
}

export function useDeleteCalendarConnection() {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: (id: string) => calendarApi.deleteConnection(id),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['calendar-connections'] });
      queryClient.invalidateQueries({ queryKey: ['calendar-events'] });
    },
  });
}

export function useSyncCalendar() {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: (id: string) => calendarApi.syncConnection(id),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['calendar-connections'] });
      queryClient.invalidateQueries({ queryKey: ['calendar-events'] });
      queryClient.invalidateQueries({ queryKey: ['calendar-sync-logs'] });
    },
  });
}

// Calendar Events
export function useCalendarEvents() {
  return useQuery({
    queryKey: ['calendar-events'],
    queryFn: () => calendarApi.listEvents(),
  });
}

// Calendar Sync Logs
export function useCalendarSyncLogs() {
  return useQuery({
    queryKey: ['calendar-sync-logs'],
    queryFn: () => calendarApi.listSyncLogs(),
  });
}

// Workspaces
export function useWorkspaces() {
  return useQuery({
    queryKey: ['workspaces'],
    queryFn: () => workspacesApi.list(),
  });
}

export function useWorkspace(id: string) {
  return useQuery({
    queryKey: ['workspaces', id],
    queryFn: () => workspacesApi.get(id),
    enabled: !!id,
  });
}

export function useCreateWorkspace() {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: (data: Partial<Workspace>) => workspacesApi.create(data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['workspaces'] });
    },
  });
}

export function useUpdateWorkspace() {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: ({ id, data }: { id: string; data: Partial<Workspace> }) =>
      workspacesApi.update(id, data),
    onSuccess: (_, variables) => {
      queryClient.invalidateQueries({ queryKey: ['workspaces'] });
      queryClient.invalidateQueries({ queryKey: ['workspaces', variables.id] });
    },
  });
}

export function useDeleteWorkspace() {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: (id: string) => workspacesApi.delete(id),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['workspaces'] });
    },
  });
}

// Workspace Members
export function useWorkspaceMembers() {
  return useQuery({
    queryKey: ['workspace-members'],
    queryFn: () => workspacesApi.listMembers(),
  });
}

export function useUpdateWorkspaceMember() {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: ({ id, data }: { id: string; data: Partial<WorkspaceMember> }) =>
      workspacesApi.updateMember(id, data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['workspace-members'] });
    },
  });
}

export function useRemoveWorkspaceMember() {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: (id: string) => workspacesApi.removeMember(id),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['workspace-members'] });
    },
  });
}

// Workspace Invitations
export function useWorkspaceInvitations() {
  return useQuery({
    queryKey: ['workspace-invitations'],
    queryFn: () => workspacesApi.listInvitations(),
  });
}

export function useInviteWorkspaceMember() {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: (data: { workspace: string; email: string; role: string; message?: string }) =>
      workspacesApi.createInvitation(data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['workspace-invitations'] });
    },
  });
}

export function useAcceptWorkspaceInvitation() {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: (id: string) => workspacesApi.acceptInvitation(id),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['workspace-invitations'] });
      queryClient.invalidateQueries({ queryKey: ['workspaces'] });
      queryClient.invalidateQueries({ queryKey: ['workspace-members'] });
    },
  });
}

export function useDeclineWorkspaceInvitation() {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: (id: string) => workspacesApi.declineInvitation(id),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['workspace-invitations'] });
    },
  });
}
