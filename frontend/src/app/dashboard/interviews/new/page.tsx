'use client';

import { Suspense } from 'react';
import { useRouter, useSearchParams } from 'next/navigation';
import Link from 'next/link';
import { useForm } from 'react-hook-form';
import { z } from 'zod';
import { format } from 'date-fns';
import {
  ArrowLeft,
  Calendar,
  Video,
  MapPin,
  Users,
  Loader2,
  Building2,
} from 'lucide-react';

import { Button } from '@/components/ui/button';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Input } from '@/components/ui/input';
import { Textarea } from '@/components/ui/textarea';
import { Switch } from '@/components/ui/switch';
import {
  Form,
  FormControl,
  FormDescription,
  FormField,
  FormItem,
  FormLabel,
  FormMessage,
} from '@/components/ui/form';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select';
import { useApplications, useCreateInterview } from '@/hooks/use-queries';
import { toast } from 'sonner';
import type { InterviewType } from '@/types';

const INTERVIEW_TYPES: { value: InterviewType; label: string; description: string }[] = [
  { value: 'phone', label: 'Phone Screen', description: 'Initial phone conversation' },
  { value: 'video', label: 'Video Call', description: 'Virtual video interview' },
  { value: 'onsite', label: 'On-site', description: 'In-person at company office' },
  { value: 'technical', label: 'Technical', description: 'Coding or technical assessment' },
  { value: 'behavioral', label: 'Behavioral', description: 'Behavioral/cultural fit interview' },
  { value: 'panel', label: 'Panel', description: 'Multiple interviewers' },
  { value: 'final', label: 'Final Round', description: 'Final decision interview' },
];

const _interviewSchema = z.object({
  application: z.number(),
  interview_type: z.string().min(1, 'Interview type is required'),
  scheduled_date: z.string().min(1, 'Date is required'),
  scheduled_time: z.string().min(1, 'Time is required'),
  duration_minutes: z.coerce.number().min(15).max(480),
  round_number: z.coerce.number().min(1).max(10).optional(),
  meeting_link: z.string().url().optional().or(z.literal('')),
  location: z.string().optional(),
  interviewer_names: z.string().optional(),
  notes: z.string().optional(),
  send_calendar_invite: z.boolean().default(true),
  set_reminder: z.boolean().default(true),
});

type InterviewFormData = z.infer<typeof _interviewSchema>;

