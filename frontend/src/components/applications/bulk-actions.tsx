'use client';

import { useState, useCallback, useEffect } from 'react';
import {
  Trash2,
  Archive,
  Tag,
  Star,
  StarOff,
  CheckSquare,
  XSquare,
  ChevronDown,
  Loader2,
} from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import { Checkbox } from '@/components/ui/checkbox';
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuSeparator,
  DropdownMenuSub,
  DropdownMenuSubContent,
  DropdownMenuSubTrigger,
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
import { toast } from 'sonner';
import { useMutation, useQueryClient } from '@tanstack/react-query';
import { api } from '@/lib/api';
import type { JobApplication, ApplicationStatus, ApplicationTag } from '@/types';

interface BulkActionsProps {
  applications: JobApplication[];
  selectedIds: Set<string>;
  onSelectionChange: (ids: Set<string>) => void;
  tags: ApplicationTag[];
}

const STATUS_OPTIONS: { value: ApplicationStatus; label: string }[] = [
  { value: 'wishlist', label: 'Wishlist' },
  { value: 'applied', label: 'Applied' },
  { value: 'screening', label: 'Screening' },
  { value: 'interviewing', label: 'Interviewing' },
  { value: 'offer', label: 'Offer' },
  { value: 'accepted', label: 'Accepted' },
  { value: 'rejected', label: 'Rejected' },
  { value: 'withdrawn', label: 'Withdrawn' },
  { value: 'ghosted', label: 'Ghosted' },
];

