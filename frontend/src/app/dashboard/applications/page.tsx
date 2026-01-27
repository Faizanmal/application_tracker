'use client';

import { useState, useMemo } from 'react';
import Link from 'next/link';
import Image from 'next/image';
import { 
  Plus, 
  Search, 
  Filter, 
  Grid3X3,
  List,
  MoreHorizontal,
  Star,
  StarOff,
  ExternalLink,
  Trash2,
  Edit,
  Archive,
  Calendar,
  Building2,
  Briefcase,
  Target,
  CheckSquare,
  Mic,
  Download,
  Upload,
} from 'lucide-react';
import {
  DndContext,
  DragOverlay,
  closestCorners,
  KeyboardSensor,
  PointerSensor,
  useSensor,
  useSensors,
  DragStartEvent,
  DragEndEvent,
  DragOverEvent,
} from '@dnd-kit/core';
import {
  SortableContext,
  sortableKeyboardCoordinates,
  verticalListSortingStrategy,
  useSortable,
} from '@dnd-kit/sortable';
import { CSS } from '@dnd-kit/utilities';
import { format } from 'date-fns';

import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Badge } from '@/components/ui/badge';
import { Skeleton } from '@/components/ui/skeleton';
import { Checkbox } from '@/components/ui/checkbox';
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu';
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
  useKanban, 
  useUpdateKanbanOrder, 
  useDeleteApplication,
  useToggleFavorite,
} from '@/hooks/use-queries';
import { AnimatedNumber } from '@/components/ui/animated-elements';
import { BulkActionsBar, useBulkSelection } from '@/components/applications/bulk-actions';
import { AdvancedSearchPanel } from '@/components/applications/advanced-search';
import { VoiceSearchButton, VoiceDictationButton } from '@/components/voice/voice-features';
import { ImportExportMenu } from '@/components/applications/import-export';
import type { JobApplication, ApplicationStatus } from '@/types';

const STATUS_CONFIG: Record<ApplicationStatus, { label: string; color: string; bgColor: string; gradient: string }> = {
  wishlist: { label: 'Wishlist', color: 'text-slate-600', bgColor: 'bg-slate-100', gradient: 'from-slate-400 to-slate-500' },
  applied: { label: 'Applied', color: 'text-blue-600', bgColor: 'bg-blue-100', gradient: 'from-blue-400 to-blue-600' },
  screening: { label: 'Screening', color: 'text-purple-600', bgColor: 'bg-purple-100', gradient: 'from-purple-400 to-purple-600' },
  interviewing: { label: 'Interviewing', color: 'text-amber-600', bgColor: 'bg-amber-100', gradient: 'from-amber-400 to-orange-500' },
  offer: { label: 'Offer', color: 'text-green-600', bgColor: 'bg-green-100', gradient: 'from-green-400 to-emerald-600' },
  accepted: { label: 'Accepted', color: 'text-emerald-600', bgColor: 'bg-emerald-100', gradient: 'from-emerald-400 to-teal-600' },
  rejected: { label: 'Rejected', color: 'text-red-600', bgColor: 'bg-red-100', gradient: 'from-red-400 to-red-600' },
  withdrawn: { label: 'Withdrawn', color: 'text-gray-600', bgColor: 'bg-gray-100', gradient: 'from-gray-400 to-gray-500' },
  ghosted: { label: 'Ghosted', color: 'text-gray-400', bgColor: 'bg-gray-50', gradient: 'from-gray-300 to-gray-400' },
};

