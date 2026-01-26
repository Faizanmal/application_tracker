'use client';

import { use, useState } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { format, parseISO, differenceInMinutes, isPast } from 'date-fns';
import {
  ArrowLeft,
  Building2,
  Calendar,
  Clock,
  Video,
  MapPin,
  Phone,
  Users,
  Edit,
  Trash2,
  MoreHorizontal,
  CheckCircle,
  Play,
  Loader2,
  Sparkles,
  FileText,
  MessageSquare,
  Star,
  ChevronDown,
  ChevronUp,
  ExternalLink,
  Copy,
} from 'lucide-react';

import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { Skeleton } from '@/components/ui/skeleton';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { Textarea } from '@/components/ui/textarea';
import { Label } from '@/components/ui/label';
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu';
import {
  Accordion,
  AccordionContent,
  AccordionItem,
  AccordionTrigger,
} from '@/components/ui/accordion';
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
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from '@/components/ui/dialog';
import { 
  useInterview,
  useUpdateInterview,
  useDeleteInterview,
  useCompleteInterview,
  useInterviewQuestions,
  useGenerateInterviewQuestions,
  useStarResponses,
  useCreateStarResponse,
} from '@/hooks/use-queries';
import { useIsPro } from '@/lib/auth';
import type { InterviewType, InterviewStatus, InterviewQuestion, STARResponse } from '@/types';
import { toast } from 'sonner';

const INTERVIEW_TYPE_CONFIG: Record<InterviewType, { label: string; icon: React.ElementType }> = {
  phone: { label: 'Phone Screen', icon: Phone },
  video: { label: 'Video Call', icon: Video },
  onsite: { label: 'On-site', icon: Building2 },
  technical: { label: 'Technical', icon: FileText },
  behavioral: { label: 'Behavioral', icon: MessageSquare },
  panel: { label: 'Panel', icon: Users },
  final: { label: 'Final Round', icon: Star },
};

const STATUS_CONFIG: Record<InterviewStatus, { label: string; color: string }> = {
  scheduled: { label: 'Scheduled', color: 'bg-blue-100 text-blue-700' },
  completed: { label: 'Completed', color: 'bg-green-100 text-green-700' },
  cancelled: { label: 'Cancelled', color: 'bg-red-100 text-red-700' },
  rescheduled: { label: 'Rescheduled', color: 'bg-yellow-100 text-yellow-700' },
  no_show: { label: 'No Show', color: 'bg-gray-100 text-gray-700' },
};

// Mock STAR questions for preparation
const COMMON_BEHAVIORAL_QUESTIONS = [
  "Tell me about a time when you had to deal with a difficult coworker.",
  "Describe a situation where you had to meet a tight deadline.",
  "Give an example of when you showed leadership.",
  "Tell me about a time when you failed and what you learned.",
  "Describe a situation where you had to handle multiple priorities.",
];

function StarResponseForm({ 
  interviewId, 
  question,
  onSave 
}: { 
  interviewId: number;
  question: string;
  onSave: () => void;
}) {
  const [formData, setFormData] = useState({
    question,
    situation: '',
    task: '',
    action: '',
    result: '',
  });
  const createStarResponse = useCreateStarResponse();

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    createStarResponse.mutate({
      questionId: 0,
      data: {
        interview: interviewId.toString(),
        ...formData,
      },
    }, {
      onSuccess: () => {
        toast.success('STAR response saved');
        onSave();
      },
    });
  };

  return (
    <form onSubmit={handleSubmit} className="space-y-4 p-4 border rounded-lg">
      <div className="space-y-2">
        <Label className="font-bold">Situation</Label>
        <Textarea
          value={formData.situation}
          onChange={(e) => setFormData(prev => ({ ...prev, situation: e.target.value }))}
          placeholder="Describe the context and background..."
          rows={3}
        />
      </div>
      <div className="space-y-2">
        <Label className="font-bold">Task</Label>
        <Textarea
          value={formData.task}
          onChange={(e) => setFormData(prev => ({ ...prev, task: e.target.value }))}
          placeholder="What was your responsibility?"
          rows={2}
        />
      </div>
      <div className="space-y-2">
        <Label className="font-bold">Action</Label>
        <Textarea
          value={formData.action}
          onChange={(e) => setFormData(prev => ({ ...prev, action: e.target.value }))}
          placeholder="What specific steps did you take?"
          rows={3}
        />
      </div>
      <div className="space-y-2">
        <Label className="font-bold">Result</Label>
        <Textarea
          value={formData.result}
          onChange={(e) => setFormData(prev => ({ ...prev, result: e.target.value }))}
          placeholder="What was the outcome? Include metrics if possible."
          rows={2}
        />
      </div>
      <Button type="submit" disabled={createStarResponse.isPending}>
        {createStarResponse.isPending ? (
          <>
            <Loader2 className="mr-2 h-4 w-4 animate-spin" />
            Saving...
          </>
        ) : (
          'Save Response'
        )}
      </Button>
    </form>
  );
}

