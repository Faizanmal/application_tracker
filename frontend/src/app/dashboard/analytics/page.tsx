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
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
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
}: {
  title: string;
  value: number | string;
  change?: number;
  changeLabel?: string;
  icon: React.ElementType;
  isLoading?: boolean;
}) {
  const isPositive = change && change > 0;
  const isNegative = change && change < 0;

  return (
    <Card>
      <CardContent className="p-6">
        <div className="flex items-center justify-between">
          <div className="space-y-1">
            <p className="text-sm text-muted-foreground">{title}</p>
            {isLoading ? (
              <Skeleton className="h-8 w-20" />
            ) : (
              <p className="text-2xl font-bold">{value}</p>
            )}
            {change !== undefined && !isLoading && (
              <div className="flex items-center gap-1 text-sm">
                {isPositive ? (
                  <ArrowUpRight className="h-4 w-4 text-green-500" />
                ) : isNegative ? (
                  <ArrowDownRight className="h-4 w-4 text-red-500" />
                ) : (
                  <Minus className="h-4 w-4 text-gray-500" />
                )}
                <span className={isPositive ? 'text-green-600' : isNegative ? 'text-red-600' : 'text-gray-600'}>
                  {isPositive ? '+' : ''}{change}%
                </span>
                <span className="text-muted-foreground">{changeLabel}</span>
              </div>
            )}
          </div>
          <div className="p-3 rounded-xl bg-primary/10">
            <Icon className="h-6 w-6 text-primary" />
          </div>
        </div>
      </CardContent>
    </Card>
  );
}

function ApplicationFunnel({ data }: { data: { name: string; value: number; fill: string }[] }) {
  return (
    <Card className="col-span-full lg:col-span-1">
      <CardHeader>
        <CardTitle>Application Funnel</CardTitle>
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
              <Bar dataKey="value" radius={[0, 4, 4, 0]}>
                {data.map((entry, index) => (
                  <Cell key={`cell-${index}`} fill={FUNNEL_COLORS[index % FUNNEL_COLORS.length]} />
                ))}
              </Bar>
            </BarChart>
          </ResponsiveContainer>
        </div>
      </CardContent>
    </Card>
  );
}

function StatusBreakdown({ data }: { data: { name: string; value: number }[] }) {
  const total = data.reduce((sum, item) => sum + item.value, 0);

  return (
    <Card>
      <CardHeader>
        <CardTitle>Status Breakdown</CardTitle>
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
    </Card>
  );
}

function ApplicationTrend({ data }: { data: { date: string; applications: number; interviews: number }[] }) {
  return (
    <Card className="col-span-full lg:col-span-2">
      <CardHeader>
        <CardTitle>Application Trend</CardTitle>
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
    </Card>
  );
}

function SourceBreakdown({ data }: { data: { name: string; value: number }[] }) {
  const COLORS = ['#6366f1', '#8b5cf6', '#a855f7', '#d946ef', '#ec4899', '#f43f5e'];

  return (
    <Card>
      <CardHeader>
        <CardTitle>Application Sources</CardTitle>
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
    </Card>
  );
}

function TopCompanies({ data }: { data: { company: string; count: number; status: string }[] }) {
  return (
    <Card>
      <CardHeader>
        <CardTitle className="flex items-center gap-2">
          <Building2 className="h-5 w-5" />
          Top Companies
        </CardTitle>
        <CardDescription>Companies you&apos;ve applied to most</CardDescription>
      </CardHeader>
      <CardContent>
        <div className="space-y-4">
          {data.slice(0, 5).map((item, index) => (
            <div key={item.company} className="flex items-center gap-4">
              <div className="flex items-center justify-center w-8 h-8 rounded-full bg-primary/10 text-primary font-semibold text-sm">
                {index + 1}
              </div>
              <div className="flex-1 min-w-0">
                <p className="font-medium truncate">{item.company}</p>
                <p className="text-sm text-muted-foreground">
                  {item.count} application{item.count > 1 ? 's' : ''}
                </p>
              </div>
              <Badge variant="outline" className="capitalize">
                {item.status.replace('_', ' ')}
              </Badge>
            </div>
          ))}
        </div>
      </CardContent>
    </Card>
  );
}

function ResponseTimeAnalysis({ avgDays, distribution }: { avgDays: number; distribution: { range: string; count: number }[] }) {
  return (
    <Card>
      <CardHeader>
        <CardTitle className="flex items-center gap-2">
          <Clock className="h-5 w-5" />
          Response Time
        </CardTitle>
        <CardDescription>How long companies take to respond</CardDescription>
      </CardHeader>
      <CardContent className="space-y-6">
        <div className="text-center">
          <p className="text-4xl font-bold text-primary">{avgDays}</p>
          <p className="text-sm text-muted-foreground">Average days to response</p>
        </div>
        <div className="h-[200px]">
          <ResponsiveContainer width="100%" height="100%">
            <BarChart data={distribution}>
              <CartesianGrid strokeDasharray="3 3" vertical={false} />
              <XAxis dataKey="range" fontSize={12} />
              <YAxis fontSize={12} />
              <Tooltip />
              <Bar dataKey="count" fill="#6366f1" radius={[4, 4, 0, 0]} />
            </BarChart>
          </ResponsiveContainer>
        </div>
      </CardContent>
    </Card>
  );
}

