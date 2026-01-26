'use client';

import { useState } from 'react';
import Link from 'next/link';
import { format, isToday, isTomorrow, isPast, parseISO } from 'date-fns';
import {
  Plus,
  Calendar,
  Clock,
  Video,
  MapPin,
  MoreHorizontal,
  Check,
  X,
  ChevronRight,
  Filter,
  Sparkles,
  Zap,
  Target,
  TrendingUp,
} from 'lucide-react';

import { Button } from '@/components/ui/button';
import { CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { Skeleton } from '@/components/ui/skeleton';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu';
import { AnimatedCard } from '@/components/ui/animated-card';
import { GradientButton, AnimatedNumber, EmptyState as AnimatedEmptyState } from '@/components/ui/animated-elements';
import { useInterviews, useTodayInterviews, useUpcomingInterviews, useCompleteInterview } from '@/hooks/use-queries';
import type { Interview, InterviewType, InterviewStatus } from '@/types';

const INTERVIEW_TYPE_LABELS: Record<InterviewType, string> = {
  phone: 'Phone Screen',
  video: 'Video Call',
  onsite: 'On-site',
  technical: 'Technical',
  behavioral: 'Behavioral',
  panel: 'Panel',
  final: 'Final Round',
};

const INTERVIEW_STATUS_CONFIG: Record<InterviewStatus, { label: string; color: string }> = {
  scheduled: { label: 'Scheduled', color: 'bg-blue-100 text-blue-700' },
  completed: { label: 'Completed', color: 'bg-green-100 text-green-700' },
  cancelled: { label: 'Cancelled', color: 'bg-red-100 text-red-700' },
  rescheduled: { label: 'Rescheduled', color: 'bg-yellow-100 text-yellow-700' },
  no_show: { label: 'No Show', color: 'bg-gray-100 text-gray-700' },
};

function InterviewCard({ interview }: { interview: Interview }) {
  const completeInterview = useCompleteInterview();
  const scheduledDate = parseISO(interview.scheduled_at);
  const isPastInterview = isPast(scheduledDate) && interview.status === 'scheduled';

  const getDateLabel = () => {
    if (isToday(scheduledDate)) return 'Today';
    if (isTomorrow(scheduledDate)) return 'Tomorrow';
    return format(scheduledDate, 'EEE, MMM d');
  };

  const handleMarkComplete = () => {
    completeInterview.mutate({ id: parseInt(interview.id), data: {} });
  };

  return (
    <AnimatedCard 
      variant="interactive" 
      hoverEffect="lift"
      className={`transition-all duration-300 ${isPastInterview ? 'border-yellow-300 bg-yellow-50/50' : ''}`}
    >
      <CardContent className="p-5">
        <div className="flex items-start justify-between gap-4">
          {/* Left: Interview Details */}
          <div className="flex-1 min-w-0">
            <div className="flex flex-wrap items-center gap-2 mb-2">
              <Badge className={`${INTERVIEW_STATUS_CONFIG[interview.status].color} animate-fade-in`}>
                {INTERVIEW_STATUS_CONFIG[interview.status].label}
              </Badge>
              <Badge variant="outline" className="bg-gradient-to-r from-primary/5 to-purple-500/5 border-primary/20">
                <Target className="mr-1 h-3 w-3" />
                {INTERVIEW_TYPE_LABELS[interview.interview_type]}
              </Badge>
              {interview.round_number > 1 && (
                <Badge variant="secondary" className="bg-gradient-to-r from-orange-100 to-amber-100 text-orange-700">
                  Round {interview.round_number}
                </Badge>
              )}
            </div>

            <Link 
              href={`/dashboard/interviews/${interview.id}`}
              className="block group"
            >
              <h3 className="font-semibold text-lg group-hover:text-primary transition-colors group-hover:translate-x-0.5 transform duration-200">
                {interview.application_company}
              </h3>
              <p className="text-muted-foreground text-sm">
                {interview.application_job_title}
              </p>
            </Link>

            {interview.title && (
              <p className="text-sm mt-1 text-muted-foreground italic">
                {interview.title}
              </p>
            )}

            <div className="flex flex-wrap items-center gap-3 mt-4 text-sm">
              <div className="flex items-center gap-1.5 px-3 py-1.5 bg-primary/5 rounded-full">
                <Calendar className="h-4 w-4 text-primary" />
                <span className="font-medium text-foreground">{getDateLabel()}</span>
              </div>
              <div className="flex items-center gap-1.5 px-3 py-1.5 bg-purple-50 rounded-full">
                <Clock className="h-4 w-4 text-purple-600" />
                <span className="font-medium text-purple-700">{format(scheduledDate, 'h:mm a')}</span>
                <span className="text-xs text-purple-500">({interview.duration_minutes} min)</span>
              </div>
              {interview.meeting_link && (
                <a 
                  href={interview.meeting_link}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="flex items-center gap-1.5 px-3 py-1.5 bg-gradient-to-r from-blue-50 to-cyan-50 rounded-full hover:from-blue-100 hover:to-cyan-100 transition-all group"
                >
                  <Video className="h-4 w-4 text-blue-600 group-hover:scale-110 transition-transform" />
                  <span className="text-blue-700 font-medium">Join Meeting</span>
                </a>
              )}
              {interview.location && (
                <div className="flex items-center gap-1.5 px-3 py-1.5 bg-green-50 rounded-full">
                  <MapPin className="h-4 w-4 text-green-600" />
                  <span className="text-green-700">{interview.location}</span>
                </div>
              )}
            </div>

            {interview.interviewer_name && (
              <div className="mt-3 text-sm flex items-center gap-2">
                <div className="w-7 h-7 rounded-full bg-gradient-to-br from-primary to-purple-600 flex items-center justify-center text-white text-xs font-medium shadow-sm">
                  {interview.interviewer_name.charAt(0)}
                </div>
                <span className="font-medium">{interview.interviewer_name}</span>
                {interview.interviewer_title && (
                  <span className="text-muted-foreground">• {interview.interviewer_title}</span>
                )}
              </div>
            )}
          </div>

          {/* Right: Actions */}
          <div className="flex items-center gap-2">
            <Link href={`/dashboard/interviews/${interview.id}`}>
              <GradientButton size="sm" className="group shadow-md hover:shadow-lg">
                <Sparkles className="mr-1.5 h-4 w-4 group-hover:animate-pulse" />
                Prepare
                <ChevronRight className="ml-1 h-4 w-4 group-hover:translate-x-0.5 transition-transform" />
              </GradientButton>
            </Link>

            <DropdownMenu>
              <DropdownMenuTrigger asChild>
                <Button variant="ghost" size="icon" className="hover:bg-gray-100">
                  <MoreHorizontal className="h-4 w-4" />
                </Button>
              </DropdownMenuTrigger>
              <DropdownMenuContent align="end" className="w-48">
                <DropdownMenuItem onClick={handleMarkComplete} className="cursor-pointer">
                  <Check className="mr-2 h-4 w-4 text-green-600" />
                  Mark as Completed
                </DropdownMenuItem>
                <DropdownMenuItem asChild>
                  <Link href={`/dashboard/interviews/${interview.id}/edit`} className="cursor-pointer">
                    <Calendar className="mr-2 h-4 w-4 text-blue-600" />
                    Reschedule
                  </Link>
                </DropdownMenuItem>
                <DropdownMenuItem className="text-red-600 cursor-pointer">
                  <X className="mr-2 h-4 w-4" />
                  Cancel Interview
                </DropdownMenuItem>
              </DropdownMenuContent>
            </DropdownMenu>
          </div>
        </div>

        {/* Past Interview Warning */}
        {isPastInterview && (
          <div className="mt-4 p-3 bg-gradient-to-r from-yellow-50 to-amber-50 border border-yellow-200 rounded-lg text-sm text-yellow-800 flex items-center gap-2">
            <div className="p-1 bg-yellow-200 rounded-full animate-pulse">
              <Zap className="h-4 w-4 text-yellow-600" />
            </div>
            <span>This interview appears to have passed. Please update its status.</span>
          </div>
        )}
      </CardContent>
    </AnimatedCard>
  );
}

function EmptyState({ message }: { message: string }) {
  return (
    <AnimatedEmptyState
      icon={<Calendar className="h-12 w-12" />}
      title="No interviews found"
      description={message}
      action={
        <Link href="/dashboard/interviews/new">
          <GradientButton className="shadow-lg hover:shadow-xl">
            <Plus className="mr-2 h-4 w-4" />
            Schedule Interview
          </GradientButton>
        </Link>
      }
    />
  );
}

export default function InterviewsPage() {
  const [activeTab, setActiveTab] = useState('upcoming');
  const { data: allInterviews, isLoading: allLoading } = useInterviews({ ordering: 'scheduled_at' });
  const { data: todayInterviews, isLoading: todayLoading } = useTodayInterviews();
  const { data: upcomingInterviews, isLoading: upcomingLoading } = useUpcomingInterviews();

  const completedInterviews = allInterviews?.results.filter(i => i.status === 'completed') || [];

  return (
    <div className="p-6 space-y-6">
      {/* Header with Gradient */}
      <div className="relative overflow-hidden rounded-2xl bg-gradient-to-r from-purple-600 via-violet-600 to-indigo-600 p-8">
        {/* Decorative elements */}
        <div className="absolute top-0 right-0 w-64 h-64 bg-white/10 rounded-full blur-3xl -translate-y-1/2 translate-x-1/2" />
        <div className="absolute bottom-0 left-0 w-48 h-48 bg-white/5 rounded-full blur-2xl translate-y-1/2 -translate-x-1/2" />
        <div className="absolute top-1/2 left-1/2 w-32 h-32 bg-purple-400/20 rounded-full blur-xl" />
        
        <div className="relative flex flex-col sm:flex-row sm:items-center sm:justify-between gap-6">
          <div className="animate-fade-in-up">
            <h1 className="text-3xl font-bold text-white flex items-center gap-3">
              <div className="p-2 bg-white/20 rounded-xl backdrop-blur-sm">
                <Calendar className="h-7 w-7" />
              </div>
              Interviews
            </h1>
            <p className="text-white/80 mt-2 max-w-md">
              Manage and prepare for your upcoming interviews with confidence
            </p>
          </div>
          <Link href="/dashboard/interviews/new" className="animate-fade-in-up stagger-2">
            <Button className="bg-white text-purple-600 hover:bg-white/90 shadow-lg hover:shadow-xl transition-all group">
              <Plus className="mr-2 h-4 w-4 group-hover:rotate-90 transition-transform duration-300" />
              Schedule Interview
            </Button>
          </Link>
        </div>

        {/* Quick Stats */}
        <div className="relative grid grid-cols-3 gap-4 mt-6 animate-fade-in-up stagger-3">
          <div className="bg-white/10 backdrop-blur-sm rounded-xl p-4 border border-white/20">
            <p className="text-white/70 text-sm">Today</p>
            <p className="text-2xl font-bold text-white">
              <AnimatedNumber value={todayInterviews?.length || 0} />
            </p>
          </div>
          <div className="bg-white/10 backdrop-blur-sm rounded-xl p-4 border border-white/20">
            <p className="text-white/70 text-sm">Upcoming</p>
            <p className="text-2xl font-bold text-white">
              <AnimatedNumber value={upcomingInterviews?.length || 0} />
            </p>
          </div>
          <div className="bg-white/10 backdrop-blur-sm rounded-xl p-4 border border-white/20">
            <p className="text-white/70 text-sm">Completed</p>
            <p className="text-2xl font-bold text-white">
              <AnimatedNumber value={completedInterviews.length} />
            </p>
          </div>
        </div>
      </div>

      {/* Today's Interviews Highlight */}
      {!todayLoading && todayInterviews && todayInterviews.length > 0 && (
        <AnimatedCard variant="premium" className="border-primary/30 bg-gradient-to-br from-primary/5 via-purple-50/50 to-transparent">
          <CardHeader className="pb-3">
            <CardTitle className="flex items-center gap-3 text-lg">
              <div className="p-2 bg-gradient-to-br from-primary to-purple-600 rounded-lg shadow-md">
                <Zap className="h-5 w-5 text-white" />
              </div>
              <span className="bg-gradient-to-r from-primary to-purple-600 bg-clip-text text-transparent font-bold">
                Today&apos;s Interviews
              </span>
              <Badge className="bg-gradient-to-r from-primary to-purple-600 text-white shadow-sm">
                {todayInterviews.length}
              </Badge>
            </CardTitle>
          </CardHeader>
          <CardContent className="space-y-4">
            {todayInterviews.map((interview, index) => (
              <div key={interview.id} className={`animate-fade-in-up`} style={{ animationDelay: `${index * 100}ms` }}>
                <InterviewCard interview={interview} />
              </div>
            ))}
          </CardContent>
        </AnimatedCard>
      )}

      {/* Interview Tabs */}
      <Tabs value={activeTab} onValueChange={setActiveTab} className="animate-fade-in-up stagger-4">
        <div className="flex items-center justify-between">
          <TabsList className="bg-muted/50 backdrop-blur-sm">
            <TabsTrigger value="upcoming" className="data-[state=active]:bg-white data-[state=active]:shadow-sm">
              <TrendingUp className="mr-2 h-4 w-4" />
              Upcoming
              {upcomingInterviews && upcomingInterviews.length > 0 && (
                <Badge variant="secondary" className="ml-2 bg-primary/10 text-primary">
                  {upcomingInterviews.length}
                </Badge>
              )}
            </TabsTrigger>
            <TabsTrigger value="completed" className="data-[state=active]:bg-white data-[state=active]:shadow-sm">
              <Check className="mr-2 h-4 w-4" />
              Completed
            </TabsTrigger>
            <TabsTrigger value="all" className="data-[state=active]:bg-white data-[state=active]:shadow-sm">
              All
            </TabsTrigger>
          </TabsList>

          <Button variant="outline" size="sm" className="gap-2 shadow-sm hover:shadow-md transition-all">
            <Filter className="h-4 w-4" />
            Filter
          </Button>
        </div>

        {/* Upcoming Tab */}
        <TabsContent value="upcoming" className="mt-6">
          {upcomingLoading ? (
            <div className="space-y-4">
              {[1, 2, 3].map((i) => (
                <Skeleton key={i} className="h-40 w-full rounded-xl" />
              ))}
            </div>
          ) : upcomingInterviews && upcomingInterviews.length > 0 ? (
            <div className="space-y-4">
              {upcomingInterviews.map((interview, index) => (
                <div key={interview.id} className="animate-fade-in-up" style={{ animationDelay: `${index * 50}ms` }}>
                  <InterviewCard interview={interview} />
                </div>
              ))}
            </div>
          ) : (
            <EmptyState message="No upcoming interviews scheduled" />
          )}
        </TabsContent>

        {/* Completed Tab */}
        <TabsContent value="completed" className="mt-6">
          {allLoading ? (
            <div className="space-y-4">
              {[1, 2, 3].map((i) => (
                <Skeleton key={i} className="h-40 w-full rounded-xl" />
              ))}
            </div>
          ) : completedInterviews.length > 0 ? (
            <div className="space-y-4">
              {completedInterviews.map((interview, index) => (
                <div key={interview.id} className="animate-fade-in-up" style={{ animationDelay: `${index * 50}ms` }}>
                  <InterviewCard interview={interview} />
                </div>
              ))}
            </div>
          ) : (
            <EmptyState message="No completed interviews yet" />
          )}
        </TabsContent>

        {/* All Tab */}
        <TabsContent value="all" className="mt-6">
          {allLoading ? (
            <div className="space-y-4">
              {[1, 2, 3].map((i) => (
                <Skeleton key={i} className="h-40 w-full rounded-xl" />
              ))}
            </div>
          ) : allInterviews && allInterviews.results.length > 0 ? (
            <div className="space-y-4">
              {allInterviews.results.map((interview, index) => (
                <div key={interview.id} className="animate-fade-in-up" style={{ animationDelay: `${index * 50}ms` }}>
                  <InterviewCard interview={interview} />
                </div>
              ))}
            </div>
          ) : (
            <EmptyState message="No interviews found" />
          )}
        </TabsContent>
      </Tabs>
    </div>
  );
}
