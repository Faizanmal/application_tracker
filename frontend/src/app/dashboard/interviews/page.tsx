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
} from 'lucide-react';

import { Button } from '@/components/ui/button';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { Skeleton } from '@/components/ui/skeleton';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu';
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
    <Card className={`hover:shadow-md transition-shadow ${isPastInterview ? 'border-yellow-300 bg-yellow-50/50' : ''}`}>
      <CardContent className="p-4">
        <div className="flex items-start justify-between gap-4">
          {/* Left: Interview Details */}
          <div className="flex-1 min-w-0">
            <div className="flex items-center gap-2 mb-1">
              <Badge className={INTERVIEW_STATUS_CONFIG[interview.status].color}>
                {INTERVIEW_STATUS_CONFIG[interview.status].label}
              </Badge>
              <Badge variant="outline">
                {INTERVIEW_TYPE_LABELS[interview.interview_type]}
              </Badge>
              {interview.round_number > 1 && (
                <Badge variant="secondary">Round {interview.round_number}</Badge>
              )}
            </div>

            <Link 
              href={`/dashboard/interviews/${interview.id}`}
              className="block group"
            >
              <h3 className="font-semibold text-lg group-hover:text-primary transition-colors">
                {interview.application_company}
              </h3>
              <p className="text-muted-foreground text-sm">
                {interview.application_job_title}
              </p>
            </Link>

            {interview.title && (
              <p className="text-sm mt-1 text-muted-foreground">
                {interview.title}
              </p>
            )}

            <div className="flex flex-wrap items-center gap-4 mt-3 text-sm text-muted-foreground">
              <div className="flex items-center gap-1">
                <Calendar className="h-4 w-4" />
                <span>{getDateLabel()}</span>
              </div>
              <div className="flex items-center gap-1">
                <Clock className="h-4 w-4" />
                <span>{format(scheduledDate, 'h:mm a')}</span>
                <span className="text-xs">({interview.duration_minutes} min)</span>
              </div>
              {interview.meeting_link && (
                <div className="flex items-center gap-1">
                  <Video className="h-4 w-4" />
                  <a 
                    href={interview.meeting_link}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="text-primary hover:underline"
                  >
                    Join Meeting
                  </a>
                </div>
              )}
              {interview.location && (
                <div className="flex items-center gap-1">
                  <MapPin className="h-4 w-4" />
                  <span>{interview.location}</span>
                </div>
              )}
            </div>

            {interview.interviewer_name && (
              <div className="mt-2 text-sm">
                <span className="text-muted-foreground">Interviewer: </span>
                <span>{interview.interviewer_name}</span>
                {interview.interviewer_title && (
                  <span className="text-muted-foreground"> ({interview.interviewer_title})</span>
                )}
              </div>
            )}
          </div>

          {/* Right: Actions */}
          <div className="flex items-center gap-2">
            <Link href={`/dashboard/interviews/${interview.id}`}>
              <Button variant="outline" size="sm">
                Prepare
                <ChevronRight className="ml-1 h-4 w-4" />
              </Button>
            </Link>

            <DropdownMenu>
              <DropdownMenuTrigger asChild>
                <Button variant="ghost" size="icon">
                  <MoreHorizontal className="h-4 w-4" />
                </Button>
              </DropdownMenuTrigger>
              <DropdownMenuContent align="end">
                <DropdownMenuItem onClick={handleMarkComplete}>
                  <Check className="mr-2 h-4 w-4" />
                  Mark as Completed
                </DropdownMenuItem>
                <DropdownMenuItem asChild>
                  <Link href={`/dashboard/interviews/${interview.id}/edit`}>
                    Reschedule
                  </Link>
                </DropdownMenuItem>
                <DropdownMenuItem className="text-red-600">
                  <X className="mr-2 h-4 w-4" />
                  Cancel Interview
                </DropdownMenuItem>
              </DropdownMenuContent>
            </DropdownMenu>
          </div>
        </div>

        {/* Past Interview Warning */}
        {isPastInterview && (
          <div className="mt-3 p-2 bg-yellow-100 rounded-md text-sm text-yellow-800">
            This interview appears to have passed. Please update its status.
          </div>
        )}
      </CardContent>
    </Card>
  );
}

function EmptyState({ message }: { message: string }) {
  return (
    <div className="py-12 text-center">
      <Calendar className="h-12 w-12 mx-auto mb-4 text-muted-foreground opacity-50" />
      <p className="text-muted-foreground">{message}</p>
      <Link href="/dashboard/interviews/new">
        <Button className="mt-4">
          <Plus className="mr-2 h-4 w-4" />
          Schedule Interview
        </Button>
      </Link>
    </div>
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
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <h1 className="text-2xl font-bold">Interviews</h1>
          <p className="text-muted-foreground">
            Manage and prepare for your interviews
          </p>
        </div>
        <Link href="/dashboard/interviews/new">
          <Button>
            <Plus className="mr-2 h-4 w-4" />
            Schedule Interview
          </Button>
        </Link>
      </div>

      {/* Today's Interviews Highlight */}
      {!todayLoading && todayInterviews && todayInterviews.length > 0 && (
        <Card className="border-primary bg-primary/5">
          <CardHeader className="pb-3">
            <CardTitle className="flex items-center gap-2 text-lg">
              <Calendar className="h-5 w-5 text-primary" />
              Today&apos;s Interviews ({todayInterviews.length})
            </CardTitle>
          </CardHeader>
          <CardContent className="space-y-3">
            {todayInterviews.map((interview) => (
              <InterviewCard key={interview.id} interview={interview} />
            ))}
          </CardContent>
        </Card>
      )}

      {/* Interview Tabs */}
      <Tabs value={activeTab} onValueChange={setActiveTab}>
        <div className="flex items-center justify-between">
          <TabsList>
            <TabsTrigger value="upcoming">
              Upcoming
              {upcomingInterviews && upcomingInterviews.length > 0 && (
                <Badge variant="secondary" className="ml-2">
                  {upcomingInterviews.length}
                </Badge>
              )}
            </TabsTrigger>
            <TabsTrigger value="completed">Completed</TabsTrigger>
            <TabsTrigger value="all">All</TabsTrigger>
          </TabsList>

          <Button variant="outline" size="sm">
            <Filter className="mr-2 h-4 w-4" />
            Filter
          </Button>
        </div>

        {/* Upcoming Tab */}
        <TabsContent value="upcoming" className="mt-6">
          {upcomingLoading ? (
            <div className="space-y-4">
              {[1, 2, 3].map((i) => (
                <Skeleton key={i} className="h-32 w-full" />
              ))}
            </div>
          ) : upcomingInterviews && upcomingInterviews.length > 0 ? (
            <div className="space-y-4">
              {upcomingInterviews.map((interview) => (
                <InterviewCard key={interview.id} interview={interview} />
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
                <Skeleton key={i} className="h-32 w-full" />
              ))}
            </div>
          ) : completedInterviews.length > 0 ? (
            <div className="space-y-4">
              {completedInterviews.map((interview) => (
                <InterviewCard key={interview.id} interview={interview} />
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
                <Skeleton key={i} className="h-32 w-full" />
              ))}
            </div>
          ) : allInterviews && allInterviews.results.length > 0 ? (
            <div className="space-y-4">
              {allInterviews.results.map((interview) => (
                <InterviewCard key={interview.id} interview={interview} />
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