// Draggable Application Card
function ApplicationCard({ 
  application, 
  isDragging = false,
  onDelete,
  onToggleFavorite,
}: { 
  application: JobApplication;
  isDragging?: boolean;
  onDelete: (id: string) => void;
  onToggleFavorite: (id: string) => void;
}) {
  const {
    attributes,
    listeners,
    setNodeRef,
    transform,
    transition,
  } = useSortable({ id: application.id });

  const style = {
    transform: CSS.Transform.toString(transform),
    transition,
  };

  return (
    <div
      ref={setNodeRef}
      style={style}
      {...attributes}
      {...listeners}
      className={`group bg-white dark:bg-gray-800 rounded-xl border p-4 cursor-grab active:cursor-grabbing transition-all duration-300 hover:shadow-lg hover:border-primary/30 hover:-translate-y-0.5 ${
        isDragging ? 'shadow-xl ring-2 ring-primary/50 opacity-90 scale-105' : ''
      }`}
    >
      <div className="flex items-start justify-between gap-2">
        <div className="flex-1 min-w-0">
          <div className="flex items-center gap-3">
            {application.company_logo ? (
              <Image 
                src={application.company_logo} 
                alt={application.company_name}
                width={40}
                height={40}
                className="w-10 h-10 rounded-lg object-contain bg-gray-50 shadow-sm"
              />
            ) : (
              <div className="w-10 h-10 rounded-lg bg-gradient-to-br from-primary/20 to-purple-500/20 flex items-center justify-center shadow-sm">
                <Building2 className="w-5 h-5 text-primary" />
              </div>
            )}
            <div className="flex-1 min-w-0">
              <p className="font-semibold text-sm truncate group-hover:text-primary transition-colors">{application.company_name}</p>
              <p className="text-xs text-muted-foreground truncate">{application.job_title}</p>
            </div>
          </div>
        </div>
        
        <div className="flex items-center gap-1 opacity-0 group-hover:opacity-100 transition-opacity">
          <Button
            variant="ghost"
            size="icon"
            className="h-7 w-7"
            onClick={(e) => {
              e.stopPropagation();
              onToggleFavorite(application.id);
            }}
          >
            {application.is_favorite ? (
              <Star className="h-4 w-4 text-yellow-500 fill-yellow-500" />
            ) : (
              <StarOff className="h-4 w-4 text-muted-foreground" />
            )}
          </Button>
          
          <DropdownMenu>
            <DropdownMenuTrigger asChild>
              <Button 
                variant="ghost" 
                size="icon" 
                className="h-7 w-7"
                onClick={(e) => e.stopPropagation()}
              >
                <MoreHorizontal className="h-4 w-4" />
              </Button>
            </DropdownMenuTrigger>
            <DropdownMenuContent align="end">
              <DropdownMenuItem asChild>
                <Link href={`/dashboard/applications/${application.id}`}>
                  <Edit className="mr-2 h-4 w-4" />
                  View Details
                </Link>
              </DropdownMenuItem>
              {application.job_link && (
                <DropdownMenuItem asChild>
                  <a href={application.job_link} target="_blank" rel="noopener noreferrer">
                    <ExternalLink className="mr-2 h-4 w-4" />
                    View Job Posting
                  </a>
                </DropdownMenuItem>
              )}
              <DropdownMenuItem asChild>
                <Link href={`/dashboard/interviews/new?application=${application.id}`}>
                  <Calendar className="mr-2 h-4 w-4" />
                  Schedule Interview
                </Link>
              </DropdownMenuItem>
              <DropdownMenuSeparator />
              <DropdownMenuItem asChild>
                <Link href={`/dashboard/applications/${application.id}/archive`}>
                  <Archive className="mr-2 h-4 w-4" />
                  Archive
                </Link>
              </DropdownMenuItem>
              <DropdownMenuItem 
                className="text-red-600"
                onClick={(e) => {
                  e.stopPropagation();
                  onDelete(application.id);
                }}
              >
                <Trash2 className="mr-2 h-4 w-4" />
                Delete
              </DropdownMenuItem>
            </DropdownMenuContent>
          </DropdownMenu>
        </div>
      </div>

      {/* Tags & Meta */}
      <div className="mt-3 flex flex-wrap items-center gap-2">
        {application.location && (
          <span className="text-xs text-muted-foreground">{application.location}</span>
        )}
        {application.salary_min && application.salary_max && (
          <span className="text-xs text-muted-foreground">
            ${(application.salary_min / 1000).toFixed(0)}k - ${(application.salary_max / 1000).toFixed(0)}k
          </span>
        )}
      </div>

      {application.tags && application.tags.length > 0 && (
        <div className="mt-2 flex flex-wrap gap-1">
          {application.tags.slice(0, 2).map((tag) => (
            <Badge 
              key={tag.id} 
              variant="secondary" 
              className="text-xs py-0"
              style={{ backgroundColor: tag.color + '20', color: tag.color }}
            >
              {tag.name}
            </Badge>
          ))}
          {application.tags.length > 2 && (
            <Badge variant="secondary" className="text-xs py-0">
              +{application.tags.length - 2}
            </Badge>
          )}
        </div>
      )}

      {/* Applied date */}
      {application.applied_date && (
        <p className="mt-2 text-xs text-muted-foreground">
          Applied {format(new Date(application.applied_date), 'MMM d, yyyy')}
        </p>
      )}

      {/* Next interview indicator */}
      {application.next_interview && (
        <div className="mt-2 flex items-center gap-1 text-xs text-primary">
          <Calendar className="h-3 w-3" />
          <span>
            Interview {format(new Date(application.next_interview.scheduled_at), 'MMM d')}
          </span>
        </div>
      )}
    </div>
  );
}

