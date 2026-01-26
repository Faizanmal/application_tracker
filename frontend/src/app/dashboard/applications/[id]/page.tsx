'use client';

import { use, useState } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { format, parseISO, formatDistanceToNow } from 'date-fns';
import {
  ArrowLeft,
  Building2,
  MapPin,
  Calendar,
  Link as LinkIcon,
  Mail,
  Phone,
  Linkedin,
  Edit,
  Trash2,
  Star,
  MoreHorizontal,
  Clock,
  Briefcase,
  Users,
  FileText,
  MessageSquare,
  Target,
  Loader2,
  Plus,
  ExternalLink,
  Sparkles,
} from 'lucide-react';

import { Button } from '@/components/ui/button';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { Skeleton } from '@/components/ui/skeleton';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { Textarea } from '@/components/ui/textarea';
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
} from '@/components/ui/select';
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
} from '@/components/ui/alert-dialog';
import { 
  useApplication,
  useUpdateApplication,
  useDeleteApplication,
  useInterviewsByApplication,
  useRemindersByApplication,
  useGenerateFollowUpEmail,
  useMatchResume,
} from '@/hooks/use-queries';
import { useIsPro } from '@/lib/auth';
import type { ApplicationStatus, JobType, WorkMode } from '@/types';
import { toast } from 'sonner';

const STATUS_CONFIG: Record<ApplicationStatus, { label: string; color: string }> = {
  wishlist: { label: 'Saved', color: 'bg-gray-100 text-gray-700' },
  applied: { label: 'Applied', color: 'bg-blue-100 text-blue-700' },
  screening: { label: 'Screening', color: 'bg-purple-100 text-purple-700' },
  interviewing: { label: 'Interviewing', color: 'bg-indigo-100 text-indigo-700' },
  offer: { label: 'Offer', color: 'bg-green-100 text-green-700' },
  rejected: { label: 'Rejected', color: 'bg-red-100 text-red-700' },
  withdrawn: { label: 'Withdrawn', color: 'bg-yellow-100 text-yellow-700' },
  accepted: { label: 'Accepted', color: 'bg-emerald-100 text-emerald-700' },
  ghosted: { label: 'Ghosted', color: 'bg-gray-100 text-gray-700' },
};

const JOB_TYPE_LABELS: Record<JobType, string> = {
  full_time: 'Full Time',
  part_time: 'Part Time',
  contract: 'Contract',
  internship: 'Internship',
  freelance: 'Freelance',
  remote: 'Remote',
};

const WORK_MODE_LABELS: Record<WorkMode, string> = {
  remote: 'Remote',
  onsite: 'On-site',
  hybrid: 'Hybrid',
};

function formatSalary(min?: number, max?: number, currency: string = 'USD'): string {
  if (!min && !max) return 'Not specified';
  const formatter = new Intl.NumberFormat('en-US', { style: 'currency', currency, maximumFractionDigits: 0 });
  if (min && max) {
    return `${formatter.format(min)} - ${formatter.format(max)}`;
  }
  if (min) return `${formatter.format(min)}+`;
  if (max) return `Up to ${formatter.format(max)}`;
  return 'Not specified';
}

