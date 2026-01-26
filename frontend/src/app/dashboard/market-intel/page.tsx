'use client';

import { useState } from 'react';
import {
  Building2,
  TrendingUp,
  DollarSign,
  MapPin,
  BarChart3,
  Calendar,
  Target,
  Search,
  Sparkles,
  Globe,
  Users,
  ArrowUpRight,
  ArrowDownRight,
} from 'lucide-react';

// import { AnimatedCard } from '@/components/ui/animated-card';
// import { GradientButton, AnimatedNumber, EmptyState as AnimatedEmptyState } from '@/components/ui/animated-elements';

import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from '@/components/ui/card';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { Badge } from '@/components/ui/badge';
import { Progress } from '@/components/ui/progress';
import { Skeleton } from '@/components/ui/skeleton';
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from '@/components/ui/dialog';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select';
import {
  useCompanies,
  useSalaryData,
  // useEstimateSalary,
  useIndustryTrends,
  useHiringSeasons,
  useJobSearchROI,
} from '@/hooks/use-queries';
import type { CompanyProfile, SalaryData, IndustryTrend } from '@/types';

type SkillItem = string | { name: string };

function CompanyCard({ company }: { company: CompanyProfile }) {
  return (
    <Card className="hover:shadow-md transition-shadow cursor-pointer">
      <CardContent className="p-4">
        <div className="flex items-start gap-4">
          {company.logo_url ? (
            /* eslint-disable-next-line @next/next/no-img-element */
            <img
              src={company.logo_url}
              alt={company.name}
              className="w-12 h-12 rounded-lg object-cover"
            />
          ) : (
            <div className="w-12 h-12 bg-primary/10 rounded-lg flex items-center justify-center">
              <Building2 className="h-6 w-6 text-primary" />
            </div>
          )}
          
          <div className="flex-1 min-w-0">
            <div className="flex items-center gap-2">
              <h3 className="font-semibold truncate">{company.name}</h3>
              {company.is_hiring && (
                <Badge className="bg-green-100 text-green-700 shrink-0">Hiring</Badge>
              )}
            </div>
            
            <p className="text-sm text-muted-foreground">{company.industry}</p>
            
            <div className="flex items-center gap-4 mt-2 text-sm">
              {company.glassdoor_rating && (
                <span className="flex items-center gap-1">
                  ⭐ {company.glassdoor_rating}
                </span>
              )}
              {company.employee_count && (
                <span className="flex items-center gap-1 text-muted-foreground">
                  <Users className="h-3 w-3" />
                  {company.employee_count.toLocaleString()}
                </span>
              )}
              {company.open_positions_count > 0 && (
                <span className="text-green-600">
                  {company.open_positions_count} open positions
                </span>
              )}
            </div>
          </div>
        </div>
      </CardContent>
    </Card>
  );
}

