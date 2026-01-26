'use client';

import { useState } from 'react';
import {
  Target,
  BookOpen,
  Briefcase,
  Plus,
  BarChart3,
  Code,
  ExternalLink,
  Github,
  CheckCircle2,
  Clock,
  Sparkles,
} from 'lucide-react';

// import { AnimatedCard } from '@/components/ui/animated-card';
// import { GradientButton, AnimatedNumber, EmptyState as AnimatedEmptyState } from '@/components/ui/animated-elements';
import { format } from 'date-fns';

import { Button } from '@/components/ui/button';
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from '@/components/ui/card';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { Badge } from '@/components/ui/badge';
import { Progress } from '@/components/ui/progress';
import { Skeleton } from '@/components/ui/skeleton';
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from '@/components/ui/dialog';
import {
  useUserSkills,
  useSkillGapAnalysis,
  useLearningProgress,
  usePortfolioProjects,
  useCareerGoals,
} from '@/hooks/use-queries';
import type { UserSkill, SkillGapAnalysis, UserLearningProgress, PortfolioProject, CareerGoal } from '@/types';

const PROFICIENCY_LABELS: Record<number, string> = {
  1: 'Beginner',
  2: 'Elementary',
  3: 'Intermediate',
  4: 'Advanced',
  5: 'Expert',
};

const PROFICIENCY_COLORS: Record<number, string> = {
  1: 'bg-red-100 text-red-700',
  2: 'bg-orange-100 text-orange-700',
  3: 'bg-yellow-100 text-yellow-700',
  4: 'bg-green-100 text-green-700',
  5: 'bg-emerald-100 text-emerald-700',
};

function SkillCard({ skill }: { skill: UserSkill }) {
  return (
    <div className="flex items-center justify-between p-3 border rounded-lg">
      <div className="flex items-center gap-3">
        <div className="p-2 bg-primary/10 rounded-lg">
          <Code className="h-4 w-4 text-primary" />
        </div>
        <div>
          <p className="font-medium">{skill.skill_details?.name || skill.skill}</p>
          {skill.years_experience && (
            <p className="text-xs text-muted-foreground">{skill.years_experience} years</p>
          )}
        </div>
      </div>
      <div className="flex items-center gap-2">
        {skill.is_verified && (
          <CheckCircle2 className="h-4 w-4 text-green-500" />
        )}
        <Badge className={PROFICIENCY_COLORS[skill.proficiency_level]}>
          {PROFICIENCY_LABELS[skill.proficiency_level]}
        </Badge>
      </div>
    </div>
  );
}

function SkillGapCard({ analysis }: { analysis: SkillGapAnalysis }) {
  return (
    <Card>
      <CardHeader className="pb-2">
        <div className="flex items-center justify-between">
          <CardTitle className="text-base">{analysis.job_title}</CardTitle>
          <Badge variant="outline" className="text-lg font-bold">
            {analysis.match_percentage}%
          </Badge>
        </div>
        <CardDescription>{analysis.target_company}</CardDescription>
      </CardHeader>
      <CardContent>
        <Progress value={analysis.match_percentage} className="h-2 mb-4" />
        
        {analysis.missing_skills.length > 0 && (
          <div className="mb-3">
            <p className="text-sm font-medium text-red-600 mb-1">Missing Skills</p>
            <div className="flex flex-wrap gap-1">
              {analysis.missing_skills.map((skill) => (
                <Badge key={skill} variant="outline" className="bg-red-50 text-red-700 border-red-200">
                  {skill}
                </Badge>
              ))}
            </div>
          </div>
        )}
        
        {analysis.strong_skills.length > 0 && (
          <div>
            <p className="text-sm font-medium text-green-600 mb-1">Strong Skills</p>
            <div className="flex flex-wrap gap-1">
              {analysis.strong_skills.map((skill) => (
                <Badge key={skill} variant="outline" className="bg-green-50 text-green-700 border-green-200">
                  {skill}
                </Badge>
              ))}
            </div>
          </div>
        )}
      </CardContent>
    </Card>
  );
}

