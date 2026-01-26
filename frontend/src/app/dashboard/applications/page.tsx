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
  Building2
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
import type { JobApplication, ApplicationStatus } from '@/types';

const STATUS_CONFIG: Record<ApplicationStatus, { label: string; color: string; bgColor: string }> = {
  wishlist: { label: 'Wishlist', color: 'text-slate-600', bgColor: 'bg-slate-100' },
  applied: { label: 'Applied', color: 'text-blue-600', bgColor: 'bg-blue-100' },
  screening: { label: 'Screening', color: 'text-purple-600', bgColor: 'bg-purple-100' },
  interviewing: { label: 'Interviewing', color: 'text-amber-600', bgColor: 'bg-amber-100' },
  offer: { label: 'Offer', color: 'text-green-600', bgColor: 'bg-green-100' },
  accepted: { label: 'Accepted', color: 'text-emerald-600', bgColor: 'bg-emerald-100' },
  rejected: { label: 'Rejected', color: 'text-red-600', bgColor: 'bg-red-100' },
  withdrawn: { label: 'Withdrawn', color: 'text-gray-600', bgColor: 'bg-gray-100' },
  ghosted: { label: 'Ghosted', color: 'text-gray-400', bgColor: 'bg-gray-50' },
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
      className={`group bg-white dark:bg-gray-800 rounded-lg border p-3 cursor-grab active:cursor-grabbing transition-shadow hover:shadow-md ${
        isDragging ? 'shadow-lg ring-2 ring-primary opacity-50' : ''
      }`}
    >
      <div className="flex items-start justify-between gap-2">
        <div className="flex-1 min-w-0">
          <div className="flex items-center gap-2">
            {application.company_logo ? (
              <Image 
                src={application.company_logo} 
                alt={application.company_name}
                width={32}
                height={32}
                className="w-8 h-8 rounded object-contain bg-gray-50"
              />
            ) : (
              <div className="w-8 h-8 rounded bg-primary/10 flex items-center justify-center">
                <Building2 className="w-4 h-4 text-primary" />
              </div>
            )}
            <div className="flex-1 min-w-0">
              <p className="font-medium text-sm truncate">{application.company_name}</p>
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
    <div className="flex-shrink-0 w-80">
      <div className={`rounded-t-lg px-3 py-2 ${config.bgColor}`}>
        <div className="flex items-center justify-between">
          <h3 className={`font-semibold text-sm ${config.color}`}>
            {config.label}
          </h3>
          <Badge variant="secondary" className="text-xs">
            {applications.length}
          </Badge>
        </div>
      </div>
      
      <div className="bg-muted/30 rounded-b-lg p-2 min-h-[500px]">
        <SortableContext 
          items={applications.map(a => a.id)} 
          strategy={verticalListSortingStrategy}
        >
          <div className="space-y-2">
            {applications.map((application) => (
              <ApplicationCard 
                key={application.id} 
                application={application}
                onDelete={onDelete}
                onToggleFavorite={onToggleFavorite}
              />
            ))}
          </div>
        </SortableContext>
        
        {applications.length === 0 && (
          <div className="h-32 flex items-center justify-center text-muted-foreground text-sm">
            No applications
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

  return (
    <div className="h-full flex flex-col">
      {/* Header */}
      <div className="flex-shrink-0 p-6 border-b bg-background">
        <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
          <div>
            <h1 className="text-2xl font-bold">Applications</h1>
            <p className="text-muted-foreground">
              Track and manage your job applications
            </p>
          </div>
          <Link href="/dashboard/applications/new">
            <Button>
              <Plus className="mr-2 h-4 w-4" />
              Add Application
            </Button>
          </Link>
        </div>

        {/* Search & Filters */}
        <div className="mt-4 flex flex-col sm:flex-row gap-4">
          <div className="relative flex-1">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
            <Input
              placeholder="Search by company or job title..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="pl-10"
            />
          </div>
          <div className="flex gap-2">
            <Button variant="outline" size="icon">
              <Filter className="h-4 w-4" />
            </Button>
            <div className="flex border rounded-md">
              <Button
                variant={viewMode === 'kanban' ? 'secondary' : 'ghost'}
                size="icon"
                className="rounded-r-none"
                onClick={() => setViewMode('kanban')}
              >
                <Grid3X3 className="h-4 w-4" />
              </Button>
              <Button
                variant={viewMode === 'list' ? 'secondary' : 'ghost'}
                size="icon"
                className="rounded-l-none"
                onClick={() => setViewMode('list')}
              >
                <List className="h-4 w-4" />
              </Button>
            </div>
          </div>
        </div>
      </div>

      {/* Kanban Board */}
      <div className="flex-1 overflow-x-auto p-6">
        {isLoading ? (
          <div className="flex gap-4">
            {visibleStatuses.map((status) => (
              <div key={status} className="flex-shrink-0 w-80">
                <Skeleton className="h-10 w-full rounded-t-lg" />
                <div className="bg-muted/30 rounded-b-lg p-2 space-y-2">
                  {[1, 2, 3].map((i) => (
                    <Skeleton key={i} className="h-24 w-full" />
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