export default function ApplicationDetailPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = use(params);
  const router = useRouter();
  const isPro = useIsPro();
  const [activeTab, setActiveTab] = useState('overview');
  const [deleteDialogOpen, setDeleteDialogOpen] = useState(false);
  const [notes, setNotes] = useState('');

  const { data: application, isLoading, error } = useApplication(parseInt(id));
  const { data: interviews } = useInterviewsByApplication(id);
  const { data: reminders } = useRemindersByApplication(id);
  const updateApplication = useUpdateApplication();
  const deleteApplication = useDeleteApplication();
  const generateFollowUp = useGenerateFollowUpEmail();
  const matchResume = useMatchResume();

  const handleStatusChange = (status: ApplicationStatus) => {
    updateApplication.mutate({ id: parseInt(id), data: { status } }, {
      onSuccess: () => toast.success('Status updated'),
    });
  };

  const handleToggleFavorite = () => {
    if (!application) return;
    updateApplication.mutate({ 
      id: parseInt(id), 
      data: { is_favorite: !application.is_favorite } 
    });
  };

  const handleDelete = () => {
    deleteApplication.mutate(id, {
      onSuccess: () => {
        toast.success('Application deleted');
        router.push('/dashboard/applications');
      },
    });
  };

  const handleGenerateFollowUp = () => {
    if (!application) return;
    generateFollowUp.mutate({ applicationId: application.id }, {
      onSuccess: (_data) => {
        toast.success('Follow-up email generated');
        // Could open a modal with the email content
      },
    });
  };

  const handleMatchResume = () => {
    if (!application) return;
    matchResume.mutate(application.id, {
      onSuccess: (data) => {
        toast.success(`Resume match: ${data.score}%`);
      },
    });
  };

  if (isLoading) {
    return (
      <div className="p-6 space-y-6">
        <div className="flex items-center gap-4">
          <Skeleton className="h-10 w-10" />
          <Skeleton className="h-8 w-64" />
        </div>
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          <div className="lg:col-span-2 space-y-6">
            <Skeleton className="h-64 w-full" />
            <Skeleton className="h-48 w-full" />
          </div>
          <Skeleton className="h-96 w-full" />
        </div>
      </div>
    );
  }

  if (error || !application) {
    return (
      <div className="p-6">
        <Card>
          <CardContent className="py-12 text-center">
            <h2 className="text-xl font-semibold mb-2">Application not found</h2>
            <p className="text-muted-foreground mb-4">
              The application you&apos;re looking for doesn&apos;t exist or has been deleted.
            </p>
            <Button asChild>
              <Link href="/dashboard/applications">
                <ArrowLeft className="mr-2 h-4 w-4" />
                Back to Applications
              </Link>
            </Button>
          </CardContent>
        </Card>
      </div>
    );
  }

  return (
    <div className="p-6 space-y-6">
      {/* Header */}
      <div className="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
        <div className="flex items-center gap-4">
          <Button variant="ghost" size="icon" asChild>
            <Link href="/dashboard/applications">
              <ArrowLeft className="h-5 w-5" />
            </Link>
          </Button>
          <div>
            <div className="flex items-center gap-3">
              <h1 className="text-2xl font-bold">{application.job_title}</h1>
              <button onClick={handleToggleFavorite}>
                <Star className={`h-5 w-5 ${application.is_favorite ? 'fill-yellow-400 text-yellow-400' : 'text-muted-foreground'}`} />
              </button>
            </div>
            <div className="flex items-center gap-2 text-muted-foreground">
              <Building2 className="h-4 w-4" />
              <span className="font-medium">{application.company_name}</span>
              {application.location && (
                <>
                  <span>•</span>
                  <MapPin className="h-4 w-4" />
                  <span>{application.location}</span>
                </>
              )}
            </div>
          </div>
        </div>

        <div className="flex items-center gap-3">
          <Select value={application.status} onValueChange={handleStatusChange}>
            <SelectTrigger className="w-[150px]">
              <Badge className={STATUS_CONFIG[application.status].color}>
                {STATUS_CONFIG[application.status].label}
              </Badge>
            </SelectTrigger>
            <SelectContent>
              {Object.entries(STATUS_CONFIG).map(([value, config]) => (
                <SelectItem key={value} value={value}>
                  {config.label}
                </SelectItem>
              ))}
            </SelectContent>
          </Select>

          <Button variant="outline" asChild>
            <Link href={`/dashboard/applications/${id}/edit`}>
              <Edit className="mr-2 h-4 w-4" />
              Edit
            </Link>
          </Button>

          <DropdownMenu>
            <DropdownMenuTrigger asChild>
              <Button variant="ghost" size="icon">
                <MoreHorizontal className="h-5 w-5" />
              </Button>
            </DropdownMenuTrigger>
            <DropdownMenuContent align="end">
              <DropdownMenuItem asChild>
                <Link href={`/dashboard/interviews/new?application=${id}`}>
                  <Calendar className="mr-2 h-4 w-4" />
                  Schedule Interview
                </Link>
              </DropdownMenuItem>
              <DropdownMenuItem asChild>
                <Link href={`/dashboard/reminders/new?application=${id}`}>
                  <Clock className="mr-2 h-4 w-4" />
                  Set Reminder
                </Link>
              </DropdownMenuItem>
              <DropdownMenuSeparator />
              <DropdownMenuItem 
                className="text-red-600"
                onClick={() => setDeleteDialogOpen(true)}
              >
                <Trash2 className="mr-2 h-4 w-4" />
                Delete
              </DropdownMenuItem>
            </DropdownMenuContent>
          </DropdownMenu>
        </div>
      </div>

      {/* Main Content */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Left Column - Details */}
        <div className="lg:col-span-2 space-y-6">
          <Tabs value={activeTab} onValueChange={setActiveTab}>
            <TabsList>
              <TabsTrigger value="overview">Overview</TabsTrigger>
              <TabsTrigger value="interviews">
                Interviews
                {interviews && interviews.results.length > 0 && (
                  <Badge variant="secondary" className="ml-2">
                    {interviews.results.length}
                  </Badge>
                )}
              </TabsTrigger>
              <TabsTrigger value="notes">Notes</TabsTrigger>
              <TabsTrigger value="activity">Activity</TabsTrigger>
            </TabsList>

            {/* Overview Tab */}
            <TabsContent value="overview" className="mt-6 space-y-6">
              {/* Quick Info */}
              <Card>
                <CardContent className="grid grid-cols-2 md:grid-cols-4 gap-4 p-6">
                  <div>
                    <p className="text-sm text-muted-foreground">Job Type</p>
                    <p className="font-medium">
                      {application.job_type ? JOB_TYPE_LABELS[application.job_type] : 'Not specified'}
                    </p>
                  </div>
                  <div>
                    <p className="text-sm text-muted-foreground">Work Mode</p>
                    <p className="font-medium">
                      {application.work_mode ? WORK_MODE_LABELS[application.work_mode] : 'Not specified'}
                    </p>
                  </div>
                  <div>
                    <p className="text-sm text-muted-foreground">Salary Range</p>
                    <p className="font-medium">
                      {formatSalary(application.salary_min ?? undefined, application.salary_max ?? undefined, application.salary_currency)}
                    </p>
                  </div>
                  <div>
                    <p className="text-sm text-muted-foreground">Applied On</p>
                    <p className="font-medium">
                      {application.applied_date
                        ? format(parseISO(application.applied_date), 'MMM d, yyyy')
                        : 'Not applied yet'}
                    </p>
                  </div>
                </CardContent>
              </Card>

              {/* Job Description */}
              {application.job_description && (
                <Card>
                  <CardHeader>
                    <CardTitle>Job Description</CardTitle>
                  </CardHeader>
                  <CardContent>
                    <div className="prose prose-sm max-w-none whitespace-pre-wrap">
                      {application.job_description}
                    </div>
                  </CardContent>
                </Card>
              )}

              {/* Cover Letter */}
              {application.cover_letter && (
                <Card>
                  <CardHeader>
                    <CardTitle>Cover Letter</CardTitle>
                  </CardHeader>
                  <CardContent>
                    <div className="prose prose-sm max-w-none whitespace-pre-wrap">
                      {application.cover_letter}
                    </div>
                  </CardContent>
                </Card>
              )}

              {/* Tags */}
              {application.tags && application.tags.length > 0 && (
                <Card>
                  <CardHeader>
                    <CardTitle>Tags</CardTitle>
                  </CardHeader>
                  <CardContent>
                    <div className="flex flex-wrap gap-2">
                      {application.tags.map((tag) => (
                        <Badge key={tag.id} variant="secondary" style={{ backgroundColor: tag.color + '20', color: tag.color }}>
                          {tag.name}
                        </Badge>
                      ))}
                    </div>
                  </CardContent>
                </Card>
              )}
            </TabsContent>

            {/* Interviews Tab */}
            <TabsContent value="interviews" className="mt-6">
              <Card>
                <CardHeader>
                  <div className="flex items-center justify-between">
                    <CardTitle>Interviews</CardTitle>
                    <Button size="sm" asChild>
                      <Link href={`/dashboard/interviews/new?application=${id}`}>
                        <Plus className="mr-2 h-4 w-4" />
                        Schedule Interview
                      </Link>
                    </Button>
                  </div>
                </CardHeader>
                <CardContent>
                  {interviews && interviews.results.length > 0 ? (
                    <div className="space-y-4">
                      {interviews.results.map((interview) => (
                        <div key={interview.id} className="flex items-center justify-between p-4 rounded-lg border">
                          <div>
                            <p className="font-medium">{interview.interview_type} Interview</p>
                            <p className="text-sm text-muted-foreground">
                              {format(parseISO(interview.scheduled_at), 'MMM d, yyyy h:mm a')}
                            </p>
                          </div>
                          <Button variant="outline" size="sm" asChild>
                            <Link href={`/dashboard/interviews/${interview.id}`}>
                              View
                            </Link>
                          </Button>
                        </div>
                      ))}
                    </div>
                  ) : (
                    <div className="py-8 text-center">
                      <Calendar className="h-12 w-12 mx-auto mb-4 text-muted-foreground opacity-50" />
                      <p className="text-muted-foreground">No interviews scheduled yet</p>
                    </div>
                  )}
                </CardContent>
              </Card>
            </TabsContent>

            {/* Notes Tab */}
            <TabsContent value="notes" className="mt-6">
              <Card>
                <CardHeader>
                  <CardTitle>Notes</CardTitle>
                </CardHeader>
                <CardContent>
                  <Textarea
                    value={application.notes || notes}
                    onChange={(e) => setNotes(e.target.value)}
                    placeholder="Add notes about this application..."
                    rows={10}
                  />
                  <Button className="mt-4" onClick={() => {
                    updateApplication.mutate({ id: parseInt(id), data: { notes } });
                    toast.success('Notes saved');
                  }}>
                    Save Notes
                  </Button>
                </CardContent>
              </Card>
            </TabsContent>

            {/* Activity Tab */}
            <TabsContent value="activity" className="mt-6">
              <Card>
                <CardHeader>
                  <CardTitle>Activity Timeline</CardTitle>
                </CardHeader>
                <CardContent>
                  <div className="space-y-4">
                    {/* Would display activity history */}
                    <div className="flex items-start gap-4">
                      <div className="p-2 rounded-full bg-blue-100">
                        <Briefcase className="h-4 w-4 text-blue-600" />
                      </div>
                      <div>
                        <p className="font-medium">Application created</p>
                        <p className="text-sm text-muted-foreground">
                          {formatDistanceToNow(parseISO(application.created_at), { addSuffix: true })}
                        </p>
                      </div>
                    </div>
                  </div>
                </CardContent>
              </Card>
            </TabsContent>
          </Tabs>
        </div>

        {/* Right Column - Sidebar */}
        <div className="space-y-6">
          {/* AI Tools */}
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <Sparkles className="h-5 w-5 text-primary" />
                AI Tools
              </CardTitle>
            </CardHeader>
            <CardContent className="space-y-3">
              <Button 
                className="w-full justify-start" 
                variant="outline"
                onClick={handleGenerateFollowUp}
                disabled={!isPro || generateFollowUp.isPending}
              >
                {generateFollowUp.isPending ? (
                  <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                ) : (
                  <Mail className="mr-2 h-4 w-4" />
                )}
                Generate Follow-up Email
                {!isPro && <Badge variant="secondary" className="ml-auto">Pro</Badge>}
              </Button>
              <Button 
                className="w-full justify-start" 
                variant="outline"
                onClick={handleMatchResume}
                disabled={!isPro || matchResume.isPending}
              >
                {matchResume.isPending ? (
                  <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                ) : (
                  <Target className="mr-2 h-4 w-4" />
                )}
                Match Resume
                {!isPro && <Badge variant="secondary" className="ml-auto">Pro</Badge>}
              </Button>
              <Button 
                className="w-full justify-start" 
                variant="outline"
                disabled={!isPro}
                asChild
              >
                <Link href={`/dashboard/applications/${id}/interview-prep`}>
                  <MessageSquare className="mr-2 h-4 w-4" />
                  Interview Questions
                  {!isPro && <Badge variant="secondary" className="ml-auto">Pro</Badge>}
                </Link>
              </Button>
            </CardContent>
          </Card>

          {/* Contact Info */}
          {(application.contact_name || application.contact_email) && (
            <Card>
              <CardHeader>
                <CardTitle>Contact</CardTitle>
              </CardHeader>
              <CardContent className="space-y-3">
                {application.contact_name && (
                  <div className="flex items-center gap-3">
                    <Users className="h-4 w-4 text-muted-foreground" />
                    <span>{application.contact_name}</span>
                  </div>
                )}
                {application.contact_email && (
                  <div className="flex items-center gap-3">
                    <Mail className="h-4 w-4 text-muted-foreground" />
                    <a href={`mailto:${application.contact_email}`} className="text-primary hover:underline">
                      {application.contact_email}
                    </a>
                  </div>
                )}
                {application.contact_phone && (
                  <div className="flex items-center gap-3">
                    <Phone className="h-4 w-4 text-muted-foreground" />
                    <a href={`tel:${application.contact_phone}`} className="text-primary hover:underline">
                      {application.contact_phone}
                    </a>
                  </div>
                )}
                {application.contact_linkedin && (
                  <div className="flex items-center gap-3">
                    <Linkedin className="h-4 w-4 text-muted-foreground" />
                    <a href={application.contact_linkedin} target="_blank" rel="noopener noreferrer" className="text-primary hover:underline">
                      LinkedIn Profile
                    </a>
                  </div>
                )}
              </CardContent>
            </Card>
          )}

          {/* Company Info */}
          <Card>
            <CardHeader>
              <CardTitle>Company</CardTitle>
            </CardHeader>
            <CardContent className="space-y-3">
              {application.company_website && (
                <div className="flex items-center gap-3">
                  <LinkIcon className="h-4 w-4 text-muted-foreground" />
                  <a href={application.company_website} target="_blank" rel="noopener noreferrer" className="text-primary hover:underline flex items-center gap-1">
                    Website
                    <ExternalLink className="h-3 w-3" />
                  </a>
                </div>
              )}
              {application.company_size && (
                <div className="flex items-center gap-3">
                  <Users className="h-4 w-4 text-muted-foreground" />
                  <span>{application.company_size}</span>
                </div>
              )}
              {application.company_industry && (
                <div className="flex items-center gap-3">
                  <Building2 className="h-4 w-4 text-muted-foreground" />
                  <span>{application.company_industry}</span>
                </div>
              )}
              {application.job_url && (
                <div className="flex items-center gap-3">
                  <Briefcase className="h-4 w-4 text-muted-foreground" />
                  <a href={application.job_url} target="_blank" rel="noopener noreferrer" className="text-primary hover:underline flex items-center gap-1">
                    Job Posting
                    <ExternalLink className="h-3 w-3" />
                  </a>
                </div>
              )}
            </CardContent>
          </Card>

          {/* Resume Used */}
          {application.resume && (
            <Card>
              <CardHeader>
                <CardTitle>Resume Used</CardTitle>
              </CardHeader>
              <CardContent>
                <div className="flex items-center gap-3">
                  <FileText className="h-5 w-5 text-muted-foreground" />
                  <div>
                    <p className="font-medium">{application.resume_name}</p>
                    <a 
                      href={`/dashboard/resumes/${application.resume}`}
                      className="text-sm text-primary hover:underline"
                    >
                      View Resume
                    </a>
                  </div>
                </div>
              </CardContent>
            </Card>
          )}

          {/* Upcoming Reminders */}
          {reminders && reminders.results.length > 0 && (
            <Card>
              <CardHeader>
                <CardTitle>Reminders</CardTitle>
              </CardHeader>
              <CardContent className="space-y-3">
                {reminders.results.slice(0, 3).map((reminder) => (
                  <div key={reminder.id} className="flex items-center gap-3 text-sm">
                    <Clock className="h-4 w-4 text-muted-foreground" />
                    <div>
                      <p className="font-medium">{reminder.title}</p>
                      <p className="text-muted-foreground">
                        {format(parseISO(reminder.scheduled_at), 'MMM d, h:mm a')}
                      </p>
                    </div>
                  </div>
                ))}
              </CardContent>
            </Card>
          )}
        </div>
      </div>

      {/* Delete Confirmation */}
      <AlertDialog open={deleteDialogOpen} onOpenChange={setDeleteDialogOpen}>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Delete Application</AlertDialogTitle>
            <AlertDialogDescription>
              Are you sure you want to delete this application for {application.job_title} at {application.company_name}? 
              This will also delete all associated interviews and reminders. This action cannot be undone.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel>Cancel</AlertDialogCancel>
            <AlertDialogAction
              onClick={handleDelete}
              className="bg-red-600 hover:bg-red-700"
            >
              {deleteApplication.isPending ? (
                <Loader2 className="mr-2 h-4 w-4 animate-spin" />
              ) : null}
              Delete
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </div>
  );
}