function WeeklyGoalProgress({ current, goal }: { current: number; goal: number }) {
  const percentage = Math.min((current / goal) * 100, 100);
  const isOnTrack = percentage >= 50; // Assuming mid-week check

  return (
    <Card>
      <CardHeader>
        <CardTitle className="flex items-center gap-2">
          <Target className="h-5 w-5" />
          Weekly Goal
        </CardTitle>
        <CardDescription>Your application target this week</CardDescription>
      </CardHeader>
      <CardContent className="space-y-6">
        <div className="text-center">
          <p className="text-4xl font-bold">
            {current} <span className="text-lg text-muted-foreground">/ {goal}</span>
          </p>
          <p className="text-sm text-muted-foreground mt-1">applications submitted</p>
        </div>
        <Progress value={percentage} className="h-3" />
        <div className="flex items-center justify-center gap-2">
          {isOnTrack ? (
            <>
              <TrendingUp className="h-4 w-4 text-green-500" />
              <span className="text-sm text-green-600">On track!</span>
            </>
          ) : (
            <>
              <TrendingDown className="h-4 w-4 text-yellow-500" />
              <span className="text-sm text-yellow-600">Keep pushing!</span>
            </>
          )}
        </div>
      </CardContent>
    </Card>
  );
}

export default function AnalyticsPage() {
  const [dateRange, setDateRange] = useState('30');
  const { data: analytics, isLoading } = useAnalytics();
  const exportApplications = useExportApplications();

  const handleExport = (exportFormat: 'csv' | 'pdf') => {
    exportApplications.mutate(exportFormat);
  };

  // Mock data - replace with real data from analytics
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
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <h1 className="text-2xl font-bold">Analytics</h1>
          <p className="text-muted-foreground">
            Insights and statistics about your job search
          </p>
        </div>
        <div className="flex items-center gap-3">
          <Select value={dateRange} onValueChange={setDateRange}>
            <SelectTrigger className="w-[150px]">
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
          <Button variant="outline" onClick={() => handleExport('csv')} disabled={exportApplications.isPending}>
            {exportApplications.isPending ? (
              <Loader2 className="mr-2 h-4 w-4 animate-spin" />
            ) : (
              <Download className="mr-2 h-4 w-4" />
            )}
            Export
          </Button>
        </div>
      </div>

      {/* Overview Stats */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
        <StatCard
          title="Total Applications"
          value={analytics?.total_applications || 0}
          change={12}
          changeLabel="vs last period"
          icon={BarChart3}
          isLoading={isLoading}
        />
        <StatCard
          title="Response Rate"
          value={`${analytics?.response_rate?.toFixed(0) || 0}%`}
          change={5}
          changeLabel="vs last period"
          icon={TrendingUp}
          isLoading={isLoading}
        />
        <StatCard
          title="Interview Rate"
          value={`${analytics?.interview_rate?.toFixed(0) || 0}%`}
          change={-2}
          changeLabel="vs last period"
          icon={Target}
          isLoading={isLoading}
        />
        <StatCard
          title="Avg Response Time"
          value={`${analytics?.avg_response_days || 0} days`}
          change={0}
          changeLabel="vs last period"
          icon={Clock}
          isLoading={isLoading}
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
      <Card>
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <TrendingUp className="h-5 w-5" />
            Insights & Recommendations
          </CardTitle>
        </CardHeader>
        <CardContent>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
            <div className="p-4 rounded-lg border bg-blue-50 border-blue-200">
              <h4 className="font-medium text-blue-900">Best Application Day</h4>
              <p className="text-sm text-blue-700 mt-1">
                You get 40% more responses when applying on Tuesdays
              </p>
            </div>
            <div className="p-4 rounded-lg border bg-green-50 border-green-200">
              <h4 className="font-medium text-green-900">Top Performing Source</h4>
              <p className="text-sm text-green-700 mt-1">
                LinkedIn referrals have a 3x higher interview rate
              </p>
            </div>
            <div className="p-4 rounded-lg border bg-purple-50 border-purple-200">
              <h4 className="font-medium text-purple-900">Follow-up Timing</h4>
              <p className="text-sm text-purple-700 mt-1">
                Following up at 7 days increases response by 25%
              </p>
            </div>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
