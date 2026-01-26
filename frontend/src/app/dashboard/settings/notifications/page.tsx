'use client';

import { useState } from 'react';
import { Loader2 } from 'lucide-react';

import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Switch } from '@/components/ui/switch';
import { Label } from '@/components/ui/label';
import { Separator } from '@/components/ui/separator';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select';
import { toast } from 'sonner';

interface NotificationSettings {
  // Email Notifications
  email_reminders: boolean;
  email_interview_updates: boolean;
  email_application_updates: boolean;
  email_weekly_summary: boolean;
  email_tips_and_advice: boolean;
  email_product_updates: boolean;
  
  // Push Notifications
  push_reminders: boolean;
  push_interview_updates: boolean;
  push_application_updates: boolean;
  
  // Preferences
  reminder_frequency: string;
  summary_day: string;
  quiet_hours_start: string;
  quiet_hours_end: string;
}

const DEFAULT_SETTINGS: NotificationSettings = {
  email_reminders: true,
  email_interview_updates: true,
  email_application_updates: false,
  email_weekly_summary: true,
  email_tips_and_advice: false,
  email_product_updates: true,
  push_reminders: true,
  push_interview_updates: true,
  push_application_updates: false,
  reminder_frequency: '24h',
  summary_day: 'sunday',
  quiet_hours_start: '22:00',
  quiet_hours_end: '08:00',
};

