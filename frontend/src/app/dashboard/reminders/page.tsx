'use client';

import { useState } from 'react';
import Link from 'next/link';
import { format, formatDistanceToNow, isPast, parseISO } from 'date-fns';
import {
  Plus,
  Bell,
  Clock,
  CheckCircle,
  AlarmClockOff,
  MoreHorizontal,
  Calendar,
  Briefcase,
  Mail,
  Filter,
  Loader2,
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
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from '@/components/ui/dialog';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Textarea } from '@/components/ui/textarea';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select';
import { 
  useReminders, 
  useUpcomingReminders, 
  useCreateReminder,
  useCompleteReminder,
  useSnoozeReminder 
} from '@/hooks/use-queries';
import type { Reminder, ReminderType, ReminderStatus } from '@/types';

const REMINDER_TYPE_CONFIG: Record<ReminderType, { label: string; icon: React.ElementType; color: string }> = {
  follow_up: { label: 'Follow Up', icon: Mail, color: 'text-blue-600 bg-blue-100' },
  interview_prep: { label: 'Interview Prep', icon: Calendar, color: 'text-purple-600 bg-purple-100' },
  application_deadline: { label: 'Deadline', icon: Clock, color: 'text-red-600 bg-red-100' },
  check_status: { label: 'Check Status', icon: Briefcase, color: 'text-yellow-600 bg-yellow-100' },
  send_thank_you: { label: 'Thank You Note', icon: Mail, color: 'text-green-600 bg-green-100' },
  custom: { label: 'Custom', icon: Bell, color: 'text-gray-600 bg-gray-100' },
};

const REMINDER_STATUS_CONFIG: Record<ReminderStatus, { label: string; color: string }> = {
  pending: { label: 'Pending', color: 'bg-yellow-100 text-yellow-700' },
  sent: { label: 'Sent', color: 'bg-blue-100 text-blue-700' },
  completed: { label: 'Completed', color: 'bg-green-100 text-green-700' },
  snoozed: { label: 'Snoozed', color: 'bg-purple-100 text-purple-700' },
  cancelled: { label: 'Cancelled', color: 'bg-gray-100 text-gray-700' },
};

function ReminderCard({ reminder }: { reminder: Reminder }) {
  const completeReminder = useCompleteReminder();
  const snoozeReminder = useSnoozeReminder();
  const [snoozeDialogOpen, setSnoozeDialogOpen] = useState(false);
  
  const scheduledDate = parseISO(reminder.scheduled_at);
  const isOverdue = isPast(scheduledDate) && reminder.status === 'pending';
  const config = REMINDER_TYPE_CONFIG[reminder.reminder_type];
  const Icon = config.icon;

  const handleComplete = () => {
    completeReminder.mutate(reminder.id);
  };

  const handleSnooze = (hours: number) => {
    snoozeReminder.mutate({ id: reminder.id, duration: hours * 60 });
    setSnoozeDialogOpen(false);
  };

  return (
    <Card className={`transition-all hover:shadow-md ${isOverdue ? 'border-red-300 bg-red-50/50' : ''}`}>
      <CardContent className="p-4">
        <div className="flex items-start gap-4">
          {/* Icon */}
          <div className={`p-2 rounded-lg ${config.color}`}>
            <Icon className="h-5 w-5" />
          </div>

          {/* Content */}
          <div className="flex-1 min-w-0">
            <div className="flex items-center gap-2 mb-1">
              <Badge className={REMINDER_STATUS_CONFIG[reminder.status].color}>
                {REMINDER_STATUS_CONFIG[reminder.status].label}
              </Badge>
              {isOverdue && (
                <Badge variant="destructive">Overdue</Badge>
              )}
            </div>

            <h3 className="font-semibold">{reminder.title}</h3>
            
            {reminder.application_company && (
              <Link 
                href={`/dashboard/applications/${reminder.application}`}
                className="text-sm text-primary hover:underline"
              >
                {reminder.application_company} - {reminder.application_job_title}
              </Link>
            )}

            {reminder.description && (
              <p className="text-sm text-muted-foreground mt-1 line-clamp-2">
                {reminder.description}
              </p>
            )}

            <div className="flex items-center gap-4 mt-2 text-sm text-muted-foreground">
              <div className="flex items-center gap-1">
                <Clock className="h-4 w-4" />
                <span>
                  {isOverdue 
                    ? `Overdue ${formatDistanceToNow(scheduledDate, { addSuffix: false })}`
                    : formatDistanceToNow(scheduledDate, { addSuffix: true })
                  }
                </span>
              </div>
              <span>{format(scheduledDate, 'MMM d, h:mm a')}</span>
            </div>

            {reminder.snooze_count > 0 && (
              <p className="text-xs text-muted-foreground mt-1">
                Snoozed {reminder.snooze_count} time{reminder.snooze_count > 1 ? 's' : ''}
              </p>
            )}
          </div>

          {/* Actions */}
          <div className="flex items-center gap-2">
            {reminder.status === 'pending' && (
              <>
                <Button
                  variant="outline"
                  size="sm"
                  onClick={handleComplete}
                  disabled={completeReminder.isPending}
                >
                  {completeReminder.isPending ? (
                    <Loader2 className="h-4 w-4 animate-spin" />
                  ) : (
                    <>
                      <CheckCircle className="mr-1 h-4 w-4" />
                      Done
                    </>
                  )}
                </Button>

                <DropdownMenu open={snoozeDialogOpen} onOpenChange={setSnoozeDialogOpen}>
                  <DropdownMenuTrigger asChild>
                    <Button variant="ghost" size="sm">
                      <AlarmClockOff className="h-4 w-4" />
                    </Button>
                  </DropdownMenuTrigger>
                  <DropdownMenuContent align="end">
                    <DropdownMenuItem onClick={() => handleSnooze(1)}>
                      Snooze 1 hour
                    </DropdownMenuItem>
                    <DropdownMenuItem onClick={() => handleSnooze(3)}>
                      Snooze 3 hours
                    </DropdownMenuItem>
                    <DropdownMenuItem onClick={() => handleSnooze(24)}>
                      Snooze 1 day
                    </DropdownMenuItem>
                    <DropdownMenuItem onClick={() => handleSnooze(72)}>
                      Snooze 3 days
                    </DropdownMenuItem>
                  </DropdownMenuContent>
                </DropdownMenu>
              </>
            )}

            <DropdownMenu>
              <DropdownMenuTrigger asChild>
                <Button variant="ghost" size="icon">
                  <MoreHorizontal className="h-4 w-4" />
                </Button>
              </DropdownMenuTrigger>
              <DropdownMenuContent align="end">
                <DropdownMenuItem>Edit</DropdownMenuItem>
                <DropdownMenuItem className="text-red-600">Delete</DropdownMenuItem>
              </DropdownMenuContent>
            </DropdownMenu>
          </div>
        </div>
      </CardContent>
    </Card>
  );
}

