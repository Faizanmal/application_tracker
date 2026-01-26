'use client';

import { useState } from 'react';
import Link from 'next/link';
import { format, formatDistanceToNow, isPast, parseISO, startOfMonth, endOfMonth, eachDayOfInterval, isSameDay } from 'date-fns';
import {
  Plus, Bell, Clock, CheckCircle, AlarmClockOff, MoreHorizontal, Calendar as CalendarIcon,
  Briefcase, Mail, Filter, Loader2, Sparkles, AlertTriangle, LayoutGrid,
} from 'lucide-react';

import { Button } from '@/components/ui/button';
import { CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { Skeleton } from '@/components/ui/skeleton';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { DropdownMenu, DropdownMenuContent, DropdownMenuItem, DropdownMenuTrigger } from '@/components/ui/dropdown-menu';
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle, DialogTrigger } from '@/components/ui/dialog';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Textarea } from '@/components/ui/textarea';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { AnimatedCard } from '@/components/ui/animated-card';
import { GradientButton } from '@/components/ui/animated-elements';
import { 
  useReminders, useCreateReminder, useCompleteReminder, useSnoozeReminder 
} from '@/hooks/use-queries';
import type { Reminder, ReminderType, ReminderStatus } from '@/types';

const REMINDER_TYPE_CONFIG: Record<ReminderType, { label: string; icon: React.ElementType; color: string; gradient: string }> = {
  follow_up: { label: 'Follow Up', icon: Mail, color: 'text-blue-600 bg-blue-100', gradient: 'from-blue-500 to-cyan-500' },
  interview_prep: { label: 'Interview Prep', icon: CalendarIcon, color: 'text-purple-600 bg-purple-100', gradient: 'from-purple-500 to-violet-500' },
  application_deadline: { label: 'Deadline', icon: Clock, color: 'text-red-600 bg-red-100', gradient: 'from-red-500 to-rose-500' },
  check_status: { label: 'Check Status', icon: Briefcase, color: 'text-yellow-600 bg-yellow-100', gradient: 'from-yellow-500 to-amber-500' },
  send_thank_you: { label: 'Thank You Note', icon: Mail, color: 'text-green-600 bg-green-100', gradient: 'from-green-500 to-emerald-500' },
  custom: { label: 'Custom', icon: Bell, color: 'text-gray-600 bg-gray-100', gradient: 'from-gray-500 to-slate-500' },
};

const REMINDER_STATUS_CONFIG: Record<ReminderStatus, { label: string; color: string }> = {
  pending: { label: 'Pending', color: 'bg-yellow-100 text-yellow-700' },
  sent: { label: 'Sent', color: 'bg-blue-100 text-blue-700' },
  completed: { label: 'Completed', color: 'bg-green-100 text-green-700' },
  snoozed: { label: 'Snoozed', color: 'bg-purple-100 text-purple-700' },
  cancelled: { label: 'Cancelled', color: 'bg-gray-100 text-gray-700' },
};

