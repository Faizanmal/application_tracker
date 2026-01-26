'use client';
"use strict";
var __spreadArray = (this && this.__spreadArray) || function (to, from, pack) {
    if (pack || arguments.length === 2) for (var i = 0, l = from.length, ar; i < l; i++) {
        if (ar || !(i in from)) {
            if (!ar) ar = Array.prototype.slice.call(from, 0, i);
            ar[i] = from[i];
        }
    }
    return to.concat(ar || Array.prototype.slice.call(from));
};
Object.defineProperty(exports, "__esModule", { value: true });
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import * as api_1 from "@/lib/api";
import { toast } from "sonner";
exports.queryKeys = void 0;
exports.useUser = useUser;
exports.useChangePassword = useChangePassword;
exports.useApplications = useApplications;
exports.useApplication = useApplication;
exports.useKanban = useKanban;
exports.useCreateApplication = useCreateApplication;
exports.useUpdateApplication = useUpdateApplication;
exports.useDeleteApplication = useDeleteApplication;
exports.useUpdateKanbanOrder = useUpdateKanbanOrder;
exports.useToggleFavorite = useToggleFavorite;
exports.useBulkUpdateStatus = useBulkUpdateStatus;
exports.useTags = useTags;
exports.useCreateTag = useCreateTag;
exports.useInterviews = useInterviews;
exports.useInterview = useInterview;
exports.useUpcomingInterviews = useUpcomingInterviews;
exports.useTodayInterviews = useTodayInterviews;
exports.useCreateInterview = useCreateInterview;
exports.useUpdateInterview = useUpdateInterview;
exports.useCompleteInterview = useCompleteInterview;
exports.useCompanyResearch = useCompanyResearch;
exports.useSaveCompanyResearch = useSaveCompanyResearch;
exports.useReminders = useReminders;
exports.useUpcomingReminders = useUpcomingReminders;
exports.useCreateReminder = useCreateReminder;
exports.useSnoozeReminder = useSnoozeReminder;
exports.useCompleteReminder = useCompleteReminder;
exports.useNotifications = useNotifications;
exports.useUnreadCount = useUnreadCount;
exports.useMarkNotificationRead = useMarkNotificationRead;
exports.useMarkAllNotificationsRead = useMarkAllNotificationsRead;
exports.useDashboard = useDashboard;
exports.useInsights = useInsights;
exports.useStatusFunnel = useStatusFunnel;
exports.useResumes = useResumes;
exports.useUploadResume = useUploadResume;
exports.useDeleteResume = useDeleteResume;
exports.useSetDefaultResume = useSetDefaultResume;
exports.useSubscription = useSubscription;
exports.usePricingPlans = usePricingPlans;
exports.useCreateCheckout = useCreateCheckout;
exports.useCancelSubscription = useCancelSubscription;
exports.useResumeSubscription = useResumeSubscription;
exports.useAIUsage = useAIUsage;
exports.useGenerateFollowUpEmail = useGenerateFollowUpEmail;
exports.useResumeMatchScore = useResumeMatchScore;
exports.useGenerateInterviewQuestions = useGenerateInterviewQuestions;
exports.useImproveStarResponse = useImproveStarResponse;
exports.useGenerateCoverLetter = useGenerateCoverLetter;
// ============================================================================
// QUERY KEYS
// ============================================================================
exports.queryKeys = {
    // Auth
    user: ['user'],
    // Applications
    applications: ['applications'],
    application: function (id) { return ['applications', id]; },
    kanban: ['applications', 'kanban'],
    // Tags
    tags: ['tags'],
    // Interviews
    interviews: ['interviews'],
    interview: function (id) { return ['interviews', id]; },
    upcomingInterviews: ['interviews', 'upcoming'],
    todayInterviews: ['interviews', 'today'],
    interviewQuestions: function (interviewId) { return ['interviews', interviewId, 'questions']; },
    commonQuestions: ['interviews', 'common-questions'],
    // Company Research
    companyResearch: function (applicationId) { return ['company-research', applicationId]; },
    // Reminders
    reminders: ['reminders'],
    reminder: function (id) { return ['reminders', id]; },
    upcomingReminders: ['reminders', 'upcoming'],
    // Notifications
    notifications: ['notifications'],
    unreadCount: ['notifications', 'unread-count'],
    // Analytics
    dashboard: ['analytics', 'dashboard'],
    insights: ['analytics', 'insights'],
    statusFunnel: ['analytics', 'status-funnel'],
    // Resumes
    resumes: ['resumes'],
    // Subscriptions
    subscription: ['subscription'],
    plans: ['plans'],
    // AI
    aiUsage: ['ai', 'usage'],
};
// ============================================================================
// USER HOOKS
// ============================================================================
function useUser() {
    return (0, useQuery)({
        queryKey: exports.queryKeys.user,
        queryFn: function () { return api_1.api.auth.me(); },
        staleTime: 5 * 60 * 1000, // 5 minutes
        retry: false,
    });
}
function useChangePassword() {
    var _queryClient = (0, useQueryClient)();
    return (0, useMutation)({
        mutationFn: function (data) {
            return api_1.api.auth.changePassword(data);
        },
        onSuccess: function () {
            toast.toast.success('Password changed successfully');
        },
        onError: function (error) {
            var _a, _b;
            toast.toast.error(((_b = (_a = error.response) === null || _a === void 0 ? void 0 : _a.data) === null || _b === void 0 ? void 0 : _b.detail) || 'Failed to change password');
        },
    });
}
// ============================================================================
// APPLICATIONS HOOKS
// ============================================================================
function useApplications(params) {
    return (0, useQuery)({
        queryKey: __spreadArray(__spreadArray([], exports.queryKeys.applications, true), [params], false),
        queryFn: function () { return api_1.api.applications.list(params); },
        staleTime: 30 * 1000,
    });
}
function useApplication(id) {
    return (0, useQuery)({
        queryKey: exports.queryKeys.application(id),
        queryFn: function () { return api_1.api.applications.get(id); },
        enabled: !!id,
    });
}
function useKanban() {
    return (0, useQuery)({
        queryKey: exports.queryKeys.kanban,
        queryFn: function () { return api_1.api.applications.kanban(); },
        staleTime: 30 * 1000,
    });
}
function useCreateApplication() {
    var queryClient = (0, useQueryClient)();
    return (0, useMutation)({
        mutationFn: function (data) { return api_1.api.applications.create(data); },
        onSuccess: function () {
            queryClient.invalidateQueries({ queryKey: exports.queryKeys.applications });
            queryClient.invalidateQueries({ queryKey: exports.queryKeys.kanban });
            queryClient.invalidateQueries({ queryKey: exports.queryKeys.dashboard });
            toast.toast.success('Application created successfully');
        },
        onError: function (error) {
            var _a, _b;
            toast.toast.error(((_b = (_a = error.response) === null || _a === void 0 ? void 0 : _a.data) === null || _b === void 0 ? void 0 : _b.detail) || 'Failed to create application');
        },
    });
}
function useUpdateApplication() {
    var queryClient = (0, useQueryClient)();
    return (0, useMutation)({
        mutationFn: function (_a) {
            var id = _a.id, data = _a.data;
            return api_1.api.applications.update(id, data);
        },
        onSuccess: function (_, _a) {
            var id = _a.id;
            queryClient.invalidateQueries({ queryKey: exports.queryKeys.applications });
            queryClient.invalidateQueries({ queryKey: exports.queryKeys.application(id) });
            queryClient.invalidateQueries({ queryKey: exports.queryKeys.kanban });
            toast.toast.success('Application updated successfully');
        },
        onError: function (error) {
            var _a, _b;
            toast.toast.error(((_b = (_a = error.response) === null || _a === void 0 ? void 0 : _a.data) === null || _b === void 0 ? void 0 : _b.detail) || 'Failed to update application');
        },
    });
}
function useDeleteApplication() {
    var queryClient = (0, useQueryClient)();
    return (0, useMutation)({
        mutationFn: function (id) { return api_1.api.applications.delete(id); },
        onSuccess: function () {
            queryClient.invalidateQueries({ queryKey: exports.queryKeys.applications });
            queryClient.invalidateQueries({ queryKey: exports.queryKeys.kanban });
            queryClient.invalidateQueries({ queryKey: exports.queryKeys.dashboard });
            toast.toast.success('Application deleted successfully');
        },
        onError: function (error) {
            var _a, _b;
            toast.toast.error(((_b = (_a = error.response) === null || _a === void 0 ? void 0 : _a.data) === null || _b === void 0 ? void 0 : _b.detail) || 'Failed to delete application');
        },
    });
}
function useUpdateKanbanOrder() {
    var queryClient = (0, useQueryClient)();
    return (0, useMutation)({
        mutationFn: function (data) { return api_1.api.applications.updateKanbanOrder(data); },
        onSuccess: function () {
            queryClient.invalidateQueries({ queryKey: exports.queryKeys.kanban });
            queryClient.invalidateQueries({ queryKey: exports.queryKeys.dashboard });
        },
        onError: function (error) {
            var _a, _b;
            queryClient.invalidateQueries({ queryKey: exports.queryKeys.kanban });
            toast.toast.error(((_b = (_a = error.response) === null || _a === void 0 ? void 0 : _a.data) === null || _b === void 0 ? void 0 : _b.detail) || 'Failed to update order');
        },
    });
}
function useToggleFavorite() {
    var queryClient = (0, useQueryClient)();
    return (0, useMutation)({
        mutationFn: function (id) { return api_1.api.applications.toggleFavorite(id); },
        onSuccess: function (_, id) {
            queryClient.invalidateQueries({ queryKey: exports.queryKeys.applications });
            queryClient.invalidateQueries({ queryKey: exports.queryKeys.application(id) });
            queryClient.invalidateQueries({ queryKey: exports.queryKeys.kanban });
        },
    });
}
function useBulkUpdateStatus() {
    var queryClient = (0, useQueryClient)();
    return (0, useMutation)({
        mutationFn: function (data) {
            return api_1.api.applications.bulkUpdateStatus(data);
        },
        onSuccess: function (_a) {
            var updated = _a.updated;
            queryClient.invalidateQueries({ queryKey: exports.queryKeys.applications });
            queryClient.invalidateQueries({ queryKey: exports.queryKeys.kanban });
            toast.toast.success("Updated ".concat(updated, " applications"));
        },
        onError: function (error) {
            var _a, _b;
            toast.toast.error(((_b = (_a = error.response) === null || _a === void 0 ? void 0 : _a.data) === null || _b === void 0 ? void 0 : _b.detail) || 'Failed to update applications');
        },
    });
}
// ============================================================================
// TAGS HOOKS
// ============================================================================
function useTags() {
    return (0, useQuery)({
        queryKey: exports.queryKeys.tags,
        queryFn: function () { return api_1.api.tags.list(); },
        staleTime: 5 * 60 * 1000,
    });
}
function useCreateTag() {
    var queryClient = (0, useQueryClient)();
    return (0, useMutation)({
        mutationFn: function (data) { return api_1.api.tags.create(data); },
        onSuccess: function () {
            queryClient.invalidateQueries({ queryKey: exports.queryKeys.tags });
            toast.toast.success('Tag created successfully');
        },
    });
}
// ============================================================================
// INTERVIEWS HOOKS
// ============================================================================
function useInterviews(params) {
    return (0, useQuery)({
        queryKey: __spreadArray(__spreadArray([], exports.queryKeys.interviews, true), [params], false),
        queryFn: function () { return api_1.api.interviews.list(params); },
        staleTime: 30 * 1000,
    });
}
function useInterview(id) {
    return (0, useQuery)({
        queryKey: exports.queryKeys.interview(id),
        queryFn: function () { return api_1.api.interviews.get(id); },
        enabled: !!id,
    });
}
function useUpcomingInterviews() {
    return (0, useQuery)({
        queryKey: exports.queryKeys.upcomingInterviews,
        queryFn: function () { return api_1.api.interviews.upcoming(); },
        staleTime: 60 * 1000,
    });
}
function useTodayInterviews() {
    return (0, useQuery)({
        queryKey: exports.queryKeys.todayInterviews,
        queryFn: function () { return api_1.api.interviews.today(); },
        staleTime: 60 * 1000,
        refetchInterval: 5 * 60 * 1000, // Refetch every 5 minutes
    });
}
function useCreateInterview() {
    var queryClient = (0, useQueryClient)();
    return (0, useMutation)({
        mutationFn: function (data) { return api_1.api.interviews.create(data); },
        onSuccess: function () {
            queryClient.invalidateQueries({ queryKey: exports.queryKeys.interviews });
            queryClient.invalidateQueries({ queryKey: exports.queryKeys.upcomingInterviews });
            queryClient.invalidateQueries({ queryKey: exports.queryKeys.dashboard });
            toast.toast.success('Interview scheduled successfully');
        },
        onError: function (error) {
            var _a, _b;
            toast.toast.error(((_b = (_a = error.response) === null || _a === void 0 ? void 0 : _a.data) === null || _b === void 0 ? void 0 : _b.detail) || 'Failed to schedule interview');
        },
    });
}
function useUpdateInterview() {
    var queryClient = (0, useQueryClient)();
    return (0, useMutation)({
        mutationFn: function (_a) {
            var id = _a.id, data = _a.data;
            return api_1.api.interviews.update(id, data);
        },
        onSuccess: function (_, _a) {
            var id = _a.id;
            queryClient.invalidateQueries({ queryKey: exports.queryKeys.interviews });
            queryClient.invalidateQueries({ queryKey: exports.queryKeys.interview(id) });
            queryClient.invalidateQueries({ queryKey: exports.queryKeys.upcomingInterviews });
            toast.toast.success('Interview updated successfully');
        },
        onError: function (error) {
            var _a, _b;
            toast.toast.error(((_b = (_a = error.response) === null || _a === void 0 ? void 0 : _a.data) === null || _b === void 0 ? void 0 : _b.detail) || 'Failed to update interview');
        },
    });
}
function useCompleteInterview() {
    var queryClient = (0, useQueryClient)();
    return (0, useMutation)({
        mutationFn: function (_a) {
            var id = _a.id, data = _a.data;
            return api_1.api.interviews.complete(id, data);
        },
        onSuccess: function () {
            queryClient.invalidateQueries({ queryKey: exports.queryKeys.interviews });
            queryClient.invalidateQueries({ queryKey: exports.queryKeys.upcomingInterviews });
            toast.toast.success('Interview marked as completed');
        },
    });
}
// ============================================================================
// COMPANY RESEARCH HOOKS
// ============================================================================
function useCompanyResearch(applicationId) {
    return (0, useQuery)({
        queryKey: exports.queryKeys.companyResearch(applicationId),
        queryFn: function () { return api_1.api.companyResearch.get(applicationId); },
        enabled: !!applicationId,
    });
}
function useSaveCompanyResearch() {
    var queryClient = (0, useQueryClient)();
    return (0, useMutation)({
        mutationFn: function (_a) {
            var applicationId = _a.applicationId, data = _a.data;
            return api_1.api.companyResearch.createOrUpdate(applicationId, data);
        },
        onSuccess: function (_, _a) {
            var applicationId = _a.applicationId;
            queryClient.invalidateQueries({ queryKey: exports.queryKeys.companyResearch(applicationId) });
            toast.toast.success('Research saved successfully');
        },
    });
}
// ============================================================================
// REMINDERS HOOKS
// ============================================================================
function useReminders(params) {
    return (0, useQuery)({
        queryKey: __spreadArray(__spreadArray([], exports.queryKeys.reminders, true), [params], false),
        queryFn: function () { return api_1.api.reminders.list(params); },
        staleTime: 30 * 1000,
    });
}
function useUpcomingReminders() {
    return (0, useQuery)({
        queryKey: exports.queryKeys.upcomingReminders,
        queryFn: function () { return api_1.api.reminders.upcoming(); },
        staleTime: 60 * 1000,
    });
}
function useCreateReminder() {
    var queryClient = (0, useQueryClient)();
    return (0, useMutation)({
        mutationFn: function (data) { return api_1.api.reminders.create(data); },
        onSuccess: function () {
            queryClient.invalidateQueries({ queryKey: exports.queryKeys.reminders });
            queryClient.invalidateQueries({ queryKey: exports.queryKeys.upcomingReminders });
            toast.toast.success('Reminder created successfully');
        },
        onError: function (error) {
            var _a, _b;
            toast.toast.error(((_b = (_a = error.response) === null || _a === void 0 ? void 0 : _a.data) === null || _b === void 0 ? void 0 : _b.detail) || 'Failed to create reminder');
        },
    });
}
function useSnoozeReminder() {
    var queryClient = (0, useQueryClient)();
    return (0, useMutation)({
        mutationFn: function (_a) {
            var id = _a.id, duration = _a.duration;
            return api_1.api.reminders.snooze(id, duration);
        },
        onSuccess: function () {
            queryClient.invalidateQueries({ queryKey: exports.queryKeys.reminders });
            toast.toast.success('Reminder snoozed');
        },
    });
}
function useCompleteReminder() {
    var queryClient = (0, useQueryClient)();
    return (0, useMutation)({
        mutationFn: function (id) { return api_1.api.reminders.complete(id); },
        onSuccess: function () {
            queryClient.invalidateQueries({ queryKey: exports.queryKeys.reminders });
            toast.toast.success('Reminder completed');
        },
    });
}
// ============================================================================
// NOTIFICATIONS HOOKS
// ============================================================================
function useNotifications(params) {
    return (0, useQuery)({
        queryKey: __spreadArray(__spreadArray([], exports.queryKeys.notifications, true), [params], false),
        queryFn: function () { return api_1.api.notifications.list(params); },
        staleTime: 30 * 1000,
    });
}
function useUnreadCount() {
    return (0, useQuery)({
        queryKey: exports.queryKeys.unreadCount,
        queryFn: function () { return api_1.api.notifications.unreadCount(); },
        staleTime: 30 * 1000,
        refetchInterval: 60 * 1000, // Refetch every minute
    });
}
function useMarkNotificationRead() {
    var queryClient = (0, useQueryClient)();
    return (0, useMutation)({
        mutationFn: function (id) { return api_1.api.notifications.markRead(id); },
        onSuccess: function () {
            queryClient.invalidateQueries({ queryKey: exports.queryKeys.notifications });
            queryClient.invalidateQueries({ queryKey: exports.queryKeys.unreadCount });
        },
    });
}
function useMarkAllNotificationsRead() {
    var queryClient = (0, useQueryClient)();
    return (0, useMutation)({
        mutationFn: function () { return api_1.api.notifications.markAllRead(); },
        onSuccess: function () {
            queryClient.invalidateQueries({ queryKey: exports.queryKeys.notifications });
            queryClient.invalidateQueries({ queryKey: exports.queryKeys.unreadCount });
        },
    });
}
// ============================================================================
// ANALYTICS HOOKS
// ============================================================================
function useDashboard() {
    return (0, useQuery)({
        queryKey: exports.queryKeys.dashboard,
        queryFn: function () { return api_1.api.analytics.dashboard(); },
        staleTime: 60 * 1000,
    });
}
function useInsights() {
    return (0, useQuery)({
        queryKey: exports.queryKeys.insights,
        queryFn: function () { return api_1.api.analytics.insights(); },
        staleTime: 5 * 60 * 1000,
    });
}
function useStatusFunnel() {
    return (0, useQuery)({
        queryKey: exports.queryKeys.statusFunnel,
        queryFn: function () { return api_1.api.analytics.statusFunnel(); },
        staleTime: 5 * 60 * 1000,
    });
}
// ============================================================================
// RESUMES HOOKS
// ============================================================================
function useResumes() {
    return (0, useQuery)({
        queryKey: exports.queryKeys.resumes,
        queryFn: function () { return api_1.api.resumes.list(); },
        staleTime: 5 * 60 * 1000,
    });
}
function useUploadResume() {
    var queryClient = (0, useQueryClient)();
    return (0, useMutation)({
        mutationFn: function (_a) {
            var file = _a.file, name = _a.name, version = _a.version;
            return api_1.api.resumes.upload(file, name, version);
        },
        onSuccess: function () {
            queryClient.invalidateQueries({ queryKey: exports.queryKeys.resumes });
            toast.toast.success('Resume uploaded successfully');
        },
        onError: function (error) {
            var _a, _b;
            toast.toast.error(((_b = (_a = error.response) === null || _a === void 0 ? void 0 : _a.data) === null || _b === void 0 ? void 0 : _b.detail) || 'Failed to upload resume');
        },
    });
}
function useDeleteResume() {
    var queryClient = (0, useQueryClient)();
    return (0, useMutation)({
        mutationFn: function (id) { return api_1.api.resumes.delete(id); },
        onSuccess: function () {
            queryClient.invalidateQueries({ queryKey: exports.queryKeys.resumes });
            toast.toast.success('Resume deleted');
        },
    });
}
function useSetDefaultResume() {
    var queryClient = (0, useQueryClient)();
    return (0, useMutation)({
        mutationFn: function (id) { return api_1.api.resumes.setDefault(id); },
        onSuccess: function () {
            queryClient.invalidateQueries({ queryKey: exports.queryKeys.resumes });
            toast.toast.success('Default resume updated');
        },
    });
}
// ============================================================================
// SUBSCRIPTION HOOKS
// ============================================================================
function useSubscription() {
    return (0, useQuery)({
        queryKey: exports.queryKeys.subscription,
        queryFn: function () { return api_1.api.subscriptions.current(); },
        staleTime: 5 * 60 * 1000,
    });
}
function usePricingPlans() {
    return (0, useQuery)({
        queryKey: exports.queryKeys.plans,
        queryFn: function () { return api_1.api.subscriptions.plans(); },
        staleTime: 10 * 60 * 1000,
    });
}
function useCreateCheckout() {
    return (0, useMutation)({
        mutationFn: function (planSlug) { return api_1.api.subscriptions.createCheckout(planSlug); },
        onSuccess: function (_a) {
            var checkout_url = _a.checkout_url;
            window.location.href = checkout_url;
        },
        onError: function (error) {
            var _a, _b;
            toast.toast.error(((_b = (_a = error.response) === null || _a === void 0 ? void 0 : _a.data) === null || _b === void 0 ? void 0 : _b.detail) || 'Failed to create checkout session');
        },
    });
}
function useCancelSubscription() {
    var queryClient = (0, useQueryClient)();
    return (0, useMutation)({
        mutationFn: function () { return api_1.api.subscriptions.cancel(); },
        onSuccess: function () {
            queryClient.invalidateQueries({ queryKey: exports.queryKeys.subscription });
            queryClient.invalidateQueries({ queryKey: exports.queryKeys.user });
            toast.toast.success('Subscription cancelled');
        },
    });
}
function useResumeSubscription() {
    var queryClient = (0, useQueryClient)();
    return (0, useMutation)({
        mutationFn: function () { return api_1.api.subscriptions.resume(); },
        onSuccess: function () {
            queryClient.invalidateQueries({ queryKey: exports.queryKeys.subscription });
            queryClient.invalidateQueries({ queryKey: exports.queryKeys.user });
            toast.toast.success('Subscription resumed');
        },
    });
}
// ============================================================================
// AI HOOKS
// ============================================================================
function useAIUsage() {
    return (0, useQuery)({
        queryKey: exports.queryKeys.aiUsage,
        queryFn: function () { return api_1.api.ai.getUsage(); },
        staleTime: 5 * 60 * 1000,
    });
}
function useGenerateFollowUpEmail() {
    return (0, useMutation)({
        mutationFn: function (_a) {
            var applicationId = _a.applicationId, tone = _a.tone;
            return api_1.api.ai.generateFollowUpEmail(applicationId, tone);
        },
        onSuccess: function () {
            toast.toast.success('Follow-up email generated');
        },
        onError: function (error) {
            var _a, _b;
            toast.toast.error(((_b = (_a = error.response) === null || _a === void 0 ? void 0 : _a.data) === null || _b === void 0 ? void 0 : _b.detail) || 'Failed to generate email');
        },
    });
}
function useResumeMatchScore() {
    return (0, useMutation)({
        mutationFn: function (applicationId) { return api_1.api.ai.getResumeMatchScore(applicationId); },
    });
}
function useGenerateInterviewQuestions() {
    return (0, useMutation)({
        mutationFn: function (_a) {
            var applicationId = _a.applicationId, interviewType = _a.interviewType, count = _a.count;
            return api_1.api.ai.generateInterviewQuestions(applicationId, interviewType, count);
        },
        onSuccess: function () {
            toast.toast.success('Interview questions generated');
        },
    });
}
function useImproveStarResponse() {
    return (0, useMutation)({
        mutationFn: function (starResponseId) { return api_1.api.ai.improveStarResponse(starResponseId); },
        onSuccess: function () {
            toast.toast.success('STAR response improved');
        },
    });
}
function useGenerateCoverLetter() {
    return (0, useMutation)({
        mutationFn: function (_a) {
            var applicationId = _a.applicationId, style = _a.style;
            return api_1.api.ai.generateCoverLetter(applicationId, style);
        },
        onSuccess: function () {
            toast.toast.success('Cover letter generated');
        },
        onError: function (error) {
            var _a, _b;
            toast.toast.error(((_b = (_a = error.response) === null || _a === void 0 ? void 0 : _a.data) === null || _b === void 0 ? void 0 : _b.detail) || 'Failed to generate cover letter');
        },
    });
}
