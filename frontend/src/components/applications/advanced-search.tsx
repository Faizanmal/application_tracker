'use client';

import { useState, useCallback, useEffect, useMemo } from 'react';
import {
  Search,
  Filter,
  Save,
  X,
  ChevronDown,
  ChevronUp,
  Calendar,
  DollarSign,
  Building2,
  MapPin,
  Tag,
  Clock,
  Star,
  Loader2,
  Bookmark,
  BookmarkCheck,
} from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Badge } from '@/components/ui/badge';
import { Label } from '@/components/ui/label';
import { Checkbox } from '@/components/ui/checkbox';
import { Slider } from '@/components/ui/slider';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select';
import {
  Sheet,
  SheetContent,
  SheetDescription,
  SheetHeader,
  SheetTitle,
  SheetTrigger,
} from '@/components/ui/sheet';
import {
  Popover,
  PopoverContent,
  PopoverTrigger,
} from '@/components/ui/popover';
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from '@/components/ui/dialog';
import { Separator } from '@/components/ui/separator';
import { Switch } from '@/components/ui/switch';
import { toast } from 'sonner';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { format } from 'date-fns';
import { Calendar as CalendarComponent } from '@/components/ui/calender';
import type { ApplicationStatus, ApplicationTag } from '@/types';

// Types
export interface SearchFilters {
  search?: string;
  status?: ApplicationStatus[];
  job_type?: string[];
  work_location?: string[];
  location?: string;
  company_name?: string;
  salary_min?: number;
  salary_max?: number;
  applied_date_from?: string;
  applied_date_to?: string;
  created_from?: string;
  created_to?: string;
  tags?: string[];
  is_favorite?: boolean;
  is_archived?: boolean;
  has_interview?: boolean;
  source?: string;
}

export interface SavedSearch {
  id: string;
  name: string;
  description: string;
  filters: SearchFilters;
  is_default: boolean;
  use_count: number;
  last_used: string | null;
  created_at: string;
  updated_at: string;
}

interface FilterOptions {
  statuses: { value: string; label: string }[];
  job_types: { value: string; label: string }[];
  work_locations: { value: string; label: string }[];
  sources: string[];
  locations: string[];
  industries: string[];
  company_sizes: string[];
  tags: { id: string; name: string; color: string }[];
}

interface AdvancedSearchProps {
  filters: SearchFilters;
  onFiltersChange: (filters: SearchFilters) => void;
  onSearch: () => void;
}

const DEFAULT_FILTERS: SearchFilters = {};