function TrendCard({ trend }: { trend: IndustryTrend }) {
  const trendColors = {
    growing: 'text-green-600',
    stable: 'text-blue-600',
    declining: 'text-red-600',
  };

  const trendIcons = {
    growing: ArrowUpRight,
    stable: TrendingUp,
    declining: ArrowDownRight,
  };

  const TrendIcon = trendIcons[trend.hiring_trend] || TrendingUp;

  return (
    <Card>
      <CardHeader className="pb-2">
        <div className="flex items-center justify-between">
          <CardTitle className="text-base">{trend.industry}</CardTitle>
          <div className={`flex items-center gap-1 ${trendColors[trend.hiring_trend]}`}>
            <TrendIcon className="h-4 w-4" />
            <span className="text-sm font-medium capitalize">{trend.hiring_trend}</span>
          </div>
        </div>
      </CardHeader>
      <CardContent>
        {trend.growth_rate !== null && (
          <p className="text-sm text-muted-foreground mb-3">
            {trend.growth_rate > 0 ? '+' : ''}{trend.growth_rate}% YoY growth
          </p>
        )}
        
        <div className="space-y-2">
          <div>
            <p className="text-xs font-medium text-muted-foreground mb-1">Top Skills</p>
            <div className="flex flex-wrap gap-1">
              {trend.top_skills.slice(0, 5).map((skill: SkillItem, index: number) => (
                <Badge key={typeof skill === 'string' ? skill : skill.name || index} variant="secondary" className="text-xs">
                  {typeof skill === 'string' ? skill : skill.name || 'Unknown'}
                </Badge>
              ))}
            </div>
          </div>
          
          {trend.emerging_skills.length > 0 && (
            <div>
              <p className="text-xs font-medium text-green-600 mb-1">Emerging</p>
              <div className="flex flex-wrap gap-1">
                {trend.emerging_skills.slice(0, 3).map((skill: SkillItem, index: number) => (
                  <Badge key={typeof skill === 'string' ? skill : skill.name || index} className="text-xs bg-green-100 text-green-700">
                    {typeof skill === 'string' ? skill : skill.name || 'Unknown'}
                  </Badge>
                ))}
              </div>
            </div>
          )}
        </div>
        
        {trend.remote_percentage !== null && (
          <div className="mt-3 flex items-center gap-2 text-sm">
            <Globe className="h-3 w-3 text-muted-foreground" />
            <span className="text-muted-foreground">{trend.remote_percentage}% remote</span>
          </div>
        )}
      </CardContent>
    </Card>
  );
}

function SalaryCard({ salary }: { salary: SalaryData }) {
  return (
    <Card>
      <CardContent className="p-4">
        <div className="flex items-start justify-between mb-2">
          <div>
            <h4 className="font-semibold">{salary.job_title}</h4>
            <p className="text-sm text-muted-foreground flex items-center gap-1">
              <MapPin className="h-3 w-3" />
              {salary.location}
            </p>
          </div>
          {salary.seniority_level && (
            <Badge variant="outline">{salary.seniority_level}</Badge>
          )}
        </div>
        
        <div className="mt-3">
          <div className="flex items-baseline gap-2">
            <span className="text-2xl font-bold">
              ${(salary.salary_median || ((salary.salary_min + salary.salary_max) / 2)).toLocaleString()}
            </span>
            <span className="text-sm text-muted-foreground">{salary.currency}/yr</span>
          </div>
          <p className="text-sm text-muted-foreground">
            ${salary.salary_min.toLocaleString()} - ${salary.salary_max.toLocaleString()}
          </p>
        </div>
        
        <div className="mt-2 flex items-center gap-2 text-xs text-muted-foreground">
          <span>Based on {salary.sample_size} data points</span>
        </div>
      </CardContent>
    </Card>
  );
}