function CreateReminderDialog() {
  const [open, setOpen] = useState(false);
  const createReminder = useCreateReminder();
  const [formData, setFormData] = useState({
    title: '',
    description: '',
    reminder_type: 'custom' as ReminderType,
    scheduled_at: '',
    send_email: true,
  });

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    createReminder.mutate({
      ...formData,
      scheduled_at: new Date(formData.scheduled_at).toISOString(),
    }, {
      onSuccess: () => {
        setOpen(false);
        setFormData({
          title: '',
          description: '',
          reminder_type: 'custom',
          scheduled_at: '',
          send_email: true,
        });
      },
    });
  };

  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <DialogTrigger asChild>
        <Button>
          <Plus className="mr-2 h-4 w-4" />
          New Reminder
        </Button>
      </DialogTrigger>
      <DialogContent className="sm:max-w-[425px]">
        <form onSubmit={handleSubmit}>
          <DialogHeader>
            <DialogTitle>Create Reminder</DialogTitle>
            <DialogDescription>
              Set a reminder to follow up or complete a task.
            </DialogDescription>
          </DialogHeader>
          
          <div className="space-y-4 py-4">
            <div className="space-y-2">
              <Label htmlFor="title">Title</Label>
              <Input
                id="title"
                value={formData.title}
                onChange={(e) => setFormData(prev => ({ ...prev, title: e.target.value }))}
                placeholder="Follow up on application"
                required
              />
            </div>

            <div className="space-y-2">
              <Label htmlFor="type">Type</Label>
              <Select
                value={formData.reminder_type}
                onValueChange={(value) => setFormData(prev => ({ ...prev, reminder_type: value as ReminderType }))}
              >
                <SelectTrigger>
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  {Object.entries(REMINDER_TYPE_CONFIG).map(([value, config]) => (
                    <SelectItem key={value} value={value}>
                      {config.label}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>

            <div className="space-y-2">
              <Label htmlFor="scheduled_at">When</Label>
              <Input
                id="scheduled_at"
                type="datetime-local"
                value={formData.scheduled_at}
                onChange={(e) => setFormData(prev => ({ ...prev, scheduled_at: e.target.value }))}
                required
              />
            </div>

            <div className="space-y-2">
              <Label htmlFor="description">Description (optional)</Label>
              <Textarea
                id="description"
                value={formData.description}
                onChange={(e) => setFormData(prev => ({ ...prev, description: e.target.value }))}
                placeholder="Add any notes..."
                rows={3}
              />
            </div>
          </div>

          <DialogFooter>
            <Button type="button" variant="outline" onClick={() => setOpen(false)}>
              Cancel
            </Button>
            <Button type="submit" disabled={createReminder.isPending}>
              {createReminder.isPending ? (
                <>
                  <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                  Creating...
                </>
              ) : (
                'Create Reminder'
              )}
            </Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  );
}

export default function RemindersPage() {
  const [activeTab, setActiveTab] = useState('pending');
  const { data: allReminders, isLoading } = useReminders({ ordering: 'scheduled_at' });
  const { data: _upcomingReminders, isLoading: _upcomingLoading } = useUpcomingReminders();

  const pendingReminders = allReminders?.results.filter(r => r.status === 'pending') || [];
  const completedReminders = allReminders?.results.filter(r => r.status === 'completed') || [];
  const overdueReminders = pendingReminders.filter(r => isPast(parseISO(r.scheduled_at)));

  return (
    <div className="p-6 space-y-6">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <h1 className="text-2xl font-bold">Reminders</h1>
          <p className="text-muted-foreground">
            Stay on top of your job search tasks
          </p>
        </div>
        <CreateReminderDialog />
      </div>

      {/* Overdue Alert */}
      {overdueReminders.length > 0 && (
        <Card className="border-red-300 bg-red-50">
          <CardHeader className="pb-2">
            <CardTitle className="flex items-center gap-2 text-lg text-red-700">
              <Clock className="h-5 w-5" />
              Overdue Reminders ({overdueReminders.length})
            </CardTitle>
          </CardHeader>
          <CardContent className="space-y-3">
            {overdueReminders.slice(0, 3).map((reminder) => (
              <ReminderCard key={reminder.id} reminder={reminder} />
            ))}
            {overdueReminders.length > 3 && (
              <Button variant="ghost" className="w-full" onClick={() => setActiveTab('pending')}>
                View all {overdueReminders.length} overdue reminders
              </Button>
            )}
          </CardContent>
        </Card>
      )}

      {/* Reminder Tabs */}
      <Tabs value={activeTab} onValueChange={setActiveTab}>
        <div className="flex items-center justify-between">
          <TabsList>
            <TabsTrigger value="pending">
              Pending
              {pendingReminders.length > 0 && (
                <Badge variant="secondary" className="ml-2">
                  {pendingReminders.length}
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

        {/* Pending Tab */}
        <TabsContent value="pending" className="mt-6">
          {isLoading ? (
            <div className="space-y-4">
              {[1, 2, 3].map((i) => (
                <Skeleton key={i} className="h-24 w-full" />
              ))}
            </div>
          ) : pendingReminders.length > 0 ? (
            <div className="space-y-4">
              {pendingReminders.map((reminder) => (
                <ReminderCard key={reminder.id} reminder={reminder} />
              ))}
            </div>
          ) : (
            <div className="py-12 text-center">
              <Bell className="h-12 w-12 mx-auto mb-4 text-muted-foreground opacity-50" />
              <p className="text-muted-foreground">No pending reminders</p>
              <p className="text-sm text-muted-foreground mt-1">
                Create a reminder to stay on track
              </p>
            </div>
          )}
        </TabsContent>

        {/* Completed Tab */}
        <TabsContent value="completed" className="mt-6">
          {isLoading ? (
            <div className="space-y-4">
              {[1, 2, 3].map((i) => (
                <Skeleton key={i} className="h-24 w-full" />
              ))}
            </div>
          ) : completedReminders.length > 0 ? (
            <div className="space-y-4">
              {completedReminders.map((reminder) => (
                <ReminderCard key={reminder.id} reminder={reminder} />
              ))}
            </div>
          ) : (
            <div className="py-12 text-center">
              <CheckCircle className="h-12 w-12 mx-auto mb-4 text-muted-foreground opacity-50" />
              <p className="text-muted-foreground">No completed reminders yet</p>
            </div>
          )}
        </TabsContent>

        {/* All Tab */}
        <TabsContent value="all" className="mt-6">
          {isLoading ? (
            <div className="space-y-4">
              {[1, 2, 3].map((i) => (
                <Skeleton key={i} className="h-24 w-full" />
              ))}
            </div>
          ) : allReminders && allReminders.results.length > 0 ? (
            <div className="space-y-4">
              {allReminders.results.map((reminder) => (
                <ReminderCard key={reminder.id} reminder={reminder} />
              ))}
            </div>
          ) : (
            <div className="py-12 text-center">
              <Bell className="h-12 w-12 mx-auto mb-4 text-muted-foreground opacity-50" />
              <p className="text-muted-foreground">No reminders found</p>
            </div>
          )}
        </TabsContent>
      </Tabs>
    </div>
  );
}
