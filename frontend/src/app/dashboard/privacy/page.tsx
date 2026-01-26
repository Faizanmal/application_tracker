'use client';

import { useState } from 'react';
import {
  Shield,
  Key,
  Download,
  Eye,
  Smartphone,
  FileText,
  AlertTriangle,
  CheckCircle2,
  Clock,
  Trash2,
  History,
} from 'lucide-react';

// import { AnimatedCard } from '@/components/ui/animated-card';
// import { GradientButton, AnimatedNumber, EmptyState as AnimatedEmptyState } from '@/components/ui/animated-elements';
import { format } from 'date-fns';

import { Button } from '@/components/ui/button';
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from '@/components/ui/card';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { Badge } from '@/components/ui/badge';
import { Switch } from '@/components/ui/switch';
import { Label } from '@/components/ui/label';
import { Skeleton } from '@/components/ui/skeleton';
import { Separator } from '@/components/ui/separator';
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
  DialogFooter,
} from '@/components/ui/dialog';
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
  AlertDialogTrigger,
} from '@/components/ui/alert-dialog';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select';
import {
  useDataExports,
  useRequestExport,
  useTwoFAStatus,
  useSetup2FA,
  // useVerify2FA,
  useDisable2FA,
  useLoginAttempts,
  useAuditLogs,
  usePrivacySettings,
  useUpdatePrivacySettings,
} from '@/hooks/use-queries';
import type { DataExportRequest, LoginAttempt, AuditLog } from '@/types';

function ExportStatusBadge({ status }: { status: string }) {
  const statusConfig: Record<string, { color: string; icon: React.ReactNode }> = {
    pending: { color: 'bg-yellow-100 text-yellow-700', icon: <Clock className="h-3 w-3" /> },
    processing: { color: 'bg-blue-100 text-blue-700', icon: <Clock className="h-3 w-3" /> },
    completed: { color: 'bg-green-100 text-green-700', icon: <CheckCircle2 className="h-3 w-3" /> },
    failed: { color: 'bg-red-100 text-red-700', icon: <AlertTriangle className="h-3 w-3" /> },
    expired: { color: 'bg-gray-100 text-gray-700', icon: <Clock className="h-3 w-3" /> },
  };

  const config = statusConfig[status] || statusConfig.pending;

  return (
    <Badge className={`${config.color} gap-1`}>
      {config.icon}
      {status}
    </Badge>
  );
}

function LoginAttemptRow({ attempt }: { attempt: LoginAttempt }) {
  return (
    <div className="flex items-center justify-between p-3 border rounded-lg">
      <div className="flex items-center gap-3">
        <div className={`p-2 rounded-full ${attempt.successful ? 'bg-green-100' : 'bg-red-100'}`}>
          {attempt.successful ? (
            <CheckCircle2 className="h-4 w-4 text-green-600" />
          ) : (
            <AlertTriangle className="h-4 w-4 text-red-600" />
          )}
        </div>
        <div>
          <div className="flex items-center gap-2">
            <span className="font-medium">{attempt.successful ? 'Successful login' : 'Failed login'}</span>
            {attempt.is_suspicious && (
              <Badge variant="destructive" className="text-xs">Suspicious</Badge>
            )}
          </div>
          <p className="text-sm text-muted-foreground">
            {attempt.ip_address} • {attempt.city && `${attempt.city}, `}{attempt.country}
          </p>
        </div>
      </div>
      <span className="text-sm text-muted-foreground">
        {format(new Date(attempt.created_at), 'MMM d, h:mm a')}
      </span>
    </div>
  );
}