// API functions (to be added to api.ts)
const searchApi = {
  getFilterOptions: async (): Promise<FilterOptions> => {
    const response = await fetch('/api/v1/applications/filter-options/', {
      headers: { 'Authorization': `Bearer ${document.cookie.split('access_token=')[1]?.split(';')[0]}` }
    });
    return response.json();
  },
  getSavedSearches: async (): Promise<SavedSearch[]> => {
    const response = await fetch('/api/v1/applications/saved-searches/', {
      headers: { 'Authorization': `Bearer ${document.cookie.split('access_token=')[1]?.split(';')[0]}` }
    });
    return response.json();
  },
  createSavedSearch: async (data: Partial<SavedSearch>): Promise<SavedSearch> => {
    const response = await fetch('/api/v1/applications/saved-searches/', {
      method: 'POST',
      headers: { 
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${document.cookie.split('access_token=')[1]?.split(';')[0]}` 
      },
      body: JSON.stringify(data)
    });
    return response.json();
  },
  deleteSavedSearch: async (id: string): Promise<void> => {
    await fetch(`/api/v1/applications/saved-searches/${id}/`, {
      method: 'DELETE',
      headers: { 'Authorization': `Bearer ${document.cookie.split('access_token=')[1]?.split(';')[0]}` }
    });
  },
};

export function AdvancedSearchPanel({
  filters,
  onFiltersChange,
  onSearch,
}: AdvancedSearchProps) {
  const [isOpen, setIsOpen] = useState(false);
  const [saveDialogOpen, setSaveDialogOpen] = useState(false);
  const [searchName, setSearchName] = useState('');
  const [searchDescription, setSearchDescription] = useState('');
  const queryClient = useQueryClient();

  // Fetch filter options
  const { data: options } = useQuery({
    queryKey: ['filter-options'],
    queryFn: searchApi.getFilterOptions,
    staleTime: 5 * 60 * 1000,
  });

  // Fetch saved searches
  const { data: savedSearches = [] } = useQuery({
    queryKey: ['saved-searches'],
    queryFn: searchApi.getSavedSearches,
  });

  // Save search mutation
  const saveSearchMutation = useMutation({
    mutationFn: searchApi.createSavedSearch,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['saved-searches'] });
      toast.success('Search saved successfully');
      setSaveDialogOpen(false);
      setSearchName('');
      setSearchDescription('');
    },
    onError: () => {
      toast.error('Failed to save search');
    },
  });

  // Delete saved search mutation
  const deleteSearchMutation = useMutation({
    mutationFn: searchApi.deleteSavedSearch,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['saved-searches'] });
      toast.success('Search deleted');
    },
  });

  // Count active filters
  const activeFilterCount = useMemo(() => {
    let count = 0;
    if (filters.search) count++;
    if (filters.status?.length) count++;
    if (filters.job_type?.length) count++;
    if (filters.work_location?.length) count++;
    if (filters.location) count++;
    if (filters.company_name) count++;
    if (filters.salary_min || filters.salary_max) count++;
    if (filters.applied_date_from || filters.applied_date_to) count++;
    if (filters.tags?.length) count++;
    if (filters.is_favorite !== undefined) count++;
    if (filters.has_interview !== undefined) count++;
    if (filters.source) count++;
    return count;
  }, [filters]);

  const handleSaveSearch = () => {
    if (!searchName.trim()) {
      toast.error('Please enter a name for the search');
      return;
    }
    saveSearchMutation.mutate({
      name: searchName,
      description: searchDescription,
      filters,
    });
  };

  const handleLoadSearch = (search: SavedSearch) => {
    onFiltersChange(search.filters);
    toast.success(`Loaded "${search.name}"`);
    setIsOpen(false);
  };

  const handleClearFilters = () => {
    onFiltersChange(DEFAULT_FILTERS);
  };

  const updateFilter = <K extends keyof SearchFilters>(
    key: K,
    value: SearchFilters[K]
  ) => {
    onFiltersChange({ ...filters, [key]: value });
  };

  const toggleArrayFilter = (key: 'status' | 'job_type' | 'work_location' | 'tags', value: string) => {
    const current = filters[key] || [];
    const updated = current.includes(value)
      ? current.filter(v => v !== value)
      : [...current, value];
    updateFilter(key, updated.length > 0 ? updated : undefined);
  };

  return (
    <>
      <div className="flex items-center gap-4">
        {/* Quick Search */}
        <div className="relative flex-1 max-w-md">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
          <Input
            placeholder="Search companies, jobs, notes..."
            value={filters.search || ''}
            onChange={(e) => updateFilter('search', e.target.value || undefined)}
            onKeyDown={(e) => e.key === 'Enter' && onSearch()}
            className="pl-10"
          />
        </div>

        {/* Filter Button */}
        <Sheet open={isOpen} onOpenChange={setIsOpen}>
          <SheetTrigger asChild>
            <Button variant="outline" className="gap-2">
              <Filter className="h-4 w-4" />
              Filters
              {activeFilterCount > 0 && (
                <Badge variant="secondary" className="ml-1">
                  {activeFilterCount}
                </Badge>
              )}
            </Button>
          </SheetTrigger>
          <SheetContent className="w-[400px] sm:w-[540px] overflow-y-auto">
            <SheetHeader>
              <SheetTitle>Advanced Search</SheetTitle>
              <SheetDescription>
                Filter your applications with multiple criteria
              </SheetDescription>
            </SheetHeader>

            <div className="mt-6 space-y-6">
              {/* Saved Searches */}
              {savedSearches.length > 0 && (
                <div className="space-y-2">
                  <Label className="text-sm font-medium flex items-center gap-2">
                    <Bookmark className="h-4 w-4" />
                    Saved Searches
                  </Label>
                  <div className="flex flex-wrap gap-2">
                    {savedSearches.map((search) => (
                      <Badge
                        key={search.id}
                        variant="secondary"
                        className="cursor-pointer hover:bg-secondary/80 gap-1"
                        onClick={() => handleLoadSearch(search)}
                      >
                        <BookmarkCheck className="h-3 w-3" />
                        {search.name}
                        <button
                          onClick={(e) => {
                            e.stopPropagation();
                            deleteSearchMutation.mutate(search.id);
                          }}
                          className="ml-1 hover:text-destructive"
                        >
                          <X className="h-3 w-3" />
                        </button>
                      </Badge>
                    ))}
                  </div>
                </div>
              )}

              <Separator />

              {/* Status Filter */}
              <div className="space-y-2">
                <Label className="text-sm font-medium">Status</Label>
                <div className="flex flex-wrap gap-2">
                  {options?.statuses.map((status) => (
                    <Badge
                      key={status.value}
                      variant={filters.status?.includes(status.value as ApplicationStatus) ? 'default' : 'outline'}
                      className="cursor-pointer"
                      onClick={() => toggleArrayFilter('status', status.value)}
                    >
                      {status.label}
                    </Badge>
                  ))}
                </div>
              </div>

              {/* Job Type Filter */}
              <div className="space-y-2">
                <Label className="text-sm font-medium">Job Type</Label>
                <div className="flex flex-wrap gap-2">
                  {options?.job_types.map((type) => (
                    <Badge
                      key={type.value}
                      variant={filters.job_type?.includes(type.value) ? 'default' : 'outline'}
                      className="cursor-pointer"
                      onClick={() => toggleArrayFilter('job_type', type.value)}
                    >
                      {type.label}
                    </Badge>
                  ))}
                </div>
              </div>

              {/* Work Location Filter */}
              <div className="space-y-2">
                <Label className="text-sm font-medium">Work Location</Label>
                <div className="flex flex-wrap gap-2">
                  {options?.work_locations.map((loc) => (
                    <Badge
                      key={loc.value}
                      variant={filters.work_location?.includes(loc.value) ? 'default' : 'outline'}
                      className="cursor-pointer"
                      onClick={() => toggleArrayFilter('work_location', loc.value)}
                    >
                      {loc.label}
                    </Badge>
                  ))}
                </div>
              </div>

              <Separator />

              {/* Location Text Filter */}
              <div className="space-y-2">
                <Label className="text-sm font-medium flex items-center gap-2">
                  <MapPin className="h-4 w-4" />
                  Location
                </Label>
                <Select
                  value={filters.location || ''}
                  onValueChange={(value) => updateFilter('location', value || undefined)}
                >
                  <SelectTrigger>
                    <SelectValue placeholder="Any location" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="">Any location</SelectItem>
                    {options?.locations.map((loc) => (
                      <SelectItem key={loc} value={loc}>{loc}</SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>

              {/* Company Name Filter */}
              <div className="space-y-2">
                <Label className="text-sm font-medium flex items-center gap-2">
                  <Building2 className="h-4 w-4" />
                  Company Name
                </Label>
                <Input
                  placeholder="Filter by company..."
                  value={filters.company_name || ''}
                  onChange={(e) => updateFilter('company_name', e.target.value || undefined)}
                />
              </div>

              <Separator />

              {/* Salary Range Filter */}
              <div className="space-y-2">
                <Label className="text-sm font-medium flex items-center gap-2">
                  <DollarSign className="h-4 w-4" />
                  Salary Range
                </Label>
                <div className="flex items-center gap-4">
                  <div className="flex-1">
                    <Input
                      type="number"
                      placeholder="Min"
                      value={filters.salary_min || ''}
                      onChange={(e) => updateFilter('salary_min', e.target.value ? Number(e.target.value) : undefined)}
                    />
                  </div>
                  <span className="text-muted-foreground">to</span>
                  <div className="flex-1">
                    <Input
                      type="number"
                      placeholder="Max"
                      value={filters.salary_max || ''}
                      onChange={(e) => updateFilter('salary_max', e.target.value ? Number(e.target.value) : undefined)}
                    />
                  </div>
                </div>
              </div>

              <Separator />

              {/* Date Range Filters */}
              <div className="space-y-2">
                <Label className="text-sm font-medium flex items-center gap-2">
                  <Calendar className="h-4 w-4" />
                  Applied Date Range
                </Label>
                <div className="flex items-center gap-4">
                  <Popover>
                    <PopoverTrigger asChild>
                      <Button variant="outline" className="flex-1 justify-start">
                        {filters.applied_date_from
                          ? format(new Date(filters.applied_date_from), 'MMM d, yyyy')
                          : 'From date'}
                      </Button>
                    </PopoverTrigger>
                    <PopoverContent className="w-auto p-0" align="start">
                      <CalendarComponent
                        mode="single"
                        selected={filters.applied_date_from ? new Date(filters.applied_date_from) : undefined}
                        onSelect={(date) => updateFilter('applied_date_from', date ? format(date, 'yyyy-MM-dd') : undefined)}
                      />
                    </PopoverContent>
                  </Popover>
                  <span className="text-muted-foreground">to</span>
                  <Popover>
                    <PopoverTrigger asChild>
                      <Button variant="outline" className="flex-1 justify-start">
                        {filters.applied_date_to
                          ? format(new Date(filters.applied_date_to), 'MMM d, yyyy')
                          : 'To date'}
                      </Button>
                    </PopoverTrigger>
                    <PopoverContent className="w-auto p-0" align="start">
                      <CalendarComponent
                        mode="single"
                        selected={filters.applied_date_to ? new Date(filters.applied_date_to) : undefined}
                        onSelect={(date) => updateFilter('applied_date_to', date ? format(date, 'yyyy-MM-dd') : undefined)}
                      />
                    </PopoverContent>
                  </Popover>
                </div>
              </div>

              <Separator />

              {/* Tags Filter */}
              {options?.tags && options.tags.length > 0 && (
                <div className="space-y-2">
                  <Label className="text-sm font-medium flex items-center gap-2">
                    <Tag className="h-4 w-4" />
                    Tags
                  </Label>
                  <div className="flex flex-wrap gap-2">
                    {options.tags.map((tag) => (
                      <Badge
                        key={tag.id}
                        variant={filters.tags?.includes(tag.id) ? 'default' : 'outline'}
                        className="cursor-pointer gap-1"
                        style={
                          filters.tags?.includes(tag.id)
                            ? { backgroundColor: tag.color, borderColor: tag.color }
                            : { borderColor: tag.color, color: tag.color }
                        }
                        onClick={() => toggleArrayFilter('tags', tag.id)}
                      >
                        {tag.name}
                      </Badge>
                    ))}
                  </div>
                </div>
              )}

              <Separator />

              {/* Source Filter */}
              {options?.sources && options.sources.length > 0 && (
                <div className="space-y-2">
                  <Label className="text-sm font-medium">Source</Label>
                  <Select
                    value={filters.source || ''}
                    onValueChange={(value) => updateFilter('source', value || undefined)}
                  >
                    <SelectTrigger>
                      <SelectValue placeholder="Any source" />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="">Any source</SelectItem>
                      {options.sources.map((src) => (
                        <SelectItem key={src} value={src}>{src}</SelectItem>
                      ))}
                    </SelectContent>
                  </Select>
                </div>
              )}

              <Separator />

              {/* Boolean Filters */}
              <div className="space-y-4">
                <div className="flex items-center justify-between">
                  <Label className="flex items-center gap-2">
                    <Star className="h-4 w-4" />
                    Favorites only
                  </Label>
                  <Switch
                    checked={filters.is_favorite === true}
                    onCheckedChange={(checked) => updateFilter('is_favorite', checked ? true : undefined)}
                  />
                </div>
                <div className="flex items-center justify-between">
                  <Label className="flex items-center gap-2">
                    <Clock className="h-4 w-4" />
                    Has scheduled interviews
                  </Label>
                  <Switch
                    checked={filters.has_interview === true}
                    onCheckedChange={(checked) => updateFilter('has_interview', checked ? true : undefined)}
                  />
                </div>
              </div>

              <Separator />

              {/* Action Buttons */}
              <div className="flex gap-2">
                <Button
                  variant="outline"
                  className="flex-1"
                  onClick={handleClearFilters}
                >
                  Clear All
                </Button>
                <Button
                  variant="outline"
                  onClick={() => setSaveDialogOpen(true)}
                  disabled={activeFilterCount === 0}
                >
                  <Save className="h-4 w-4 mr-2" />
                  Save Search
                </Button>
                <Button
                  className="flex-1"
                  onClick={() => {
                    onSearch();
                    setIsOpen(false);
                  }}
                >
                  Apply Filters
                </Button>
              </div>
            </div>
          </SheetContent>
        </Sheet>

        {/* Active Filter Badges */}
        {activeFilterCount > 0 && (
          <div className="flex items-center gap-2">
            <Button
              variant="ghost"
              size="sm"
              onClick={handleClearFilters}
              className="text-muted-foreground"
            >
              Clear all
            </Button>
          </div>
        )}
      </div>

      {/* Save Search Dialog */}
      <Dialog open={saveDialogOpen} onOpenChange={setSaveDialogOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Save Search</DialogTitle>
            <DialogDescription>
              Save your current filters to quickly access them later
            </DialogDescription>
          </DialogHeader>
          <div className="space-y-4">
            <div className="space-y-2">
              <Label>Name</Label>
              <Input
                placeholder="e.g., Tech companies in SF"
                value={searchName}
                onChange={(e) => setSearchName(e.target.value)}
              />
            </div>
            <div className="space-y-2">
              <Label>Description (optional)</Label>
              <Input
                placeholder="Describe this search..."
                value={searchDescription}
                onChange={(e) => setSearchDescription(e.target.value)}
              />
            </div>
          </div>
          <DialogFooter>
            <Button variant="outline" onClick={() => setSaveDialogOpen(false)}>
              Cancel
            </Button>
            <Button
              onClick={handleSaveSearch}
              disabled={saveSearchMutation.isPending}
            >
              {saveSearchMutation.isPending && (
                <Loader2 className="h-4 w-4 mr-2 animate-spin" />
              )}
              Save Search
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </>
  );
}

export default AdvancedSearchPanel;