// Kanban Column
function KanbanColumn({ 
  status, 
  applications,
  onDelete,
  onToggleFavorite,
}: { 
  status: ApplicationStatus;
  applications: JobApplication[];
  onDelete: (id: string) => void;
  onToggleFavorite: (id: string) => void;
}) {
  const config = STATUS_CONFIG[status];

  return (
    <div className="flex-shrink-0 w-80 animate-fade-in-up">
      <div className={`rounded-t-xl px-4 py-3 bg-gradient-to-r ${config.gradient}`}>
        <div className="flex items-center justify-between">
          <h3 className="font-semibold text-sm text-white drop-shadow-sm">
            {config.label}
          </h3>
          <Badge variant="secondary" className="bg-white/20 text-white border-0 backdrop-blur-sm">
            {applications.length}
          </Badge>
        </div>
      </div>
      
      <div className="bg-gradient-to-b from-muted/50 to-muted/20 rounded-b-xl p-3 min-h-[500px] border border-t-0 border-muted/50">
        <SortableContext 
          items={applications.map(a => a.id)} 
          strategy={verticalListSortingStrategy}
        >
          <div className="space-y-3">
            {applications.map((application, index) => (
              <div key={application.id} style={{ animationDelay: `${index * 50}ms` }} className="animate-fade-in-up">
                <ApplicationCard 
                  application={application}
                  onDelete={onDelete}
                  onToggleFavorite={onToggleFavorite}
                />
              </div>
            ))}
          </div>
        </SortableContext>
        
        {applications.length === 0 && (
          <div className="h-32 flex flex-col items-center justify-center text-muted-foreground text-sm">
            <Target className="h-8 w-8 mb-2 opacity-30" />
            <span>No applications</span>
          </div>
        )}
      </div>
    </div>
  );
}