function ProjectCard({ project }: { project: PortfolioProject }) {
  return (
    <Card className="overflow-hidden">
      {project.featured_image && (
        <div className="aspect-video bg-muted relative">
          {/* eslint-disable-next-line @next/next/no-img-element */}
          <img
            src={project.featured_image}
            alt={project.title}
            className="object-cover w-full h-full"
          />
        </div>
      )}
      <CardContent className="p-4">
        <div className="flex items-start justify-between">
          <div>
            <h3 className="font-semibold">{project.title}</h3>
            <p className="text-sm text-muted-foreground line-clamp-2">{project.description}</p>
          </div>
          {project.is_featured && (
            <Badge className="bg-amber-100 text-amber-700">Featured</Badge>
          )}
        </div>
        
        <div className="flex flex-wrap gap-1 mt-3">
          {project.technologies.slice(0, 4).map((tech) => (
            <Badge key={tech} variant="secondary" className="text-xs">
              {tech}
            </Badge>
          ))}
          {project.technologies.length > 4 && (
            <Badge variant="secondary" className="text-xs">
              +{project.technologies.length - 4}
            </Badge>
          )}
        </div>
        
        <div className="flex items-center gap-2 mt-4">
          {project.project_url && (
            <Button variant="outline" size="sm" asChild>
              <a href={project.project_url} target="_blank" rel="noopener noreferrer">
                <ExternalLink className="h-3 w-3 mr-1" />
                Demo
              </a>
            </Button>
          )}
          {project.github_url && (
            <Button variant="outline" size="sm" asChild>
              <a href={project.github_url} target="_blank" rel="noopener noreferrer">
                <Github className="h-3 w-3 mr-1" />
                Code
              </a>
            </Button>
          )}
        </div>
      </CardContent>
    </Card>
  );
}

function GoalCard({ goal }: { goal: CareerGoal }) {
  const statusColors: Record<string, string> = {
    not_started: 'bg-gray-100 text-gray-700',
    in_progress: 'bg-blue-100 text-blue-700',
    completed: 'bg-green-100 text-green-700',
    abandoned: 'bg-red-100 text-red-700',
  };

  return (
    <Card>
      <CardContent className="p-4">
        <div className="flex items-start justify-between mb-3">
          <div>
            <h3 className="font-semibold">{goal.title}</h3>
            <p className="text-sm text-muted-foreground">{goal.description}</p>
          </div>
          <Badge className={statusColors[goal.status]}>{goal.status.replace('_', ' ')}</Badge>
        </div>
        
        <div className="space-y-2">
          <div className="flex items-center justify-between text-sm">
            <span className="text-muted-foreground">Progress</span>
            <span className="font-medium">{goal.progress_percentage}%</span>
          </div>
          <Progress value={goal.progress_percentage} className="h-2" />
        </div>
        
        {goal.target_date && (
          <div className="flex items-center gap-1 mt-3 text-sm text-muted-foreground">
            <Clock className="h-3 w-3" />
            Target: {format(new Date(goal.target_date), 'MMM d, yyyy')}
          </div>
        )}
        
        {goal.milestones.length > 0 && (
          <div className="mt-3 space-y-1">
            {goal.milestones.slice(0, 3).map((milestone, i) => (
              <div key={i} className="flex items-center gap-2 text-sm">
                <CheckCircle2
                  className={`h-3 w-3 ${milestone.completed ? 'text-green-500' : 'text-gray-300'}`}
                />
                <span className={milestone.completed ? 'line-through text-muted-foreground' : ''}>
                  {milestone.title}
                </span>
              </div>
            ))}
          </div>
        )}
      </CardContent>
    </Card>
  );
}