export function BulkActions({
  applications,
  selectedIds,
  onSelectionChange,
  tags,
}: BulkActionsProps) {
  const [deleteDialogOpen, setDeleteDialogOpen] = useState(false);
  const queryClient = useQueryClient();
  
  const selectedCount = selectedIds.size;
  const allSelected = selectedCount === applications.length && applications.length > 0;
  const someSelected = selectedCount > 0 && selectedCount < applications.length;

  // Bulk status update mutation
  const bulkStatusMutation = useMutation({
    mutationFn: (data: { application_ids: string[]; status: ApplicationStatus }) =>
      api.applications.bulkStatus(data),
    onSuccess: (result) => {
      queryClient.invalidateQueries({ queryKey: ['applications'] });
      queryClient.invalidateQueries({ queryKey: ['kanban'] });
      toast.success(`Updated ${result.updated_count} applications`);
      onSelectionChange(new Set());
    },
    onError: () => {
      toast.error('Failed to update applications');
    },
  });

  // Bulk delete mutation
  const bulkDeleteMutation = useMutation({
    mutationFn: (applicationIds: string[]) =>
      api.applications.bulkDelete(applicationIds),
    onSuccess: (result) => {
      queryClient.invalidateQueries({ queryKey: ['applications'] });
      queryClient.invalidateQueries({ queryKey: ['kanban'] });
      toast.success(`Deleted ${result.deleted_count} applications`);
      onSelectionChange(new Set());
    },
    onError: () => {
      toast.error('Failed to delete applications');
    },
  });

  // Bulk archive mutation
  const bulkArchiveMutation = useMutation({
    mutationFn: (data: { application_ids: string[]; archive: boolean }) =>
      api.applications.bulkArchive(data),
    onSuccess: (result) => {
      queryClient.invalidateQueries({ queryKey: ['applications'] });
      queryClient.invalidateQueries({ queryKey: ['kanban'] });
      toast.success(`Archived ${result.updated_count} applications`);
      onSelectionChange(new Set());
    },
    onError: () => {
      toast.error('Failed to archive applications');
    },
  });

  // Bulk tag mutation
  const bulkTagMutation = useMutation({
    mutationFn: (data: { application_ids: string[]; tag_ids: string[]; action: 'add' | 'remove' }) =>
      api.applications.bulkTag(data),
    onSuccess: (result) => {
      queryClient.invalidateQueries({ queryKey: ['applications'] });
      queryClient.invalidateQueries({ queryKey: ['kanban'] });
      toast.success(`Updated tags for ${result.updated_count} applications`);
    },
    onError: () => {
      toast.error('Failed to update tags');
    },
  });

  // Bulk favorite mutation
  const bulkFavoriteMutation = useMutation({
    mutationFn: (data: { application_ids: string[]; is_favorite: boolean }) =>
      api.applications.bulkFavorite(data),
    onSuccess: (result) => {
      queryClient.invalidateQueries({ queryKey: ['applications'] });
      queryClient.invalidateQueries({ queryKey: ['kanban'] });
      toast.success(`Updated ${result.updated_count} applications`);
    },
    onError: () => {
      toast.error('Failed to update favorites');
    },
  });

  const handleSelectAll = useCallback(() => {
    if (allSelected) {
      onSelectionChange(new Set());
    } else {
      onSelectionChange(new Set(applications.map(a => a.id)));
    }
  }, [allSelected, applications, onSelectionChange]);

  const handleStatusChange = useCallback((status: ApplicationStatus) => {
    bulkStatusMutation.mutate({
      application_ids: Array.from(selectedIds),
      status,
    });
  }, [selectedIds, bulkStatusMutation]);

  const handleDelete = useCallback(() => {
    bulkDeleteMutation.mutate(Array.from(selectedIds));
    setDeleteDialogOpen(false);
  }, [selectedIds, bulkDeleteMutation]);

  const handleArchive = useCallback((archive: boolean) => {
    bulkArchiveMutation.mutate({
      application_ids: Array.from(selectedIds),
      archive,
    });
  }, [selectedIds, bulkArchiveMutation]);

  const handleTagAction = useCallback((tagId: string, action: 'add' | 'remove') => {
    bulkTagMutation.mutate({
      application_ids: Array.from(selectedIds),
      tag_ids: [tagId],
      action,
    });
  }, [selectedIds, bulkTagMutation]);

  const handleFavorite = useCallback((isFavorite: boolean) => {
    bulkFavoriteMutation.mutate({
      application_ids: Array.from(selectedIds),
      is_favorite: isFavorite,
    });
  }, [selectedIds, bulkFavoriteMutation]);

  const isLoading = 
    bulkStatusMutation.isPending ||
    bulkDeleteMutation.isPending ||
    bulkArchiveMutation.isPending ||
    bulkTagMutation.isPending ||
    bulkFavoriteMutation.isPending;

  if (applications.length === 0) return null;

  return (
    <>
      <div className="flex items-center gap-4 py-3 px-4 bg-muted/50 rounded-lg border">
        {/* Select All Checkbox */}
        <div className="flex items-center gap-2">
          <Checkbox
            id="select-all"
            checked={allSelected}
            // @ts-expect-error - indeterminate is valid
            indeterminate={someSelected}
            onCheckedChange={handleSelectAll}
            aria-label="Select all applications"
          />
          <label htmlFor="select-all" className="text-sm font-medium cursor-pointer">
            {allSelected ? 'Deselect All' : 'Select All'}
          </label>
        </div>

        {/* Selection Count */}
        {selectedCount > 0 && (
          <Badge variant="secondary" className="gap-1">
            <CheckSquare className="h-3 w-3" />
            {selectedCount} selected
          </Badge>
        )}

        {/* Bulk Actions */}
        {selectedCount > 0 && (
          <div className="flex items-center gap-2 ml-auto">
            {isLoading && <Loader2 className="h-4 w-4 animate-spin" />}

            {/* Status Dropdown */}
            <DropdownMenu>
              <DropdownMenuTrigger asChild>
                <Button variant="outline" size="sm" disabled={isLoading}>
                  Status
                  <ChevronDown className="ml-1 h-4 w-4" />
                </Button>
              </DropdownMenuTrigger>
              <DropdownMenuContent align="start">
                {STATUS_OPTIONS.map((option) => (
                  <DropdownMenuItem
                    key={option.value}
                    onClick={() => handleStatusChange(option.value)}
                  >
                    {option.label}
                  </DropdownMenuItem>
                ))}
              </DropdownMenuContent>
            </DropdownMenu>

            {/* Tags Dropdown */}
            <DropdownMenu>
              <DropdownMenuTrigger asChild>
                <Button variant="outline" size="sm" disabled={isLoading}>
                  <Tag className="h-4 w-4 mr-1" />
                  Tags
                  <ChevronDown className="ml-1 h-4 w-4" />
                </Button>
              </DropdownMenuTrigger>
              <DropdownMenuContent align="start">
                <DropdownMenuSub>
                  <DropdownMenuSubTrigger>Add Tag</DropdownMenuSubTrigger>
                  <DropdownMenuSubContent>
                    {tags.map((tag) => (
                      <DropdownMenuItem
                        key={tag.id}
                        onClick={() => handleTagAction(tag.id, 'add')}
                      >
                        <div
                          className="w-3 h-3 rounded-full mr-2"
                          style={{ backgroundColor: tag.color }}
                        />
                        {tag.name}
                      </DropdownMenuItem>
                    ))}
                    {tags.length === 0 && (
                      <DropdownMenuItem disabled>No tags available</DropdownMenuItem>
                    )}
                  </DropdownMenuSubContent>
                </DropdownMenuSub>
                <DropdownMenuSub>
                  <DropdownMenuSubTrigger>Remove Tag</DropdownMenuSubTrigger>
                  <DropdownMenuSubContent>
                    {tags.map((tag) => (
                      <DropdownMenuItem
                        key={tag.id}
                        onClick={() => handleTagAction(tag.id, 'remove')}
                      >
                        <div
                          className="w-3 h-3 rounded-full mr-2"
                          style={{ backgroundColor: tag.color }}
                        />
                        {tag.name}
                      </DropdownMenuItem>
                    ))}
                    {tags.length === 0 && (
                      <DropdownMenuItem disabled>No tags available</DropdownMenuItem>
                    )}
                  </DropdownMenuSubContent>
                </DropdownMenuSub>
              </DropdownMenuContent>
            </DropdownMenu>

            {/* Favorite Buttons */}
            <Button
              variant="outline"
              size="sm"
              onClick={() => handleFavorite(true)}
              disabled={isLoading}
            >
              <Star className="h-4 w-4 mr-1" />
              Favorite
            </Button>
            <Button
              variant="outline"
              size="sm"
              onClick={() => handleFavorite(false)}
              disabled={isLoading}
            >
              <StarOff className="h-4 w-4 mr-1" />
              Unfavorite
            </Button>

            {/* Archive Button */}
            <Button
              variant="outline"
              size="sm"
              onClick={() => handleArchive(true)}
              disabled={isLoading}
            >
              <Archive className="h-4 w-4 mr-1" />
              Archive
            </Button>

            {/* Delete Button */}
            <Button
              variant="destructive"
              size="sm"
              onClick={() => setDeleteDialogOpen(true)}
              disabled={isLoading}
            >
              <Trash2 className="h-4 w-4 mr-1" />
              Delete
            </Button>

            {/* Clear Selection */}
            <Button
              variant="ghost"
              size="sm"
              onClick={() => onSelectionChange(new Set())}
              disabled={isLoading}
            >
              <XSquare className="h-4 w-4" />
            </Button>
          </div>
        )}
      </div>

      {/* Delete Confirmation Dialog */}
      <AlertDialog open={deleteDialogOpen} onOpenChange={setDeleteDialogOpen}>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Delete {selectedCount} Applications</AlertDialogTitle>
            <AlertDialogDescription>
              Are you sure you want to delete these applications? This action cannot be undone.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel>Cancel</AlertDialogCancel>
            <AlertDialogAction
              onClick={handleDelete}
              className="bg-red-600 hover:bg-red-700"
            >
              Delete {selectedCount} Applications
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </>
  );
}