function NewInterviewFormContent() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const preselectedAppId = searchParams.get('application');
  
  const { data: applications, isLoading: applicationsLoading } = useApplications({ status: 'interviewing,applied,screening' });
  const createInterview = useCreateInterview();

  const form = useForm<InterviewFormData>({
    defaultValues: {
      application: preselectedAppId ? parseInt(preselectedAppId) : undefined,
      interview_type: '',
      scheduled_date: '',
      scheduled_time: '',
      duration_minutes: 60,
      round_number: 1,
      meeting_link: '',
      location: '',
      interviewer_names: '',
      notes: '',
      send_calendar_invite: true,
      set_reminder: true,
    },
  });

  const interviewType = form.watch('interview_type');

  const onSubmit = async (data: InterviewFormData) => {
    // Combine date and time
    const scheduled_at = new Date(`${data.scheduled_date}T${data.scheduled_time}`).toISOString();

    createInterview.mutate({
      application: data.application.toString(),
      interview_type: data.interview_type as InterviewType,
      scheduled_at,
      duration_minutes: data.duration_minutes,
      round_number: data.round_number,
      meeting_link: data.meeting_link || undefined,
      location: data.location || undefined,
      interviewer_names: data.interviewer_names || undefined,
      notes: data.notes || undefined,
    }, {
      onSuccess: (interview) => {
        toast.success('Interview scheduled successfully');
        router.push(`/dashboard/interviews/${interview.id}`);
      },
      onError: (error: unknown) => {
        const err = error as { response?: { data?: { message?: string } } };
        toast.error(err.response?.data?.message || 'Failed to schedule interview');
      },
    });
  };

  return (
    <div className="p-6 max-w-3xl mx-auto">
      {/* Header */}
      <div className="flex items-center gap-4 mb-8">
        <Button variant="ghost" size="icon" asChild>
          <Link href="/dashboard/interviews">
            <ArrowLeft className="h-5 w-5" />
          </Link>
        </Button>
        <div>
          <h1 className="text-2xl font-bold">Schedule Interview</h1>
          <p className="text-muted-foreground">
            Add a new interview to your calendar
          </p>
        </div>
      </div>

      <Form {...form}>
        <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-6">
          {/* Application Selection */}
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <Building2 className="h-5 w-5" />
                Application
              </CardTitle>
            </CardHeader>
            <CardContent>
              <FormField
                control={form.control}
                name="application"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Select Application</FormLabel>
                    <Select
                      onValueChange={(value) => field.onChange(parseInt(value))}
                      value={field.value?.toString()}
                    >
                      <FormControl>
                        <SelectTrigger>
                          <SelectValue placeholder="Choose an application..." />
                        </SelectTrigger>
                      </FormControl>
                      <SelectContent>
                        {applicationsLoading ? (
                          <SelectItem value="loading" disabled>Loading...</SelectItem>
                        ) : applications?.results.map((app) => (
                          <SelectItem key={app.id} value={app.id.toString()}>
                            <div className="flex items-center gap-2">
                              <span className="font-medium">{app.company_name}</span>
                              <span className="text-muted-foreground">- {app.job_title}</span>
                            </div>
                          </SelectItem>
                        ))}
                      </SelectContent>
                    </Select>
                    <FormMessage />
                  </FormItem>
                )}
              />
            </CardContent>
          </Card>

          {/* Interview Type */}
          <Card>
            <CardHeader>
              <CardTitle>Interview Type</CardTitle>
            </CardHeader>
            <CardContent>
              <FormField
                control={form.control}
                name="interview_type"
                render={({ field }) => (
                  <FormItem>
                    <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
                      {INTERVIEW_TYPES.map((type) => (
                        <button
                          key={type.value}
                          type="button"
                          onClick={() => field.onChange(type.value)}
                          className={`p-4 rounded-lg border text-left transition-all ${
                            field.value === type.value
                              ? 'border-primary bg-primary/5 ring-2 ring-primary'
                              : 'border-muted hover:border-primary/50'
                          }`}
                        >
                          <p className="font-medium">{type.label}</p>
                          <p className="text-xs text-muted-foreground mt-1">
                            {type.description}
                          </p>
                        </button>
                      ))}
                    </div>
                    <FormMessage />
                  </FormItem>
                )}
              />
            </CardContent>
          </Card>

          {/* Date & Time */}
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <Calendar className="h-5 w-5" />
                Date & Time
              </CardTitle>
            </CardHeader>
            <CardContent className="space-y-6">
              <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                <FormField
                  control={form.control}
                  name="scheduled_date"
                  render={({ field }) => (
                    <FormItem>
                      <FormLabel>Date</FormLabel>
                      <FormControl>
                        <Input
                          type="date"
                          min={format(new Date(), 'yyyy-MM-dd')}
                          {...field}
                        />
                      </FormControl>
                      <FormMessage />
                    </FormItem>
                  )}
                />

                <FormField
                  control={form.control}
                  name="scheduled_time"
                  render={({ field }) => (
                    <FormItem>
                      <FormLabel>Time</FormLabel>
                      <FormControl>
                        <Input type="time" {...field} />
                      </FormControl>
                      <FormMessage />
                    </FormItem>
                  )}
                />

                <FormField
                  control={form.control}
                  name="duration_minutes"
                  render={({ field }) => (
                    <FormItem>
                      <FormLabel>Duration</FormLabel>
                      <Select
                        onValueChange={(value) => field.onChange(parseInt(value))}
                        value={field.value?.toString()}
                      >
                        <FormControl>
                          <SelectTrigger>
                            <SelectValue />
                          </SelectTrigger>
                        </FormControl>
                        <SelectContent>
                          <SelectItem value="15">15 minutes</SelectItem>
                          <SelectItem value="30">30 minutes</SelectItem>
                          <SelectItem value="45">45 minutes</SelectItem>
                          <SelectItem value="60">1 hour</SelectItem>
                          <SelectItem value="90">1.5 hours</SelectItem>
                          <SelectItem value="120">2 hours</SelectItem>
                          <SelectItem value="180">3 hours</SelectItem>
                          <SelectItem value="240">4 hours</SelectItem>
                        </SelectContent>
                      </Select>
                      <FormMessage />
                    </FormItem>
                  )}
                />
              </div>

              <FormField
                control={form.control}
                name="round_number"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Interview Round</FormLabel>
                    <FormControl>
                      <Input 
                        type="number" 
                        min={1} 
                        max={10} 
                        className="w-24"
                        {...field} 
                      />
                    </FormControl>
                    <FormDescription>
                      Which round of interviews is this?
                    </FormDescription>
                    <FormMessage />
                  </FormItem>
                )}
              />
            </CardContent>
          </Card>

          {/* Location / Meeting Link */}
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                {interviewType === 'video' || interviewType === 'phone' ? (
                  <Video className="h-5 w-5" />
                ) : (
                  <MapPin className="h-5 w-5" />
                )}
                Meeting Details
              </CardTitle>
            </CardHeader>
            <CardContent className="space-y-6">
              {(interviewType === 'video' || interviewType === 'phone' || !interviewType) && (
                <FormField
                  control={form.control}
                  name="meeting_link"
                  render={({ field }) => (
                    <FormItem>
                      <FormLabel>Meeting Link</FormLabel>
                      <FormControl>
                        <Input 
                          placeholder="https://zoom.us/j/123456789" 
                          {...field} 
                        />
                      </FormControl>
                      <FormDescription>
                        Zoom, Google Meet, Teams, or other video call link
                      </FormDescription>
                      <FormMessage />
                    </FormItem>
                  )}
                />
              )}

              {(interviewType === 'onsite' || !interviewType) && (
                <FormField
                  control={form.control}
                  name="location"
                  render={({ field }) => (
                    <FormItem>
                      <FormLabel>Location</FormLabel>
                      <FormControl>
                        <Input 
                          placeholder="123 Main St, San Francisco, CA 94102" 
                          {...field} 
                        />
                      </FormControl>
                      <FormMessage />
                    </FormItem>
                  )}
                />
              )}
            </CardContent>
          </Card>

          {/* Interviewers */}
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <Users className="h-5 w-5" />
                Interviewers
              </CardTitle>
            </CardHeader>
            <CardContent>
              <FormField
                control={form.control}
                name="interviewer_names"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Interviewer Names</FormLabel>
                    <FormControl>
                      <Input 
                        placeholder="John Smith, Jane Doe" 
                        {...field} 
                      />
                    </FormControl>
                    <FormDescription>
                      Separate multiple names with commas
                    </FormDescription>
                    <FormMessage />
                  </FormItem>
                )}
              />
            </CardContent>
          </Card>

          {/* Notes */}
          <Card>
            <CardHeader>
              <CardTitle>Notes</CardTitle>
            </CardHeader>
            <CardContent>
              <FormField
                control={form.control}
                name="notes"
                render={({ field }) => (
                  <FormItem>
                    <FormControl>
                      <Textarea
                        placeholder="Add any notes about this interview..."
                        rows={4}
                        {...field}
                      />
                    </FormControl>
                    <FormMessage />
                  </FormItem>
                )}
              />
            </CardContent>
          </Card>

          {/* Options */}
          <Card>
            <CardHeader>
              <CardTitle>Options</CardTitle>
            </CardHeader>
            <CardContent className="space-y-6">
              <FormField
                control={form.control}
                name="send_calendar_invite"
                render={({ field }) => (
                  <FormItem className="flex items-center justify-between">
                    <div className="space-y-0.5">
                      <FormLabel>Add to Calendar</FormLabel>
                      <FormDescription>
                        Create a calendar event for this interview
                      </FormDescription>
                    </div>
                    <FormControl>
                      <Switch
                        checked={field.value}
                        onCheckedChange={field.onChange}
                      />
                    </FormControl>
                  </FormItem>
                )}
              />

              <FormField
                control={form.control}
                name="set_reminder"
                render={({ field }) => (
                  <FormItem className="flex items-center justify-between">
                    <div className="space-y-0.5">
                      <FormLabel>Set Reminder</FormLabel>
                      <FormDescription>
                        Get notified 1 day and 1 hour before the interview
                      </FormDescription>
                    </div>
                    <FormControl>
                      <Switch
                        checked={field.value}
                        onCheckedChange={field.onChange}
                      />
                    </FormControl>
                  </FormItem>
                )}
              />
            </CardContent>
          </Card>

          {/* Submit */}
          <div className="flex items-center justify-end gap-4">
            <Button type="button" variant="outline" asChild>
              <Link href="/dashboard/interviews">Cancel</Link>
            </Button>
            <Button type="submit" disabled={createInterview.isPending}>
              {createInterview.isPending ? (
                <>
                  <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                  Scheduling...
                </>
              ) : (
                <>
                  <Calendar className="mr-2 h-4 w-4" />
                  Schedule Interview
                </>
              )}
            </Button>
          </div>
        </form>
      </Form>
    </div>
  );
}

export default function NewInterviewPage() {
  return (
    <Suspense fallback={
      <div className="p-6 max-w-3xl mx-auto">
        <div className="flex items-center gap-4 mb-8">
          <Button variant="ghost" size="icon" asChild>
            <Link href="/dashboard/interviews">
              <ArrowLeft className="h-5 w-5" />
            </Link>
          </Button>
          <div>
            <h1 className="text-2xl font-bold">Schedule Interview</h1>
            <p className="text-muted-foreground">Loading...</p>
          </div>
        </div>
      </div>
    }>
      <NewInterviewFormContent />
    </Suspense>
  );
}
