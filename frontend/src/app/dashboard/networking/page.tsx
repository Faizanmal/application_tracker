'use client';

import { useState } from 'react';
import {
  Users,
  UserPlus,
  Handshake,
  Calendar,
  GraduationCap,
  Search,
  Filter,
  MoreHorizontal,
  Mail,
  Phone,
  Linkedin,
  Star,
} from 'lucide-react';
import { format } from 'date-fns';

import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Badge } from '@/components/ui/badge';
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from '@/components/ui/card';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { Avatar, AvatarFallback } from '@/components/ui/avatar';
import { AnimatedCard } from '@/components/ui/animated-card';
import { GradientButton, AnimatedNumber, EmptyState as AnimatedEmptyState } from '@/components/ui/animated-elements';
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from '@/components/ui/dialog';
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu';
import { Skeleton } from '@/components/ui/skeleton';
import {
  useConnections,
  useReferrals,
  useNetworkingEvents,
  useMentorships,
} from '@/hooks/use-queries';
import type { ProfessionalConnection, Referral, NetworkingEvent, MentorshipRelationship } from '@/types';

const CONNECTION_TYPE_CONFIG: Record<string, { colors: string; gradient: string }> = {
  colleague: { colors: 'bg-blue-100 text-blue-700', gradient: 'from-blue-500 to-indigo-600' },
  recruiter: { colors: 'bg-purple-100 text-purple-700', gradient: 'from-purple-500 to-violet-600' },
  alumni: { colors: 'bg-green-100 text-green-700', gradient: 'from-green-500 to-emerald-600' },
  referral: { colors: 'bg-amber-100 text-amber-700', gradient: 'from-amber-500 to-orange-600' },
  mentor: { colors: 'bg-rose-100 text-rose-700', gradient: 'from-rose-500 to-pink-600' },
  other: { colors: 'bg-gray-100 text-gray-700', gradient: 'from-gray-500 to-slate-600' },
};

function ConnectionCard({ connection, index }: { connection: ProfessionalConnection; index: number }) {
  const initials = connection.name
    .split(' ')
    .map((n) => n[0])
    .join('')
    .toUpperCase();

  const config = CONNECTION_TYPE_CONFIG[connection.connection_type] || CONNECTION_TYPE_CONFIG.other;

  return (
    <AnimatedCard variant="interactive" hoverEffect="lift" className={`animate-fade-in-up stagger-${Math.min(index % 4 + 1, 4)}`}>
      <CardContent className="p-4">
        <div className="flex items-start gap-4">
          <Avatar className="h-12 w-12 ring-2 ring-offset-2 ring-primary/20">
            <AvatarFallback className={`bg-gradient-to-br ${config.gradient} text-white`}>
              {initials}
            </AvatarFallback>
          </Avatar>
          
          <div className="flex-1 min-w-0">
            <div className="flex items-center justify-between">
              <h3 className="font-semibold truncate">{connection.name}</h3>
              <DropdownMenu>
                <DropdownMenuTrigger asChild>
                  <Button variant="ghost" size="icon" className="h-8 w-8">
                    <MoreHorizontal className="h-4 w-4" />
                  </Button>
                </DropdownMenuTrigger>
                <DropdownMenuContent align="end">
                  <DropdownMenuItem>Edit</DropdownMenuItem>
                  <DropdownMenuItem>Schedule Follow-up</DropdownMenuItem>
                  <DropdownMenuItem className="text-red-600">Delete</DropdownMenuItem>
                </DropdownMenuContent>
              </DropdownMenu>
            </div>
            
            <p className="text-sm text-muted-foreground truncate">
              {connection.title} at {connection.company}
            </p>
            
            <div className="flex items-center gap-2 mt-2">
              <Badge variant="secondary" className={`${config.colors} rounded-full px-3`}>
                {connection.connection_type}
              </Badge>
              {connection.is_alumni && (
                <Badge variant="outline" className="bg-green-50 rounded-full">
                  <GraduationCap className="h-3 w-3 mr-1" />
                  Alumni
                </Badge>
              )}
              <div className="flex items-center gap-0.5 ml-auto">
                {[1, 2, 3, 4, 5].map((level) => (
                  <Star
                    key={level}
                    className={`h-3 w-3 ${
                      level <= connection.relationship_strength
                        ? 'text-amber-400 fill-amber-400'
                        : 'text-gray-300'
                    }`}
                  />
                ))}
              </div>
            </div>
            
            <div className="flex items-center gap-3 mt-3 text-muted-foreground">
              {connection.email && (
                <a href={`mailto:${connection.email}`} className="hover:text-primary transition-colors">
                  <Mail className="h-4 w-4" />
                </a>
              )}
              {connection.phone && (
                <a href={`tel:${connection.phone}`} className="hover:text-primary transition-colors">
                  <Phone className="h-4 w-4" />
                </a>
              )}
              {connection.linkedin_url && (
                <a href={connection.linkedin_url} target="_blank" rel="noopener noreferrer" className="hover:text-primary transition-colors">
                  <Linkedin className="h-4 w-4" />
                </a>
              )}
              {connection.last_contacted && (
                <span className="text-xs ml-auto">
                  Last contact: {format(new Date(connection.last_contacted), 'MMM d')}
                </span>
              )}
            </div>
          </div>
        </div>
      </CardContent>
    </AnimatedCard>
  );
}