// Selection checkbox for individual items
export function SelectionCheckbox({
  id,
  selectedIds,
  onToggle,
}: {
  id: string;
  selectedIds: Set<string>;
  onToggle: (id: string) => void;
}) {
  return (
    <Checkbox
      checked={selectedIds.has(id)}
      onCheckedChange={() => onToggle(id)}
      onClick={(e) => e.stopPropagation()}
      aria-label="Select application"
      className="data-[state=checked]:bg-primary"
    />
  );
}

// Hook for managing selection state
export function useSelection() {
  const [selectedIds, setSelectedIds] = useState<Set<string>>(new Set());

  const toggleSelection = useCallback((id: string) => {
    setSelectedIds((prev) => {
      const next = new Set(prev);
      if (next.has(id)) {
        next.delete(id);
      } else {
        next.add(id);
      }
      return next;
    });
  }, []);

  const clearSelection = useCallback(() => {
    setSelectedIds(new Set());
  }, []);

  const selectAll = useCallback((ids: string[]) => {
    setSelectedIds(new Set(ids));
  }, []);

  return {
    selectedIds,
    setSelectedIds,
    toggleSelection,
    clearSelection,
    selectAll,
  };
}

// Extended hook for bulk selection with selection mode
export function useBulkSelection() {
  const [isSelectionMode, setIsSelectionMode] = useState(false);
  const { selectedIds, toggleSelection, clearSelection, selectAll } = useSelection();

  const toggleSelectionMode = useCallback(() => {
    setIsSelectionMode((prev) => {
      if (prev) {
        clearSelection();
      }
      return !prev;
    });
  }, [clearSelection]);

  return {
    selectedIds,
    isSelectionMode,
    toggleSelection,
    selectAll,
    clearSelection,
    toggleSelectionMode,
  };
}