export default function ApplicationsPage() {
  const { data: kanbanData, isLoading } = useKanban();
  const updateKanbanOrder = useUpdateKanbanOrder();
  const deleteApplication = useDeleteApplication();
  const toggleFavorite = useToggleFavorite();
  
  const [searchQuery, setSearchQuery] = useState('');
  const [activeId, setActiveId] = useState<string | null>(null);
  const [deleteDialogOpen, setDeleteDialogOpen] = useState(false);
  const [applicationToDelete, setApplicationToDelete] = useState<string | null>(null);
  const [viewMode, setViewMode] = useState<'kanban' | 'list'>('kanban');
  const [showAdvancedSearch, setShowAdvancedSearch] = useState(false);
  
  // Bulk selection
  const {
    selectedIds,
    isSelectionMode,
    toggleSelection,
    selectAll,
    clearSelection,
    toggleSelectionMode,
  } = useBulkSelection();

  const sensors = useSensors(
    useSensor(PointerSensor, {
      activationConstraint: {
        distance: 8,
      },
    }),
    useSensor(KeyboardSensor, {
      coordinateGetter: sortableKeyboardCoordinates,
    })
  );

  // Visible columns (exclude some for cleaner view)
  const visibleStatuses: ApplicationStatus[] = [
    'wishlist', 
    'applied', 
    'screening', 
    'interviewing', 
    'offer'
  ];

  // Filter applications by search
  const filteredKanban = useMemo(() => {
    if (!kanbanData) return null;
    if (!searchQuery) return kanbanData;

    const query = searchQuery.toLowerCase();
    const filtered: typeof kanbanData = {} as typeof kanbanData;

    for (const [status, column] of Object.entries(kanbanData)) {
      filtered[status as ApplicationStatus] = {
        ...column,
        applications: column.applications.filter(
          (app) =>
            app.company_name.toLowerCase().includes(query) ||
            app.job_title.toLowerCase().includes(query)
        ),
      };
    }

    return filtered;
  }, [kanbanData, searchQuery]);

  const handleDragStart = (event: DragStartEvent) => {
    setActiveId(event.active.id as string);
  };

  const handleDragEnd = (event: DragEndEvent) => {
    const { active, over } = event;
    setActiveId(null);

    if (!over || !kanbanData) return;

    const activeId = active.id as string;
    const overId = over.id as string;

    // Find which column the item came from and which it's going to
    let sourceStatus: ApplicationStatus | null = null;
    let targetStatus: ApplicationStatus | null = null;
    let targetIndex = -1;

    for (const [status, column] of Object.entries(kanbanData)) {
      const activeIndex = column.applications.findIndex(a => a.id === activeId);
      if (activeIndex !== -1) {
        sourceStatus = status as ApplicationStatus;
      }
      
      const overIndex = column.applications.findIndex(a => a.id === overId);
      if (overIndex !== -1) {
        targetStatus = status as ApplicationStatus;
        targetIndex = overIndex;
      }
    }

    // If dropped on a column header (status), find the column
    if (!targetStatus && visibleStatuses.includes(overId as ApplicationStatus)) {
      targetStatus = overId as ApplicationStatus;
      targetIndex = kanbanData[targetStatus]?.applications.length || 0;
    }

    if (sourceStatus && targetStatus) {
      updateKanbanOrder.mutate({
        application_id: activeId,
        new_status: targetStatus,
        new_order: targetIndex,
      });
    }
  };

  const handleDragOver = (_event: DragOverEvent) => {
    // Handle drag over for column drops
  };

  const handleDelete = (id: string) => {
    setApplicationToDelete(id);
    setDeleteDialogOpen(true);
  };

  const confirmDelete = () => {
    if (applicationToDelete) {
      deleteApplication.mutate(applicationToDelete);
      setDeleteDialogOpen(false);
      setApplicationToDelete(null);
    }
  };

  const handleToggleFavorite = (id: string) => {
    toggleFavorite.mutate(id);
  };

  // Find the active application for drag overlay
  const activeApplication = useMemo(() => {
    if (!activeId || !kanbanData) return null;
    for (const column of Object.values(kanbanData)) {
      const found = column.applications.find(a => a.id === activeId);
      if (found) return found;
    }
    return null;
  }, [activeId, kanbanData]);

  // Calculate stats
  const totalApplications = useMemo(() => {
    if (!kanbanData) return 0;
    return Object.values(kanbanData).reduce((sum, col) => sum + col.applications.length, 0);
  }, [kanbanData]);

  const activeApplications = useMemo(() => {
    if (!kanbanData) return 0;
    const activeStatuses: ApplicationStatus[] = ['applied', 'screening', 'interviewing', 'offer'];
    return activeStatuses.reduce((sum, status) => sum + (kanbanData[status]?.applications.length || 0), 0);
  }, [kanbanData]);

  return (
    <div className="h-full flex flex-col">
      {/* Header with Gradient */}
      <div className="flex-shrink-0 border-b bg-background">
        <div className="relative overflow-hidden bg-gradient-to-r from-blue-600 via-indigo-600 to-purple-600 p-8">
          {/* Decorative elements */}
          <div className="absolute top-0 right-0 w-64 h-64 bg-white/10 rounded-full blur-3xl -translate-y-1/2 translate-x-1/2" />
          <div className="absolute bottom-0 left-0 w-48 h-48 bg-white/5 rounded-full blur-2xl translate-y-1/2 -translate-x-1/2" />
          <div className="absolute top-1/2 right-1/4 w-32 h-32 bg-indigo-400/20 rounded-full blur-xl" />
          
          <div className="relative flex flex-col sm:flex-row sm:items-center sm:justify-between gap-6">
            <div className="animate-fade-in-up">
              <h1 className="text-3xl font-bold text-white flex items-center gap-3">
                <div className="p-2 bg-white/20 rounded-xl backdrop-blur-sm">
                  <Briefcase className="h-7 w-7" />
                </div>
                Applications
              </h1>
              <p className="text-white/80 mt-2 max-w-md">
                Track and manage your job applications with drag-and-drop
              </p>
            </div>
            <Link href="/dashboard/applications/new" className="animate-fade-in-up stagger-2">
              <Button className="bg-white text-indigo-600 hover:bg-white/90 shadow-lg hover:shadow-xl transition-all group">
                <Plus className="mr-2 h-4 w-4 group-hover:rotate-90 transition-transform duration-300" />
                Add Application
              </Button>
            </Link>
          </div>

          {/* Quick Stats */}
          <div className="relative grid grid-cols-4 gap-4 mt-6 animate-fade-in-up stagger-3">
            <div className="bg-white/10 backdrop-blur-sm rounded-xl p-4 border border-white/20">
              <p className="text-white/70 text-sm">Total</p>
              <p className="text-2xl font-bold text-white">
                <AnimatedNumber value={totalApplications} />
              </p>
            </div>
            <div className="bg-white/10 backdrop-blur-sm rounded-xl p-4 border border-white/20">
              <p className="text-white/70 text-sm">Active</p>
              <p className="text-2xl font-bold text-white">
                <AnimatedNumber value={activeApplications} />
              </p>
            </div>
            <div className="bg-white/10 backdrop-blur-sm rounded-xl p-4 border border-white/20">
              <p className="text-white/70 text-sm">Interviewing</p>
              <p className="text-2xl font-bold text-white">
                <AnimatedNumber value={kanbanData?.interviewing?.applications.length || 0} />
              </p>
            </div>
            <div className="bg-white/10 backdrop-blur-sm rounded-xl p-4 border border-white/20">
              <p className="text-white/70 text-sm">Offers</p>
              <p className="text-2xl font-bold text-white">
                <AnimatedNumber value={kanbanData?.offer?.applications.length || 0} />
              </p>
            </div>
          </div>
        </div>

        {/* Search & Filters */}
        <div className="p-4 flex flex-col gap-4 bg-muted/30">
          {/* Bulk Actions Bar - shows when selection mode is active */}
          {isSelectionMode && (
            <BulkActionsBar
              selectedCount={selectedIds.size}
              onClearSelection={clearSelection}
              onExitSelectionMode={toggleSelectionMode}
            />
          )}
          
          {/* Advanced Search Panel */}
          {showAdvancedSearch && (
            <AdvancedSearchPanel 
              onSearch={(filters) => {
                // Apply filters to search
                console.log('Advanced search filters:', filters);
              }}
              onClose={() => setShowAdvancedSearch(false)}
            />
          )}
          
          <div className="flex flex-col sm:flex-row gap-4">
            <div className="relative flex-1 flex gap-2">
              <div className="relative flex-1">
                <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
                <Input
                  placeholder="Search by company or job title..."
                  value={searchQuery}
                  onChange={(e) => setSearchQuery(e.target.value)}
                  className="pl-10 bg-white shadow-sm border-muted/50"
                />
              </div>
              <VoiceSearchButton 
                onResult={(text) => setSearchQuery(text)}
              />
            </div>
            <div className="flex gap-2">
              <Button 
                variant={showAdvancedSearch ? 'secondary' : 'outline'} 
                size="icon" 
                className="shadow-sm"
                onClick={() => setShowAdvancedSearch(!showAdvancedSearch)}
              >
                <Filter className="h-4 w-4" />
              </Button>
              <Button
                variant={isSelectionMode ? 'secondary' : 'outline'}
                size="icon"
                className="shadow-sm"
                onClick={toggleSelectionMode}
                title="Bulk select"
              >
                <CheckSquare className="h-4 w-4" />
              </Button>
              <ImportExportMenu />
              <div className="flex border rounded-lg shadow-sm overflow-hidden">
                <Button
                  variant={viewMode === 'kanban' ? 'secondary' : 'ghost'}
                  size="icon"
                  className="rounded-none border-0"
                  onClick={() => setViewMode('kanban')}
                >
                  <Grid3X3 className="h-4 w-4" />
                </Button>
                <Button
                  variant={viewMode === 'list' ? 'secondary' : 'ghost'}
                  size="icon"
                  className="rounded-none border-0"
                  onClick={() => setViewMode('list')}
                >
                  <List className="h-4 w-4" />
                </Button>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Kanban Board */}
      <div className="flex-1 overflow-x-auto p-6 bg-gradient-to-b from-muted/20 to-background">
        {isLoading ? (
          <div className="flex gap-4">
            {visibleStatuses.map((status, index) => (
              <div key={status} className="flex-shrink-0 w-80 animate-fade-in-up" style={{ animationDelay: `${index * 100}ms` }}>
                <Skeleton className="h-12 w-full rounded-t-xl" />
                <div className="bg-muted/30 rounded-b-xl p-3 space-y-3 border border-t-0">
                  {[1, 2, 3].map((i) => (
                    <Skeleton key={i} className="h-28 w-full rounded-xl" />
                  ))}
                </div>
              </div>
            ))}
          </div>
        ) : (
          <DndContext
            sensors={sensors}
            collisionDetection={closestCorners}
            onDragStart={handleDragStart}
            onDragEnd={handleDragEnd}
            onDragOver={handleDragOver}
          >
            <div className="flex gap-4">
              {visibleStatuses.map((status) => (
                <KanbanColumn
                  key={status}
                  status={status}
                  applications={filteredKanban?.[status]?.applications || []}
                  onDelete={handleDelete}
                  onToggleFavorite={handleToggleFavorite}
                />
              ))}
            </div>

            <DragOverlay>
              {activeApplication && (
                <div className="w-80">
                  <ApplicationCard 
                    application={activeApplication} 
                    isDragging
                    onDelete={() => {}}
                    onToggleFavorite={() => {}}
                  />
                </div>
              )}
            </DragOverlay>
          </DndContext>
        )}
      </div>

      {/* Delete Confirmation Dialog */}
      <AlertDialog open={deleteDialogOpen} onOpenChange={setDeleteDialogOpen}>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Delete Application</AlertDialogTitle>
            <AlertDialogDescription>
              Are you sure you want to delete this application? This action cannot be undone.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel>Cancel</AlertDialogCancel>
            <AlertDialogAction 
              onClick={confirmDelete}
              className="bg-red-600 hover:bg-red-700"
            >
              Delete
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </div>
  );
}
