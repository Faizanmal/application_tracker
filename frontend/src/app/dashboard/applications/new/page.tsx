'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import Link from 'next/link';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import * as z from 'zod';
import { format } from 'date-fns';
import { 
  ArrowLeft, 
  Loader2, 
  Building2, 
  Briefcase,
  MapPin,
  DollarSign,
  Link as LinkIcon,
  Calendar as CalendarIcon,
  FileText,
  User,
  Mail,
  Phone,
  Linkedin,
  Sparkles
} from 'lucide-react';

import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Textarea } from '@/components/ui/textarea';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { 
  Select, 
  SelectContent, 
  SelectItem, 
  SelectTrigger, 
  SelectValue 
} from '@/components/ui/select';
import { Calendar } from '@/components/ui/calender';
import { Popover, PopoverContent, PopoverTrigger } from '@/components/ui/popover';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { useCreateApplication, useResumes } from '@/hooks/use-queries';
import { useIsPro } from '@/lib/auth';
import type { ApplicationStatus, JobType, WorkLocation, Resume } from '@/types';

const applicationSchema = z.object({
  company_name: z.string().min(1, 'Company name is required'),
  job_title: z.string().min(1, 'Job title is required'),
  job_link: z.string().url('Please enter a valid URL').optional().or(z.literal('')),
  job_description: z.string().optional(),
  location: z.string().optional(),
  work_location: z.enum(['onsite', 'remote', 'hybrid']).optional(),
  job_type: z.enum(['full_time', 'part_time', 'contract', 'internship', 'freelance', 'remote']).optional(),
  salary_min: z.number().optional().nullable(),
  salary_max: z.number().optional().nullable(),
  status: z.enum(['wishlist', 'applied', 'screening', 'interviewing', 'offer', 'accepted', 'rejected', 'withdrawn', 'ghosted']),
  applied_date: z.date().optional().nullable(),
  deadline: z.date().optional().nullable(),
  notes: z.string().optional(),
  cover_letter: z.string().optional(),
  resume: z.string().optional(),
  source: z.string().optional(),
  referral: z.string().optional(),
  contact_name: z.string().optional(),
  contact_email: z.string().email().optional().or(z.literal('')),
  contact_phone: z.string().optional(),
  contact_linkedin: z.string().url().optional().or(z.literal('')),
  company_website: z.string().url().optional().or(z.literal('')),
  company_size: z.string().optional(),
  company_industry: z.string().optional(),
});

type ApplicationFormData = z.infer<typeof applicationSchema>;

const JOB_TYPES: { value: JobType; label: string }[] = [
  { value: 'full_time', label: 'Full-time' },
  { value: 'part_time', label: 'Part-time' },
  { value: 'contract', label: 'Contract' },
  { value: 'internship', label: 'Internship' },
  { value: 'freelance', label: 'Freelance' },
];

const WORK_LOCATIONS: { value: WorkLocation; label: string }[] = [
  { value: 'onsite', label: 'On-site' },
  { value: 'remote', label: 'Remote' },
  { value: 'hybrid', label: 'Hybrid' },
];

const STATUSES: { value: ApplicationStatus; label: string }[] = [
  { value: 'wishlist', label: 'Wishlist' },
  { value: 'applied', label: 'Applied' },
  { value: 'screening', label: 'Screening' },
  { value: 'interviewing', label: 'Interviewing' },
  { value: 'offer', label: 'Offer' },
];

const SOURCES = [
  'LinkedIn',
  'Indeed',
  'Glassdoor',
  'Company Website',
  'Referral',
  'Job Fair',
  'Recruiter',
  'Other',
];

