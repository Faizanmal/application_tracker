'use client';

import { useState } from 'react';
import {
  Plug,
  Mail,
  Calendar,
  Linkedin,
  MessageSquare,
  Key,
  Zap,
  ExternalLink,
  Check,
  AlertCircle,
  Copy,
  RefreshCw,
  Plus,
  Trash2,
  Link,
  Unlink,
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
import { Input } from '@/components/ui/input';
import { Skeleton } from '@/components/ui/skeleton';
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
import { toast } from 'sonner';

// Placeholder hooks - these should be imported from use-queries
const useEmailIntegrations = () => ({ data: [], isLoading: false });
const useCalendarIntegrations = () => ({ data: [], isLoading: false });
const useSlackIntegrations = () => ({ data: [], isLoading: false });
const useDiscordIntegrations = () => ({ data: [], isLoading: false });
const useAPIKeys = () => ({ data: [], isLoading: false });
const useCreateAPIKey = () => ({ mutate: (_data: Record<string, unknown>) => {} });
const useRevokeAPIKey = () => ({ mutate: (_id: string) => {} });

interface Integration {
  id: string;
  provider: string;
  email?: string;
  is_active: boolean;
  sync_enabled?: boolean;
  last_sync_at?: string;
  created_at: string;
}

interface APIKey {
  id: string;
  name: string;
  key_prefix: string;
  scopes: string[];
  is_active: boolean;
  last_used_at?: string;
  expires_at?: string;
  created_at: string;
}

function IntegrationStatusBadge({ isActive, lastSync }: { isActive: boolean; lastSync?: string }) {
  if (!isActive) {
    return (
      <Badge variant="outline" className="gap-1">
        <AlertCircle className="h-3 w-3" />
        Disconnected
      </Badge>
    );
  }
  
  return (
    <Badge className="bg-green-100 text-green-700 gap-1">
      <Check className="h-3 w-3" />
      Connected
      {lastSync && (
        <span className="ml-1 text-xs opacity-75">
          • Synced {format(new Date(lastSync), 'MMM d')}
        </span>
      )}
    </Badge>
  );
}

function IntegrationCard({
  icon: Icon,
  title,
  description,
  provider: _provider,
  integration,
  onConnect,
  onDisconnect,
  onSync,
}: {
  icon: React.ElementType;
  title: string;
  description: string;
  provider: string;
  integration?: Integration;
  onConnect: () => void;
  onDisconnect: () => void;
  onSync?: () => void;
}) {
  return (
    <Card>
      <CardContent className="p-6">
        <div className="flex items-start justify-between">
          <div className="flex items-start gap-4">
            <div className="p-3 rounded-lg bg-primary/10">
              <Icon className="h-6 w-6 text-primary" />
            </div>
            <div>
              <h3 className="font-semibold">{title}</h3>
              <p className="text-sm text-muted-foreground mb-2">{description}</p>
              {integration ? (
                <IntegrationStatusBadge 
                  isActive={integration.is_active} 
                  lastSync={integration.last_sync_at} 
                />
              ) : (
                <Badge variant="outline" className="gap-1">
                  <AlertCircle className="h-3 w-3" />
                  Not connected
                </Badge>
              )}
            </div>
          </div>
          <div className="flex items-center gap-2">
            {integration?.is_active ? (
              <>
                {onSync && (
                  <Button variant="outline" size="sm" onClick={onSync}>
                    <RefreshCw className="h-4 w-4" />
                  </Button>
                )}
                <AlertDialog>
                  <AlertDialogTrigger asChild>
                    <Button variant="outline" size="sm">
                      <Unlink className="h-4 w-4 mr-1" />
                      Disconnect
                    </Button>
                  </AlertDialogTrigger>
                  <AlertDialogContent>
                    <AlertDialogHeader>
                      <AlertDialogTitle>Disconnect {title}?</AlertDialogTitle>
                      <AlertDialogDescription>
                        This will stop syncing data from {title}. You can reconnect anytime.
                      </AlertDialogDescription>
                    </AlertDialogHeader>
                    <AlertDialogFooter>
                      <AlertDialogCancel>Cancel</AlertDialogCancel>
                      <AlertDialogAction onClick={onDisconnect}>
                        Disconnect
                      </AlertDialogAction>
                    </AlertDialogFooter>
                  </AlertDialogContent>
                </AlertDialog>
              </>
            ) : (
              <Button size="sm" onClick={onConnect}>
                <Link className="h-4 w-4 mr-1" />
                Connect
              </Button>
            )}
          </div>
        </div>
      </CardContent>
    </Card>
  );
}

function APIKeyRow({ apiKey, onRevoke }: { apiKey: APIKey; onRevoke: () => void }) {
  const copyToClipboard = () => {
    navigator.clipboard.writeText(apiKey.key_prefix + '...');
    toast.success('API key prefix copied to clipboard');
  };

  return (
    <div className="flex items-center justify-between p-4 border rounded-lg">
      <div className="flex items-center gap-4">
        <div className="p-2 rounded-lg bg-muted">
          <Key className="h-5 w-5" />
        </div>
        <div>
          <div className="flex items-center gap-2">
            <span className="font-medium">{apiKey.name}</span>
            {!apiKey.is_active && (
              <Badge variant="destructive" className="text-xs">Revoked</Badge>
            )}
          </div>
          <div className="flex items-center gap-2 text-sm text-muted-foreground">
            <code className="bg-muted px-1 rounded">{apiKey.key_prefix}...</code>
            <Button
              variant="ghost"
              size="sm"
              className="h-6 w-6 p-0"
              onClick={copyToClipboard}
            >
              <Copy className="h-3 w-3" />
            </Button>
          </div>
          <div className="flex items-center gap-2 mt-1">
            {apiKey.scopes.map((scope) => (
              <Badge key={scope} variant="outline" className="text-xs">
                {scope}
              </Badge>
            ))}
          </div>
        </div>
      </div>
      <div className="flex items-center gap-4">
        <div className="text-right text-sm text-muted-foreground">
          {apiKey.last_used_at && (
            <p>Last used {format(new Date(apiKey.last_used_at), 'MMM d')}</p>
          )}
          {apiKey.expires_at && (
            <p>Expires {format(new Date(apiKey.expires_at), 'MMM d, yyyy')}</p>
          )}
        </div>
        {apiKey.is_active && (
          <AlertDialog>
            <AlertDialogTrigger asChild>
              <Button variant="ghost" size="sm" className="text-red-600">
                <Trash2 className="h-4 w-4" />
              </Button>
            </AlertDialogTrigger>
            <AlertDialogContent>
              <AlertDialogHeader>
                <AlertDialogTitle>Revoke API Key?</AlertDialogTitle>
                <AlertDialogDescription>
                  This action cannot be undone. Any applications using this key will stop working.
                </AlertDialogDescription>
              </AlertDialogHeader>
              <AlertDialogFooter>
                <AlertDialogCancel>Cancel</AlertDialogCancel>
                <AlertDialogAction onClick={onRevoke} className="bg-red-600">
                  Revoke Key
                </AlertDialogAction>
              </AlertDialogFooter>
            </AlertDialogContent>
          </AlertDialog>
        )}
      </div>
    </div>
  );
}

export default function IntegrationsPage() {
  const [createKeyDialogOpen, setCreateKeyDialogOpen] = useState(false);
  const [newKeyName, setNewKeyName] = useState('');
  
  const { data: emailIntegrations, isLoading: emailLoading } = useEmailIntegrations();
  const { data: calendarIntegrations, isLoading: calendarLoading } = useCalendarIntegrations();
  const { data: slackIntegrations } = useSlackIntegrations();
  const { data: discordIntegrations } = useDiscordIntegrations();
  const { data: apiKeys, isLoading: keysLoading } = useAPIKeys();
  
  const createAPIKey = useCreateAPIKey();
  const revokeAPIKey = useRevokeAPIKey();

  const handleOAuthConnect = (provider: string) => {
    // Redirect to OAuth flow
    window.location.href = `/api/v1/integrations/${provider}/oauth/`;
  };

  const activeIntegrations = [
    ...(emailIntegrations as Integration[] || []),
    ...(calendarIntegrations as Integration[] || []),
    ...(slackIntegrations as Integration[] || []),
    ...(discordIntegrations as Integration[] || []),
  ].filter(i => i.is_active).length;

  const activeKeys = (apiKeys as APIKey[] || []).filter(k => k.is_active).length;

  return (
    <div className="p-6 space-y-6">
      {/* Header with Gradient */}
      <div className="relative overflow-hidden rounded-2xl bg-gradient-to-r from-violet-500 via-purple-500 to-indigo-500 p-8">
        <div className="absolute top-0 right-0 w-64 h-64 bg-white/10 rounded-full blur-3xl -translate-y-1/2 translate-x-1/2" />
        <div className="absolute bottom-0 left-0 w-48 h-48 bg-white/5 rounded-full blur-2xl translate-y-1/2 -translate-x-1/2" />
        <div className="absolute top-1/2 right-1/4 w-32 h-32 bg-violet-300/20 rounded-full blur-xl" />
        
        <div className="relative flex flex-col sm:flex-row sm:items-center sm:justify-between gap-6">
          <div className="animate-fade-in-up">
            <h1 className="text-3xl font-bold text-white flex items-center gap-3">
              <div className="p-2 bg-white/20 rounded-xl backdrop-blur-sm">
                <Plug className="h-7 w-7" />
              </div>
              Integrations
            </h1>
            <p className="text-white/80 mt-2 max-w-md">
              Connect external services and manage API access
            </p>
          </div>
        </div>
      </div>

      {/* Overview Cards */}
      <div className="grid gap-4 md:grid-cols-4">
        <Card>
          <CardHeader className="flex flex-row items-center justify-between pb-2">
            <CardTitle className="text-sm font-medium">Connected</CardTitle>
            <Plug className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{activeIntegrations}</div>
            <p className="text-xs text-muted-foreground">active integrations</p>
          </CardContent>
        </Card>
        
        <Card>
          <CardHeader className="flex flex-row items-center justify-between pb-2">
            <CardTitle className="text-sm font-medium">API Keys</CardTitle>
            <Key className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{activeKeys}</div>
            <p className="text-xs text-muted-foreground">active keys</p>
          </CardContent>
        </Card>
        
        <Card>
          <CardHeader className="flex flex-row items-center justify-between pb-2">
            <CardTitle className="text-sm font-medium">Automations</CardTitle>
            <Zap className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">0</div>
            <p className="text-xs text-muted-foreground">Zapier workflows</p>
          </CardContent>
        </Card>
        
        <Card>
          <CardHeader className="flex flex-row items-center justify-between pb-2">
            <CardTitle className="text-sm font-medium">Syncs Today</CardTitle>
            <RefreshCw className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">0</div>
            <p className="text-xs text-muted-foreground">data syncs</p>
          </CardContent>
        </Card>
      </div>

      {/* Tabs */}
      <Tabs defaultValue="email" className="space-y-4">
        <TabsList>
          <TabsTrigger value="email">
            <Mail className="h-4 w-4 mr-2" />
            Email
          </TabsTrigger>
          <TabsTrigger value="calendar">
            <Calendar className="h-4 w-4 mr-2" />
            Calendar
          </TabsTrigger>
          <TabsTrigger value="communication">
            <MessageSquare className="h-4 w-4 mr-2" />
            Communication
          </TabsTrigger>
          <TabsTrigger value="automation">
            <Zap className="h-4 w-4 mr-2" />
            Automation
          </TabsTrigger>
          <TabsTrigger value="api">
            <Key className="h-4 w-4 mr-2" />
            API
          </TabsTrigger>
        </TabsList>

        <TabsContent value="email" className="space-y-4">
          <Card>
            <CardHeader>
              <CardTitle>Email Integration</CardTitle>
              <CardDescription>
                Automatically track job-related emails and responses
              </CardDescription>
            </CardHeader>
            <CardContent className="space-y-4">
              {emailLoading ? (
                <div className="space-y-4">
                  {[1, 2].map((i) => (
                    <Skeleton key={i} className="h-24" />
                  ))}
                </div>
              ) : (
                <>
                  <IntegrationCard
                    icon={Mail}
                    title="Gmail"
                    description="Track job-related emails from your Gmail account"
                    provider="gmail"
                    integration={(emailIntegrations as Integration[])?.find(i => i.provider === 'gmail')}
                    onConnect={() => handleOAuthConnect('gmail')}
                    onDisconnect={() => {}}
                    onSync={() => {}}
                  />
                  <IntegrationCard
                    icon={Mail}
                    title="Outlook"
                    description="Sync emails from your Microsoft Outlook account"
                    provider="outlook"
                    integration={(emailIntegrations as Integration[])?.find(i => i.provider === 'outlook')}
                    onConnect={() => handleOAuthConnect('outlook')}
                    onDisconnect={() => {}}
                    onSync={() => {}}
                  />
                </>
              )}
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle>Email Settings</CardTitle>
              <CardDescription>Configure how emails are processed</CardDescription>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="flex items-center justify-between">
                <div className="space-y-0.5">
                  <Label>Auto-detect Applications</Label>
                  <p className="text-sm text-muted-foreground">
                    Automatically create applications from job-related emails
                  </p>
                </div>
                <Switch />
              </div>
              <div className="flex items-center justify-between">
                <div className="space-y-0.5">
                  <Label>Track Responses</Label>
                  <p className="text-sm text-muted-foreground">
                    Update application status when you receive responses
                  </p>
                </div>
                <Switch />
              </div>
            </CardContent>
          </Card>
        </TabsContent>

        <TabsContent value="calendar" className="space-y-4">
          <Card>
            <CardHeader>
              <CardTitle>Calendar Integration</CardTitle>
              <CardDescription>
                Sync interviews and reminders with your calendar
              </CardDescription>
            </CardHeader>
            <CardContent className="space-y-4">
              {calendarLoading ? (
                <div className="space-y-4">
                  {[1, 2].map((i) => (
                    <Skeleton key={i} className="h-24" />
                  ))}
                </div>
              ) : (
                <>
                  <IntegrationCard
                    icon={Calendar}
                    title="Google Calendar"
                    description="Sync interviews and reminders to Google Calendar"
                    provider="google_calendar"
                    integration={(calendarIntegrations as Integration[])?.find(i => i.provider === 'google_calendar')}
                    onConnect={() => handleOAuthConnect('google-calendar')}
                    onDisconnect={() => {}}
                    onSync={() => {}}
                  />
                  <IntegrationCard
                    icon={Calendar}
                    title="Outlook Calendar"
                    description="Sync with your Microsoft Outlook calendar"
                    provider="outlook_calendar"
                    integration={(calendarIntegrations as Integration[])?.find(i => i.provider === 'outlook_calendar')}
                    onConnect={() => handleOAuthConnect('outlook-calendar')}
                    onDisconnect={() => {}}
                    onSync={() => {}}
                  />
                </>
              )}
            </CardContent>
          </Card>
        </TabsContent>

        <TabsContent value="communication" className="space-y-4">
          <Card>
            <CardHeader>
              <CardTitle>Communication Tools</CardTitle>
              <CardDescription>
                Get notifications in your favorite communication apps
              </CardDescription>
            </CardHeader>
            <CardContent className="space-y-4">
              <IntegrationCard
                icon={Linkedin}
                title="LinkedIn"
                description="Track LinkedIn connections and messages"
                provider="linkedin"
                integration={undefined}
                onConnect={() => handleOAuthConnect('linkedin')}
                onDisconnect={() => {}}
              />
              <IntegrationCard
                icon={MessageSquare}
                title="Slack"
                description="Receive notifications and updates in Slack"
                provider="slack"
                integration={(slackIntegrations as Integration[])?.[0]}
                onConnect={() => handleOAuthConnect('slack')}
                onDisconnect={() => {}}
              />
              <IntegrationCard
                icon={MessageSquare}
                title="Discord"
                description="Get alerts in your Discord server"
                provider="discord"
                integration={(discordIntegrations as Integration[])?.[0]}
                onConnect={() => handleOAuthConnect('discord')}
                onDisconnect={() => {}}
              />
            </CardContent>
          </Card>
        </TabsContent>

        <TabsContent value="automation" className="space-y-4">
          <Card>
            <CardHeader>
              <CardTitle>Automation</CardTitle>
              <CardDescription>
                Connect with automation platforms
              </CardDescription>
            </CardHeader>
            <CardContent className="space-y-4">
              <IntegrationCard
                icon={Zap}
                title="Zapier"
                description="Connect with 5,000+ apps through Zapier"
                provider="zapier"
                integration={undefined}
                onConnect={() => window.open('https://zapier.com', '_blank')}
                onDisconnect={() => {}}
              />
              
              <div className="mt-6 p-6 bg-muted rounded-lg">
                <h4 className="font-medium mb-2">Popular Workflows</h4>
                <div className="grid gap-3 md:grid-cols-2">
                  <div className="flex items-center gap-3 p-3 bg-background rounded-lg">
                    <Zap className="h-5 w-5 text-amber-500" />
                    <div>
                      <p className="text-sm font-medium">New Application → Spreadsheet</p>
                      <p className="text-xs text-muted-foreground">Add row to Google Sheets</p>
                    </div>
                  </div>
                  <div className="flex items-center gap-3 p-3 bg-background rounded-lg">
                    <Zap className="h-5 w-5 text-amber-500" />
                    <div>
                      <p className="text-sm font-medium">Interview Scheduled → Calendar</p>
                      <p className="text-xs text-muted-foreground">Create calendar event</p>
                    </div>
                  </div>
                  <div className="flex items-center gap-3 p-3 bg-background rounded-lg">
                    <Zap className="h-5 w-5 text-amber-500" />
                    <div>
                      <p className="text-sm font-medium">Status Change → Slack</p>
                      <p className="text-xs text-muted-foreground">Post to Slack channel</p>
                    </div>
                  </div>
                  <div className="flex items-center gap-3 p-3 bg-background rounded-lg">
                    <Zap className="h-5 w-5 text-amber-500" />
                    <div>
                      <p className="text-sm font-medium">Offer Received → Email</p>
                      <p className="text-xs text-muted-foreground">Send notification email</p>
                    </div>
                  </div>
                </div>
              </div>
            </CardContent>
          </Card>
        </TabsContent>

        <TabsContent value="api" className="space-y-4">
          <Card>
            <CardHeader className="flex flex-row items-center justify-between">
              <div>
                <CardTitle>API Keys</CardTitle>
                <CardDescription>
                  Manage API access for external applications
                </CardDescription>
              </div>
              <Dialog open={createKeyDialogOpen} onOpenChange={setCreateKeyDialogOpen}>
                <DialogTrigger asChild>
                  <Button>
                    <Plus className="h-4 w-4 mr-2" />
                    Create API Key
                  </Button>
                </DialogTrigger>
                <DialogContent>
                  <DialogHeader>
                    <DialogTitle>Create API Key</DialogTitle>
                    <DialogDescription>
                      Generate a new API key for external access
                    </DialogDescription>
                  </DialogHeader>
                  <div className="space-y-4 py-4">
                    <div className="space-y-2">
                      <Label>Key Name</Label>
                      <Input
                        placeholder="My API Key"
                        value={newKeyName}
                        onChange={(e) => setNewKeyName(e.target.value)}
                      />
                    </div>
                    <div className="space-y-2">
                      <Label>Scopes</Label>
                      <div className="flex flex-wrap gap-2">
                        {['applications:read', 'applications:write', 'interviews:read', 'analytics:read'].map((scope) => (
                          <Badge key={scope} variant="outline" className="cursor-pointer hover:bg-primary/10">
                            {scope}
                          </Badge>
                        ))}
                      </div>
                    </div>
                  </div>
                  <DialogFooter>
                    <Button
                      onClick={() => {
                        createAPIKey.mutate({ name: newKeyName, scopes: ['applications:read'] });
                        setCreateKeyDialogOpen(false);
                        setNewKeyName('');
                      }}
                    >
                      Create Key
                    </Button>
                  </DialogFooter>
                </DialogContent>
              </Dialog>
            </CardHeader>
            <CardContent>
              {keysLoading ? (
                <div className="space-y-4">
                  {[1, 2].map((i) => (
                    <Skeleton key={i} className="h-24" />
                  ))}
                </div>
              ) : (apiKeys as APIKey[])?.length > 0 ? (
                <div className="space-y-4">
                  {(apiKeys as APIKey[]).map((key) => (
                    <APIKeyRow
                      key={key.id}
                      apiKey={key}
                      onRevoke={() => revokeAPIKey.mutate(key.id)}
                    />
                  ))}
                </div>
              ) : (
                <div className="text-center py-8">
                  <Key className="h-12 w-12 mx-auto text-muted-foreground mb-3" />
                  <h3 className="font-medium mb-1">No API Keys</h3>
                  <p className="text-sm text-muted-foreground mb-4">
                    Create an API key to access your data programmatically
                  </p>
                  <Button onClick={() => setCreateKeyDialogOpen(true)}>
                    <Plus className="h-4 w-4 mr-2" />
                    Create Your First Key
                  </Button>
                </div>
              )}
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle>API Documentation</CardTitle>
              <CardDescription>
                Learn how to use the JobScouter API
              </CardDescription>
            </CardHeader>
            <CardContent>
              <div className="flex items-center justify-between p-4 bg-muted rounded-lg">
                <div className="flex items-center gap-3">
                  <ExternalLink className="h-5 w-5" />
                  <div>
                    <p className="font-medium">API Reference</p>
                    <p className="text-sm text-muted-foreground">
                      Full documentation with examples and guides
                    </p>
                  </div>
                </div>
                <Button variant="outline" asChild>
                  <a href="/docs/api" target="_blank">
                    View Docs
                    <ExternalLink className="h-4 w-4 ml-2" />
                  </a>
                </Button>
              </div>
            </CardContent>
          </Card>
        </TabsContent>
      </Tabs>
    </div>
  );
}
