'use client';

import { 
  Briefcase, 
  TrendingUp, 
  Calendar, 
  CheckCircle,
  Clock,
  Plus,
  Building2,
  Sparkles,
  Target,
  Zap,
  Trophy,
  ArrowRight,
  ChevronRight,
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

import { Card, CardContent } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
// import { Progress } from '@/components/ui/progress';
import { Skeleton } from '@/components/ui/skeleton';
import { 
  AnimatedNumber, 
  AnimatedProgress, 
  GradientButton,
  StatCard,
  EmptyState,
} from '@/components/ui/animated-elements';
import { AnimatedCard, AnimatedCardContent, AnimatedCardHeader, AnimatedCardTitle, AnimatedCardDescription } from '@/components/ui/animated-card';
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
    <div className="p-6 space-y-8">
      {/* Welcome Header with Gradient */}
      <div className="relative overflow-hidden rounded-2xl gradient-primary p-8 text-white animate-fade-in">
        <div className="relative z-10 flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
          <div>
            <div className="flex items-center gap-2 mb-2">
              <Sparkles className="h-5 w-5 animate-pulse" />
              <span className="text-sm font-medium text-white/80">
                {format(new Date(), 'EEEE, MMMM d, yyyy')}
              </span>
            </div>
            <h1 className="text-3xl font-bold mb-2">
              Welcome back, {user?.first_name || 'there'}! 👋
            </h1>
            <p className="text-white/80 max-w-lg">
              Here&apos;s your job search progress at a glance. Keep up the momentum!
            </p>
          </div>
          <Link href="/dashboard/applications/new">
            <GradientButton variant="secondary" size="lg" shine className="shadow-xl">
              <Plus className="mr-2 h-5 w-5" />
              Add Application
            </GradientButton>
          </Link>
        </div>
        
        {/* Decorative elements */}
        <div className="absolute top-0 right-0 w-64 h-64 bg-white/10 rounded-full blur-3xl -translate-y-1/2 translate-x-1/2" />
        <div className="absolute bottom-0 left-0 w-48 h-48 bg-white/10 rounded-full blur-3xl translate-y-1/2 -translate-x-1/2" />
        <div className="absolute top-1/2 left-1/2 w-96 h-96 bg-white/5 rounded-full blur-3xl -translate-x-1/2 -translate-y-1/2" />
      </div>

      {/* Stats Grid with Animations */}
      <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
        {stats.map((stat, index) => (
          <StatCard
            key={stat.name}
            title={stat.name}
            value={dashboardLoading ? 0 : stat.value}
            icon={<stat.icon className="h-5 w-5" />}
            change={stat.change !== null ? { value: stat.change, label: stat.changeLabel } : undefined}
            trend={stat.change !== null && stat.change > 0 ? 'up' : 'neutral'}
            delay={index * 100}
          />
        ))}
      </div>

      {/* Quick Actions */}
      <div className="grid gap-4 md:grid-cols-3 animate-fade-in-up opacity-0 stagger-3" style={{ animationFillMode: 'forwards' }}>
        <Link href="/dashboard/applications" className="group">
          <Card className="hover-lift cursor-pointer border-2 border-transparent hover:border-primary/20 transition-all">
            <CardContent className="p-6 flex items-center gap-4">
              <div className="p-3 rounded-xl bg-blue-100 text-blue-600 group-hover:scale-110 transition-transform">
                <Briefcase className="h-6 w-6" />
              </div>
              <div className="flex-1">
                <h3 className="font-semibold">Track Applications</h3>
                <p className="text-sm text-muted-foreground">Manage your job applications</p>
              </div>
              <ChevronRight className="h-5 w-5 text-muted-foreground group-hover:translate-x-1 transition-transform" />
            </CardContent>
          </Card>
        </Link>
        
        <Link href="/dashboard/interviews" className="group">
          <Card className="hover-lift cursor-pointer border-2 border-transparent hover:border-primary/20 transition-all">
            <CardContent className="p-6 flex items-center gap-4">
              <div className="p-3 rounded-xl bg-purple-100 text-purple-600 group-hover:scale-110 transition-transform">
                <Calendar className="h-6 w-6" />
              </div>
              <div className="flex-1">
                <h3 className="font-semibold">Schedule Interviews</h3>
                <p className="text-sm text-muted-foreground">Prepare for your next interview</p>
              </div>
              <ChevronRight className="h-5 w-5 text-muted-foreground group-hover:translate-x-1 transition-transform" />
            </CardContent>
          </Card>
        </Link>
        
        <Link href="/dashboard/analytics" className="group">
          <Card className="hover-lift cursor-pointer border-2 border-transparent hover:border-primary/20 transition-all">
            <CardContent className="p-6 flex items-center gap-4">
              <div className="p-3 rounded-xl bg-emerald-100 text-emerald-600 group-hover:scale-110 transition-transform">
                <TrendingUp className="h-6 w-6" />
              </div>
              <div className="flex-1">
                <h3 className="font-semibold">View Analytics</h3>
                <p className="text-sm text-muted-foreground">Insights into your progress</p>
              </div>
              <ChevronRight className="h-5 w-5 text-muted-foreground group-hover:translate-x-1 transition-transform" />
            </CardContent>
          </Card>
        </Link>
      </div>

      {/* Response Rate & Interview Rate with Enhanced Design */}
      <div className="grid gap-4 md:grid-cols-2">
        <AnimatedCard delay={400} hoverEffect="glow">
          <AnimatedCardHeader>
            <div className="flex items-center gap-2">
              <div className="p-2 rounded-lg bg-blue-100">
                <Target className="h-4 w-4 text-blue-600" />
              </div>
              <AnimatedCardTitle>Response Rate</AnimatedCardTitle>
            </div>
            <AnimatedCardDescription>Companies that responded to your applications</AnimatedCardDescription>
          </AnimatedCardHeader>
          <AnimatedCardContent>
            {dashboardLoading ? (
              <Skeleton className="h-4 w-full" />
            ) : (
              <>
                <div className="flex items-center justify-between mb-3">
                  <span className="text-3xl font-bold gradient-text">
                    <AnimatedNumber value={Math.round((dashboardData?.response_rate || 0) * 100)} suffix="%" />
                  </span>
                  <Badge variant="secondary" className="text-xs">
                    {dashboardData?.active_applications || 0} / {dashboardData?.total_applications || 0}
                  </Badge>
                </div>
                <AnimatedProgress 
                  value={(dashboardData?.response_rate || 0) * 100} 
                  variant="gradient"
                  size="md"
                  animated
                />
              </>
            )}
          </AnimatedCardContent>
        </AnimatedCard>

        <AnimatedCard delay={500} hoverEffect="glow">
          <AnimatedCardHeader>
            <div className="flex items-center gap-2">
              <div className="p-2 rounded-lg bg-purple-100">
                <Zap className="h-4 w-4 text-purple-600" />
              </div>
              <AnimatedCardTitle>Interview Rate</AnimatedCardTitle>
            </div>
            <AnimatedCardDescription>Applications that led to interviews</AnimatedCardDescription>
          </AnimatedCardHeader>
          <AnimatedCardContent>
            {dashboardLoading ? (
              <Skeleton className="h-4 w-full" />
            ) : (
              <>
                <div className="flex items-center justify-between mb-3">
                  <span className="text-3xl font-bold gradient-text">
                    <AnimatedNumber value={Math.round((dashboardData?.interview_rate || 0) * 100)} suffix="%" />
                  </span>
                  <Badge variant="secondary" className="text-xs">
                    {dashboardData?.interviews_scheduled || 0} interviews
                  </Badge>
                </div>
                <AnimatedProgress 
                  value={(dashboardData?.interview_rate || 0) * 100} 
                  variant="gradient"
                  size="md"
                  animated
                />
              </>
            )}
          </AnimatedCardContent>
        </AnimatedCard>
      </div>

      {/* Charts Row with Enhanced Styling */}
      <div className="grid gap-4 lg:grid-cols-2">
        {/* Weekly Activity Chart */}
        <AnimatedCard delay={600} className="overflow-hidden">
          <AnimatedCardHeader>
            <div className="flex items-center justify-between">
              <div>
                <AnimatedCardTitle className="text-lg">Weekly Activity</AnimatedCardTitle>
                <AnimatedCardDescription>Applications submitted over the past weeks</AnimatedCardDescription>
              </div>
              <Badge className="gradient-primary text-white">
                <TrendingUp className="h-3 w-3 mr-1" />
                Live
              </Badge>
            </div>
          </AnimatedCardHeader>
          <AnimatedCardContent>
            {dashboardLoading ? (
              <Skeleton className="h-64 w-full" />
            ) : weeklyData.length > 0 ? (
              <div className="h-64">
                <ResponsiveContainer width="100%" height="100%">
                  <AreaChart data={weeklyData}>
                    <defs>
                      <linearGradient id="colorCount" x1="0" y1="0" x2="0" y2="1">
                        <stop offset="5%" stopColor="#6366f1" stopOpacity={0.4} />
                        <stop offset="95%" stopColor="#6366f1" stopOpacity={0} />
                      </linearGradient>
                    </defs>
                    <CartesianGrid strokeDasharray="3 3" className="stroke-muted" opacity={0.3} />
                    <XAxis 
                      dataKey="week" 
                      className="text-xs"
                      tickFormatter={(value) => value.split('-')[1] || value}
                      tick={{ fill: '#6b7280' }}
                    />
                    <YAxis className="text-xs" tick={{ fill: '#6b7280' }} />
                    <Tooltip 
                      contentStyle={{ 
                        backgroundColor: 'hsl(var(--background))',
                        border: '1px solid hsl(var(--border))',
                        borderRadius: '12px',
                        boxShadow: '0 10px 40px rgba(0,0,0,0.1)'
                      }}
                    />
                    <Area
                      type="monotone"
                      dataKey="count"
                      stroke="#6366f1"
                      strokeWidth={3}
                      fillOpacity={1}
                      fill="url(#colorCount)"
                    />
                  </AreaChart>
                </ResponsiveContainer>
              </div>
            ) : (
              <EmptyState
                icon={<TrendingUp className="h-8 w-8" />}
                title="No activity yet"
                description="Start adding applications to see your activity chart"
                action={
                  <Link href="/dashboard/applications/new">
                    <Button size="sm">Add Your First Application</Button>
                  </Link>
                }
              />
            )}
          </AnimatedCardContent>
        </AnimatedCard>

        {/* Status Distribution with Enhanced Design */}
        <AnimatedCard delay={700} className="overflow-hidden">
          <AnimatedCardHeader>
            <AnimatedCardTitle className="text-lg">Application Status</AnimatedCardTitle>
            <AnimatedCardDescription>Distribution of your applications by status</AnimatedCardDescription>
          </AnimatedCardHeader>
          <AnimatedCardContent>
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
                        innerRadius={55}
                        outerRadius={85}
                        paddingAngle={3}
                        dataKey="value"
                      >
                        {statusChartData.map((entry, index) => (
                          <Cell 
                            key={`cell-${index}`} 
                            fill={entry.color}
                            className="transition-all duration-300 hover:opacity-80"
                          />
                        ))}
                      </Pie>
                      <Tooltip 
                        contentStyle={{ 
                          backgroundColor: 'hsl(var(--background))',
                          border: '1px solid hsl(var(--border))',
                          borderRadius: '12px',
                          boxShadow: '0 10px 40px rgba(0,0,0,0.1)'
                        }}
                      />
                    </PieChart>
                  </ResponsiveContainer>
                </div>
                <div className="w-1/2 space-y-2">
                  {statusChartData.slice(0, 5).map((item, index) => (
                    <div 
                      key={item.name} 
                      className="flex items-center gap-2 p-2 rounded-lg hover:bg-muted transition-colors animate-fade-in-left opacity-0"
                      style={{ animationDelay: `${800 + index * 100}ms`, animationFillMode: 'forwards' }}
                    >
                      <div 
                        className="w-3 h-3 rounded-full ring-2 ring-offset-2 ring-offset-background" 
                        style={{ backgroundColor: item.color }}
                      />
                      <span className="text-sm flex-1 truncate">{item.name}</span>
                      <span className="text-sm font-semibold">{item.value}</span>
                    </div>
                  ))}
                </div>
              </div>
            ) : (
              <EmptyState
                icon={<Briefcase className="h-8 w-8" />}
                title="No applications yet"
                description="Start tracking your job search journey"
                action={
                  <Link href="/dashboard/applications/new">
                    <Button size="sm">Add Application</Button>
                  </Link>
                }
              />
            )}
          </AnimatedCardContent>
        </AnimatedCard>
      </div>

      {/* Upcoming Section with Enhanced Cards */}
      <div className="grid gap-4 lg:grid-cols-2">
        {/* Upcoming Interviews */}
        <AnimatedCard delay={800}>
          <AnimatedCardHeader className="flex flex-row items-center justify-between">
            <div>
              <div className="flex items-center gap-2 mb-1">
                <div className="p-1.5 rounded-lg bg-purple-100">
                  <Calendar className="h-4 w-4 text-purple-600" />
                </div>
                <AnimatedCardTitle className="text-lg">Upcoming Interviews</AnimatedCardTitle>
              </div>
              <AnimatedCardDescription>Your next scheduled interviews</AnimatedCardDescription>
            </div>
            <Link href="/dashboard/interviews">
              <Button variant="ghost" size="sm" className="group">
                View all
                <ArrowRight className="ml-1 h-4 w-4 group-hover:translate-x-1 transition-transform" />
              </Button>
            </Link>
          </AnimatedCardHeader>
          <AnimatedCardContent>
            {interviewsLoading ? (
              <div className="space-y-3">
                {[1, 2, 3].map((i) => (
                  <Skeleton key={i} className="h-16 w-full rounded-xl" />
                ))}
              </div>
            ) : upcomingInterviews && upcomingInterviews.length > 0 ? (
              <div className="space-y-3">
                {upcomingInterviews.slice(0, 3).map((interview, index) => (
                  <Link 
                    key={interview.id} 
                    href={`/dashboard/interviews/${interview.id}`}
                    className="block animate-fade-in-up opacity-0"
                    style={{ animationDelay: `${900 + index * 100}ms`, animationFillMode: 'forwards' }}
                  >
                    <div className="flex items-center gap-4 p-4 rounded-xl border bg-card hover:bg-muted/50 hover:border-primary/20 transition-all group">
                      <div className="flex-shrink-0 w-12 h-12 gradient-accent rounded-xl flex items-center justify-center group-hover:scale-105 transition-transform">
                        <Building2 className="h-6 w-6 text-white" />
                      </div>
                      <div className="flex-1 min-w-0">
                        <p className="font-semibold truncate group-hover:text-primary transition-colors">
                          {interview.application_company}
                        </p>
                        <p className="text-sm text-muted-foreground truncate">
                          {interview.title || interview.interview_type}
                        </p>
                      </div>
                      <div className="text-right">
                        <p className="text-sm font-semibold text-primary">
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
              <EmptyState
                icon={<Calendar className="h-8 w-8" />}
                title="No upcoming interviews"
                description="Schedule an interview from your applications"
              />
            )}
          </AnimatedCardContent>
        </AnimatedCard>

        {/* Upcoming Reminders */}
        <AnimatedCard delay={900}>
          <AnimatedCardHeader className="flex flex-row items-center justify-between">
            <div>
              <div className="flex items-center gap-2 mb-1">
                <div className="p-1.5 rounded-lg bg-amber-100">
                  <Clock className="h-4 w-4 text-amber-600" />
                </div>
                <AnimatedCardTitle className="text-lg">Upcoming Reminders</AnimatedCardTitle>
              </div>
              <AnimatedCardDescription>Tasks and follow-ups to complete</AnimatedCardDescription>
            </div>
            <Link href="/dashboard/reminders">
              <Button variant="ghost" size="sm" className="group">
                View all
                <ArrowRight className="ml-1 h-4 w-4 group-hover:translate-x-1 transition-transform" />
              </Button>
            </Link>
          </AnimatedCardHeader>
          <AnimatedCardContent>
            {remindersLoading ? (
              <div className="space-y-3">
                {[1, 2, 3].map((i) => (
                  <Skeleton key={i} className="h-16 w-full rounded-xl" />
                ))}
              </div>
            ) : upcomingReminders && upcomingReminders.length > 0 ? (
              <div className="space-y-3">
                {upcomingReminders.slice(0, 3).map((reminder, index) => (
                  <div 
                    key={reminder.id} 
                    className="flex items-center gap-4 p-4 rounded-xl border bg-card hover:bg-muted/50 hover:border-primary/20 transition-all animate-fade-in-up opacity-0"
                    style={{ animationDelay: `${1000 + index * 100}ms`, animationFillMode: 'forwards' }}
                  >
                    <div className="flex-shrink-0 w-12 h-12 gradient-warning rounded-xl flex items-center justify-center">
                      <Clock className="h-6 w-6 text-white" />
                    </div>
                    <div className="flex-1 min-w-0">
                      <p className="font-semibold truncate">{reminder.title}</p>
                      {reminder.application_company && (
                        <p className="text-sm text-muted-foreground truncate">
                          {reminder.application_company}
                        </p>
                      )}
                    </div>
                    <Badge className="bg-amber-100 text-amber-700 hover:bg-amber-100">
                      {formatDistanceToNow(new Date(reminder.scheduled_at), { addSuffix: true })}
                    </Badge>
                  </div>
                ))}
              </div>
            ) : (
              <EmptyState
                icon={<Clock className="h-8 w-8" />}
                title="No upcoming reminders"
                description="Create reminders to stay on track"
              />
            )}
          </AnimatedCardContent>
        </AnimatedCard>
      </div>

      {/* Recent Activity with Enhanced Design */}
      <AnimatedCard delay={1000}>
        <AnimatedCardHeader>
          <div className="flex items-center gap-2">
            <div className="p-2 rounded-lg bg-emerald-100">
              <TrendingUp className="h-4 w-4 text-emerald-600" />
            </div>
            <div>
              <AnimatedCardTitle className="text-lg">Recent Activity</AnimatedCardTitle>
              <AnimatedCardDescription>Latest updates on your applications</AnimatedCardDescription>
            </div>
          </div>
        </AnimatedCardHeader>
        <AnimatedCardContent>
          {dashboardLoading ? (
            <div className="space-y-3">
              {[1, 2, 3, 4, 5].map((i) => (
                <Skeleton key={i} className="h-14 w-full rounded-xl" />
              ))}
            </div>
          ) : dashboardData?.recent_activity && dashboardData.recent_activity.length > 0 ? (
            <div className="space-y-3">
              {dashboardData.recent_activity.map((activity, index) => (
                <div 
                  key={activity.id}
                  className="flex items-center gap-4 p-4 rounded-xl border bg-card hover:bg-muted/50 hover:border-primary/20 transition-all animate-fade-in-up opacity-0"
                  style={{ animationDelay: `${1100 + index * 100}ms`, animationFillMode: 'forwards' }}
                >
                  <div className="flex-shrink-0 w-10 h-10 rounded-full bg-gradient-to-br from-indigo-500 to-purple-500 flex items-center justify-center">
                    <TrendingUp className="h-5 w-5 text-white" />
                  </div>
                  <div className="flex-1 min-w-0">
                    <p className="text-sm">
                      <span className="font-semibold">{activity.title}</span>
                      {' '}for{' '}
                      <Link 
                        href={`/dashboard/applications/${activity.application.id}`}
                        className="text-primary hover:underline font-medium"
                      >
                        {activity.application.company_name} - {activity.application.job_title}
                      </Link>
                    </p>
                  </div>
                  <span className="text-xs text-muted-foreground whitespace-nowrap px-3 py-1 rounded-full bg-muted">
                    {formatDistanceToNow(new Date(activity.created_at), { addSuffix: true })}
                  </span>
                </div>
              ))}
            </div>
          ) : (
            <EmptyState
              icon={<TrendingUp className="h-8 w-8" />}
              title="No recent activity"
              description="Activity will appear here as you update your applications"
            />
          )}
        </AnimatedCardContent>
      </AnimatedCard>

      {/* Pro Tip Card */}
      <AnimatedCard variant="premium" delay={1200} className="border-indigo-200 dark:border-indigo-800">
        <AnimatedCardContent className="p-6">
          <div className="flex items-start gap-4">
            <div className="p-3 rounded-xl bg-gradient-to-br from-indigo-500 to-purple-500 text-white">
              <Trophy className="h-6 w-6" />
            </div>
            <div className="flex-1">
              <h3 className="font-semibold text-lg mb-1">Pro Tip 💡</h3>
              <p className="text-muted-foreground">
                Set up reminders for follow-ups 1 week after submitting applications. 
                Companies that don&apos;t respond within 2 weeks often won&apos;t respond at all.
              </p>
            </div>
            <Link href="/dashboard/reminders">
              <Button variant="outline" className="hover:bg-primary hover:text-primary-foreground transition-colors">
                Set Reminder
                <ArrowRight className="ml-2 h-4 w-4" />
              </Button>
            </Link>
          </div>
        </AnimatedCardContent>
      </AnimatedCard>
    </div>
  );
}
