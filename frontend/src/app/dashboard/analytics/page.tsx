'use client';

import { useState } from 'react';
import {
  BarChart3,
  TrendingUp,
  TrendingDown,
  Target,
  Clock,
  Building2,
  Download,
  Calendar,
  ArrowUpRight,
  ArrowDownRight,
  Minus,
  Loader2,
  Sparkles,
  Zap,
  PieChart as PieChartIcon,
} from 'lucide-react';
import {
  AreaChart,
  Area,
  BarChart,
  Bar,
  PieChart,
  Pie,
  Cell,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
  Legend,
} from 'recharts';

import { Button } from '@/components/ui/button';
import { CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { Skeleton } from '@/components/ui/skeleton';
import { Progress } from '@/components/ui/progress';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select';
import { AnimatedCard } from '@/components/ui/animated-card';
import { AnimatedNumber } from '@/components/ui/animated-elements';
import { useAnalytics, useExportApplications } from '@/hooks/use-queries';

const STATUS_COLORS: Record<string, string> = {
  applied: '#6366f1',
  interviewing: '#8b5cf6',
  offer: '#22c55e',
  rejected: '#ef4444',
  saved: '#94a3b8',
  withdrawn: '#f97316',
};

const FUNNEL_COLORS = ['#6366f1', '#8b5cf6', '#a855f7', '#22c55e'];

function StatCard({
  title,
  value,
  change,
  changeLabel,
  icon: Icon,
  isLoading,
  gradient,
}: {
  title: string;
  value: number | string;
  change?: number;
  changeLabel?: string;
  icon: React.ElementType;
  isLoading?: boolean;
  gradient?: string;
}) {
  const isPositive = change && change > 0;
  const isNegative = change && change < 0;

  return (
    <AnimatedCard variant="interactive" hoverEffect="lift">
      <CardContent className="p-6">
        <div className="flex items-center justify-between">
          <div className="space-y-1">
            <p className="text-sm text-muted-foreground font-medium">{title}</p>
            {isLoading ? (
              <Skeleton className="h-8 w-20" />
            ) : (
              <p className="text-3xl font-bold">
                {typeof value === 'number' ? <AnimatedNumber value={value} /> : value}
              </p>
            )}
            {change !== undefined && !isLoading && (
              <div className="flex items-center gap-1.5 text-sm">
                <div className={`flex items-center gap-1 px-2 py-0.5 rounded-full ${isPositive ? 'bg-green-100 text-green-700' : isNegative ? 'bg-red-100 text-red-700' : 'bg-gray-100 text-gray-700'}`}>
                  {isPositive ? (
                    <ArrowUpRight className="h-3.5 w-3.5" />
                  ) : isNegative ? (
                    <ArrowDownRight className="h-3.5 w-3.5" />
                  ) : (
                    <Minus className="h-3.5 w-3.5" />
                  )}
                  <span className="font-medium">
                    {isPositive ? '+' : ''}{change}%
                  </span>
                </div>
                <span className="text-muted-foreground text-xs">{changeLabel}</span>
              </div>
            )}
          </div>
          <div className={`p-3 rounded-xl shadow-md ${gradient || 'bg-gradient-to-br from-primary to-purple-600'}`}>
            <Icon className="h-6 w-6 text-white" />
          </div>
        </div>
      </CardContent>
    </AnimatedCard>
  );
}

function ApplicationFunnel({ data }: { data: { name: string; value: number; fill: string }[] }) {
  return (
    <AnimatedCard variant="default" className="col-span-full lg:col-span-1">
      <CardHeader>
        <CardTitle className="flex items-center gap-2">
          <div className="p-2 bg-gradient-to-br from-purple-500 to-pink-500 rounded-lg">
            <Target className="h-4 w-4 text-white" />
          </div>
          Application Funnel
        </CardTitle>
        <CardDescription>Track your conversion through each stage</CardDescription>
      </CardHeader>
      <CardContent>
        <div className="h-[300px]">
          <ResponsiveContainer width="100%" height="100%">
            <BarChart data={data} layout="vertical" margin={{ top: 20, right: 30, left: 20, bottom: 5 }}>
              <CartesianGrid strokeDasharray="3 3" horizontal={false} />
              <XAxis type="number" />
              <YAxis dataKey="name" type="category" width={100} />
              <Tooltip />
              <Bar dataKey="value" radius={[0, 8, 8, 0]}>
                {data.map((entry, index) => (
                  <Cell key={`cell-${index}`} fill={FUNNEL_COLORS[index % FUNNEL_COLORS.length]} />
                ))}
              </Bar>
            </BarChart>
          </ResponsiveContainer>
        </div>
      </CardContent>
    </AnimatedCard>
  );
}

function StatusBreakdown({ data }: { data: { name: string; value: number }[] }) {
  const total = data.reduce((sum, item) => sum + item.value, 0);

  return (
    <AnimatedCard variant="default">
      <CardHeader>
        <CardTitle className="flex items-center gap-2">
          <div className="p-2 bg-gradient-to-br from-blue-500 to-indigo-500 rounded-lg">
            <PieChartIcon className="h-4 w-4 text-white" />
          </div>
          Status Breakdown
        </CardTitle>
        <CardDescription>Current status of all applications</CardDescription>
      </CardHeader>
      <CardContent className="space-y-4">
        {data.map((item) => {
          const percentage = total > 0 ? (item.value / total) * 100 : 0;
          return (
            <div key={item.name} className="space-y-2">
              <div className="flex items-center justify-between text-sm">
                <span className="capitalize">{item.name.replace('_', ' ')}</span>
                <span className="text-muted-foreground">
                  {item.value} ({percentage.toFixed(0)}%)
                </span>
              </div>
              <Progress 
                value={percentage} 
                className="h-2"
                style={{ 
                  '--tw-bg-opacity': 1,
                  backgroundColor: STATUS_COLORS[item.name] || '#94a3b8',
                } as React.CSSProperties}
              />
            </div>
          );
        })}
      </CardContent>
    </AnimatedCard>
  );
}

function ApplicationTrend({ data }: { data: { date: string; applications: number; interviews: number }[] }) {
  return (
    <AnimatedCard variant="default" className="col-span-full lg:col-span-2">
      <CardHeader>
        <CardTitle className="flex items-center gap-2">
          <div className="p-2 bg-gradient-to-br from-indigo-500 to-blue-500 rounded-lg">
            <TrendingUp className="h-4 w-4 text-white" />
          </div>
          Application Trend
        </CardTitle>
        <CardDescription>Applications and interviews over time</CardDescription>
      </CardHeader>
      <CardContent>
        <div className="h-[300px]">
          <ResponsiveContainer width="100%" height="100%">
            <AreaChart data={data}>
              <defs>
                <linearGradient id="colorApplications" x1="0" y1="0" x2="0" y2="1">
                  <stop offset="5%" stopColor="#6366f1" stopOpacity={0.3} />
                  <stop offset="95%" stopColor="#6366f1" stopOpacity={0} />
                </linearGradient>
                <linearGradient id="colorInterviews" x1="0" y1="0" x2="0" y2="1">
                  <stop offset="5%" stopColor="#22c55e" stopOpacity={0.3} />
                  <stop offset="95%" stopColor="#22c55e" stopOpacity={0} />
                </linearGradient>
              </defs>
              <CartesianGrid strokeDasharray="3 3" vertical={false} />
              <XAxis dataKey="date" fontSize={12} />
              <YAxis fontSize={12} />
              <Tooltip />
              <Legend />
              <Area
                type="monotone"
                dataKey="applications"
                stroke="#6366f1"
                fill="url(#colorApplications)"
                strokeWidth={2}
              />
              <Area
                type="monotone"
                dataKey="interviews"
                stroke="#22c55e"
                fill="url(#colorInterviews)"
                strokeWidth={2}
              />
            </AreaChart>
          </ResponsiveContainer>
        </div>
      </CardContent>
    </AnimatedCard>
  );
}

function SourceBreakdown({ data }: { data: { name: string; value: number }[] }) {
  const COLORS = ['#6366f1', '#8b5cf6', '#a855f7', '#d946ef', '#ec4899', '#f43f5e'];

  return (
    <AnimatedCard variant="default">
      <CardHeader>
        <CardTitle className="flex items-center gap-2">
          <div className="p-2 bg-gradient-to-br from-pink-500 to-rose-500 rounded-lg">
            <Sparkles className="h-4 w-4 text-white" />
          </div>
          Application Sources
        </CardTitle>
        <CardDescription>Where your applications come from</CardDescription>
      </CardHeader>
      <CardContent>
        <div className="h-[250px]">
          <ResponsiveContainer width="100%" height="100%">
            <PieChart>
              <Pie
                data={data}
                cx="50%"
                cy="50%"
                innerRadius={60}
                outerRadius={80}
                paddingAngle={2}
                dataKey="value"
              >
                {data.map((entry, index) => (
                  <Cell key={`cell-${index}`} fill={COLORS[index % COLORS.length]} />
                ))}
              </Pie>
              <Tooltip />
              <Legend />
            </PieChart>
          </ResponsiveContainer>
        </div>
      </CardContent>
    </AnimatedCard>
  );
}

function TopCompanies({ data }: { data: { company: string; count: number; status: string }[] }) {
  return (
    <AnimatedCard variant="default">
      <CardHeader>
        <CardTitle className="flex items-center gap-2">
          <div className="p-2 bg-gradient-to-br from-cyan-500 to-blue-500 rounded-lg">
            <Building2 className="h-4 w-4 text-white" />
          </div>
          Top Companies
        </CardTitle>
        <CardDescription>Companies you&apos;ve applied to most</CardDescription>
      </CardHeader>
      <CardContent>
        <div className="space-y-4">
          {data.slice(0, 5).map((item, index) => (
            <div key={item.company} className="flex items-center gap-4 animate-fade-in-up" style={{ animationDelay: `${index * 50}ms` }}>
              <div className={`flex items-center justify-center w-8 h-8 rounded-full font-semibold text-sm text-white shadow-sm ${index === 0 ? 'bg-gradient-to-br from-yellow-400 to-orange-500' : index === 1 ? 'bg-gradient-to-br from-gray-300 to-gray-400' : index === 2 ? 'bg-gradient-to-br from-amber-600 to-orange-700' : 'bg-gradient-to-br from-primary to-purple-600'}`}>
                {index + 1}
              </div>
              <div className="flex-1 min-w-0">
                <p className="font-medium truncate">{item.company}</p>
                <p className="text-sm text-muted-foreground">
                  {item.count} application{item.count > 1 ? 's' : ''}
                </p>
              </div>
              <Badge variant="outline" className="capitalize bg-gradient-to-r from-primary/5 to-purple-500/5">
                {item.status.replace('_', ' ')}
              </Badge>
            </div>
          ))}
        </div>
      </CardContent>
    </AnimatedCard>
  );
}

function ResponseTimeAnalysis({ avgDays, distribution }: { avgDays: number; distribution: { range: string; count: number }[] }) {
  return (
    <AnimatedCard variant="default">
      <CardHeader>
        <CardTitle className="flex items-center gap-2">
          <div className="p-2 bg-gradient-to-br from-amber-500 to-orange-500 rounded-lg">
            <Clock className="h-4 w-4 text-white" />
          </div>
          Response Time
        </CardTitle>
        <CardDescription>How long companies take to respond</CardDescription>
      </CardHeader>
      <CardContent className="space-y-6">
        <div className="text-center p-4 bg-gradient-to-br from-primary/5 to-purple-500/5 rounded-xl">
          <p className="text-5xl font-bold bg-gradient-to-r from-primary to-purple-600 bg-clip-text text-transparent">
            <AnimatedNumber value={avgDays} />
          </p>
          <p className="text-sm text-muted-foreground mt-1">Average days to response</p>
        </div>
        <div className="h-[200px]">
          <ResponsiveContainer width="100%" height="100%">
            <BarChart data={distribution}>
              <CartesianGrid strokeDasharray="3 3" vertical={false} />
              <XAxis dataKey="range" fontSize={12} />
              <YAxis fontSize={12} />
              <Tooltip />
              <Bar dataKey="count" fill="#6366f1" radius={[6, 6, 0, 0]} />
            </BarChart>
          </ResponsiveContainer>
        </div>
      </CardContent>
    </AnimatedCard>
  );
}

function WeeklyGoalProgress({ current, goal }: { current: number; goal: number }) {
  const percentage = Math.min((current / goal) * 100, 100);
  const isOnTrack = percentage >= 50;

  return (
    <AnimatedCard variant="default">
      <CardHeader>
        <CardTitle className="flex items-center gap-2">
          <div className="p-2 bg-gradient-to-br from-green-500 to-emerald-500 rounded-lg">
            <Target className="h-4 w-4 text-white" />
          </div>
          Weekly Goal
        </CardTitle>
        <CardDescription>Your application target this week</CardDescription>
      </CardHeader>
      <CardContent className="space-y-6">
        <div className="text-center p-4 bg-gradient-to-br from-green-50 to-emerald-50 rounded-xl">
          <p className="text-4xl font-bold">
            <span className="bg-gradient-to-r from-green-600 to-emerald-600 bg-clip-text text-transparent">
              <AnimatedNumber value={current} />
            </span>
            <span className="text-lg text-muted-foreground"> / {goal}</span>
          </p>
          <p className="text-sm text-muted-foreground mt-1">applications submitted</p>
        </div>
        <Progress value={percentage} className="h-4" />
        <div className="flex items-center justify-center gap-2 p-3 rounded-lg bg-gradient-to-r from-green-50 to-emerald-50">
          {isOnTrack ? (
            <>
              <TrendingUp className="h-5 w-5 text-green-500" />
              <span className="text-sm font-medium text-green-600">You&apos;re on track! Keep it up!</span>
            </>
          ) : (
            <>
              <TrendingDown className="h-5 w-5 text-yellow-500" />
              <span className="text-sm font-medium text-yellow-600">Keep pushing! You got this!</span>
            </>
          )}
        </div>
      </CardContent>
    </AnimatedCard>
  );
}

export default function AnalyticsPage() {
  const [dateRange, setDateRange] = useState('30');
  const { data: analytics, isLoading } = useAnalytics();
  const exportApplications = useExportApplications();

  const handleExport = (exportFormat: 'csv' | 'pdf') => {
    exportApplications.mutate(exportFormat);
  };

  const trendData = [
    { date: 'Week 1', applications: 12, interviews: 2 },
    { date: 'Week 2', applications: 18, interviews: 4 },
    { date: 'Week 3', applications: 15, interviews: 3 },
    { date: 'Week 4', applications: 22, interviews: 6 },
  ];

  const funnelData = [
    { name: 'Applied', value: analytics?.total_applications || 0, fill: '#6366f1' },
    { name: 'Interview', value: analytics?.total_interviews || 0, fill: '#8b5cf6' },
    { name: 'Offer', value: analytics?.offers || 0, fill: '#22c55e' },
  ];

  const statusData = analytics?.by_status 
    ? Object.entries(analytics.by_status).map(([name, value]) => ({ name, value: value as number }))
    : [];

  const sourceData = analytics?.by_source
    ? Object.entries(analytics.by_source).map(([name, value]) => ({ name, value: value as number }))
    : [];

  const responseTimeDistribution = [
    { range: '< 1 week', count: 15 },
    { range: '1-2 weeks', count: 25 },
    { range: '2-4 weeks', count: 18 },
    { range: '> 4 weeks', count: 8 },
  ];

  const topCompanies = [
    { company: 'Google', count: 3, status: 'interviewing' },
    { company: 'Microsoft', count: 2, status: 'applied' },
    { company: 'Amazon', count: 2, status: 'rejected' },
    { company: 'Meta', count: 1, status: 'saved' },
    { company: 'Apple', count: 1, status: 'applied' },
  ];

  return (
    <div className="p-6 space-y-6">
      {/* Header with Gradient */}
      <div className="relative overflow-hidden rounded-2xl bg-gradient-to-r from-teal-600 via-cyan-600 to-blue-600 p-8">
        <div className="absolute top-0 right-0 w-64 h-64 bg-white/10 rounded-full blur-3xl -translate-y-1/2 translate-x-1/2" />
        <div className="absolute bottom-0 left-0 w-48 h-48 bg-white/5 rounded-full blur-2xl translate-y-1/2 -translate-x-1/2" />
        <div className="absolute top-1/2 right-1/4 w-32 h-32 bg-cyan-400/20 rounded-full blur-xl" />
        
        <div className="relative flex flex-col sm:flex-row sm:items-center sm:justify-between gap-6">
          <div className="animate-fade-in-up">
            <h1 className="text-3xl font-bold text-white flex items-center gap-3">
              <div className="p-2 bg-white/20 rounded-xl backdrop-blur-sm">
                <BarChart3 className="h-7 w-7" />
              </div>
              Analytics
            </h1>
            <p className="text-white/80 mt-2 max-w-md">
              Insights and statistics about your job search journey
            </p>
          </div>
          <div className="flex items-center gap-3 animate-fade-in-up stagger-2">
            <Select value={dateRange} onValueChange={setDateRange}>
              <SelectTrigger className="w-[150px] bg-white/10 border-white/20 text-white backdrop-blur-sm">
                <Calendar className="mr-2 h-4 w-4" />
                <SelectValue />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="7">Last 7 days</SelectItem>
                <SelectItem value="30">Last 30 days</SelectItem>
                <SelectItem value="90">Last 90 days</SelectItem>
                <SelectItem value="365">Last year</SelectItem>
              </SelectContent>
            </Select>
            <Button 
              variant="secondary" 
              onClick={() => handleExport('csv')} 
              disabled={exportApplications.isPending}
              className="bg-white text-cyan-600 hover:bg-white/90 shadow-lg"
            >
              {exportApplications.isPending ? (
                <Loader2 className="mr-2 h-4 w-4 animate-spin" />
              ) : (
                <Download className="mr-2 h-4 w-4" />
              )}
              Export
            </Button>
          </div>
        </div>

        <div className="relative grid grid-cols-2 sm:grid-cols-4 gap-4 mt-6 animate-fade-in-up stagger-3">
          <div className="bg-white/10 backdrop-blur-sm rounded-xl p-4 border border-white/20">
            <p className="text-white/70 text-sm">Total Apps</p>
            <p className="text-2xl font-bold text-white">
              <AnimatedNumber value={analytics?.total_applications || 0} />
            </p>
          </div>
          <div className="bg-white/10 backdrop-blur-sm rounded-xl p-4 border border-white/20">
            <p className="text-white/70 text-sm">Interviews</p>
            <p className="text-2xl font-bold text-white">
              <AnimatedNumber value={analytics?.total_interviews || 0} />
            </p>
          </div>
          <div className="bg-white/10 backdrop-blur-sm rounded-xl p-4 border border-white/20">
            <p className="text-white/70 text-sm">Response Rate</p>
            <p className="text-2xl font-bold text-white">
              {analytics?.response_rate?.toFixed(0) || 0}%
            </p>
          </div>
          <div className="bg-white/10 backdrop-blur-sm rounded-xl p-4 border border-white/20">
            <p className="text-white/70 text-sm">Offers</p>
            <p className="text-2xl font-bold text-white">
              <AnimatedNumber value={analytics?.offers || 0} />
            </p>
          </div>
        </div>
      </div>

      {/* Overview Stats */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 animate-fade-in-up stagger-4">
        <StatCard
          title="Total Applications"
          value={analytics?.total_applications || 0}
          change={12}
          changeLabel="vs last period"
          icon={BarChart3}
          isLoading={isLoading}
          gradient="bg-gradient-to-br from-indigo-500 to-blue-600"
        />
        <StatCard
          title="Response Rate"
          value={`${analytics?.response_rate?.toFixed(0) || 0}%`}
          change={5}
          changeLabel="vs last period"
          icon={TrendingUp}
          isLoading={isLoading}
          gradient="bg-gradient-to-br from-green-500 to-emerald-600"
        />
        <StatCard
          title="Interview Rate"
          value={`${analytics?.interview_rate?.toFixed(0) || 0}%`}
          change={-2}
          changeLabel="vs last period"
          icon={Target}
          isLoading={isLoading}
          gradient="bg-gradient-to-br from-purple-500 to-violet-600"
        />
        <StatCard
          title="Avg Response Time"
          value={`${analytics?.avg_response_days || 0} days`}
          change={0}
          changeLabel="vs last period"
          icon={Clock}
          isLoading={isLoading}
          gradient="bg-gradient-to-br from-amber-500 to-orange-600"
        />
      </div>

      {/* Charts Row 1 */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <ApplicationTrend data={trendData} />
        <ApplicationFunnel data={funnelData} />
      </div>

      {/* Charts Row 2 */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        <StatusBreakdown data={statusData} />
        <SourceBreakdown data={sourceData} />
        <WeeklyGoalProgress current={analytics?.this_week || 0} goal={20} />
      </div>

      {/* Charts Row 3 */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        <ResponseTimeAnalysis 
          avgDays={analytics?.avg_response_days || 0} 
          distribution={responseTimeDistribution} 
        />
        <TopCompanies data={topCompanies} />
      </div>

      {/* Insights Section */}
      <AnimatedCard variant="premium">
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <div className="p-2 bg-gradient-to-br from-primary to-purple-600 rounded-lg">
              <Zap className="h-4 w-4 text-white" />
            </div>
            <span className="bg-gradient-to-r from-primary to-purple-600 bg-clip-text text-transparent">
              Insights & Recommendations
            </span>
          </CardTitle>
        </CardHeader>
        <CardContent>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
            <div className="p-5 rounded-xl border bg-gradient-to-br from-blue-50 to-indigo-50 border-blue-200 hover:shadow-md transition-all animate-fade-in-up">
              <div className="flex items-center gap-2 mb-2">
                <div className="p-1.5 bg-blue-500 rounded-lg">
                  <Calendar className="h-4 w-4 text-white" />
                </div>
                <h4 className="font-semibold text-blue-900">Best Application Day</h4>
              </div>
              <p className="text-sm text-blue-700">
                You get 40% more responses when applying on Tuesdays
              </p>
            </div>
            <div className="p-5 rounded-xl border bg-gradient-to-br from-green-50 to-emerald-50 border-green-200 hover:shadow-md transition-all animate-fade-in-up stagger-2">
              <div className="flex items-center gap-2 mb-2">
                <div className="p-1.5 bg-green-500 rounded-lg">
                  <TrendingUp className="h-4 w-4 text-white" />
                </div>
                <h4 className="font-semibold text-green-900">Top Performing Source</h4>
              </div>
              <p className="text-sm text-green-700">
                LinkedIn referrals have a 3x higher interview rate
              </p>
            </div>
            <div className="p-5 rounded-xl border bg-gradient-to-br from-purple-50 to-violet-50 border-purple-200 hover:shadow-md transition-all animate-fade-in-up stagger-3">
              <div className="flex items-center gap-2 mb-2">
                <div className="p-1.5 bg-purple-500 rounded-lg">
                  <Clock className="h-4 w-4 text-white" />
                </div>
                <h4 className="font-semibold text-purple-900">Follow-up Timing</h4>
              </div>
              <p className="text-sm text-purple-700">
                Following up at 7 days increases response by 25%
              </p>
            </div>
          </div>
        </CardContent>
      </AnimatedCard>
    </div>
  );
}
