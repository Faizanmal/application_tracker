'use client';

import { useState } from 'react';
import {
  Trophy,
  Flame,
  Star,
  Target,
  Users,
  Medal,
  Crown,
  MessageSquare,
  ArrowUp,
  Sparkles,
} from 'lucide-react';

// import { AnimatedCard } from '@/components/ui/animated-card';
// import { GradientButton, AnimatedNumber, EmptyState as AnimatedEmptyState } from '@/components/ui/animated-elements';

import { Button } from '@/components/ui/button';
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from '@/components/ui/card';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { Badge } from '@/components/ui/badge';
import { Progress } from '@/components/ui/progress';
import { Skeleton } from '@/components/ui/skeleton';
import { Avatar, AvatarFallback } from '@/components/ui/avatar';
import {
  useUserAchievements,
  usePoints,
  useStreaks,
  useLeaderboard,
  useChallenges,
  useUserChallenges,
  useCommunityPosts,
  useJoinChallenge,
  useUpvotePost,
} from '@/hooks/use-queries';
import type { UserAchievement, UserStreak, Challenge, UserChallenge, CommunityPost, LeaderboardEntry } from '@/types';

const TIER_COLORS: Record<string, string> = {
  bronze: 'from-amber-600 to-amber-800',
  silver: 'from-gray-400 to-gray-600',
  gold: 'from-yellow-400 to-yellow-600',
  platinum: 'from-cyan-400 to-cyan-600',
  diamond: 'from-purple-400 to-purple-600',
};

const TIER_ICONS: Record<string, string> = {
  bronze: '🥉',
  silver: '🥈',
  gold: '🥇',
  platinum: '💎',
  diamond: '👑',
};

function AchievementCard({ achievement }: { achievement: UserAchievement }) {
  const isEarned = !!achievement.earned_at;
  const details = achievement.achievement_details;
  
  return (
    <div
      className={`p-4 rounded-lg border-2 transition-all ${
        isEarned
          ? 'bg-gradient-to-br ' + TIER_COLORS[details?.tier || 'bronze'] + ' text-white border-transparent'
          : 'bg-muted/50 border-dashed border-muted-foreground/30'
      }`}
    >
      <div className="flex items-center gap-3">
        <div className={`text-3xl ${!isEarned && 'grayscale opacity-50'}`}>
          {details?.icon || TIER_ICONS[details?.tier || 'bronze']}
        </div>
        <div className="flex-1">
          <h4 className={`font-semibold ${!isEarned && 'text-muted-foreground'}`}>
            {details?.name || 'Achievement'}
          </h4>
          <p className={`text-sm ${isEarned ? 'text-white/80' : 'text-muted-foreground'}`}>
            {details?.description}
          </p>
        </div>
        {isEarned && (
          <Badge className="bg-white/20 text-white">
            +{details?.points || 0} pts
          </Badge>
        )}
      </div>
      
      {!isEarned && achievement.progress > 0 && (
        <div className="mt-3">
          <Progress value={achievement.progress} className="h-2" />
          <p className="text-xs text-muted-foreground mt-1">{achievement.progress}% complete</p>
        </div>
      )}
    </div>
  );
}

function StreakCard({ streak }: { streak: UserStreak }) {
  const streakLabels: Record<string, string> = {
    daily_login: 'Daily Login',
    daily_application: 'Daily Application',
    weekly_goal: 'Weekly Goal',
    learning: 'Learning',
  };

  return (
    <Card>
      <CardContent className="p-4">
        <div className="flex items-center gap-3">
          <div className="p-3 bg-orange-100 rounded-full">
            <Flame className="h-6 w-6 text-orange-500" />
          </div>
          <div className="flex-1">
            <p className="text-sm text-muted-foreground">{streakLabels[streak.streak_type]}</p>
            <div className="flex items-baseline gap-2">
              <span className="text-3xl font-bold">{streak.current_streak}</span>
              <span className="text-sm text-muted-foreground">days</span>
            </div>
          </div>
          <div className="text-right">
            <p className="text-xs text-muted-foreground">Best</p>
            <p className="font-semibold">{streak.longest_streak}</p>
          </div>
        </div>
      </CardContent>
    </Card>
  );
}

