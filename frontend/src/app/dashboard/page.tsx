'use client';

import { 
  Briefcase, 
  TrendingUp, 
  Calendar, 
  CheckCircle,
  Clock,
  ArrowUpRight,
  Plus,
  Building2
} from 'lucide-react';
import Link from 'next/link';
import { format, formatDistanceToNow } from 'date-fns';
import { 
  AreaChart, 
  Area, 
  XAxis, 
  YAxis, 
  CartesianGrid, 
  Tooltip, 
  ResponsiveContainer,
  PieChart,
  Pie,
  Cell,
} from 'recharts';

import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import { Progress } from '@/components/ui/progress';
import { Skeleton } from '@/components/ui/skeleton';
import { useDashboard, useUpcomingInterviews, useUpcomingReminders } from '@/hooks/use-queries';
import { useAuthStore } from '@/lib/auth';

const statusColors: Record<string, string> = {
  wishlist: '#94a3b8',
  applied: '#3b82f6',
  screening: '#8b5cf6',
  interviewing: '#f59e0b',
  offer: '#22c55e',
  accepted: '#10b981',
  rejected: '#ef4444',
  withdrawn: '#6b7280',
  ghosted: '#9ca3af',
};

const STATUS_LABELS: Record<string, string> = {
  wishlist: 'Wishlist',
  applied: 'Applied',
  screening: 'Screening',
  interviewing: 'Interviewing',
  offer: 'Offer',
  accepted: 'Accepted',
  rejected: 'Rejected',
  withdrawn: 'Withdrawn',
  ghosted: 'Ghosted',
};