export default function MarketIntelPage() {
  const [companySearch, setCompanySearch] = useState('');
  const [selectedIndustry, setSelectedIndustry] = useState<string>('');
  const [salaryDialogOpen, setSalaryDialogOpen] = useState(false);
  
  const { data: companies, isLoading: companiesLoading } = useCompanies(companySearch);
  const { data: salaries, isLoading: salariesLoading } = useSalaryData();
  const { data: trends, isLoading: trendsLoading } = useIndustryTrends(selectedIndustry);
  const { data: hiringSeasons, isLoading: seasonsLoading } = useHiringSeasons(selectedIndustry);
  const { data: roiData, isLoading: roiLoading } = useJobSearchROI();
  
  // const estimateSalary = useEstimateSalary();

  return (
    <div className="p-6 space-y-6">
      {/* Header with Gradient */}
      <div className="relative overflow-hidden rounded-2xl bg-gradient-to-r from-blue-500 via-cyan-500 to-teal-500 p-8">
        <div className="absolute top-0 right-0 w-64 h-64 bg-white/10 rounded-full blur-3xl -translate-y-1/2 translate-x-1/2" />
        <div className="absolute bottom-0 left-0 w-48 h-48 bg-white/5 rounded-full blur-2xl translate-y-1/2 -translate-x-1/2" />
        <div className="absolute top-1/2 right-1/4 w-32 h-32 bg-cyan-300/20 rounded-full blur-xl" />
        
        <div className="relative flex flex-col sm:flex-row sm:items-center sm:justify-between gap-6">
          <div className="animate-fade-in-up">
            <h1 className="text-3xl font-bold text-white flex items-center gap-3">
              <div className="p-2 bg-white/20 rounded-xl backdrop-blur-sm">
                <BarChart3 className="h-7 w-7" />
              </div>
              Market Intelligence
            </h1>
            <p className="text-white/80 mt-2 max-w-md">
              Research companies, salaries, and industry trends
            </p>
          </div>
          
          <Dialog open={salaryDialogOpen} onOpenChange={setSalaryDialogOpen}>
            <DialogTrigger asChild>
              <Button className="bg-white/20 hover:bg-white/30 text-white border-white/30">
                <DollarSign className="h-4 w-4 mr-2" />
                Estimate Salary
              </Button>
            </DialogTrigger>
            <DialogContent>
              <DialogHeader>
                <DialogTitle>Salary Estimator</DialogTitle>
                <DialogDescription>
                  Get an AI-powered salary estimate for your target role.
                </DialogDescription>
              </DialogHeader>
              <div className="text-muted-foreground text-center py-8">
                Salary estimation form coming soon...
              </div>
            </DialogContent>
          </Dialog>
        </div>
      </div>

      {/* Quick Stats */}
      <div className="grid gap-4 md:grid-cols-4">
        <Card>
          <CardHeader className="flex flex-row items-center justify-between pb-2">
            <CardTitle className="text-sm font-medium">Companies Tracked</CardTitle>
            <Building2 className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{companies?.length || 0}</div>
          </CardContent>
        </Card>
        
        <Card>
          <CardHeader className="flex flex-row items-center justify-between pb-2">
            <CardTitle className="text-sm font-medium">Salary Data Points</CardTitle>
            <DollarSign className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{salaries?.length || 0}</div>
          </CardContent>
        </Card>
        
        <Card>
          <CardHeader className="flex flex-row items-center justify-between pb-2">
            <CardTitle className="text-sm font-medium">Industry Trends</CardTitle>
            <TrendingUp className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{trends?.length || 0}</div>
          </CardContent>
        </Card>
        
        <Card>
          <CardHeader className="flex flex-row items-center justify-between pb-2">
            <CardTitle className="text-sm font-medium">Your ROI</CardTitle>
            <Target className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">
              {roiData?.[0]?.response_rate ? `${roiData[0].response_rate.toFixed(1)}%` : '—'}
            </div>
            <p className="text-xs text-muted-foreground">Response rate</p>
          </CardContent>
        </Card>
      </div>

      {/* Tabs */}
      <Tabs defaultValue="companies" className="space-y-4">
        <TabsList>
          <TabsTrigger value="companies">
            <Building2 className="h-4 w-4 mr-2" />
            Companies
          </TabsTrigger>
          <TabsTrigger value="salaries">
            <DollarSign className="h-4 w-4 mr-2" />
            Salaries
          </TabsTrigger>
          <TabsTrigger value="trends">
            <TrendingUp className="h-4 w-4 mr-2" />
            Trends
          </TabsTrigger>
          <TabsTrigger value="timing">
            <Calendar className="h-4 w-4 mr-2" />
            Best Timing
          </TabsTrigger>
          <TabsTrigger value="roi">
            <BarChart3 className="h-4 w-4 mr-2" />
            Your ROI
          </TabsTrigger>
        </TabsList>

        <TabsContent value="companies" className="space-y-4">
          <div className="relative">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
            <Input
              placeholder="Search companies by name..."
              value={companySearch}
              onChange={(e) => setCompanySearch(e.target.value)}
              className="pl-9"
            />
          </div>
          
          {companiesLoading ? (
            <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
              {[1, 2, 3, 4, 5, 6].map((i) => (
                <Skeleton key={i} className="h-28" />
              ))}
            </div>
          ) : companies && companies.length > 0 ? (
            <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
              {companies.map((company: CompanyProfile) => (
                <CompanyCard key={company.id} company={company} />
              ))}
            </div>
          ) : (
            <Card>
              <CardContent className="flex flex-col items-center justify-center py-12">
                <Building2 className="h-12 w-12 text-muted-foreground mb-4" />
                <h3 className="text-lg font-semibold">Search for companies</h3>
                <p className="text-muted-foreground text-center mt-1">
                  Enter a company name to see detailed information.
                </p>
              </CardContent>
            </Card>
          )}
        </TabsContent>

        <TabsContent value="salaries" className="space-y-4">
          <div className="flex gap-2">
            <Input placeholder="Search by job title..." className="flex-1" />
            <Select>
              <SelectTrigger className="w-[180px]">
                <SelectValue placeholder="Location" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="us">United States</SelectItem>
                <SelectItem value="remote">Remote</SelectItem>
                <SelectItem value="sf">San Francisco</SelectItem>
                <SelectItem value="nyc">New York</SelectItem>
              </SelectContent>
            </Select>
          </div>
          
          {salariesLoading ? (
            <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
              {[1, 2, 3, 4, 5, 6].map((i) => (
                <Skeleton key={i} className="h-36" />
              ))}
            </div>
          ) : salaries && salaries.length > 0 ? (
            <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
              {salaries.map((salary: SalaryData) => (
                <SalaryCard key={salary.id} salary={salary} />
              ))}
            </div>
          ) : (
            <Card>
              <CardContent className="flex flex-col items-center justify-center py-12">
                <DollarSign className="h-12 w-12 text-muted-foreground mb-4" />
                <h3 className="text-lg font-semibold">No salary data yet</h3>
                <p className="text-muted-foreground text-center mt-1">
                  Salary data will be populated as more users contribute.
                </p>
              </CardContent>
            </Card>
          )}
        </TabsContent>

        <TabsContent value="trends" className="space-y-4">
          <Select value={selectedIndustry} onValueChange={setSelectedIndustry}>
            <SelectTrigger className="w-[280px]">
              <SelectValue placeholder="Filter by industry" />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value="">All Industries</SelectItem>
              <SelectItem value="technology">Technology</SelectItem>
              <SelectItem value="finance">Finance</SelectItem>
              <SelectItem value="healthcare">Healthcare</SelectItem>
              <SelectItem value="retail">Retail</SelectItem>
            </SelectContent>
          </Select>
          
          {trendsLoading ? (
            <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
              {[1, 2, 3, 4, 5, 6].map((i) => (
                <Skeleton key={i} className="h-48" />
              ))}
            </div>
          ) : trends && trends.length > 0 ? (
            <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
              {trends.map((trend: IndustryTrend) => (
                <TrendCard key={trend.id} trend={trend} />
              ))}
            </div>
          ) : (
            <Card>
              <CardContent className="flex flex-col items-center justify-center py-12">
                <TrendingUp className="h-12 w-12 text-muted-foreground mb-4" />
                <h3 className="text-lg font-semibold">No trends data yet</h3>
                <p className="text-muted-foreground text-center mt-1">
                  Industry trends will appear as data is collected.
                </p>
              </CardContent>
            </Card>
          )}
        </TabsContent>

        <TabsContent value="timing">
          <Card>
            <CardHeader>
              <CardTitle>Best Time to Apply</CardTitle>
              <CardDescription>Hiring patterns throughout the year</CardDescription>
            </CardHeader>
            <CardContent>
              {seasonsLoading ? (
                <Skeleton className="h-48" />
              ) : hiringSeasons ? (
                <div className="space-y-4">
                  <div>
                    <h4 className="font-medium text-green-600 mb-2">🔥 Peak Months</h4>
                    <div className="flex flex-wrap gap-2">
                      {hiringSeasons.peak_months?.map((month: string) => (
                        <Badge key={month} className="bg-green-100 text-green-700">
                          {month}
                        </Badge>
                      ))}
                    </div>
                  </div>
                  
                  <div>
                    <h4 className="font-medium text-amber-600 mb-2">❄️ Slow Months</h4>
                    <div className="flex flex-wrap gap-2">
                      {hiringSeasons.slow_months?.map((month: string) => (
                        <Badge key={month} className="bg-amber-100 text-amber-700">
                          {month}
                        </Badge>
                      ))}
                    </div>
                  </div>
                  
                  {hiringSeasons.best_time_to_apply && (
                    <div className="mt-4 p-4 bg-blue-50 rounded-lg">
                      <div className="flex items-start gap-2">
                        <Sparkles className="h-5 w-5 text-blue-600 shrink-0 mt-0.5" />
                        <p className="text-sm text-blue-800">{hiringSeasons.best_time_to_apply}</p>
                      </div>
                    </div>
                  )}
                </div>
              ) : (
                <div className="text-center py-8 text-muted-foreground">
                  No hiring season data available
                </div>
              )}
            </CardContent>
          </Card>
        </TabsContent>

        <TabsContent value="roi">
          <Card>
            <CardHeader>
              <CardTitle>Job Search ROI</CardTitle>
              <CardDescription>Track your job search efficiency</CardDescription>
            </CardHeader>
            <CardContent>
              {roiLoading ? (
                <Skeleton className="h-48" />
              ) : roiData?.[0] ? (
                <div className="space-y-6">
                  <div className="grid gap-4 md:grid-cols-4">
                    <div className="text-center p-4 bg-muted/50 rounded-lg">
                      <p className="text-3xl font-bold">{roiData[0].total_applications}</p>
                      <p className="text-sm text-muted-foreground">Applications</p>
                    </div>
                    <div className="text-center p-4 bg-muted/50 rounded-lg">
                      <p className="text-3xl font-bold">{roiData[0].responses_received}</p>
                      <p className="text-sm text-muted-foreground">Responses</p>
                    </div>
                    <div className="text-center p-4 bg-muted/50 rounded-lg">
                      <p className="text-3xl font-bold">{roiData[0].interviews_scheduled}</p>
                      <p className="text-sm text-muted-foreground">Interviews</p>
                    </div>
                    <div className="text-center p-4 bg-muted/50 rounded-lg">
                      <p className="text-3xl font-bold">{roiData[0].offers_received}</p>
                      <p className="text-sm text-muted-foreground">Offers</p>
                    </div>
                  </div>
                  
                  <div className="space-y-4">
                    <div>
                      <div className="flex items-center justify-between mb-1">
                        <span className="text-sm">Response Rate</span>
                        <span className="font-medium">{roiData[0].response_rate?.toFixed(1) || 0}%</span>
                      </div>
                      <Progress value={roiData[0].response_rate || 0} className="h-2" />
                    </div>
                    <div>
                      <div className="flex items-center justify-between mb-1">
                        <span className="text-sm">Interview Rate</span>
                        <span className="font-medium">{roiData[0].interview_rate?.toFixed(1) || 0}%</span>
                      </div>
                      <Progress value={roiData[0].interview_rate || 0} className="h-2" />
                    </div>
                    <div>
                      <div className="flex items-center justify-between mb-1">
                        <span className="text-sm">Offer Rate</span>
                        <span className="font-medium">{roiData[0].offer_rate?.toFixed(1) || 0}%</span>
                      </div>
                      <Progress value={roiData[0].offer_rate || 0} className="h-2" />
                    </div>
                  </div>
                </div>
              ) : (
                <div className="text-center py-8 text-muted-foreground">
                  <BarChart3 className="h-12 w-12 mx-auto mb-4 opacity-50" />
                  <p>Start tracking your applications to see ROI data</p>
                </div>
              )}
            </CardContent>
          </Card>
        </TabsContent>
      </Tabs>
    </div>
  );
}