function ConnectionsSkeleton() {
  return (
    <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
      {[1, 2, 3, 4, 5, 6].map((i) => (
        <Card key={i}>
          <CardContent className="p-4">
            <div className="flex gap-4">
              <Skeleton className="h-12 w-12 rounded-full" />
              <div className="flex-1 space-y-2">
                <Skeleton className="h-4 w-3/4" />
                <Skeleton className="h-3 w-1/2" />
                <Skeleton className="h-5 w-20" />
              </div>
            </div>
          </CardContent>
        </Card>
      ))}
    </div>
  );
}

export default function NetworkingPage() {
  const [searchQuery, setSearchQuery] = useState('');
  const [addDialogOpen, setAddDialogOpen] = useState(false);
  
  const { data: connections, isLoading: connectionsLoading } = useConnections();
  const { data: referrals, isLoading: referralsLoading } = useReferrals();
  const { data: events, isLoading: eventsLoading } = useNetworkingEvents();
  const { data: mentorships, isLoading: mentorshipsLoading } = useMentorships();
  
  const filteredConnections = connections?.filter((c: ProfessionalConnection) =>
    c.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
    c.company.toLowerCase().includes(searchQuery.toLowerCase()) ||
    c.title.toLowerCase().includes(searchQuery.toLowerCase())
  ) || [];

  return (
    <div className="p-6 space-y-6">
      {/* Header with Gradient */}
      <div className="relative overflow-hidden rounded-2xl bg-gradient-to-r from-indigo-600 via-purple-600 to-pink-600 p-8">
        <div className="absolute top-0 right-0 w-64 h-64 bg-white/10 rounded-full blur-3xl -translate-y-1/2 translate-x-1/2" />
        <div className="absolute bottom-0 left-0 w-48 h-48 bg-white/5 rounded-full blur-2xl translate-y-1/2 -translate-x-1/2" />
        <div className="absolute top-1/2 right-1/4 w-32 h-32 bg-pink-400/20 rounded-full blur-xl" />
        
        <div className="relative flex flex-col sm:flex-row sm:items-center sm:justify-between gap-6">
          <div className="animate-fade-in-up">
            <h1 className="text-3xl font-bold text-white flex items-center gap-3">
              <div className="p-2 bg-white/20 rounded-xl backdrop-blur-sm">
                <Users className="h-7 w-7" />
              </div>
              Professional Network
            </h1>
            <p className="text-white/80 mt-2 max-w-md">
              Manage your connections, referrals, and mentorship relationships
            </p>
          </div>
          
          <Dialog open={addDialogOpen} onOpenChange={setAddDialogOpen}>
            <DialogTrigger asChild>
              <Button className="bg-white text-indigo-600 hover:bg-white/90 shadow-lg animate-fade-in-up stagger-2">
                <UserPlus className="h-4 w-4 mr-2" />
                Add Connection
              </Button>
            </DialogTrigger>
            <DialogContent>
              <DialogHeader>
                <DialogTitle className="flex items-center gap-2">
                  <div className="p-2 bg-gradient-to-br from-primary to-purple-600 rounded-lg">
                    <UserPlus className="h-4 w-4 text-white" />
                  </div>
                  Add New Connection
                </DialogTitle>
                <DialogDescription>
                  Add a professional connection to your network.
                </DialogDescription>
              </DialogHeader>
              <div className="text-muted-foreground text-center py-8">
                Connection form coming soon...
              </div>
            </DialogContent>
          </Dialog>
        </div>

        <div className="relative grid grid-cols-2 sm:grid-cols-4 gap-4 mt-6 animate-fade-in-up stagger-3">
          <div className="bg-white/10 backdrop-blur-sm rounded-xl p-4 border border-white/20">
            <p className="text-white/70 text-sm">Connections</p>
            <p className="text-2xl font-bold text-white">
              <AnimatedNumber value={connections?.length ?? 0} />
            </p>
          </div>
          <div className="bg-white/10 backdrop-blur-sm rounded-xl p-4 border border-white/20">
            <p className="text-white/70 text-sm">Referrals</p>
            <p className="text-2xl font-bold text-white">
              <AnimatedNumber value={referrals?.length ?? 0} />
            </p>
          </div>
          <div className="bg-white/10 backdrop-blur-sm rounded-xl p-4 border border-white/20">
            <p className="text-white/70 text-sm">Events</p>
            <p className="text-2xl font-bold text-white">
              <AnimatedNumber value={events?.length ?? 0} />
            </p>
          </div>
          <div className="bg-white/10 backdrop-blur-sm rounded-xl p-4 border border-white/20">
            <p className="text-white/70 text-sm">Mentorships</p>
            <p className="text-2xl font-bold text-white">
              <AnimatedNumber value={mentorships?.length ?? 0} />
            </p>
          </div>
        </div>
      </div>

      {/* Tabs */}
      <Tabs defaultValue="connections" className="space-y-4">
        <TabsList className="bg-muted/50 p-1 rounded-xl">
          <TabsTrigger value="connections" className="rounded-lg data-[state=active]:bg-white data-[state=active]:shadow-sm">
            <Users className="h-4 w-4 mr-2" />
            Connections
          </TabsTrigger>
          <TabsTrigger value="referrals" className="rounded-lg data-[state=active]:bg-white data-[state=active]:shadow-sm">
            <Handshake className="h-4 w-4 mr-2" />
            Referrals
          </TabsTrigger>
          <TabsTrigger value="events" className="rounded-lg data-[state=active]:bg-white data-[state=active]:shadow-sm">
            <Calendar className="h-4 w-4 mr-2" />
            Events
          </TabsTrigger>
          <TabsTrigger value="mentorship" className="rounded-lg data-[state=active]:bg-white data-[state=active]:shadow-sm">
            <GraduationCap className="h-4 w-4 mr-2" />
            Mentorship
          </TabsTrigger>
        </TabsList>

        <TabsContent value="connections" className="space-y-4">
          {/* Search */}
          <div className="flex gap-2">
            <div className="relative flex-1">
              <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
              <Input
                placeholder="Search connections..."
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                className="pl-9 rounded-xl"
              />
            </div>
            <Button variant="outline" className="rounded-xl">
              <Filter className="h-4 w-4 mr-2" />
              Filter
            </Button>
          </div>

          {/* Connections Grid */}
          {connectionsLoading ? (
            <ConnectionsSkeleton />
          ) : filteredConnections.length > 0 ? (
            <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
              {filteredConnections.map((connection: ProfessionalConnection, index: number) => (
                <ConnectionCard key={connection.id} connection={connection} index={index} />
              ))}
            </div>
          ) : (
            <AnimatedEmptyState
              icon={<Users className="h-12 w-12" />}
              title="No connections yet"
              description="Start building your professional network by adding connections."
              action={
                <GradientButton onClick={() => setAddDialogOpen(true)}>
                  <UserPlus className="h-4 w-4 mr-2" />
                  Add Your First Connection
                </GradientButton>
              }
            />
          )}
        </TabsContent>

        <TabsContent value="referrals">
          <AnimatedCard variant="default">
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <div className="p-2 bg-gradient-to-br from-amber-500 to-orange-600 rounded-lg">
                  <Handshake className="h-4 w-4 text-white" />
                </div>
                Referrals
              </CardTitle>
              <CardDescription>Track referrals you&apos;ve received or given</CardDescription>
            </CardHeader>
            <CardContent>
              {referralsLoading ? (
                <Skeleton className="h-32" />
              ) : (referrals?.length ?? 0) > 0 ? (
                <div className="space-y-4">
                  {referrals?.map((referral: Referral, index: number) => (
                    <div key={referral.id} className={`flex items-center justify-between p-4 rounded-xl bg-gradient-to-r from-amber-50 to-orange-50 border border-amber-200 animate-fade-in-up stagger-${Math.min(index + 1, 4)}`}>
                      <div>
                        <p className="font-medium">Referral for {referral.application}</p>
                        <p className="text-sm text-muted-foreground">
                          From: {referral.referrer}
                        </p>
                      </div>
                      <Badge className="bg-gradient-to-r from-amber-500 to-orange-600 text-white">{referral.referral_status}</Badge>
                    </div>
                  ))}
                </div>
              ) : (
                <div className="text-center py-8 text-muted-foreground">
                  No referrals tracked yet
                </div>
              )}
            </CardContent>
          </AnimatedCard>
        </TabsContent>

        <TabsContent value="events">
          <AnimatedCard variant="default">
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <div className="p-2 bg-gradient-to-br from-blue-500 to-indigo-600 rounded-lg">
                  <Calendar className="h-4 w-4 text-white" />
                </div>
                Networking Events
              </CardTitle>
              <CardDescription>Track conferences, meetups, and career fairs</CardDescription>
            </CardHeader>
            <CardContent>
              {eventsLoading ? (
                <Skeleton className="h-32" />
              ) : (events?.length ?? 0) > 0 ? (
                <div className="space-y-4">
                  {events?.map((event: NetworkingEvent, index: number) => (
                    <div key={event.id} className={`flex items-center justify-between p-4 rounded-xl bg-gradient-to-r from-blue-50 to-indigo-50 border border-blue-200 animate-fade-in-up stagger-${Math.min(index + 1, 4)}`}>
                      <div>
                        <p className="font-medium">{event.name}</p>
                        <p className="text-sm text-muted-foreground">
                          {format(new Date(event.date), 'PPP')} • {event.location}
                        </p>
                      </div>
                      <Badge variant="outline" className="bg-blue-100 text-blue-700 border-blue-200">{event.connections_made} connections</Badge>
                    </div>
                  ))}
                </div>
              ) : (
                <div className="text-center py-8 text-muted-foreground">
                  No events tracked yet
                </div>
              )}
            </CardContent>
          </AnimatedCard>
        </TabsContent>

        <TabsContent value="mentorship">
          <AnimatedCard variant="default">
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <div className="p-2 bg-gradient-to-br from-rose-500 to-pink-600 rounded-lg">
                  <GraduationCap className="h-4 w-4 text-white" />
                </div>
                Mentorship Relationships
              </CardTitle>
              <CardDescription>Manage your mentor connections and sessions</CardDescription>
            </CardHeader>
            <CardContent>
              {mentorshipsLoading ? (
                <Skeleton className="h-32" />
              ) : (mentorships?.length ?? 0) > 0 ? (
                <div className="space-y-4">
                  {mentorships?.map((mentorship: MentorshipRelationship, index: number) => (
                    <div key={mentorship.id} className={`p-4 rounded-xl bg-gradient-to-r from-rose-50 to-pink-50 border border-rose-200 animate-fade-in-up stagger-${Math.min(index + 1, 4)}`}>
                      <div className="flex items-center justify-between">
                        <p className="font-medium">{mentorship.mentor}</p>
                        <Badge className="bg-gradient-to-r from-rose-500 to-pink-600 text-white">{mentorship.status}</Badge>
                      </div>
                      <p className="text-sm text-muted-foreground mt-1">
                        {mentorship.total_sessions} sessions • {mentorship.meeting_frequency}
                      </p>
                    </div>
                  ))}
                </div>
              ) : (
                <div className="text-center py-8 text-muted-foreground">
                  No mentorship relationships yet
                </div>
              )}
            </CardContent>
          </AnimatedCard>
        </TabsContent>
      </Tabs>
    </div>
  );
}
