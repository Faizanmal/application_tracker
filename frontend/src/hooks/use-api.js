'use client';
"use strict";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import * as api_1 from "@/lib/api";
Object.defineProperty(exports, "__esModule", { value: true });
exports.useMeetings = useMeetings;
exports.useMeeting = useMeeting;
exports.useMeetingStats = useMeetingStats;
exports.useAnalytics = useAnalytics;
exports.useUploadMeeting = useUploadMeeting;
exports.useUpdateMeeting = useUpdateMeeting;
exports.useDeleteMeeting = useDeleteMeeting;
exports.useShareMeeting = useShareMeeting;
exports.useActionItems = useActionItems;
exports.useActionItem = useActionItem;
exports.useCreateActionItem = useCreateActionItem;
exports.useUpdateActionItem = useUpdateActionItem;
exports.useCompleteActionItem = useCompleteActionItem;
exports.useDeleteActionItem = useDeleteActionItem;
exports.useMeetingNotes = useMeetingNotes;
exports.useCreateNote = useCreateNote;
exports.useDeleteNote = useDeleteNote;
exports.useToggleFavorite = useToggleFavorite;
exports.useFavorites = useFavorites;
exports.useActivities = useActivities;
exports.useActivity = useActivity;
exports.useTemplates = useTemplates;
exports.useTemplate = useTemplate;
exports.useCreateTemplate = useCreateTemplate;
exports.useUpdateTemplate = useUpdateTemplate;
exports.useDeleteTemplate = useDeleteTemplate;
exports.useIntegrations = useIntegrations;
exports.useIntegration = useIntegration;
exports.useCreateIntegration = useCreateIntegration;
exports.useUpdateIntegration = useUpdateIntegration;
exports.useDeleteIntegration = useDeleteIntegration;
exports.useTestIntegration = useTestIntegration;
exports.useNotificationLogs = useNotificationLogs;
exports.useCalendarConnections = useCalendarConnections;
exports.useCalendarConnection = useCalendarConnection;
exports.useCreateCalendarConnection = useCreateCalendarConnection;
exports.useUpdateCalendarConnection = useUpdateCalendarConnection;
exports.useDeleteCalendarConnection = useDeleteCalendarConnection;
exports.useSyncCalendar = useSyncCalendar;
exports.useCalendarEvents = useCalendarEvents;
exports.useCalendarSyncLogs = useCalendarSyncLogs;
exports.useWorkspaces = useWorkspaces;
exports.useWorkspace = useWorkspace;
exports.useCreateWorkspace = useCreateWorkspace;
exports.useUpdateWorkspace = useUpdateWorkspace;
exports.useDeleteWorkspace = useDeleteWorkspace;
exports.useWorkspaceMembers = useWorkspaceMembers;
exports.useUpdateWorkspaceMember = useUpdateWorkspaceMember;
exports.useRemoveWorkspaceMember = useRemoveWorkspaceMember;
exports.useWorkspaceInvitations = useWorkspaceInvitations;
exports.useInviteWorkspaceMember = useInviteWorkspaceMember;
exports.useAcceptWorkspaceInvitation = useAcceptWorkspaceInvitation;
exports.useDeclineWorkspaceInvitation = useDeclineWorkspaceInvitation;
// Meetings
function useMeetings(params) {
    return (0, useQuery)({
        queryKey: ['meetings', params],
        queryFn: function () { return api_1.meetingsApi.list(params); },
    });
}
function useMeeting(id) {
    return (0, useQuery)({
        queryKey: ['meetings', id],
        queryFn: function () { return api_1.meetingsApi.get(id); },
        enabled: !!id,
    });
}
function useMeetingStats() {
    return (0, useQuery)({
        queryKey: ['meetings', 'stats'],
        queryFn: function () { return api_1.meetingsApi.getStats(); },
    });
}
function useAnalytics(days) {
    if (days === void 0) { days = 30; }
    return (0, useQuery)({
        queryKey: ['meetings', 'analytics', days],
        queryFn: function () { return api_1.meetingsApi.getAnalytics(days); },
    });
}
function useUploadMeeting() {
    var queryClient = (0, useQueryClient)();
    return (0, useMutation)({
        mutationFn: function (formData) { return api_1.meetingsApi.create(formData); },
        onSuccess: function () {
            queryClient.invalidateQueries({ queryKey: ['meetings'] });
            queryClient.invalidateQueries({ queryKey: ['meetings', 'stats'] });
        },
    });
}
function useUpdateMeeting() {
    var queryClient = (0, useQueryClient)();
    return (0, useMutation)({
        mutationFn: function (_a) {
            var id = _a.id, data = _a.data;
            return api_1.meetingsApi.update(id, data);
        },
        onSuccess: function (_, variables) {
            queryClient.invalidateQueries({ queryKey: ['meetings'] });
            queryClient.invalidateQueries({ queryKey: ['meetings', variables.id] });
        },
    });
}
function useDeleteMeeting() {
    var queryClient = (0, useQueryClient)();
    return (0, useMutation)({
        mutationFn: function (id) { return api_1.meetingsApi.delete(id); },
        onSuccess: function () {
            queryClient.invalidateQueries({ queryKey: ['meetings'] });
            queryClient.invalidateQueries({ queryKey: ['meetings', 'stats'] });
        },
    });
}
function useShareMeeting() {
    return (0, useMutation)({
        mutationFn: function (id) { return api_1.meetingsApi.share(id); },
    });
}
// Action Items
function useActionItems(params) {
    return (0, useQuery)({
        queryKey: ['action-items', params],
        queryFn: function () { return api_1.actionItemsApi.list(params); },
    });
}
function useActionItem(id) {
    return (0, useQuery)({
        queryKey: ['action-items', id],
        queryFn: function () { return api_1.actionItemsApi.get(id); },
        enabled: !!id,
    });
}
function useCreateActionItem() {
    var queryClient = (0, useQueryClient)();
    return (0, useMutation)({
        mutationFn: function (data) { return api_1.actionItemsApi.create(data); },
        onSuccess: function () {
            queryClient.invalidateQueries({ queryKey: ['action-items'] });
            queryClient.invalidateQueries({ queryKey: ['meetings', 'stats'] });
        },
    });
}
function useUpdateActionItem() {
    var queryClient = (0, useQueryClient)();
    return (0, useMutation)({
        mutationFn: function (_a) {
            var id = _a.id, data = _a.data;
            return api_1.actionItemsApi.update(id, data);
        },
        onSuccess: function (_, variables) {
            queryClient.invalidateQueries({ queryKey: ['action-items'] });
            queryClient.invalidateQueries({ queryKey: ['action-items', variables.id] });
            queryClient.invalidateQueries({ queryKey: ['meetings', 'stats'] });
        },
    });
}
function useCompleteActionItem() {
    var queryClient = (0, useQueryClient)();
    return (0, useMutation)({
        mutationFn: function (id) { return api_1.actionItemsApi.complete(id); },
        onSuccess: function () {
            queryClient.invalidateQueries({ queryKey: ['action-items'] });
            queryClient.invalidateQueries({ queryKey: ['meetings', 'stats'] });
        },
    });
}
function useDeleteActionItem() {
    var queryClient = (0, useQueryClient)();
    return (0, useMutation)({
        mutationFn: function (id) { return api_1.actionItemsApi.delete(id); },
        onSuccess: function () {
            queryClient.invalidateQueries({ queryKey: ['action-items'] });
            queryClient.invalidateQueries({ queryKey: ['meetings', 'stats'] });
        },
    });
}
// Meeting Notes
function useMeetingNotes(meetingId) {
    return (0, useQuery)({
        queryKey: ['notes', meetingId],
        queryFn: function () { return api_1.notesApi.list(meetingId); },
        enabled: !!meetingId,
    });
}
function useCreateNote() {
    var queryClient = (0, useQueryClient)();
    return (0, useMutation)({
        mutationFn: function (data) {
            return api_1.notesApi.create(data);
        },
        onSuccess: function (_, variables) {
            queryClient.invalidateQueries({ queryKey: ['notes', variables.meeting] });
        },
    });
}
function useDeleteNote() {
    var queryClient = (0, useQueryClient)();
    return (0, useMutation)({
        mutationFn: function (id) { return api_1.notesApi.delete(id); },
        onSuccess: function () {
            queryClient.invalidateQueries({ queryKey: ['notes'] });
        },
    });
}
// Favorites
function useToggleFavorite() {
    var queryClient = (0, useQueryClient)();
    return (0, useMutation)({
        mutationFn: function (id) { return api_1.meetingsApi.toggleFavorite(id); },
        onSuccess: function (_, id) {
            queryClient.invalidateQueries({ queryKey: ['meetings'] });
            queryClient.invalidateQueries({ queryKey: ['meetings', id] });
        },
    });
}
function useFavorites() {
    return (0, useQuery)({
        queryKey: ['meetings', 'favorites'],
        queryFn: function () { return api_1.meetingsApi.getFavorites(); },
    });
}
// Activities
function useActivities(limit) {
    return (0, useQuery)({
        queryKey: ['activities', limit],
        queryFn: function () { return api_1.activitiesApi.list(limit); },
    });
}
function useActivity(id) {
    return (0, useQuery)({
        queryKey: ['activities', id],
        queryFn: function () { return api_1.activitiesApi.get(id); },
        enabled: !!id,
    });
}
// Templates
function useTemplates() {
    return (0, useQuery)({
        queryKey: ['templates'],
        queryFn: function () { return api_1.templatesApi.list(); },
    });
}
function useTemplate(id) {
    return (0, useQuery)({
        queryKey: ['templates', id],
        queryFn: function () { return api_1.templatesApi.get(id); },
        enabled: !!id,
    });
}
function useCreateTemplate() {
    var queryClient = (0, useQueryClient)();
    return (0, useMutation)({
        mutationFn: function (data) { return api_1.templatesApi.create(data); },
        onSuccess: function () {
            queryClient.invalidateQueries({ queryKey: ['templates'] });
        },
    });
}
function useUpdateTemplate() {
    var queryClient = (0, useQueryClient)();
    return (0, useMutation)({
        mutationFn: function (_a) {
            var id = _a.id, data = _a.data;
            return api_1.templatesApi.update(id, data);
        },
        onSuccess: function (_, variables) {
            queryClient.invalidateQueries({ queryKey: ['templates'] });
            queryClient.invalidateQueries({ queryKey: ['templates', variables.id] });
        },
    });
}
function useDeleteTemplate() {
    var queryClient = (0, useQueryClient)();
    return (0, useMutation)({
        mutationFn: function (id) { return api_1.templatesApi.delete(id); },
        onSuccess: function () {
            queryClient.invalidateQueries({ queryKey: ['templates'] });
        },
    });
}
// Integrations
function useIntegrations() {
    return (0, useQuery)({
        queryKey: ['integrations'],
        queryFn: function () { return api_1.integrationsApi.list(); },
    });
}
function useIntegration(id) {
    return (0, useQuery)({
        queryKey: ['integrations', id],
        queryFn: function () { return api_1.integrationsApi.get(id); },
        enabled: !!id,
    });
}
function useCreateIntegration() {
    var queryClient = (0, useQueryClient)();
    return (0, useMutation)({
        mutationFn: function (data) { return api_1.integrationsApi.create(data); },
        onSuccess: function () {
            queryClient.invalidateQueries({ queryKey: ['integrations'] });
        },
    });
}
function useUpdateIntegration() {
    var queryClient = (0, useQueryClient)();
    return (0, useMutation)({
        mutationFn: function (_a) {
            var id = _a.id, data = _a.data;
            return api_1.integrationsApi.update(id, data);
        },
        onSuccess: function (_, variables) {
            queryClient.invalidateQueries({ queryKey: ['integrations'] });
            queryClient.invalidateQueries({ queryKey: ['integrations', variables.id] });
        },
    });
}
function useDeleteIntegration() {
    var queryClient = (0, useQueryClient)();
    return (0, useMutation)({
        mutationFn: function (id) { return api_1.integrationsApi.delete(id); },
        onSuccess: function () {
            queryClient.invalidateQueries({ queryKey: ['integrations'] });
        },
    });
}
function useTestIntegration() {
    return (0, useMutation)({
        mutationFn: function (_a) {
            var id = _a.id, testMessage = _a.testMessage;
            return api_1.integrationsApi.test(id, testMessage);
        },
    });
}
// Notification Logs
function useNotificationLogs() {
    return (0, useQuery)({
        queryKey: ['notification-logs'],
        queryFn: function () { return api_1.notificationLogsApi.list(); },
    });
}
// Calendar Connections
function useCalendarConnections() {
    return (0, useQuery)({
        queryKey: ['calendar-connections'],
        queryFn: function () { return api_1.calendarApi.listConnections(); },
    });
}
function useCalendarConnection(id) {
    return (0, useQuery)({
        queryKey: ['calendar-connections', id],
        queryFn: function () { return api_1.calendarApi.getConnection(id); },
        enabled: !!id,
    });
}
function useCreateCalendarConnection() {
    var queryClient = (0, useQueryClient)();
    return (0, useMutation)({
        mutationFn: function (data) { return api_1.calendarApi.createConnection(data); },
        onSuccess: function () {
            queryClient.invalidateQueries({ queryKey: ['calendar-connections'] });
        },
    });
}
function useUpdateCalendarConnection() {
    var queryClient = (0, useQueryClient)();
    return (0, useMutation)({
        mutationFn: function (_a) {
            var id = _a.id, data = _a.data;
            return api_1.calendarApi.updateConnection(id, data);
        },
        onSuccess: function (_, variables) {
            queryClient.invalidateQueries({ queryKey: ['calendar-connections'] });
            queryClient.invalidateQueries({ queryKey: ['calendar-connections', variables.id] });
        },
    });
}
function useDeleteCalendarConnection() {
    var queryClient = (0, useQueryClient)();
    return (0, useMutation)({
        mutationFn: function (id) { return api_1.calendarApi.deleteConnection(id); },
        onSuccess: function () {
            queryClient.invalidateQueries({ queryKey: ['calendar-connections'] });
            queryClient.invalidateQueries({ queryKey: ['calendar-events'] });
        },
    });
}
function useSyncCalendar() {
    var queryClient = (0, useQueryClient)();
    return (0, useMutation)({
        mutationFn: function (id) { return api_1.calendarApi.syncConnection(id); },
        onSuccess: function () {
            queryClient.invalidateQueries({ queryKey: ['calendar-connections'] });
            queryClient.invalidateQueries({ queryKey: ['calendar-events'] });
            queryClient.invalidateQueries({ queryKey: ['calendar-sync-logs'] });
        },
    });
}
// Calendar Events
function useCalendarEvents() {
    return (0, useQuery)({
        queryKey: ['calendar-events'],
        queryFn: function () { return api_1.calendarApi.listEvents(); },
    });
}
// Calendar Sync Logs
function useCalendarSyncLogs() {
    return (0, useQuery)({
        queryKey: ['calendar-sync-logs'],
        queryFn: function () { return api_1.calendarApi.listSyncLogs(); },
    });
}
// Workspaces
function useWorkspaces() {
    return (0, useQuery)({
        queryKey: ['workspaces'],
        queryFn: function () { return api_1.workspacesApi.list(); },
    });
}
function useWorkspace(id) {
    return (0, useQuery)({
        queryKey: ['workspaces', id],
        queryFn: function () { return api_1.workspacesApi.get(id); },
        enabled: !!id,
    });
}
function useCreateWorkspace() {
    var queryClient = (0, useQueryClient)();
    return (0, useMutation)({
        mutationFn: function (data) { return api_1.workspacesApi.create(data); },
        onSuccess: function () {
            queryClient.invalidateQueries({ queryKey: ['workspaces'] });
        },
    });
}
function useUpdateWorkspace() {
    var queryClient = (0, useQueryClient)();
    return (0, useMutation)({
        mutationFn: function (_a) {
            var id = _a.id, data = _a.data;
            return api_1.workspacesApi.update(id, data);
        },
        onSuccess: function (_, variables) {
            queryClient.invalidateQueries({ queryKey: ['workspaces'] });
            queryClient.invalidateQueries({ queryKey: ['workspaces', variables.id] });
        },
    });
}
function useDeleteWorkspace() {
    var queryClient = (0, useQueryClient)();
    return (0, useMutation)({
        mutationFn: function (id) { return api_1.workspacesApi.delete(id); },
        onSuccess: function () {
            queryClient.invalidateQueries({ queryKey: ['workspaces'] });
        },
    });
}
// Workspace Members
function useWorkspaceMembers() {
    return (0, useQuery)({
        queryKey: ['workspace-members'],
        queryFn: function () { return api_1.workspacesApi.listMembers(); },
    });
}
function useUpdateWorkspaceMember() {
    var queryClient = (0, useQueryClient)();
    return (0, useMutation)({
        mutationFn: function (_a) {
            var id = _a.id, data = _a.data;
            return api_1.workspacesApi.updateMember(id, data);
        },
        onSuccess: function () {
            queryClient.invalidateQueries({ queryKey: ['workspace-members'] });
        },
    });
}
function useRemoveWorkspaceMember() {
    var queryClient = (0, useQueryClient)();
    return (0, useMutation)({
        mutationFn: function (id) { return api_1.workspacesApi.removeMember(id); },
        onSuccess: function () {
            queryClient.invalidateQueries({ queryKey: ['workspace-members'] });
        },
    });
}
// Workspace Invitations
function useWorkspaceInvitations() {
    return (0, useQuery)({
        queryKey: ['workspace-invitations'],
        queryFn: function () { return api_1.workspacesApi.listInvitations(); },
    });
}
function useInviteWorkspaceMember() {
    var queryClient = (0, useQueryClient)();
    return (0, useMutation)({
        mutationFn: function (data) {
            return api_1.workspacesApi.createInvitation(data);
        },
        onSuccess: function () {
            queryClient.invalidateQueries({ queryKey: ['workspace-invitations'] });
        },
    });
}
function useAcceptWorkspaceInvitation() {
    var queryClient = (0, useQueryClient)();
    return (0, useMutation)({
        mutationFn: function (id) { return api_1.workspacesApi.acceptInvitation(id); },
        onSuccess: function () {
            queryClient.invalidateQueries({ queryKey: ['workspace-invitations'] });
            queryClient.invalidateQueries({ queryKey: ['workspaces'] });
            queryClient.invalidateQueries({ queryKey: ['workspace-members'] });
        },
    });
}
function useDeclineWorkspaceInvitation() {
    var queryClient = (0, useQueryClient)();
    return (0, useMutation)({
        mutationFn: function (id) { return api_1.workspacesApi.declineInvitation(id); },
        onSuccess: function () {
            queryClient.invalidateQueries({ queryKey: ['workspace-invitations'] });
        },
    });
}