function ChallengeCard({ 
  challenge, 
  userChallenge,
  onJoin 
}: { 
  challenge: Challenge;
  userChallenge?: UserChallenge;
  onJoin: () => void;
}) {
  const isJoined = !!userChallenge;
  const progress = userChallenge?.progress || 0;
  const isCompleted = userChallenge?.completed;

  return (
    <Card className={isCompleted ? 'bg-green-50 border-green-200' : ''}>
      <CardContent className="p-4">
        <div className="flex items-start justify-between mb-3">
          <div>
            <h4 className="font-semibold flex items-center gap-2">
              {challenge.title}
              {isCompleted && <CheckCircle2 className="h-4 w-4 text-green-500" />}
            </h4>
            <p className="text-sm text-muted-foreground">{challenge.description}</p>
          </div>
          <Badge variant="outline" className="shrink-0">
            +{challenge.points_reward} pts
          </Badge>
        </div>
        
        {isJoined && (
          <div className="mb-3">
            <div className="flex items-center justify-between text-sm mb-1">
              <span>{progress} / {challenge.target_count}</span>
              <span>{Math.round((progress / challenge.target_count) * 100)}%</span>
            </div>
            <Progress value={(progress / challenge.target_count) * 100} className="h-2" />
          </div>
        )}
        
        <div className="flex items-center justify-between">
          <p className="text-xs text-muted-foreground">
            Ends: {new Date(challenge.end_date).toLocaleDateString()}
          </p>
          {!isJoined && (
            <Button size="sm" onClick={onJoin}>
              Join Challenge
            </Button>
          )}
        </div>
      </CardContent>
    </Card>
  );
}

function CommunityPostCard({ 
  post, 
  onUpvote 
}: { 
  post: CommunityPost;
  onUpvote: () => void;
}) {
  const typeLabels: Record<string, { label: string; color: string }> = {
    success_story: { label: 'Success Story', color: 'bg-green-100 text-green-700' },
    tip: { label: 'Tip', color: 'bg-blue-100 text-blue-700' },
    question: { label: 'Question', color: 'bg-purple-100 text-purple-700' },
    discussion: { label: 'Discussion', color: 'bg-gray-100 text-gray-700' },
    resource: { label: 'Resource', color: 'bg-amber-100 text-amber-700' },
  };

  const typeInfo = typeLabels[post.post_type] || typeLabels.discussion;

  return (
    <Card>
      <CardContent className="p-4">
        <div className="flex items-start gap-3">
          <Avatar className="h-10 w-10">
            <AvatarFallback>
              {post.is_anonymous ? '?' : 'U'}
            </AvatarFallback>
          </Avatar>
          
          <div className="flex-1 min-w-0">
            <div className="flex items-center gap-2 mb-1">
              <Badge className={typeInfo.color}>{typeInfo.label}</Badge>
              {post.is_anonymous && (
                <span className="text-xs text-muted-foreground">Anonymous</span>
              )}
            </div>
            
            <h4 className="font-semibold">{post.title}</h4>
            <p className="text-sm text-muted-foreground line-clamp-2 mt-1">
              {post.content}
            </p>
            
            <div className="flex items-center gap-4 mt-3">
              <Button
                variant="ghost"
                size="sm"
                className="gap-1 text-muted-foreground hover:text-primary"
                onClick={onUpvote}
              >
                <ArrowUp className="h-4 w-4" />
                {post.upvotes_count}
              </Button>
              <Button variant="ghost" size="sm" className="gap-1 text-muted-foreground">
                <MessageSquare className="h-4 w-4" />
                {post.comments_count}
              </Button>
            </div>
          </div>
        </div>
      </CardContent>
    </Card>
  );
}

// Import CheckCircle2 that was missing
import { CheckCircle2 } from 'lucide-react';