export default function InterviewDetailPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = use(params);
  const router = useRouter();
  const isPro = useIsPro();
  const [activeTab, setActiveTab] = useState('details');
  const [deleteDialogOpen, setDeleteDialogOpen] = useState(false);
  const [completeDialogOpen, setCompleteDialogOpen] = useState(false);
  const [feedback, setFeedback] = useState('');
  const [rating, setRating] = useState(3);
  const [preparingQuestion, setPreparingQuestion] = useState<string | null>(null);

  const { data: interview, isLoading, error } = useInterview(parseInt(id));
  const { data: questions } = useInterviewQuestions(parseInt(id));
  const { data: starResponses } = useStarResponses(parseInt(id));
  const updateInterview = useUpdateInterview();
  const deleteInterview = useDeleteInterview();
  const completeInterview = useCompleteInterview();
  const generateQuestions = useGenerateInterviewQuestions();

  const handleDelete = () => {
    deleteInterview.mutate(parseInt(id), {
      onSuccess: () => {
        toast.success('Interview deleted');
        router.push('/dashboard/interviews');
      },
    });
  };

  const handleComplete = () => {
    completeInterview.mutate({ 
      id: parseInt(id), 
      data: { feedback, rating }
    }, {
      onSuccess: () => {
        toast.success('Interview marked as completed');
        setCompleteDialogOpen(false);
      },
    });
  };

  const handleGenerateQuestions = () => {
    if (!interview) return;
    generateQuestions.mutate({ applicationId: interview.application }, {
      onSuccess: () => {
        toast.success('Questions generated');
      },
    });
  };

  const handleCopyMeetingLink = () => {
    if (interview?.meeting_link) {
      navigator.clipboard.writeText(interview.meeting_link);
      toast.success('Meeting link copied');
    }
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

  if (error || !interview) {
    return (
      <div className="p-6">
        <Card>
          <CardContent className="py-12 text-center">
            <h2 className="text-xl font-semibold mb-2">Interview not found</h2>
            <p className="text-muted-foreground mb-4">
              The interview you&apos;re looking for doesn&apos;t exist or has been deleted.
            </p>
            <Button asChild>
              <Link href="/dashboard/interviews">
                <ArrowLeft className="mr-2 h-4 w-4" />
                Back to Interviews
              </Link>
            </Button>
          </CardContent>
        </Card>
      </div>
    );
  }

  const scheduledDate = parseISO(interview.scheduled_at);
  const isUpcoming = !isPast(scheduledDate) && interview.status === 'scheduled';
  const minutesUntil = differenceInMinutes(scheduledDate, new Date());
  const TypeIcon = INTERVIEW_TYPE_CONFIG[interview.interview_type]?.icon || Calendar;

  return (
    <div className="p-6 space-y-6">
      {/* Header */}
      <div className="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
        <div className="flex items-center gap-4">
          <Button variant="ghost" size="icon" asChild>
            <Link href="/dashboard/interviews">
              <ArrowLeft className="h-5 w-5" />
            </Link>
          </Button>
          <div>
            <div className="flex items-center gap-3">
              <h1 className="text-2xl font-bold">
                {INTERVIEW_TYPE_CONFIG[interview.interview_type]?.label || 'Interview'}
              </h1>
              <Badge className={STATUS_CONFIG[interview.status].color}>
                {STATUS_CONFIG[interview.status].label}
              </Badge>
            </div>
            <div className="flex items-center gap-2 text-muted-foreground">
              <Building2 className="h-4 w-4" />
              <Link 
                href={`/dashboard/applications/${interview.application}`}
                className="font-medium hover:underline"
              >
                {interview.application_company} - {interview.application_job_title}
              </Link>
            </div>
          </div>
        </div>

        <div className="flex items-center gap-3">
          {isUpcoming && interview.meeting_link && (
            <Button asChild>
              <a href={interview.meeting_link} target="_blank" rel="noopener noreferrer">
                <Video className="mr-2 h-4 w-4" />
                Join Meeting
              </a>
            </Button>
          )}
          
          {interview.status === 'scheduled' && (
            <Button variant="outline" onClick={() => setCompleteDialogOpen(true)}>
              <CheckCircle className="mr-2 h-4 w-4" />
              Mark Complete
            </Button>
          )}

          <DropdownMenu>
            <DropdownMenuTrigger asChild>
              <Button variant="ghost" size="icon">
                <MoreHorizontal className="h-5 w-5" />
              </Button>
            </DropdownMenuTrigger>
            <DropdownMenuContent align="end">
              <DropdownMenuItem asChild>
                <Link href={`/dashboard/interviews/${id}/edit`}>
                  <Edit className="mr-2 h-4 w-4" />
                  Edit
                </Link>
              </DropdownMenuItem>
              <DropdownMenuItem>
                <Calendar className="mr-2 h-4 w-4" />
                Reschedule
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

      {/* Countdown / Status */}
      {isUpcoming && minutesUntil > 0 && minutesUntil < 60 * 24 && (
        <Card className="border-primary bg-primary/5">
          <CardContent className="flex items-center justify-between p-4">
            <div className="flex items-center gap-4">
              <div className="p-3 rounded-full bg-primary/10">
                <Clock className="h-6 w-6 text-primary" />
              </div>
              <div>
                <p className="font-semibold text-lg">
                  {minutesUntil < 60 
                    ? `Starting in ${minutesUntil} minutes`
                    : `Starting in ${Math.floor(minutesUntil / 60)} hours`
                  }
                </p>
                <p className="text-muted-foreground">
                  {format(scheduledDate, 'EEEE, MMMM d, yyyy at h:mm a')}
                </p>
              </div>
            </div>
            {interview.meeting_link && (
              <Button asChild>
                <a href={interview.meeting_link} target="_blank" rel="noopener noreferrer">
                  <Play className="mr-2 h-4 w-4" />
                  Join Now
                </a>
              </Button>
            )}
          </CardContent>
        </Card>
      )}

      {/* Main Content */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Left Column */}
        <div className="lg:col-span-2">
          <Tabs value={activeTab} onValueChange={setActiveTab}>
            <TabsList>
              <TabsTrigger value="details">Details</TabsTrigger>
              <TabsTrigger value="preparation">
                Preparation
                <Badge variant="secondary" className="ml-2">
                  {questions?.length || 0}
                </Badge>
              </TabsTrigger>
              <TabsTrigger value="notes">Notes</TabsTrigger>
            </TabsList>

            {/* Details Tab */}
            <TabsContent value="details" className="mt-6 space-y-6">
              <Card>
                <CardContent className="grid grid-cols-2 md:grid-cols-4 gap-4 p-6">
                  <div>
                    <p className="text-sm text-muted-foreground">Type</p>
                    <div className="flex items-center gap-2 font-medium">
                      <TypeIcon className="h-4 w-4" />
                      {INTERVIEW_TYPE_CONFIG[interview.interview_type]?.label}
                    </div>
                  </div>
                  <div>
                    <p className="text-sm text-muted-foreground">Date & Time</p>
                    <p className="font-medium">
                      {format(scheduledDate, 'MMM d, yyyy h:mm a')}
                    </p>
                  </div>
                  <div>
                    <p className="text-sm text-muted-foreground">Duration</p>
                    <p className="font-medium">{interview.duration_minutes} minutes</p>
                  </div>
                  <div>
                    <p className="text-sm text-muted-foreground">Round</p>
                    <p className="font-medium">Round {interview.round_number || 1}</p>
                  </div>
                </CardContent>
              </Card>

              {/* Interviewers */}
              {interview.interviewer_names && (
                <Card>
                  <CardHeader>
                    <CardTitle className="flex items-center gap-2">
                      <Users className="h-5 w-5" />
                      Interviewers
                    </CardTitle>
                  </CardHeader>
                  <CardContent>
                    <div className="flex flex-wrap gap-2">
                      {interview.interviewer_names.split(',').map((name, i) => (
                        <Badge key={i} variant="secondary">
                          {name.trim()}
                        </Badge>
                      ))}
                    </div>
                  </CardContent>
                </Card>
              )}

              {/* Meeting Details */}
              <Card>
                <CardHeader>
                  <CardTitle>Meeting Details</CardTitle>
                </CardHeader>
                <CardContent className="space-y-4">
                  {interview.meeting_link && (
                    <div className="flex items-center justify-between p-3 rounded-lg bg-muted">
                      <div className="flex items-center gap-3">
                        <Video className="h-5 w-5 text-muted-foreground" />
                        <div>
                          <p className="font-medium">Video Call</p>
                          <a 
                            href={interview.meeting_link} 
                            target="_blank" 
                            rel="noopener noreferrer"
                            className="text-sm text-primary hover:underline flex items-center gap-1"
                          >
                            {interview.meeting_link.substring(0, 40)}...
                            <ExternalLink className="h-3 w-3" />
                          </a>
                        </div>
                      </div>
                      <Button variant="ghost" size="icon" onClick={handleCopyMeetingLink}>
                        <Copy className="h-4 w-4" />
                      </Button>
                    </div>
                  )}
                  {interview.location && (
                    <div className="flex items-center gap-3 p-3 rounded-lg bg-muted">
                      <MapPin className="h-5 w-5 text-muted-foreground" />
                      <div>
                        <p className="font-medium">Location</p>
                        <p className="text-sm text-muted-foreground">{interview.location}</p>
                      </div>
                    </div>
                  )}
                </CardContent>
              </Card>

              {/* Completed Interview - Feedback */}
              {interview.status === 'completed' && interview.feedback && (
                <Card>
                  <CardHeader>
                    <CardTitle>Interview Feedback</CardTitle>
                  </CardHeader>
                  <CardContent>
                    {interview.rating && (
                      <div className="flex items-center gap-2 mb-4">
                        <span className="text-sm text-muted-foreground">Rating:</span>
                        {[1, 2, 3, 4, 5].map((star) => (
                          <Star
                            key={star}
                            className={`h-5 w-5 ${star <= interview.rating! ? 'fill-yellow-400 text-yellow-400' : 'text-muted'}`}
                          />
                        ))}
                      </div>
                    )}
                    <p className="whitespace-pre-wrap">{interview.feedback}</p>
                  </CardContent>
                </Card>
              )}
            </TabsContent>

            {/* Preparation Tab */}
            <TabsContent value="preparation" className="mt-6 space-y-6">
              {/* AI Generate Questions */}
              <Card>
                <CardHeader>
                  <div className="flex items-center justify-between">
                    <CardTitle className="flex items-center gap-2">
                      <Sparkles className="h-5 w-5 text-primary" />
                      Interview Questions
                    </CardTitle>
                    <Button 
                      onClick={handleGenerateQuestions}
                      disabled={!isPro || generateQuestions.isPending}
                    >
                      {generateQuestions.isPending ? (
                        <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                      ) : (
                        <Sparkles className="mr-2 h-4 w-4" />
                      )}
                      Generate AI Questions
                      {!isPro && <Badge variant="secondary" className="ml-2">Pro</Badge>}
                    </Button>
                  </div>
                </CardHeader>
                <CardContent>
                  {questions && questions.length > 0 ? (
                    <Accordion type="single" collapsible className="w-full">
                      {questions.map((q: InterviewQuestion, index: number) => (
                        <AccordionItem key={q.id} value={`question-${q.id}`}>
                          <AccordionTrigger>
                            <div className="flex items-center gap-3 text-left">
                              <span className="text-muted-foreground">{index + 1}.</span>
                              {q.question}
                            </div>
                          </AccordionTrigger>
                          <AccordionContent>
                            {q.suggested_answer && (
                              <div className="p-4 bg-muted rounded-lg">
                                <p className="text-sm text-muted-foreground mb-1">Suggested approach:</p>
                                <p>{q.suggested_answer}</p>
                              </div>
                            )}
                          </AccordionContent>
                        </AccordionItem>
                      ))}
                    </Accordion>
                  ) : (
                    <div className="py-8 text-center">
                      <MessageSquare className="h-12 w-12 mx-auto mb-4 text-muted-foreground opacity-50" />
                      <p className="text-muted-foreground">No questions prepared yet</p>
                      <p className="text-sm text-muted-foreground mt-1">
                        {isPro 
                          ? 'Use AI to generate relevant questions based on the job description'
                          : 'Upgrade to Pro to generate AI-powered interview questions'}
                      </p>
                    </div>
                  )}
                </CardContent>
              </Card>

              {/* STAR Responses */}
              <Card>
                <CardHeader>
                  <CardTitle>STAR Method Preparation</CardTitle>
                  <CardDescription>
                    Prepare behavioral interview answers using the STAR method
                  </CardDescription>
                </CardHeader>
                <CardContent className="space-y-4">
                  {/* Common questions to prepare */}
                  <div className="space-y-3">
                    {COMMON_BEHAVIORAL_QUESTIONS.map((question, index) => {
                      const hasResponse = starResponses?.some((r: STARResponse) => r.question === question);
                      return (
                        <div key={index} className="border rounded-lg">
                          <button
                            onClick={() => setPreparingQuestion(preparingQuestion === question ? null : question)}
                            className="w-full p-4 flex items-center justify-between text-left hover:bg-muted/50"
                          >
                            <div className="flex items-center gap-3">
                              {hasResponse ? (
                                <CheckCircle className="h-5 w-5 text-green-600" />
                              ) : (
                                <div className="h-5 w-5 rounded-full border-2 border-muted-foreground" />
                              )}
                              <span>{question}</span>
                            </div>
                            {preparingQuestion === question ? (
                              <ChevronUp className="h-5 w-5" />
                            ) : (
                              <ChevronDown className="h-5 w-5" />
                            )}
                          </button>
                          {preparingQuestion === question && !hasResponse && (
                            <div className="border-t">
                              <StarResponseForm 
                                interviewId={parseInt(id)}
                                question={question}
                                onSave={() => setPreparingQuestion(null)}
                              />
                            </div>
                          )}
                          {preparingQuestion === question && hasResponse && (
                            <div className="border-t p-4">
                              {starResponses?.filter((r: STARResponse) => r.question === question).map((response: STARResponse) => (
                                <div key={response.id} className="space-y-3">
                                  <div>
                                    <Label className="text-muted-foreground">Situation</Label>
                                    <p className="mt-1">{response.situation}</p>
                                  </div>
                                  <div>
                                    <Label className="text-muted-foreground">Task</Label>
                                    <p className="mt-1">{response.task}</p>
                                  </div>
                                  <div>
                                    <Label className="text-muted-foreground">Action</Label>
                                    <p className="mt-1">{response.action}</p>
                                  </div>
                                  <div>
                                    <Label className="text-muted-foreground">Result</Label>
                                    <p className="mt-1">{response.result}</p>
                                  </div>
                                </div>
                              ))}
                            </div>
                          )}
                        </div>
                      );
                    })}
                  </div>
                </CardContent>
              </Card>
            </TabsContent>

            {/* Notes Tab */}
            <TabsContent value="notes" className="mt-6">
              <Card>
                <CardHeader>
                  <CardTitle>Interview Notes</CardTitle>
                </CardHeader>
                <CardContent>
                  <Textarea
                    value={interview.notes || ''}
                    placeholder="Add notes about this interview..."
                    rows={15}
                    onChange={(e) => {
                      updateInterview.mutate({ id: parseInt(id), data: { notes: e.target.value } });
                    }}
                  />
                  <p className="text-sm text-muted-foreground mt-2">
                    Notes are automatically saved
                  </p>
                </CardContent>
              </Card>
            </TabsContent>
          </Tabs>
        </div>

        {/* Right Column - Sidebar */}
        <div className="space-y-6">
          {/* Quick Prep Checklist */}
          <Card>
            <CardHeader>
              <CardTitle>Preparation Checklist</CardTitle>
            </CardHeader>
            <CardContent>
              <div className="space-y-3">
                {[
                  'Research the company',
                  'Review job description',
                  'Prepare STAR responses',
                  'Test video/audio setup',
                  'Prepare questions to ask',
                  'Have resume ready',
                ].map((item, index) => (
                  <label key={index} className="flex items-center gap-3 cursor-pointer">
                    <input type="checkbox" className="h-4 w-4 rounded" />
                    <span className="text-sm">{item}</span>
                  </label>
                ))}
              </div>
            </CardContent>
          </Card>

          {/* Company Research */}
          <Card>
            <CardHeader>
              <CardTitle>Company Research</CardTitle>
            </CardHeader>
            <CardContent className="space-y-3">
              <Button variant="outline" className="w-full justify-start" asChild>
                <a href={`https://www.linkedin.com/company/${interview.application_company?.toLowerCase().replace(/\s+/g, '-')}`} target="_blank" rel="noopener noreferrer">
                  <ExternalLink className="mr-2 h-4 w-4" />
                  LinkedIn
                </a>
              </Button>
              <Button variant="outline" className="w-full justify-start" asChild>
                <a href={`https://www.glassdoor.com/Search/results.htm?keyword=${encodeURIComponent(interview.application_company || '')}`} target="_blank" rel="noopener noreferrer">
                  <ExternalLink className="mr-2 h-4 w-4" />
                  Glassdoor Reviews
                </a>
              </Button>
              <Button variant="outline" className="w-full justify-start" asChild>
                <a href={`https://www.google.com/search?q=${encodeURIComponent(interview.application_company || '')} news`} target="_blank" rel="noopener noreferrer">
                  <ExternalLink className="mr-2 h-4 w-4" />
                  Recent News
                </a>
              </Button>
            </CardContent>
          </Card>

          {/* Application Link */}
          <Card>
            <CardHeader>
              <CardTitle>Related Application</CardTitle>
            </CardHeader>
            <CardContent>
              <Link 
                href={`/dashboard/applications/${interview.application}`}
                className="flex items-center gap-3 p-3 rounded-lg border hover:bg-muted transition-colors"
              >
                <Building2 className="h-5 w-5 text-muted-foreground" />
                <div className="flex-1 min-w-0">
                  <p className="font-medium truncate">{interview.application_job_title}</p>
                  <p className="text-sm text-muted-foreground truncate">{interview.application_company}</p>
                </div>
                <ExternalLink className="h-4 w-4 text-muted-foreground" />
              </Link>
            </CardContent>
          </Card>
        </div>
      </div>

      {/* Delete Confirmation */}
      <AlertDialog open={deleteDialogOpen} onOpenChange={setDeleteDialogOpen}>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Delete Interview</AlertDialogTitle>
            <AlertDialogDescription>
              Are you sure you want to delete this interview? This action cannot be undone.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel>Cancel</AlertDialogCancel>
            <AlertDialogAction
              onClick={handleDelete}
              className="bg-red-600 hover:bg-red-700"
            >
              Delete
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>

      {/* Complete Interview Dialog */}
      <Dialog open={completeDialogOpen} onOpenChange={setCompleteDialogOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Complete Interview</DialogTitle>
            <DialogDescription>
              How did the interview go? Add your feedback and rating.
            </DialogDescription>
          </DialogHeader>
          
          <div className="space-y-4 py-4">
            <div className="space-y-2">
              <Label>Rating</Label>
              <div className="flex items-center gap-1">
                {[1, 2, 3, 4, 5].map((star) => (
                  <button
                    key={star}
                    onClick={() => setRating(star)}
                    className="p-1"
                  >
                    <Star
                      className={`h-6 w-6 ${star <= rating ? 'fill-yellow-400 text-yellow-400' : 'text-muted'}`}
                    />
                  </button>
                ))}
              </div>
            </div>
            
            <div className="space-y-2">
              <Label>Feedback</Label>
              <Textarea
                value={feedback}
                onChange={(e) => setFeedback(e.target.value)}
                placeholder="How did the interview go? What went well? What could be improved?"
                rows={5}
              />
            </div>
          </div>

          <DialogFooter>
            <Button variant="outline" onClick={() => setCompleteDialogOpen(false)}>
              Cancel
            </Button>
            <Button onClick={handleComplete} disabled={completeInterview.isPending}>
              {completeInterview.isPending ? (
                <>
                  <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                  Saving...
                </>
              ) : (
                'Mark Complete'
              )}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
}