export default function NotificationSettingsPage() {
  const [settings, setSettings] = useState<NotificationSettings>(DEFAULT_SETTINGS);
  const [isSaving, setIsSaving] = useState(false);

  const handleToggle = (key: keyof NotificationSettings) => {
    setSettings(prev => ({
      ...prev,
      [key]: !prev[key],
    }));
  };

  const handleChange = (key: keyof NotificationSettings, value: string) => {
    setSettings(prev => ({
      ...prev,
      [key]: value,
    }));
  };

  const handleSave = async () => {
    setIsSaving(true);
    try {
      // TODO: Call API to save settings
      await new Promise(resolve => setTimeout(resolve, 1000));
      toast.success('Notification settings saved');
    } catch (_error) {
      toast.error('Failed to save settings');
    } finally {
      setIsSaving(false);
    }
  };

  return (
    <div className="space-y-6">
      {/* Email Notifications */}
      <Card>
        <CardHeader>
          <CardTitle>Email Notifications</CardTitle>
          <CardDescription>
            Choose what emails you&apos;d like to receive
          </CardDescription>
        </CardHeader>
        <CardContent className="space-y-6">
          <div className="flex items-center justify-between">
            <div className="space-y-0.5">
              <Label>Reminders</Label>
              <p className="text-sm text-muted-foreground">
                Get email reminders for follow-ups and deadlines
              </p>
            </div>
            <Switch
              checked={settings.email_reminders}
              onCheckedChange={() => handleToggle('email_reminders')}
            />
          </div>
          <Separator />

          <div className="flex items-center justify-between">
            <div className="space-y-0.5">
              <Label>Interview Updates</Label>
              <p className="text-sm text-muted-foreground">
                Notifications about upcoming and past interviews
              </p>
            </div>
            <Switch
              checked={settings.email_interview_updates}
              onCheckedChange={() => handleToggle('email_interview_updates')}
            />
          </div>
          <Separator />

          <div className="flex items-center justify-between">
            <div className="space-y-0.5">
              <Label>Application Updates</Label>
              <p className="text-sm text-muted-foreground">
                Status changes and activity on your applications
              </p>
            </div>
            <Switch
              checked={settings.email_application_updates}
              onCheckedChange={() => handleToggle('email_application_updates')}
            />
          </div>
          <Separator />

          <div className="flex items-center justify-between">
            <div className="space-y-0.5">
              <Label>Weekly Summary</Label>
              <p className="text-sm text-muted-foreground">
                A weekly digest of your job search progress
              </p>
            </div>
            <Switch
              checked={settings.email_weekly_summary}
              onCheckedChange={() => handleToggle('email_weekly_summary')}
            />
          </div>
          <Separator />

          <div className="flex items-center justify-between">
            <div className="space-y-0.5">
              <Label>Tips & Advice</Label>
              <p className="text-sm text-muted-foreground">
                Job search tips and career advice
              </p>
            </div>
            <Switch
              checked={settings.email_tips_and_advice}
              onCheckedChange={() => handleToggle('email_tips_and_advice')}
            />
          </div>
          <Separator />

          <div className="flex items-center justify-between">
            <div className="space-y-0.5">
              <Label>Product Updates</Label>
              <p className="text-sm text-muted-foreground">
                New features and improvements to JobScouter
              </p>
            </div>
            <Switch
              checked={settings.email_product_updates}
              onCheckedChange={() => handleToggle('email_product_updates')}
            />
          </div>
        </CardContent>
      </Card>

      {/* Push Notifications */}
      <Card>
        <CardHeader>
          <CardTitle>Push Notifications</CardTitle>
          <CardDescription>
            Browser and mobile push notifications
          </CardDescription>
        </CardHeader>
        <CardContent className="space-y-6">
          <div className="flex items-center justify-between">
            <div className="space-y-0.5">
              <Label>Reminders</Label>
              <p className="text-sm text-muted-foreground">
                Push notifications for upcoming reminders
              </p>
            </div>
            <Switch
              checked={settings.push_reminders}
              onCheckedChange={() => handleToggle('push_reminders')}
            />
          </div>
          <Separator />

          <div className="flex items-center justify-between">
            <div className="space-y-0.5">
              <Label>Interview Updates</Label>
              <p className="text-sm text-muted-foreground">
                Get notified before interviews
              </p>
            </div>
            <Switch
              checked={settings.push_interview_updates}
              onCheckedChange={() => handleToggle('push_interview_updates')}
            />
          </div>
          <Separator />

          <div className="flex items-center justify-between">
            <div className="space-y-0.5">
              <Label>Application Updates</Label>
              <p className="text-sm text-muted-foreground">
                Real-time application status changes
              </p>
            </div>
            <Switch
              checked={settings.push_application_updates}
              onCheckedChange={() => handleToggle('push_application_updates')}
            />
          </div>
        </CardContent>
      </Card>

      {/* Notification Preferences */}
      <Card>
        <CardHeader>
          <CardTitle>Preferences</CardTitle>
          <CardDescription>
            Customize how and when you receive notifications
          </CardDescription>
        </CardHeader>
        <CardContent className="space-y-6">
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div className="space-y-2">
              <Label>Reminder Frequency</Label>
              <Select
                value={settings.reminder_frequency}
                onValueChange={(value) => handleChange('reminder_frequency', value)}
              >
                <SelectTrigger>
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="1h">1 hour before</SelectItem>
                  <SelectItem value="3h">3 hours before</SelectItem>
                  <SelectItem value="24h">1 day before</SelectItem>
                  <SelectItem value="48h">2 days before</SelectItem>
                </SelectContent>
              </Select>
              <p className="text-sm text-muted-foreground">
                When to send reminder notifications before due time
              </p>
            </div>

            <div className="space-y-2">
              <Label>Weekly Summary Day</Label>
              <Select
                value={settings.summary_day}
                onValueChange={(value) => handleChange('summary_day', value)}
              >
                <SelectTrigger>
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="monday">Monday</SelectItem>
                  <SelectItem value="friday">Friday</SelectItem>
                  <SelectItem value="saturday">Saturday</SelectItem>
                  <SelectItem value="sunday">Sunday</SelectItem>
                </SelectContent>
              </Select>
              <p className="text-sm text-muted-foreground">
                Day to receive your weekly summary email
              </p>
            </div>
          </div>

          <Separator />

          <div>
            <Label className="mb-4 block">Quiet Hours</Label>
            <p className="text-sm text-muted-foreground mb-4">
              Don&apos;t send push notifications during these hours
            </p>
            <div className="grid grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label className="text-muted-foreground">Start</Label>
                <Select
                  value={settings.quiet_hours_start}
                  onValueChange={(value) => handleChange('quiet_hours_start', value)}
                >
                  <SelectTrigger>
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    {Array.from({ length: 24 }, (_, i) => {
                      const hour = i.toString().padStart(2, '0');
                      return (
                        <SelectItem key={hour} value={`${hour}:00`}>
                          {hour}:00
                        </SelectItem>
                      );
                    })}
                  </SelectContent>
                </Select>
              </div>
              <div className="space-y-2">
                <Label className="text-muted-foreground">End</Label>
                <Select
                  value={settings.quiet_hours_end}
                  onValueChange={(value) => handleChange('quiet_hours_end', value)}
                >
                  <SelectTrigger>
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    {Array.from({ length: 24 }, (_, i) => {
                      const hour = i.toString().padStart(2, '0');
                      return (
                        <SelectItem key={hour} value={`${hour}:00`}>
                          {hour}:00
                        </SelectItem>
                      );
                    })}
                  </SelectContent>
                </Select>
              </div>
            </div>
          </div>
        </CardContent>
      </Card>

      {/* Save Button */}
      <div className="flex justify-end">
        <Button onClick={handleSave} disabled={isSaving}>
          {isSaving ? (
            <>
              <Loader2 className="mr-2 h-4 w-4 animate-spin" />
              Saving...
            </>
          ) : (
            'Save Preferences'
          )}
        </Button>
      </div>
    </div>
  );
}