// --- Sub-Component: Reminder Card ---
function ReminderCard({ reminder }: { reminder: Reminder }) {
  const completeReminder = useCompleteReminder();
  const snoozeReminder = useSnoozeReminder();
  const [snoozeDialogOpen, setSnoozeDialogOpen] = useState(false);
  
  const scheduledDate = parseISO(reminder.scheduled_at);
  const isOverdue = isPast(scheduledDate) && reminder.status === 'pending';
  const config = REMINDER_TYPE_CONFIG[reminder.reminder_type];
  const Icon = config.icon;

  return (
    <AnimatedCard 
      variant="interactive" 
      hoverEffect="lift"
      className={`transition-all duration-300 ${isOverdue ? 'border-red-300 bg-gradient-to-br from-red-50 to-orange-50' : ''}`}
    >
      <CardContent className="p-5">
        <div className="flex items-start gap-4">
          <div className={`p-3 rounded-xl bg-gradient-to-br ${config.gradient} shadow-md`}>
            <Icon className="h-5 w-5 text-white" />
          </div>

          <div className="flex-1 min-w-0">
            <div className="flex flex-wrap items-center gap-2 mb-2">
              <Badge className={`${REMINDER_STATUS_CONFIG[reminder.status].color} animate-fade-in`}>
                {REMINDER_STATUS_CONFIG[reminder.status].label}
              </Badge>
              {isOverdue && (
                <Badge variant="destructive" className="animate-pulse">
                  <AlertTriangle className="mr-1 h-3 w-3" /> Overdue
                </Badge>
              )}
            </div>

            <h3 className="font-semibold text-lg">{reminder.title}</h3>
            
            {reminder.application_company && (
              <Link href={`/dashboard/applications/${reminder.application}`} className="text-sm text-primary hover:underline inline-flex items-center gap-1 mt-1">
                <Briefcase className="h-3 w-3" />
                {reminder.application_company} - {reminder.application_job_title}
              </Link>
            )}

            {reminder.description && <p className="text-sm text-muted-foreground mt-2 line-clamp-2">{reminder.description}</p>}

            <div className="flex flex-wrap items-center gap-3 mt-3 text-sm">
              <div className={`flex items-center gap-1.5 px-3 py-1.5 rounded-full ${isOverdue ? 'bg-red-100 text-red-700' : 'bg-muted'}`}>
                <Clock className="h-4 w-4" />
                <span className="font-medium">
                  {isOverdue ? `Overdue ${formatDistanceToNow(scheduledDate)}` : formatDistanceToNow(scheduledDate, { addSuffix: true })}
                </span>
              </div>
              <div className="flex items-center gap-1.5 px-3 py-1.5 bg-muted rounded-full">
                <CalendarIcon className="h-4 w-4 text-muted-foreground" />
                <span>{format(scheduledDate, 'MMM d, h:mm a')}</span>
              </div>
            </div>

            <div className="flex items-center gap-2 mt-4">
              <GradientButton size="sm" onClick={() => completeReminder.mutate(reminder.id)} disabled={completeReminder.isPending}>
                {completeReminder.isPending ? <Loader2 className="h-4 w-4 animate-spin" /> : <><CheckCircle className="mr-1 h-4 w-4" /> Done</>}
              </GradientButton>

              <DropdownMenu open={snoozeDialogOpen} onOpenChange={setSnoozeDialogOpen}>
                <DropdownMenuTrigger asChild>
                  <Button variant="outline" size="icon" className="h-9 w-9 hover:bg-purple-50">
                    <AlarmClockOff className="h-4 w-4" />
                  </Button>
                </DropdownMenuTrigger>
                <DropdownMenuContent align="end">
                  {[1, 3, 24, 72].map(hrs => (
                    <DropdownMenuItem key={hrs} onClick={() => snoozeReminder.mutate({ id: reminder.id, duration: hrs * 60 })}>
                      <Clock className="mr-2 h-4 w-4" /> {hrs >= 24 ? `${hrs/24} day(s)` : `${hrs} hour(s)`}
                    </DropdownMenuItem>
                  ))}
                </DropdownMenuContent>
              </DropdownMenu>

              <DropdownMenu>
                <DropdownMenuTrigger asChild>
                  <Button variant="ghost" size="icon" className="h-9 w-9"><MoreHorizontal className="h-4 w-4" /></Button>
                </DropdownMenuTrigger>
                <DropdownMenuContent align="end">
                  <DropdownMenuItem>Edit</DropdownMenuItem>
                  <DropdownMenuItem className="text-red-600">Delete</DropdownMenuItem>
                </DropdownMenuContent>
              </DropdownMenu>
            </div>
          </div>
        </div>
      </CardContent>
    </AnimatedCard>
  );
}