export default function PrivacyPage() {
  const [exportDialogOpen, setExportDialogOpen] = useState(false);
  const [twoFADialogOpen, setTwoFADialogOpen] = useState(false);
  
  const { data: exports, isLoading: exportsLoading } = useDataExports();
  const { data: twoFA, isLoading: twoFALoading } = useTwoFAStatus();
  const { data: loginAttempts, isLoading: loginLoading } = useLoginAttempts();
  const { data: auditLogs, isLoading: auditLoading } = useAuditLogs();
  const { data: privacySettings, isLoading: settingsLoading } = usePrivacySettings();
  
  const requestExport = useRequestExport();
  const setup2FA = useSetup2FA();
  // const verify2FA = useVerify2FA();
  const disable2FA = useDisable2FA();
  const updateSettings = useUpdatePrivacySettings();

  const handleSettingChange = (key: string, value: boolean | string | number) => {
    updateSettings.mutate({ [key]: value });
  };

  return (
    <div className="p-6 space-y-6">
      {/* Header with Gradient */}
      <div className="relative overflow-hidden rounded-2xl bg-gradient-to-r from-slate-600 via-gray-600 to-zinc-600 p-8">
        <div className="absolute top-0 right-0 w-64 h-64 bg-white/10 rounded-full blur-3xl -translate-y-1/2 translate-x-1/2" />
        <div className="absolute bottom-0 left-0 w-48 h-48 bg-white/5 rounded-full blur-2xl translate-y-1/2 -translate-x-1/2" />
        <div className="absolute top-1/2 right-1/4 w-32 h-32 bg-slate-400/20 rounded-full blur-xl" />
        
        <div className="relative flex flex-col sm:flex-row sm:items-center sm:justify-between gap-6">
          <div className="animate-fade-in-up">
            <h1 className="text-3xl font-bold text-white flex items-center gap-3">
              <div className="p-2 bg-white/20 rounded-xl backdrop-blur-sm">
                <Shield className="h-7 w-7" />
              </div>
              Privacy & Security
            </h1>
            <p className="text-white/80 mt-2 max-w-md">
              Manage your data, security settings, and privacy preferences
            </p>
          </div>
        </div>
      </div>

      {/* Security Overview */}
      <div className="grid gap-4 md:grid-cols-4">
        <Card>
          <CardHeader className="flex flex-row items-center justify-between pb-2">
            <CardTitle className="text-sm font-medium">Two-Factor Auth</CardTitle>
            <Shield className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="flex items-center gap-2">
              {twoFA?.is_enabled ? (
                <>
                  <CheckCircle2 className="h-5 w-5 text-green-500" />
                  <span className="font-semibold text-green-600">Enabled</span>
                </>
              ) : (
                <>
                  <AlertTriangle className="h-5 w-5 text-amber-500" />
                  <span className="font-semibold text-amber-600">Disabled</span>
                </>
              )}
            </div>
          </CardContent>
        </Card>
        
        <Card>
          <CardHeader className="flex flex-row items-center justify-between pb-2">
            <CardTitle className="text-sm font-medium">Data Exports</CardTitle>
            <Download className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{exports?.length || 0}</div>
            <p className="text-xs text-muted-foreground">exports requested</p>
          </CardContent>
        </Card>
        
        <Card>
          <CardHeader className="flex flex-row items-center justify-between pb-2">
            <CardTitle className="text-sm font-medium">Login Attempts</CardTitle>
            <Key className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">
              {loginAttempts?.filter((a: LoginAttempt) => a.is_suspicious).length || 0}
            </div>
            <p className="text-xs text-muted-foreground">suspicious attempts</p>
          </CardContent>
        </Card>
        
        <Card>
          <CardHeader className="flex flex-row items-center justify-between pb-2">
            <CardTitle className="text-sm font-medium">Audit Events</CardTitle>
            <History className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{auditLogs?.length || 0}</div>
            <p className="text-xs text-muted-foreground">recent events</p>
          </CardContent>
        </Card>
      </div>

      {/* Tabs */}
      <Tabs defaultValue="security" className="space-y-4">
        <TabsList>
          <TabsTrigger value="security">
            <Shield className="h-4 w-4 mr-2" />
            Security
          </TabsTrigger>
          <TabsTrigger value="data">
            <Download className="h-4 w-4 mr-2" />
            Data
          </TabsTrigger>
          <TabsTrigger value="privacy">
            <Eye className="h-4 w-4 mr-2" />
            Privacy
          </TabsTrigger>
          <TabsTrigger value="activity">
            <History className="h-4 w-4 mr-2" />
            Activity
          </TabsTrigger>
        </TabsList>

        <TabsContent value="security" className="space-y-4">
          {/* Two-Factor Authentication */}
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <Smartphone className="h-5 w-5" />
                Two-Factor Authentication
              </CardTitle>
              <CardDescription>
                Add an extra layer of security to your account
              </CardDescription>
            </CardHeader>
            <CardContent>
              {twoFALoading ? (
                <Skeleton className="h-24" />
              ) : twoFA?.is_enabled ? (
                <div className="space-y-4">
                  <div className="flex items-center justify-between p-4 bg-green-50 rounded-lg">
                    <div className="flex items-center gap-3">
                      <CheckCircle2 className="h-6 w-6 text-green-600" />
                      <div>
                        <p className="font-medium text-green-700">2FA is enabled</p>
                        <p className="text-sm text-green-600">
                          Using {twoFA.primary_method === 'totp' ? 'Authenticator App' : twoFA.primary_method}
                        </p>
                      </div>
                    </div>
                    <div className="flex items-center gap-2">
                      <Badge variant="outline">
                        {twoFA.backup_codes_remaining} backup codes left
                      </Badge>
                      <AlertDialog>
                        <AlertDialogTrigger asChild>
                          <Button variant="outline" size="sm">Disable</Button>
                        </AlertDialogTrigger>
                        <AlertDialogContent>
                          <AlertDialogHeader>
                            <AlertDialogTitle>Disable Two-Factor Authentication?</AlertDialogTitle>
                            <AlertDialogDescription>
                              This will make your account less secure. Are you sure?
                            </AlertDialogDescription>
                          </AlertDialogHeader>
                          <AlertDialogFooter>
                            <AlertDialogCancel>Cancel</AlertDialogCancel>
                            <AlertDialogAction onClick={() => disable2FA.mutate()}>
                              Disable 2FA
                            </AlertDialogAction>
                          </AlertDialogFooter>
                        </AlertDialogContent>
                      </AlertDialog>
                    </div>
                  </div>
                </div>
              ) : (
                <div className="space-y-4">
                  <div className="flex items-center justify-between p-4 bg-amber-50 rounded-lg">
                    <div className="flex items-center gap-3">
                      <AlertTriangle className="h-6 w-6 text-amber-600" />
                      <div>
                        <p className="font-medium text-amber-700">2FA is not enabled</p>
                        <p className="text-sm text-amber-600">
                          Enable 2FA to protect your account
                        </p>
                      </div>
                    </div>
                    <Dialog open={twoFADialogOpen} onOpenChange={setTwoFADialogOpen}>
                      <DialogTrigger asChild>
                        <Button>Enable 2FA</Button>
                      </DialogTrigger>
                      <DialogContent>
                        <DialogHeader>
                          <DialogTitle>Set Up Two-Factor Authentication</DialogTitle>
                          <DialogDescription>
                            Choose your preferred 2FA method
                          </DialogDescription>
                        </DialogHeader>
                        <div className="space-y-4 py-4">
                          <Button
                            variant="outline"
                            className="w-full justify-start gap-3 h-auto p-4"
                            onClick={() => setup2FA.mutate({ method: 'totp' })}
                          >
                            <Smartphone className="h-6 w-6" />
                            <div className="text-left">
                              <p className="font-medium">Authenticator App</p>
                              <p className="text-sm text-muted-foreground">
                                Use an app like Google Authenticator
                              </p>
                            </div>
                          </Button>
                        </div>
                      </DialogContent>
                    </Dialog>
                  </div>
                </div>
              )}
            </CardContent>
          </Card>

          {/* Recent Login Activity */}
          <Card>
            <CardHeader>
              <CardTitle>Recent Login Activity</CardTitle>
              <CardDescription>Monitor your account access</CardDescription>
            </CardHeader>
            <CardContent>
              {loginLoading ? (
                <div className="space-y-3">
                  {[1, 2, 3].map((i) => (
                    <Skeleton key={i} className="h-16" />
                  ))}
                </div>
              ) : loginAttempts && loginAttempts.length > 0 ? (
                <div className="space-y-3">
                  {loginAttempts.slice(0, 5).map((attempt: LoginAttempt) => (
                    <LoginAttemptRow key={attempt.id} attempt={attempt} />
                  ))}
                </div>
              ) : (
                <p className="text-muted-foreground text-center py-8">
                  No login activity recorded
                </p>
              )}
            </CardContent>
          </Card>
        </TabsContent>

        <TabsContent value="data" className="space-y-4">
          {/* Data Export */}
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <FileText className="h-5 w-5" />
                Export Your Data
              </CardTitle>
              <CardDescription>
                Download a copy of all your data (GDPR Article 20)
              </CardDescription>
            </CardHeader>
            <CardContent className="space-y-4">
              <Dialog open={exportDialogOpen} onOpenChange={setExportDialogOpen}>
                <DialogTrigger asChild>
                  <Button>
                    <Download className="h-4 w-4 mr-2" />
                    Request Data Export
                  </Button>
                </DialogTrigger>
                <DialogContent>
                  <DialogHeader>
                    <DialogTitle>Export Your Data</DialogTitle>
                    <DialogDescription>
                      Choose what data to include in your export
                    </DialogDescription>
                  </DialogHeader>
                  <div className="space-y-4 py-4">
                    <Select defaultValue="json">
                      <SelectTrigger>
                        <SelectValue placeholder="Export format" />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="json">JSON</SelectItem>
                        <SelectItem value="csv">CSV</SelectItem>
                      </SelectContent>
                    </Select>
                    <p className="text-sm text-muted-foreground">
                      Your export will include all applications, interviews, notes, and settings.
                    </p>
                  </div>
                  <DialogFooter>
                    <Button
                      onClick={() => {
                        requestExport.mutate({ format: 'json' });
                        setExportDialogOpen(false);
                      }}
                    >
                      Start Export
                    </Button>
                  </DialogFooter>
                </DialogContent>
              </Dialog>

              {exportsLoading ? (
                <Skeleton className="h-24" />
              ) : exports && exports.length > 0 ? (
                <div className="space-y-3">
                  <h4 className="text-sm font-medium">Recent Exports</h4>
                  {exports.map((exp: DataExportRequest) => (
                    <div key={exp.id} className="flex items-center justify-between p-3 border rounded-lg">
                      <div>
                        <p className="font-medium">{exp.format.toUpperCase()} Export</p>
                        <p className="text-sm text-muted-foreground">
                          {format(new Date(exp.created_at), 'PPP')}
                        </p>
                      </div>
                      <div className="flex items-center gap-2">
                        <ExportStatusBadge status={exp.status} />
                        {exp.status === 'completed' && exp.download_url && (
                          <Button variant="outline" size="sm" asChild>
                            <a href={exp.download_url}>Download</a>
                          </Button>
                        )}
                      </div>
                    </div>
                  ))}
                </div>
              ) : null}
            </CardContent>
          </Card>

          {/* Delete Account */}
          <Card className="border-red-200">
            <CardHeader>
              <CardTitle className="flex items-center gap-2 text-red-600">
                <Trash2 className="h-5 w-5" />
                Delete Account
              </CardTitle>
              <CardDescription>
                Permanently delete your account and all data (GDPR Article 17)
              </CardDescription>
            </CardHeader>
            <CardContent>
              <AlertDialog>
                <AlertDialogTrigger asChild>
                  <Button variant="destructive">
                    <Trash2 className="h-4 w-4 mr-2" />
                    Delete My Account
                  </Button>
                </AlertDialogTrigger>
                <AlertDialogContent>
                  <AlertDialogHeader>
                    <AlertDialogTitle>Are you absolutely sure?</AlertDialogTitle>
                    <AlertDialogDescription>
                      This action cannot be undone. This will permanently delete your account
                      and remove all your data from our servers.
                    </AlertDialogDescription>
                  </AlertDialogHeader>
                  <AlertDialogFooter>
                    <AlertDialogCancel>Cancel</AlertDialogCancel>
                    <AlertDialogAction className="bg-red-600 hover:bg-red-700">
                      Yes, delete my account
                    </AlertDialogAction>
                  </AlertDialogFooter>
                </AlertDialogContent>
              </AlertDialog>
            </CardContent>
          </Card>
        </TabsContent>

        <TabsContent value="privacy" className="space-y-4">
          <Card>
            <CardHeader>
              <CardTitle>Privacy Settings</CardTitle>
              <CardDescription>Control how your data is used</CardDescription>
            </CardHeader>
            <CardContent className="space-y-6">
              {settingsLoading ? (
                <div className="space-y-4">
                  {[1, 2, 3, 4].map((i) => (
                    <Skeleton key={i} className="h-12" />
                  ))}
                </div>
              ) : (
                <>
                  <div className="space-y-4">
                    <h4 className="text-sm font-medium">Data Collection</h4>
                    
                    <div className="flex items-center justify-between">
                      <div className="space-y-0.5">
                        <Label>Analytics</Label>
                        <p className="text-sm text-muted-foreground">
                          Help improve the product with anonymous usage data
                        </p>
                      </div>
                      <Switch
                        checked={privacySettings?.allow_analytics}
                        onCheckedChange={(checked) => handleSettingChange('allow_analytics', checked)}
                      />
                    </div>
                    
                    <div className="flex items-center justify-between">
                      <div className="space-y-0.5">
                        <Label>AI Training</Label>
                        <p className="text-sm text-muted-foreground">
                          Allow your data to improve AI features
                        </p>
                      </div>
                      <Switch
                        checked={privacySettings?.allow_ai_training}
                        onCheckedChange={(checked) => handleSettingChange('allow_ai_training', checked)}
                      />
                    </div>
                    
                    <div className="flex items-center justify-between">
                      <div className="space-y-0.5">
                        <Label>Personalization</Label>
                        <p className="text-sm text-muted-foreground">
                          Get personalized recommendations
                        </p>
                      </div>
                      <Switch
                        checked={privacySettings?.allow_personalization}
                        onCheckedChange={(checked) => handleSettingChange('allow_personalization', checked)}
                      />
                    </div>
                  </div>

                  <Separator />

                  <div className="space-y-4">
                    <h4 className="text-sm font-medium">Visibility</h4>
                    
                    <div className="flex items-center justify-between">
                      <div className="space-y-0.5">
                        <Label>Profile Visibility</Label>
                        <p className="text-sm text-muted-foreground">
                          Who can see your profile
                        </p>
                      </div>
                      <Select
                        value={privacySettings?.profile_visibility || 'private'}
                        onValueChange={(value) => handleSettingChange('profile_visibility', value)}
                      >
                        <SelectTrigger className="w-40">
                          <SelectValue />
                        </SelectTrigger>
                        <SelectContent>
                          <SelectItem value="private">Private</SelectItem>
                          <SelectItem value="connections">Connections</SelectItem>
                          <SelectItem value="public">Public</SelectItem>
                        </SelectContent>
                      </Select>
                    </div>
                    
                    <div className="flex items-center justify-between">
                      <div className="space-y-0.5">
                        <Label>Show in Leaderboards</Label>
                        <p className="text-sm text-muted-foreground">
                          Appear in community leaderboards
                        </p>
                      </div>
                      <Switch
                        checked={privacySettings?.show_in_leaderboards}
                        onCheckedChange={(checked) => handleSettingChange('show_in_leaderboards', checked)}
                      />
                    </div>
                  </div>

                  <Separator />

                  <div className="space-y-4">
                    <h4 className="text-sm font-medium">Communication</h4>
                    
                    <div className="flex items-center justify-between">
                      <div className="space-y-0.5">
                        <Label>Marketing Emails</Label>
                        <p className="text-sm text-muted-foreground">
                          Receive promotional emails
                        </p>
                      </div>
                      <Switch
                        checked={privacySettings?.allow_marketing_emails}
                        onCheckedChange={(checked) => handleSettingChange('allow_marketing_emails', checked)}
                      />
                    </div>
                    
                    <div className="flex items-center justify-between">
                      <div className="space-y-0.5">
                        <Label>Product Updates</Label>
                        <p className="text-sm text-muted-foreground">
                          Get notified about new features
                        </p>
                      </div>
                      <Switch
                        checked={privacySettings?.allow_product_updates}
                        onCheckedChange={(checked) => handleSettingChange('allow_product_updates', checked)}
                      />
                    </div>
                  </div>
                </>
              )}
            </CardContent>
          </Card>
        </TabsContent>

        <TabsContent value="activity" className="space-y-4">
          <Card>
            <CardHeader>
              <CardTitle>Security Audit Log</CardTitle>
              <CardDescription>Track security-related events on your account</CardDescription>
            </CardHeader>
            <CardContent>
              {auditLoading ? (
                <div className="space-y-3">
                  {[1, 2, 3, 4, 5].map((i) => (
                    <Skeleton key={i} className="h-14" />
                  ))}
                </div>
              ) : auditLogs && auditLogs.length > 0 ? (
                <div className="space-y-3">
                  {auditLogs.map((log: AuditLog) => (
                    <div key={log.id} className="flex items-center justify-between p-3 border rounded-lg">
                      <div className="flex items-center gap-3">
                        <div className={`p-2 rounded-full ${
                          log.severity === 'critical' ? 'bg-red-100' :
                          log.severity === 'warning' ? 'bg-amber-100' : 'bg-blue-100'
                        }`}>
                          <Shield className={`h-4 w-4 ${
                            log.severity === 'critical' ? 'text-red-600' :
                            log.severity === 'warning' ? 'text-amber-600' : 'text-blue-600'
                          }`} />
                        </div>
                        <div>
                          <p className="font-medium">{log.event_type_display}</p>
                          <p className="text-sm text-muted-foreground">{log.description}</p>
                        </div>
                      </div>
                      <span className="text-sm text-muted-foreground">
                        {format(new Date(log.created_at), 'MMM d, h:mm a')}
                      </span>
                    </div>
                  ))}
                </div>
              ) : (
                <p className="text-muted-foreground text-center py-8">
                  No audit events recorded
                </p>
              )}
            </CardContent>
          </Card>
        </TabsContent>
      </Tabs>
    </div>
  );
}