export default function DashboardPage() {
  const { user } = useAuthStore();
  const { data: dashboardData, isLoading: dashboardLoading } = useDashboard();
  const { data: upcomingInterviews, isLoading: interviewsLoading } = useUpcomingInterviews();
  const { data: upcomingReminders, isLoading: remindersLoading } = useUpcomingReminders();

  const stats = [
    {
      name: 'Total Applications',
      value: dashboardData?.total_applications || 0,
      icon: Briefcase,
      change: dashboardData?.applications_this_week || 0,
      changeLabel: 'this week',
      color: 'text-blue-600',
      bgColor: 'bg-blue-100',
    },
    {
      name: 'Active Applications',
      value: dashboardData?.active_applications || 0,
      icon: Clock,
      change: null,
      changeLabel: 'in progress',
      color: 'text-yellow-600',
      bgColor: 'bg-yellow-100',
    },
    {
      name: 'Interviews Scheduled',
      value: dashboardData?.interviews_scheduled || 0,
      icon: Calendar,
      change: dashboardData?.interviews_this_week || 0,
      changeLabel: 'this week',
      color: 'text-purple-600',
      bgColor: 'bg-purple-100',
    },
    {
      name: 'Offers Received',
      value: dashboardData?.offers_received || 0,
      icon: CheckCircle,
      change: null,
      changeLabel: 'total offers',
      color: 'text-green-600',
      bgColor: 'bg-green-100',
    },
  ];

  // Prepare chart data
  const statusChartData = dashboardData?.applications_by_status
    ? Object.entries(dashboardData.applications_by_status)
        .filter(([_, value]) => value > 0)
        .map(([status, value]) => ({
          name: STATUS_LABELS[status] || status,
          value,
          color: statusColors[status] || '#6b7280',
        }))
    : [];

  const weeklyData = dashboardData?.weekly_activity || [];

  return (
    <div className="p-6 space-y-6">
      {/* Welcome Header */}
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <h1 className="text-2xl font-bold text-gray-900 dark:text-white">
            Welcome back, {user?.first_name || 'there'}! 👋
          </h1>
          <p className="text-muted-foreground mt-1">
            Here&apos;s an overview of your job search progress.
          </p>
        </div>
        <Link href="/dashboard/applications/new">
          <Button>
            <Plus className="mr-2 h-4 w-4" />
            Add Application
          </Button>
        </Link>
      </div>

      {/* Stats Grid */}
      <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
        {stats.map((stat) => (
          <Card key={stat.name}>
            <CardContent className="p-6">
              <div className="flex items-center justify-between">
                <div className={`p-2 rounded-lg ${stat.bgColor}`}>
                  <stat.icon className={`h-5 w-5 ${stat.color}`} />
                </div>
                {stat.change !== null && stat.change > 0 && (
                  <div className="flex items-center text-green-600 text-sm">
                    <ArrowUpRight className="h-4 w-4" />
                    <span>+{stat.change}</span>
                  </div>
                )}
              </div>
              <div className="mt-4">
                {dashboardLoading ? (
                  <Skeleton className="h-8 w-20" />
                ) : (
                  <p className="text-3xl font-bold">{stat.value}</p>
                )}
                <p className="text-sm text-muted-foreground mt-1">{stat.name}</p>
              </div>
            </CardContent>
          </Card>
        ))}
      </div>

      {/* Response Rate & Interview Rate */}
      <div className="grid gap-4 md:grid-cols-2">
        <Card>
          <CardHeader>
            <CardTitle className="text-lg">Response Rate</CardTitle>
            <CardDescription>Companies that responded to your applications</CardDescription>
          </CardHeader>
          <CardContent>
            {dashboardLoading ? (
              <Skeleton className="h-4 w-full" />
            ) : (
              <>
                <div className="flex items-center justify-between mb-2">
                  <span className="text-2xl font-bold">
                    {((dashboardData?.response_rate || 0) * 100).toFixed(0)}%
                  </span>
                  <span className="text-sm text-muted-foreground">
                    {dashboardData?.active_applications || 0} / {dashboardData?.total_applications || 0}
                  </span>
                </div>
                <Progress value={(dashboardData?.response_rate || 0) * 100} className="h-2" />
              </>
            )}
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle className="text-lg">Interview Rate</CardTitle>
            <CardDescription>Applications that led to interviews</CardDescription>
          </CardHeader>
          <CardContent>
            {dashboardLoading ? (
              <Skeleton className="h-4 w-full" />
            ) : (
              <>
                <div className="flex items-center justify-between mb-2">
                  <span className="text-2xl font-bold">
                    {((dashboardData?.interview_rate || 0) * 100).toFixed(0)}%
                  </span>
                  <span className="text-sm text-muted-foreground">
                    {dashboardData?.interviews_scheduled || 0} interviews
                  </span>
                </div>
                <Progress value={(dashboardData?.interview_rate || 0) * 100} className="h-2" />
              </>
            )}
          </CardContent>
        </Card>
      </div>

      {/* Charts Row */}
      <div className="grid gap-4 lg:grid-cols-2">
        {/* Weekly Activity Chart */}
        <Card>
          <CardHeader>
            <CardTitle className="text-lg">Weekly Activity</CardTitle>
            <CardDescription>Applications submitted over the past weeks</CardDescription>
          </CardHeader>
          <CardContent>
            {dashboardLoading ? (
              <Skeleton className="h-64 w-full" />
            ) : weeklyData.length > 0 ? (
              <div className="h-64">
                <ResponsiveContainer width="100%" height="100%">
                  <AreaChart data={weeklyData}>
                    <defs>
                      <linearGradient id="colorCount" x1="0" y1="0" x2="0" y2="1">
                        <stop offset="5%" stopColor="#3b82f6" stopOpacity={0.3} />
                        <stop offset="95%" stopColor="#3b82f6" stopOpacity={0} />
                      </linearGradient>
                    </defs>
                    <CartesianGrid strokeDasharray="3 3" className="stroke-muted" />
                    <XAxis 
                      dataKey="week" 
                      className="text-xs"
                      tickFormatter={(value) => value.split('-')[1] || value}
                    />
                    <YAxis className="text-xs" />
                    <Tooltip 
                      contentStyle={{ 
                        backgroundColor: 'hsl(var(--background))',
                        border: '1px solid hsl(var(--border))',
                        borderRadius: '8px'
                      }}
                    />
                    <Area
                      type="monotone"
                      dataKey="count"
                      stroke="#3b82f6"
                      strokeWidth={2}
                      fillOpacity={1}
                      fill="url(#colorCount)"
                    />
                  </AreaChart>
                </ResponsiveContainer>
              </div>
            ) : (
              <div className="h-64 flex items-center justify-center text-muted-foreground">
                <p>No activity data yet. Start adding applications!</p>
              </div>
            )}
          </CardContent>
        </Card>

        {/* Status Distribution */}
        <Card>
          <CardHeader>
            <CardTitle className="text-lg">Application Status</CardTitle>
            <CardDescription>Distribution of your applications by status</CardDescription>
          </CardHeader>
          <CardContent>
            {dashboardLoading ? (
              <Skeleton className="h-64 w-full" />
            ) : statusChartData.length > 0 ? (
              <div className="h-64 flex items-center">
                <div className="w-1/2">
                  <ResponsiveContainer width="100%" height={200}>
                    <PieChart>
                      <Pie
                        data={statusChartData}
                        cx="50%"
                        cy="50%"
                        innerRadius={50}
                        outerRadius={80}
                        paddingAngle={2}
                        dataKey="value"
                      >
                        {statusChartData.map((entry, index) => (
                          <Cell key={`cell-${index}`} fill={entry.color} />
                        ))}
                      </Pie>
                      <Tooltip />
                    </PieChart>
                  </ResponsiveContainer>
                </div>
                <div className="w-1/2 space-y-2">
                  {statusChartData.slice(0, 5).map((item) => (
                    <div key={item.name} className="flex items-center gap-2">
                      <div 
                        className="w-3 h-3 rounded-full" 
                        style={{ backgroundColor: item.color }}
                      />
                      <span className="text-sm flex-1 truncate">{item.name}</span>
                      <span className="text-sm font-medium">{item.value}</span>
                    </div>
                  ))}
                </div>
              </div>
            ) : (
              <div className="h-64 flex items-center justify-center text-muted-foreground">
                <p>No applications yet. Start tracking your job search!</p>
              </div>
            )}
          </CardContent>
        </Card>
      </div>

      {/* Upcoming Section */}
      <div className="grid gap-4 lg:grid-cols-2">
        {/* Upcoming Interviews */}
        <Card>
          <CardHeader className="flex flex-row items-center justify-between">
            <div>
              <CardTitle className="text-lg">Upcoming Interviews</CardTitle>
              <CardDescription>Your next scheduled interviews</CardDescription>
            </div>
            <Link href="/dashboard/interviews">
              <Button variant="ghost" size="sm">
                View all
                <ArrowUpRight className="ml-1 h-4 w-4" />
              </Button>
            </Link>
          </CardHeader>
          <CardContent>
            {interviewsLoading ? (
              <div className="space-y-3">
                {[1, 2, 3].map((i) => (
                  <Skeleton key={i} className="h-16 w-full" />
                ))}
              </div>
            ) : upcomingInterviews && upcomingInterviews.length > 0 ? (
              <div className="space-y-3">
                {upcomingInterviews.slice(0, 3).map((interview) => (
                  <Link 
                    key={interview.id} 
                    href={`/dashboard/interviews/${interview.id}`}
                    className="block"
                  >
                    <div className="flex items-center gap-4 p-3 rounded-lg hover:bg-muted transition-colors">
                      <div className="flex-shrink-0 w-10 h-10 bg-primary/10 rounded-lg flex items-center justify-center">
                        <Building2 className="h-5 w-5 text-primary" />
                      </div>
                      <div className="flex-1 min-w-0">
                        <p className="font-medium truncate">
                          {interview.application_company}
                        </p>
                        <p className="text-sm text-muted-foreground truncate">
                          {interview.title || interview.interview_type}
                        </p>
                      </div>
                      <div className="text-right">
                        <p className="text-sm font-medium">
                          {format(new Date(interview.scheduled_at), 'MMM d')}
                        </p>
                        <p className="text-xs text-muted-foreground">
                          {format(new Date(interview.scheduled_at), 'h:mm a')}
                        </p>
                      </div>
                    </div>
                  </Link>
                ))}
              </div>
            ) : (
              <div className="py-8 text-center text-muted-foreground">
                <Calendar className="h-12 w-12 mx-auto mb-3 opacity-50" />
                <p>No upcoming interviews</p>
                <p className="text-sm mt-1">Schedule an interview from your applications</p>
              </div>
            )}
          </CardContent>
        </Card>

        {/* Upcoming Reminders */}
        <Card>
          <CardHeader className="flex flex-row items-center justify-between">
            <div>
              <CardTitle className="text-lg">Upcoming Reminders</CardTitle>
              <CardDescription>Tasks and follow-ups to complete</CardDescription>
            </div>
            <Link href="/dashboard/reminders">
              <Button variant="ghost" size="sm">
                View all
                <ArrowUpRight className="ml-1 h-4 w-4" />
              </Button>
            </Link>
          </CardHeader>
          <CardContent>
            {remindersLoading ? (
              <div className="space-y-3">
                {[1, 2, 3].map((i) => (
                  <Skeleton key={i} className="h-16 w-full" />
                ))}
              </div>
            ) : upcomingReminders && upcomingReminders.length > 0 ? (
              <div className="space-y-3">
                {upcomingReminders.slice(0, 3).map((reminder) => (
                  <div 
                    key={reminder.id} 
                    className="flex items-center gap-4 p-3 rounded-lg hover:bg-muted transition-colors"
                  >
                    <div className="flex-shrink-0 w-10 h-10 bg-yellow-100 rounded-lg flex items-center justify-center">
                      <Clock className="h-5 w-5 text-yellow-600" />
                    </div>
                    <div className="flex-1 min-w-0">
                      <p className="font-medium truncate">{reminder.title}</p>
                      {reminder.application_company && (
                        <p className="text-sm text-muted-foreground truncate">
                          {reminder.application_company}
                        </p>
                      )}
                    </div>
                    <Badge variant="outline" className="text-xs">
                      {formatDistanceToNow(new Date(reminder.scheduled_at), { addSuffix: true })}
                    </Badge>
                  </div>
                ))}
              </div>
            ) : (
              <div className="py-8 text-center text-muted-foreground">
                <Clock className="h-12 w-12 mx-auto mb-3 opacity-50" />
                <p>No upcoming reminders</p>
                <p className="text-sm mt-1">Create reminders to stay on track</p>
              </div>
            )}
          </CardContent>
        </Card>
      </div>

      {/* Recent Activity */}
      <Card>
        <CardHeader>
          <CardTitle className="text-lg">Recent Activity</CardTitle>
          <CardDescription>Latest updates on your applications</CardDescription>
        </CardHeader>
        <CardContent>
          {dashboardLoading ? (
            <div className="space-y-3">
              {[1, 2, 3, 4, 5].map((i) => (
                <Skeleton key={i} className="h-12 w-full" />
              ))}
            </div>
          ) : dashboardData?.recent_activity && dashboardData.recent_activity.length > 0 ? (
            <div className="space-y-3">
              {dashboardData.recent_activity.map((activity) => (
                <div 
                  key={activity.id}
                  className="flex items-center gap-4 p-3 rounded-lg hover:bg-muted transition-colors"
                >
                  <div className="flex-shrink-0 w-10 h-10 bg-muted rounded-full flex items-center justify-center">
                    <TrendingUp className="h-5 w-5 text-muted-foreground" />
                  </div>
                  <div className="flex-1 min-w-0">
                    <p className="text-sm">
                      <span className="font-medium">{activity.title}</span>
                      {' '}for{' '}
                      <Link 
                        href={`/dashboard/applications/${activity.application.id}`}
                        className="text-primary hover:underline"
                      >
                        {activity.application.company_name} - {activity.application.job_title}
                      </Link>
                    </p>
                  </div>
                  <span className="text-xs text-muted-foreground whitespace-nowrap">
                    {formatDistanceToNow(new Date(activity.created_at), { addSuffix: true })}
                  </span>
                </div>
              ))}
            </div>
          ) : (
            <div className="py-8 text-center text-muted-foreground">
              <TrendingUp className="h-12 w-12 mx-auto mb-3 opacity-50" />
              <p>No recent activity</p>
              <p className="text-sm mt-1">Activity will appear here as you update your applications</p>
            </div>
          )}
        </CardContent>
      </Card>
    </div>
  );
}