export default function CareerPage() {
  const [analyzeDialogOpen, setAnalyzeDialogOpen] = useState(false);
  
  const { data: skills, isLoading: skillsLoading } = useUserSkills();
  const { data: skillGaps, isLoading: skillGapsLoading } = useSkillGapAnalysis();
  const { data: learningProgress, isLoading: learningLoading } = useLearningProgress();
  const { data: projects, isLoading: projectsLoading } = usePortfolioProjects();
  const { data: goals, isLoading: goalsLoading } = useCareerGoals();

  return (
    <div className="p-6 space-y-6">
      {/* Header with Gradient */}
      <div className="relative overflow-hidden rounded-2xl bg-gradient-to-r from-emerald-500 via-teal-500 to-green-500 p-8">
        <div className="absolute top-0 right-0 w-64 h-64 bg-white/10 rounded-full blur-3xl -translate-y-1/2 translate-x-1/2" />
        <div className="absolute bottom-0 left-0 w-48 h-48 bg-white/5 rounded-full blur-2xl translate-y-1/2 -translate-x-1/2" />
        <div className="absolute top-1/2 right-1/4 w-32 h-32 bg-emerald-300/20 rounded-full blur-xl" />
        
        <div className="relative flex flex-col sm:flex-row sm:items-center sm:justify-between gap-6">
          <div className="animate-fade-in-up">
            <h1 className="text-3xl font-bold text-white flex items-center gap-3">
              <div className="p-2 bg-white/20 rounded-xl backdrop-blur-sm">
                <Target className="h-7 w-7" />
              </div>
              Career Development
            </h1>
            <p className="text-white/80 mt-2 max-w-md">
              Track your skills, learning progress, and career goals
            </p>
          </div>
          
          <Dialog open={analyzeDialogOpen} onOpenChange={setAnalyzeDialogOpen}>
            <DialogTrigger asChild>
              <Button className="bg-white/20 hover:bg-white/30 text-white border-white/30">
                <Sparkles className="h-4 w-4 mr-2" />
                Analyze Skill Gap
              </Button>
            </DialogTrigger>
            <DialogContent>
              <DialogHeader>
                <DialogTitle>Skill Gap Analysis</DialogTitle>
                <DialogDescription>
                  Enter a target role to analyze your skill gaps.
                </DialogDescription>
              </DialogHeader>
              <div className="text-muted-foreground text-center py-8">
                Analysis form coming soon...
              </div>
            </DialogContent>
          </Dialog>
        </div>
      </div>

      {/* Stats */}
      <div className="grid gap-4 md:grid-cols-4">
        <Card>
          <CardHeader className="flex flex-row items-center justify-between pb-2">
            <CardTitle className="text-sm font-medium">Skills</CardTitle>
            <Code className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{skills?.length || 0}</div>
          </CardContent>
        </Card>
        
        <Card>
          <CardHeader className="flex flex-row items-center justify-between pb-2">
            <CardTitle className="text-sm font-medium">In Progress</CardTitle>
            <BookOpen className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">
              {learningProgress?.filter((p: Record<string, unknown>) => p.status === 'in_progress').length || 0}
            </div>
          </CardContent>
        </Card>
        
        <Card>
          <CardHeader className="flex flex-row items-center justify-between pb-2">
            <CardTitle className="text-sm font-medium">Projects</CardTitle>
            <Briefcase className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{projects?.length || 0}</div>
          </CardContent>
        </Card>
        
        <Card>
          <CardHeader className="flex flex-row items-center justify-between pb-2">
            <CardTitle className="text-sm font-medium">Goals</CardTitle>
            <Target className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{goals?.length || 0}</div>
          </CardContent>
        </Card>
      </div>

      {/* Tabs */}
      <Tabs defaultValue="skills" className="space-y-4">
        <TabsList>
          <TabsTrigger value="skills">
            <Code className="h-4 w-4 mr-2" />
            Skills
          </TabsTrigger>
          <TabsTrigger value="learning">
            <BookOpen className="h-4 w-4 mr-2" />
            Learning
          </TabsTrigger>
          <TabsTrigger value="portfolio">
            <Briefcase className="h-4 w-4 mr-2" />
            Portfolio
          </TabsTrigger>
          <TabsTrigger value="goals">
            <Target className="h-4 w-4 mr-2" />
            Goals
          </TabsTrigger>
        </TabsList>

        <TabsContent value="skills" className="space-y-4">
          <div className="grid gap-6 lg:grid-cols-2">
            {/* My Skills */}
            <Card>
              <CardHeader>
                <div className="flex items-center justify-between">
                  <CardTitle>My Skills</CardTitle>
                  <Button size="sm">
                    <Plus className="h-4 w-4 mr-1" />
                    Add Skill
                  </Button>
                </div>
              </CardHeader>
              <CardContent>
                {skillsLoading ? (
                  <div className="space-y-2">
                    {[1, 2, 3].map((i) => (
                      <Skeleton key={i} className="h-14" />
                    ))}
                  </div>
                ) : skills && skills.length > 0 ? (
                  <div className="space-y-2">
                    {skills.map((skill: UserSkill) => (
                      <SkillCard key={skill.id} skill={skill} />
                    ))}
                  </div>
                ) : (
                  <div className="text-center py-8 text-muted-foreground">
                    No skills added yet. Start by adding your top skills.
                  </div>
                )}
              </CardContent>
            </Card>

            {/* Skill Gap Analysis */}
            <div className="space-y-4">
              <h3 className="text-lg font-semibold">Skill Gap Analyses</h3>
              {skillGapsLoading ? (
                <Skeleton className="h-48" />
              ) : skillGaps && skillGaps.length > 0 ? (
                skillGaps.map((analysis: SkillGapAnalysis) => (
                  <SkillGapCard key={analysis.id} analysis={analysis} />
                ))
              ) : (
                <Card>
                  <CardContent className="flex flex-col items-center justify-center py-8">
                    <BarChart3 className="h-12 w-12 text-muted-foreground mb-4" />
                    <p className="text-muted-foreground text-center">
                      Run a skill gap analysis to see how you match up against job requirements.
                    </p>
                  </CardContent>
                </Card>
              )}
            </div>
          </div>
        </TabsContent>

        <TabsContent value="learning">
          <Card>
            <CardHeader>
              <CardTitle>Learning Progress</CardTitle>
              <CardDescription>Track courses, certifications, and learning resources</CardDescription>
            </CardHeader>
            <CardContent>
              {learningLoading ? (
                <Skeleton className="h-32" />
              ) : learningProgress && learningProgress.length > 0 ? (
                <div className="space-y-4">
                  {learningProgress.map((progress: UserLearningProgress) => (
                    <div key={progress.id} className="p-4 border rounded-lg">
                      <div className="flex items-center justify-between mb-2">
                        <h4 className="font-medium">{progress.resource_details?.title || progress.resource}</h4>
                        <Badge>{progress.status.replace('_', ' ')}</Badge>
                      </div>
                      <Progress value={progress.progress_percentage} className="h-2" />
                      <p className="text-sm text-muted-foreground mt-2">
                        {progress.hours_spent} hours spent
                      </p>
                    </div>
                  ))}
                </div>
              ) : (
                <div className="text-center py-8 text-muted-foreground">
                  <BookOpen className="h-12 w-12 mx-auto mb-4 opacity-50" />
                  <p>No learning progress tracked yet</p>
                </div>
              )}
            </CardContent>
          </Card>
        </TabsContent>

        <TabsContent value="portfolio">
          <div className="flex items-center justify-between mb-4">
            <h3 className="text-lg font-semibold">Portfolio Projects</h3>
            <Button>
              <Plus className="h-4 w-4 mr-2" />
              Add Project
            </Button>
          </div>
          
          {projectsLoading ? (
            <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
              {[1, 2, 3].map((i) => (
                <Skeleton key={i} className="h-64" />
              ))}
            </div>
          ) : projects && projects.length > 0 ? (
            <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
              {projects.map((project: PortfolioProject) => (
                <ProjectCard key={project.id} project={project} />
              ))}
            </div>
          ) : (
            <Card>
              <CardContent className="flex flex-col items-center justify-center py-12">
                <Briefcase className="h-12 w-12 text-muted-foreground mb-4" />
                <h3 className="text-lg font-semibold">No projects yet</h3>
                <p className="text-muted-foreground text-center mt-1">
                  Showcase your work by adding portfolio projects.
                </p>
              </CardContent>
            </Card>
          )}
        </TabsContent>

        <TabsContent value="goals">
          <div className="flex items-center justify-between mb-4">
            <h3 className="text-lg font-semibold">Career Goals</h3>
            <Button>
              <Plus className="h-4 w-4 mr-2" />
              Add Goal
            </Button>
          </div>
          
          {goalsLoading ? (
            <div className="grid gap-4 md:grid-cols-2">
              {[1, 2].map((i) => (
                <Skeleton key={i} className="h-48" />
              ))}
            </div>
          ) : goals && goals.length > 0 ? (
            <div className="grid gap-4 md:grid-cols-2">
              {goals.map((goal: CareerGoal) => (
                <GoalCard key={goal.id} goal={goal} />
              ))}
            </div>
          ) : (
            <Card>
              <CardContent className="flex flex-col items-center justify-center py-12">
                <Target className="h-12 w-12 text-muted-foreground mb-4" />
                <h3 className="text-lg font-semibold">No goals set</h3>
                <p className="text-muted-foreground text-center mt-1">
                  Set career goals to track your progress and stay motivated.
                </p>
              </CardContent>
            </Card>
          )}
        </TabsContent>
      </Tabs>
    </div>
  );
}