export default function NewApplicationPage() {
  const router = useRouter();
  const createApplication = useCreateApplication();
  const { data: resumes } = useResumes();
  const isPro = useIsPro();
  const [activeTab, setActiveTab] = useState('basic');

  const {
    register,
    handleSubmit,
    formState: { errors },
    setValue,
    watch,
  } = useForm<ApplicationFormData>({
    resolver: zodResolver(applicationSchema),
    defaultValues: {
      status: 'wishlist',
      applied_date: null,
      deadline: null,
    },
  });

  const appliedDate = watch('applied_date');
  const deadline = watch('deadline');
  const status = watch('status');

  const onSubmit = async (data: ApplicationFormData) => {
    try {
      const payload = {
        ...data,
        applied_date: data.applied_date ? format(data.applied_date, 'yyyy-MM-dd') : null,
        deadline: data.deadline ? format(data.deadline, 'yyyy-MM-dd') : null,
        job_link: data.job_link || undefined,
        contact_email: data.contact_email || undefined,
        contact_linkedin: data.contact_linkedin || undefined,
        company_website: data.company_website || undefined,
      };
      
      await createApplication.mutateAsync(payload);
      router.push('/dashboard/applications');
    } catch (_error) {
      // Error handled by mutation
    }
  };

  return (
    <div className="p-6 max-w-4xl mx-auto">
      {/* Header */}
      <div className="flex items-center gap-4 mb-6">
        <Button variant="ghost" size="icon" asChild>
          <Link href="/dashboard/applications">
            <ArrowLeft className="h-5 w-5" />
          </Link>
        </Button>
        <div>
          <h1 className="text-2xl font-bold">Add New Application</h1>
          <p className="text-muted-foreground">Track a new job opportunity</p>
        </div>
      </div>

      <form onSubmit={handleSubmit(onSubmit)}>
        <Tabs value={activeTab} onValueChange={setActiveTab}>
          <TabsList className="mb-6">
            <TabsTrigger value="basic">Basic Info</TabsTrigger>
            <TabsTrigger value="details">Job Details</TabsTrigger>
            <TabsTrigger value="company">Company</TabsTrigger>
            <TabsTrigger value="contact">Contact</TabsTrigger>
          </TabsList>

          {/* Basic Info Tab */}
          <TabsContent value="basic">
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <Briefcase className="h-5 w-5" />
                  Basic Information
                </CardTitle>
                <CardDescription>
                  Enter the essential details about this job application
                </CardDescription>
              </CardHeader>
              <CardContent className="space-y-6">
                <div className="grid gap-4 sm:grid-cols-2">
                  <div className="space-y-2">
                    <Label htmlFor="company_name">Company Name *</Label>
                    <Input
                      id="company_name"
                      placeholder="e.g., Google"
                      {...register('company_name')}
                      className={errors.company_name ? 'border-red-500' : ''}
                    />
                    {errors.company_name && (
                      <p className="text-sm text-red-500">{errors.company_name.message}</p>
                    )}
                  </div>

                  <div className="space-y-2">
                    <Label htmlFor="job_title">Job Title *</Label>
                    <Input
                      id="job_title"
                      placeholder="e.g., Software Engineer"
                      {...register('job_title')}
                      className={errors.job_title ? 'border-red-500' : ''}
                    />
                    {errors.job_title && (
                      <p className="text-sm text-red-500">{errors.job_title.message}</p>
                    )}
                  </div>
                </div>

                <div className="space-y-2">
                  <Label htmlFor="job_link">Job Posting URL</Label>
                  <div className="relative">
                    <LinkIcon className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
                    <Input
                      id="job_link"
                      placeholder="https://..."
                      className="pl-10"
                      {...register('job_link')}
                    />
                  </div>
                </div>

                <div className="grid gap-4 sm:grid-cols-2">
                  <div className="space-y-2">
                    <Label>Status</Label>
                    <Select
                      value={status}
                      onValueChange={(value) => setValue('status', value as ApplicationStatus)}
                    >
                      <SelectTrigger>
                        <SelectValue placeholder="Select status" />
                      </SelectTrigger>
                      <SelectContent>
                        {STATUSES.map((s) => (
                          <SelectItem key={s.value} value={s.value}>
                            {s.label}
                          </SelectItem>
                        ))}
                      </SelectContent>
                    </Select>
                  </div>

                  <div className="space-y-2">
                    <Label>Applied Date</Label>
                    <Popover>
                      <PopoverTrigger asChild>
                        <Button
                          variant="outline"
                          className={`w-full justify-start text-left font-normal ${
                            !appliedDate && 'text-muted-foreground'
                          }`}
                        >
                          <CalendarIcon className="mr-2 h-4 w-4" />
                          {appliedDate ? format(appliedDate, 'PPP') : 'Select date'}
                        </Button>
                      </PopoverTrigger>
                      <PopoverContent className="w-auto p-0" align="start">
                        <Calendar
                          mode="single"
                          selected={appliedDate || undefined}
                          onSelect={(date: Date | undefined) => setValue('applied_date', date || null)}
                          initialFocus
                        />
                      </PopoverContent>
                    </Popover>
                  </div>
                </div>

                <div className="grid gap-4 sm:grid-cols-2">
                  <div className="space-y-2">
                    <Label>Source</Label>
                    <Select
                      onValueChange={(value) => setValue('source', value)}
                    >
                      <SelectTrigger>
                        <SelectValue placeholder="Where did you find this job?" />
                      </SelectTrigger>
                      <SelectContent>
                        {SOURCES.map((source) => (
                          <SelectItem key={source} value={source}>
                            {source}
                          </SelectItem>
                        ))}
                      </SelectContent>
                    </Select>
                  </div>

                  <div className="space-y-2">
                    <Label htmlFor="referral">Referral</Label>
                    <Input
                      id="referral"
                      placeholder="Who referred you?"
                      {...register('referral')}
                    />
                  </div>
                </div>

                <div className="space-y-2">
                  <Label>Resume</Label>
                  <Select
                    onValueChange={(value) => setValue('resume', value)}
                  >
                    <SelectTrigger>
                      <SelectValue placeholder="Select a resume" />
                    </SelectTrigger>
                    <SelectContent>
                      {resumes?.results?.map((resume: Resume) => (
                        <SelectItem key={resume.id} value={resume.id.toString()}>
                          {resume.name} {resume.is_default && '(Default)'}
                        </SelectItem>
                      ))}
                    </SelectContent>
                  </Select>
                </div>

                <div className="space-y-2">
                  <Label htmlFor="notes">Notes</Label>
                  <Textarea
                    id="notes"
                    placeholder="Any notes about this application..."
                    rows={4}
                    {...register('notes')}
                  />
                </div>
              </CardContent>
            </Card>
          </TabsContent>

          {/* Job Details Tab */}
          <TabsContent value="details">
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <FileText className="h-5 w-5" />
                  Job Details
                </CardTitle>
                <CardDescription>
                  Additional information about the position
                </CardDescription>
              </CardHeader>
              <CardContent className="space-y-6">
                <div className="grid gap-4 sm:grid-cols-2">
                  <div className="space-y-2">
                    <Label>Job Type</Label>
                    <Select
                      onValueChange={(value) => setValue('job_type', value as JobType)}
                    >
                      <SelectTrigger>
                        <SelectValue placeholder="Select job type" />
                      </SelectTrigger>
                      <SelectContent>
                        {JOB_TYPES.map((type) => (
                          <SelectItem key={type.value} value={type.value}>
                            {type.label}
                          </SelectItem>
                        ))}
                      </SelectContent>
                    </Select>
                  </div>

                  <div className="space-y-2">
                    <Label>Work Location</Label>
                    <Select
                      onValueChange={(value) => setValue('work_location', value as WorkLocation)}
                    >
                      <SelectTrigger>
                        <SelectValue placeholder="Select work location" />
                      </SelectTrigger>
                      <SelectContent>
                        {WORK_LOCATIONS.map((loc) => (
                          <SelectItem key={loc.value} value={loc.value}>
                            {loc.label}
                          </SelectItem>
                        ))}
                      </SelectContent>
                    </Select>
                  </div>
                </div>

                <div className="space-y-2">
                  <Label htmlFor="location">Location</Label>
                  <div className="relative">
                    <MapPin className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
                    <Input
                      id="location"
                      placeholder="e.g., San Francisco, CA"
                      className="pl-10"
                      {...register('location')}
                    />
                  </div>
                </div>

                <div className="grid gap-4 sm:grid-cols-2">
                  <div className="space-y-2">
                    <Label htmlFor="salary_min">Salary Min</Label>
                    <div className="relative">
                      <DollarSign className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
                      <Input
                        id="salary_min"
                        type="number"
                        placeholder="50000"
                        className="pl-10"
                        {...register('salary_min', { valueAsNumber: true })}
                      />
                    </div>
                  </div>

                  <div className="space-y-2">
                    <Label htmlFor="salary_max">Salary Max</Label>
                    <div className="relative">
                      <DollarSign className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
                      <Input
                        id="salary_max"
                        type="number"
                        placeholder="80000"
                        className="pl-10"
                        {...register('salary_max', { valueAsNumber: true })}
                      />
                    </div>
                  </div>
                </div>

                <div className="space-y-2">
                  <Label>Application Deadline</Label>
                  <Popover>
                    <PopoverTrigger asChild>
                      <Button
                        variant="outline"
                        className={`w-full justify-start text-left font-normal ${
                          !deadline && 'text-muted-foreground'
                        }`}
                      >
                        <CalendarIcon className="mr-2 h-4 w-4" />
                        {deadline ? format(deadline, 'PPP') : 'Select deadline'}
                      </Button>
                    </PopoverTrigger>
                    <PopoverContent className="w-auto p-0" align="start">
                      <Calendar
                        mode="single"
                        selected={deadline || undefined}
                        onSelect={(date: Date | undefined) => setValue('deadline', date || null)}
                        initialFocus
                      />
                    </PopoverContent>
                  </Popover>
                </div>

                <div className="space-y-2">
                  <Label htmlFor="job_description">Job Description</Label>
                  <Textarea
                    id="job_description"
                    placeholder="Paste the job description here..."
                    rows={8}
                    {...register('job_description')}
                  />
                  {isPro && (
                    <p className="text-xs text-muted-foreground flex items-center gap-1">
                      <Sparkles className="h-3 w-3" />
                      Pro tip: Paste the job description to get AI-powered resume matching
                    </p>
                  )}
                </div>

                <div className="space-y-2">
                  <Label htmlFor="cover_letter">Cover Letter</Label>
                  <Textarea
                    id="cover_letter"
                    placeholder="Enter your cover letter..."
                    rows={6}
                    {...register('cover_letter')}
                  />
                  {isPro && (
                    <Button type="button" variant="outline" size="sm" className="mt-2">
                      <Sparkles className="mr-2 h-4 w-4" />
                      Generate with AI
                    </Button>
                  )}
                </div>
              </CardContent>
            </Card>
          </TabsContent>

          {/* Company Tab */}
          <TabsContent value="company">
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <Building2 className="h-5 w-5" />
                  Company Information
                </CardTitle>
                <CardDescription>
                  Details about the company
                </CardDescription>
              </CardHeader>
              <CardContent className="space-y-6">
                <div className="space-y-2">
                  <Label htmlFor="company_website">Company Website</Label>
                  <div className="relative">
                    <LinkIcon className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
                    <Input
                      id="company_website"
                      placeholder="https://company.com"
                      className="pl-10"
                      {...register('company_website')}
                    />
                  </div>
                </div>

                <div className="grid gap-4 sm:grid-cols-2">
                  <div className="space-y-2">
                    <Label htmlFor="company_size">Company Size</Label>
                    <Select
                      onValueChange={(value) => setValue('company_size', value)}
                    >
                      <SelectTrigger>
                        <SelectValue placeholder="Select size" />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="1-10">1-10 employees</SelectItem>
                        <SelectItem value="11-50">11-50 employees</SelectItem>
                        <SelectItem value="51-200">51-200 employees</SelectItem>
                        <SelectItem value="201-500">201-500 employees</SelectItem>
                        <SelectItem value="501-1000">501-1000 employees</SelectItem>
                        <SelectItem value="1001-5000">1001-5000 employees</SelectItem>
                        <SelectItem value="5001+">5001+ employees</SelectItem>
                      </SelectContent>
                    </Select>
                  </div>

                  <div className="space-y-2">
                    <Label htmlFor="company_industry">Industry</Label>
                    <Input
                      id="company_industry"
                      placeholder="e.g., Technology"
                      {...register('company_industry')}
                    />
                  </div>
                </div>
              </CardContent>
            </Card>
          </TabsContent>

          {/* Contact Tab */}
          <TabsContent value="contact">
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <User className="h-5 w-5" />
                  Contact Information
                </CardTitle>
                <CardDescription>
                  Recruiter or hiring manager details
                </CardDescription>
              </CardHeader>
              <CardContent className="space-y-6">
                <div className="space-y-2">
                  <Label htmlFor="contact_name">Contact Name</Label>
                  <div className="relative">
                    <User className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
                    <Input
                      id="contact_name"
                      placeholder="John Smith"
                      className="pl-10"
                      {...register('contact_name')}
                    />
                  </div>
                </div>

                <div className="space-y-2">
                  <Label htmlFor="contact_email">Contact Email</Label>
                  <div className="relative">
                    <Mail className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
                    <Input
                      id="contact_email"
                      type="email"
                      placeholder="recruiter@company.com"
                      className="pl-10"
                      {...register('contact_email')}
                    />
                  </div>
                </div>

                <div className="space-y-2">
                  <Label htmlFor="contact_phone">Contact Phone</Label>
                  <div className="relative">
                    <Phone className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
                    <Input
                      id="contact_phone"
                      placeholder="+1 (555) 123-4567"
                      className="pl-10"
                      {...register('contact_phone')}
                    />
                  </div>
                </div>

                <div className="space-y-2">
                  <Label htmlFor="contact_linkedin">Contact LinkedIn</Label>
                  <div className="relative">
                    <Linkedin className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
                    <Input
                      id="contact_linkedin"
                      placeholder="https://linkedin.com/in/..."
                      className="pl-10"
                      {...register('contact_linkedin')}
                    />
                  </div>
                </div>
              </CardContent>
            </Card>
          </TabsContent>
        </Tabs>

        {/* Submit Button */}
        <div className="flex justify-end gap-4 mt-6">
          <Button type="button" variant="outline" asChild>
            <Link href="/dashboard/applications">Cancel</Link>
          </Button>
          <Button type="submit" disabled={createApplication.isPending}>
            {createApplication.isPending ? (
              <>
                <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                Creating...
              </>
            ) : (
              'Create Application'
            )}
          </Button>
        </div>
      </form>
    </div>
  );
}