// Bulk Actions Bar - Fixed bar at top when items are selected
interface BulkActionsBarProps {
  selectedCount: number;
  onClearSelection: () => void;
  onExitSelectionMode: () => void;
}

export function BulkActionsBar({
  selectedCount,
  onClearSelection,
  onExitSelectionMode,
}: BulkActionsBarProps) {
  const queryClient = useQueryClient();
  const [deleteDialogOpen, setDeleteDialogOpen] = useState(false);

  if (selectedCount === 0) {
    return (
      <div className="flex items-center justify-between p-3 bg-blue-50 dark:bg-blue-900/20 rounded-lg border border-blue-200 dark:border-blue-800">
        <span className="text-sm text-blue-700 dark:text-blue-300">
          Click on applications to select them
        </span>
        <Button
          variant="ghost"
          size="sm"
          onClick={onExitSelectionMode}
        >
          Cancel
        </Button>
      </div>
    );
  }

  return (
    <div className="flex items-center justify-between p-3 bg-primary/10 rounded-lg border border-primary/20">
      <div className="flex items-center gap-4">
        <Badge variant="secondary" className="font-medium">
          {selectedCount} selected
        </Badge>
        <div className="flex items-center gap-2">
          <DropdownMenu>
            <DropdownMenuTrigger asChild>
              <Button variant="outline" size="sm">
                Change Status
                <ChevronDown className="ml-2 h-4 w-4" />
              </Button>
            </DropdownMenuTrigger>
            <DropdownMenuContent>
              {STATUS_OPTIONS.map((status) => (
                <DropdownMenuItem key={status.value}>
                  {status.label}
                </DropdownMenuItem>
              ))}
            </DropdownMenuContent>
          </DropdownMenu>
          <Button variant="outline" size="sm">
            <Tag className="mr-2 h-4 w-4" />
            Add Tags
          </Button>
          <Button variant="outline" size="sm">
            <Star className="mr-2 h-4 w-4" />
            Favorite
          </Button>
          <Button variant="outline" size="sm">
            <Archive className="mr-2 h-4 w-4" />
            Archive
          </Button>
          <Button 
            variant="outline" 
            size="sm" 
            className="text-destructive hover:text-destructive"
            onClick={() => setDeleteDialogOpen(true)}
          >
            <Trash2 className="mr-2 h-4 w-4" />
            Delete
          </Button>
        </div>
      </div>
      <div className="flex items-center gap-2">
        <Button variant="ghost" size="sm" onClick={onClearSelection}>
          Clear
        </Button>
        <Button variant="ghost" size="sm" onClick={onExitSelectionMode}>
          <XSquare className="mr-2 h-4 w-4" />
          Exit
        </Button>
      </div>

      <AlertDialog open={deleteDialogOpen} onOpenChange={setDeleteDialogOpen}>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Delete {selectedCount} applications?</AlertDialogTitle>
            <AlertDialogDescription>
              This action cannot be undone. All selected applications will be permanently deleted.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel>Cancel</AlertDialogCancel>
            <AlertDialogAction
              className="bg-destructive text-destructive-foreground hover:bg-destructive/90"
              onClick={() => {
                toast.success(`Deleted ${selectedCount} applications`);
                onClearSelection();
                setDeleteDialogOpen(false);
              }}
            >
              Delete
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </div>
  );
}