export default function GamificationPage() {
  const [leaderboardPeriod, setLeaderboardPeriod] = useState<'weekly' | 'monthly'>('weekly');
  
  const { data: userAchievements, isLoading: achievementsLoading } = useUserAchievements();
  const { data: points } = usePoints();
  const { data: streaks, isLoading: streaksLoading } = useStreaks();
  const { data: leaderboard, isLoading: leaderboardLoading } = useLeaderboard(leaderboardPeriod);
  const { data: challenges, isLoading: challengesLoading } = useChallenges();
  const { data: userChallenges } = useUserChallenges();
  const { data: communityPosts, isLoading: postsLoading } = useCommunityPosts();
  
  const joinChallenge = useJoinChallenge();
  const upvotePost = useUpvotePost();

  // Calculate level from points
  const level = points?.level || 1;
  const totalPoints = points?.total_points || 0;
  const pointsToNextLevel = (level * 100) - (totalPoints % (level * 100));

  return (
    <div className="p-6 space-y-6">
      {/* Header with Gradient */}
      <div className="relative overflow-hidden rounded-2xl bg-gradient-to-r from-amber-500 via-yellow-500 to-orange-500 p-8">
        <div className="absolute top-0 right-0 w-64 h-64 bg-white/10 rounded-full blur-3xl -translate-y-1/2 translate-x-1/2" />
        <div className="absolute bottom-0 left-0 w-48 h-48 bg-white/5 rounded-full blur-2xl translate-y-1/2 -translate-x-1/2" />
        <div className="absolute top-1/2 right-1/4 w-32 h-32 bg-amber-300/20 rounded-full blur-xl" />
        
        <div className="relative flex flex-col sm:flex-row sm:items-center sm:justify-between gap-6">
          <div className="animate-fade-in-up">
            <h1 className="text-3xl font-bold text-white flex items-center gap-3">
              <div className="p-2 bg-white/20 rounded-xl backdrop-blur-sm">
                <Trophy className="h-7 w-7" />
              </div>
              Achievements & Progress
            </h1>
            <p className="text-white/80 mt-2 max-w-md">
              Track your accomplishments and compete with the community
            </p>
          </div>
        </div>
      </div>

      {/* Stats Overview */}
      <div className="grid gap-4 md:grid-cols-4">
        <Card className="bg-gradient-to-br from-primary to-primary/80 text-primary-foreground">
          <CardContent className="p-4">
            <div className="flex items-center gap-3">
              <div className="p-2 bg-white/20 rounded-lg">
                <Crown className="h-6 w-6" />
              </div>
              <div>
                <p className="text-sm opacity-80">Level</p>
                <p className="text-3xl font-bold">{level}</p>
              </div>
            </div>
            <div className="mt-3">
              <Progress value={100 - (pointsToNextLevel / (level * 100) * 100)} className="h-2 bg-white/20" />
              <p className="text-xs mt-1 opacity-80">{pointsToNextLevel} pts to next level</p>
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardContent className="p-4">
            <div className="flex items-center gap-3">
              <div className="p-2 bg-amber-100 rounded-lg">
                <Star className="h-6 w-6 text-amber-600" />
              </div>
              <div>
                <p className="text-sm text-muted-foreground">Total Points</p>
                <p className="text-3xl font-bold">{totalPoints.toLocaleString()}</p>
              </div>
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardContent className="p-4">
            <div className="flex items-center gap-3">
              <div className="p-2 bg-purple-100 rounded-lg">
                <Trophy className="h-6 w-6 text-purple-600" />
              </div>
              <div>
                <p className="text-sm text-muted-foreground">Achievements</p>
                <p className="text-3xl font-bold">
                  {userAchievements?.filter((a: UserAchievement) => a.earned_at).length || 0}
                </p>
              </div>
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardContent className="p-4">
            <div className="flex items-center gap-3">
              <div className="p-2 bg-orange-100 rounded-lg">
                <Flame className="h-6 w-6 text-orange-600" />
              </div>
              <div>
                <p className="text-sm text-muted-foreground">Best Streak</p>
                <p className="text-3xl font-bold">
                  {streaks?.reduce((max: number, s: UserStreak) => 
                    Math.max(max, s.longest_streak), 0
                  ) || 0}
                </p>
              </div>
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Tabs */}
      <Tabs defaultValue="achievements" className="space-y-4">
        <TabsList>
          <TabsTrigger value="achievements">
            <Trophy className="h-4 w-4 mr-2" />
            Achievements
          </TabsTrigger>
          <TabsTrigger value="streaks">
            <Flame className="h-4 w-4 mr-2" />
            Streaks
          </TabsTrigger>
          <TabsTrigger value="challenges">
            <Target className="h-4 w-4 mr-2" />
            Challenges
          </TabsTrigger>
          <TabsTrigger value="leaderboard">
            <Medal className="h-4 w-4 mr-2" />
            Leaderboard
          </TabsTrigger>
          <TabsTrigger value="community">
            <Users className="h-4 w-4 mr-2" />
            Community
          </TabsTrigger>
        </TabsList>

        <TabsContent value="achievements" className="space-y-4">
          {achievementsLoading ? (
            <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
              {[1, 2, 3, 4, 5, 6].map((i) => (
                <Skeleton key={i} className="h-28" />
              ))}
            </div>
          ) : userAchievements && userAchievements.length > 0 ? (
            <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
              {userAchievements.map((achievement: UserAchievement) => (
                <AchievementCard key={achievement.id} achievement={achievement} />
              ))}
            </div>
          ) : (
            <Card>
              <CardContent className="flex flex-col items-center justify-center py-12">
                <Trophy className="h-12 w-12 text-muted-foreground mb-4" />
                <h3 className="text-lg font-semibold">No achievements yet</h3>
                <p className="text-muted-foreground text-center mt-1">
                  Start applying and engaging to earn achievements!
                </p>
              </CardContent>
            </Card>
          )}
        </TabsContent>

        <TabsContent value="streaks" className="space-y-4">
          {streaksLoading ? (
            <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
              {[1, 2, 3, 4].map((i) => (
                <Skeleton key={i} className="h-24" />
              ))}
            </div>
          ) : streaks && streaks.length > 0 ? (
            <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
              {streaks.map((streak: UserStreak) => (
                <StreakCard key={streak.id} streak={streak} />
              ))}
            </div>
          ) : (
            <Card>
              <CardContent className="flex flex-col items-center justify-center py-12">
                <Flame className="h-12 w-12 text-muted-foreground mb-4" />
                <h3 className="text-lg font-semibold">Start a streak!</h3>
                <p className="text-muted-foreground text-center mt-1">
                  Log in daily and apply to jobs to build your streaks.
                </p>
              </CardContent>
            </Card>
          )}
        </TabsContent>

        <TabsContent value="challenges" className="space-y-4">
          <div className="flex items-center justify-between">
            <h3 className="text-lg font-semibold">Active Challenges</h3>
            <Badge variant="outline" className="gap-1">
              <Sparkles className="h-3 w-3" />
              Earn bonus points
            </Badge>
          </div>
          
          {challengesLoading ? (
            <div className="grid gap-4 md:grid-cols-2">
              {[1, 2, 3, 4].map((i) => (
                <Skeleton key={i} className="h-40" />
              ))}
            </div>
          ) : challenges && challenges.length > 0 ? (
            <div className="grid gap-4 md:grid-cols-2">
              {challenges.filter((c: Challenge) => c.is_active).map((challenge: Challenge) => (
                <ChallengeCard
                  key={challenge.id}
                  challenge={challenge}
                  userChallenge={userChallenges?.find((uc: Record<string, unknown>) => uc.challenge === challenge.id)}
                  onJoin={() => joinChallenge.mutate(challenge.id)}
                />
              ))}
            </div>
          ) : (
            <Card>
              <CardContent className="flex flex-col items-center justify-center py-12">
                <Target className="h-12 w-12 text-muted-foreground mb-4" />
                <h3 className="text-lg font-semibold">No active challenges</h3>
                <p className="text-muted-foreground text-center mt-1">
                  Check back soon for new challenges!
                </p>
              </CardContent>
            </Card>
          )}
        </TabsContent>

        <TabsContent value="leaderboard" className="space-y-4">
          <div className="flex items-center gap-2">
            <Button
              variant={leaderboardPeriod === 'weekly' ? 'default' : 'outline'}
              size="sm"
              onClick={() => setLeaderboardPeriod('weekly')}
            >
              This Week
            </Button>
            <Button
              variant={leaderboardPeriod === 'monthly' ? 'default' : 'outline'}
              size="sm"
              onClick={() => setLeaderboardPeriod('monthly')}
            >
              This Month
            </Button>
          </div>
          
          <Card>
            <CardHeader>
              <CardTitle>Top Performers</CardTitle>
              <CardDescription>See how you rank against other job seekers</CardDescription>
            </CardHeader>
            <CardContent>
              {leaderboardLoading ? (
                <div className="space-y-3">
                  {[1, 2, 3, 4, 5].map((i) => (
                    <Skeleton key={i} className="h-14" />
                  ))}
                </div>
              ) : leaderboard?.results?.length > 0 ? (
                <div className="space-y-2">
                  {leaderboard.results.map((entry: LeaderboardEntry, index: number) => (
                    <div
                      key={entry.id}
                      className={`flex items-center gap-4 p-3 rounded-lg ${
                        index < 3 ? 'bg-amber-50' : 'bg-muted/50'
                      }`}
                    >
                      <div className={`w-8 h-8 flex items-center justify-center rounded-full font-bold ${
                        index === 0 ? 'bg-yellow-400 text-yellow-900' :
                        index === 1 ? 'bg-gray-300 text-gray-700' :
                        index === 2 ? 'bg-amber-600 text-amber-100' :
                        'bg-muted text-muted-foreground'
                      }`}>
                        {index + 1}
                      </div>
                      <Avatar>
                        <AvatarFallback>U{index + 1}</AvatarFallback>
                      </Avatar>
                      <div className="flex-1">
                        <p className="font-medium">User {index + 1}</p>
                        <p className="text-sm text-muted-foreground">Level {entry.level}</p>
                      </div>
                      <div className="text-right">
                        <p className="font-bold">{entry.points?.toLocaleString() || 0}</p>
                        <p className="text-xs text-muted-foreground">points</p>
                      </div>
                    </div>
                  ))}
                </div>
              ) : (
                <div className="text-center py-8 text-muted-foreground">
                  Leaderboard data coming soon
                </div>
              )}
            </CardContent>
          </Card>
        </TabsContent>

        <TabsContent value="community" className="space-y-4">
          <div className="flex items-center justify-between">
            <h3 className="text-lg font-semibold">Community Posts</h3>
            <Button>
              <MessageSquare className="h-4 w-4 mr-2" />
              Create Post
            </Button>
          </div>
          
          {postsLoading ? (
            <div className="space-y-4">
              {[1, 2, 3].map((i) => (
                <Skeleton key={i} className="h-32" />
              ))}
            </div>
          ) : communityPosts && communityPosts.length > 0 ? (
            <div className="space-y-4">
              {communityPosts.map((post: CommunityPost) => (
                <CommunityPostCard
                  key={post.id}
                  post={post}
                  onUpvote={() => upvotePost.mutate(post.id)}
                />
              ))}
            </div>
          ) : (
            <Card>
              <CardContent className="flex flex-col items-center justify-center py-12">
                <Users className="h-12 w-12 text-muted-foreground mb-4" />
                <h3 className="text-lg font-semibold">No community posts yet</h3>
                <p className="text-muted-foreground text-center mt-1">
                  Be the first to share your experience!
                </p>
              </CardContent>
            </Card>
          )}
        </TabsContent>
      </Tabs>
    </div>
  );
}