// --- Main Page Component ---
export default function RemindersPage() {
  const { data: allReminders, isLoading } = useReminders();
  const [viewMode, setViewMode] = useState<'grid' | 'calendar'>('grid');
  
  const reminders = allReminders?.results || [];
  const pendingReminders = reminders.filter(r => r.status === 'pending' || r.status === 'snoozed');
  // const completedReminders = reminders.filter(r => r.status === 'completed');
  const overdueReminders = reminders.filter(r => isPast(parseISO(r.scheduled_at)) && r.status === 'pending');

  return (
    <div className="container max-w-6xl py-8 space-y-8">
      {/* Premium Header */}
      <div className="relative overflow-hidden rounded-2xl bg-gradient-to-r from-amber-500 via-orange-500 to-red-500 p-8 shadow-lg">
        <div className="relative z-10 flex flex-col md:flex-row md:items-center justify-between gap-6">
          <div className="animate-fade-in-up">
            <h1 className="text-3xl font-bold text-white flex items-center gap-3">
              <div className="p-2 bg-white/20 rounded-xl backdrop-blur-sm"><Bell className="h-7 w-7" /></div>
              Task Reminders
            </h1>
            <p className="text-white/80 mt-2">Manage your follow-ups and stay on top of your job hunt.</p>
          </div>
          <CreateReminderDialog />
        </div>
        <div className="absolute top-0 right-0 w-64 h-64 bg-white/10 rounded-full blur-3xl -translate-y-1/2 translate-x-1/2" />
      </div>

      {/* Overdue Section */}
      {overdueReminders.length > 0 && (
        <AnimatedCard variant="premium" className="border-red-300 bg-gradient-to-br from-red-50 via-orange-50 to-amber-50">
          <CardHeader className="pb-3">
            <CardTitle className="flex items-center gap-3 text-lg text-red-700">
              <AlertTriangle className="h-5 w-5 animate-pulse" /> Overdue Attention Required
              <Badge className="bg-red-500 text-white">{overdueReminders.length}</Badge>
            </CardTitle>
          </CardHeader>
          <CardContent className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
            {overdueReminders.slice(0, 3).map(r => <ReminderCard key={r.id} reminder={r} />)}
          </CardContent>
        </AnimatedCard>
      )}

      {/* View Toggle & Tabs */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 bg-muted/30 p-2 rounded-xl border">
        <Tabs defaultValue="pending" className="w-full md:w-auto">
          <TabsList className="bg-transparent">
            <TabsTrigger value="pending" className="data-[state=active]:bg-white shadow-sm">Pending</TabsTrigger>
            <TabsTrigger value="completed">Completed</TabsTrigger>
            <TabsTrigger value="all">All</TabsTrigger>
          </TabsList>
        </Tabs>

        <div className="flex items-center gap-2">
          <div className="flex border rounded-lg overflow-hidden bg-white">
            <Button variant={viewMode === 'grid' ? 'default' : 'ghost'} size="sm" className="rounded-none" onClick={() => setViewMode('grid')}>
              <LayoutGrid className="h-4 w-4 mr-2" /> Grid
            </Button>
            <Button variant={viewMode === 'calendar' ? 'default' : 'ghost'} size="sm" className="rounded-none" onClick={() => setViewMode('calendar')}>
              <CalendarIcon className="h-4 w-4 mr-2" /> Calendar
            </Button>
          </div>
          <Button variant="outline" size="sm"><Filter className="h-4 w-4 mr-2" /> Filter</Button>
        </div>
      </div>

      {/* Main Content Area */}
      <div className="mt-6">
        {viewMode === 'grid' ? (
          <Tabs defaultValue="pending">
            <TabsContent value="pending" className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
              {isLoading ? <SkeletonGrid /> : pendingReminders.map(r => <ReminderCard key={r.id} reminder={r} />)}
            </TabsContent>
            {/* ... Other TabsContent handled similarly ... */}
          </Tabs>
        ) : (
          <CalendarView reminders={reminders} />
        )}
      </div>
    </div>
  );
}

// --- Sub-Component: Calendar View ---
function CalendarView({ reminders }: { reminders: Reminder[] }) {
  const days = eachDayOfInterval({ start: startOfMonth(new Date()), end: endOfMonth(new Date()) });
  
  return (
    <div className="bg-white rounded-2xl border shadow-sm overflow-hidden">
      <div className="grid grid-cols-7 border-b bg-muted/50">
        {['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'].map(d => (
          <div key={d} className="py-3 text-center text-sm font-semibold text-muted-foreground">{d}</div>
        ))}
      </div>
      <div className="grid grid-cols-7">
        {days.map((day, idx) => {
          const dayReminders = reminders.filter(r => isSameDay(parseISO(r.scheduled_at), day));
          return (
            <div key={idx} className="min-h-[120px] p-2 border-r border-b hover:bg-slate-50 transition-colors">
              <span className="text-xs font-medium text-muted-foreground">{format(day, 'd')}</span>
              <div className="mt-1 space-y-1">
                {dayReminders.map(r => (
                  <div key={r.id} className={`text-[10px] p-1 rounded border truncate ${REMINDER_TYPE_CONFIG[r.reminder_type].color}`}>
                    {r.title}
                  </div>
                ))}
              </div>
            </div>
          );
        })}
      </div>
    </div>
  );
}

function SkeletonGrid() {
  return (
    <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3 w-full">
      {[1, 2, 3].map(i => <Skeleton key={i} className="h-48 w-full rounded-xl" />)}
    </div>
  );
}

// --- Sub-Component: Create Dialog ---
function CreateReminderDialog() {
  const [open, setOpen] = useState(false);
  const createReminder = useCreateReminder();
  const [formData, setFormData] = useState({
    title: '', description: '', reminder_type: 'custom' as ReminderType, scheduled_at: '',
  });

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    createReminder.mutate({ ...formData, scheduled_at: new Date(formData.scheduled_at).toISOString() }, {
      onSuccess: () => { setOpen(false); setFormData({ title: '', description: '', reminder_type: 'custom', scheduled_at: '' }); }
    });
  };

  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <DialogTrigger asChild>
        <Button className="bg-white text-orange-600 hover:bg-orange-50 shadow-lg group">
          <Plus className="mr-2 h-4 w-4 group-hover:rotate-90 transition-transform" /> New Reminder
        </Button>
      </DialogTrigger>
      <DialogContent className="sm:max-w-[425px]">
        <form onSubmit={handleSubmit}>
          <DialogHeader>
            <DialogTitle className="flex items-center gap-2">
              <Sparkles className="h-5 w-5 text-orange-500" /> Create Reminder
            </DialogTitle>
            <DialogDescription>Set a task to stay on track.</DialogDescription>
          </DialogHeader>
          <div className="space-y-4 py-4">
            <div className="space-y-2">
              <Label>Title</Label>
              <Input required value={formData.title} onChange={e => setFormData(p => ({...p, title: e.target.value}))} placeholder="e.g. Follow up with Google" />
            </div>
            <div className="grid grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label>Type</Label>
                <Select value={formData.reminder_type} onValueChange={(v: ReminderType) => setFormData(p => ({...p, reminder_type: v}))}>
                  <SelectTrigger><SelectValue /></SelectTrigger>
                  <SelectContent>
                    {Object.entries(REMINDER_TYPE_CONFIG).map(([val, cfg]) => <SelectItem key={val} value={val}>{cfg.label}</SelectItem>)}
                  </SelectContent>
                </Select>
              </div>
              <div className="space-y-2">
                <Label>When</Label>
                <Input required type="datetime-local" value={formData.scheduled_at} onChange={e => setFormData(p => ({...p, scheduled_at: e.target.value}))} />
              </div>
            </div>
            <div className="space-y-2">
              <Label>Notes</Label>
              <Textarea value={formData.description} onChange={e => setFormData(p => ({...p, description: e.target.value}))} rows={3} />
            </div>
          </div>
          <DialogFooter>
            <Button type="submit" disabled={createReminder.isPending} className="w-full">
              {createReminder.isPending ? <Loader2 className="animate-spin h-4 w-4" /> : 'Create Reminder'}
            </Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  );
}