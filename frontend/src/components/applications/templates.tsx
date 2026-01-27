'use client';

import { useState, useCallback } from 'react';
import {
  FileText,
  Plus,
  Edit,
  Trash2,
  Copy,
  Star,
  StarOff,
  MoreHorizontal,
  Loader2,
  ChevronRight,
  FolderOpen,
} from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Textarea } from '@/components/ui/textarea';
import { Badge } from '@/components/ui/badge';
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from '@/components/ui/dialog';
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select';
import {
  Card,
  CardContent,
  CardDescription,
  CardFooter,
  CardHeader,
  CardTitle,
} from '@/components/ui/card';
import { Separator } from '@/components/ui/separator';
import { toast } from 'sonner';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { apiClient } from '@/lib/api';
import type { ApplicationTag } from '@/types';

// Types
interface ApplicationTemplate {
  id: string;
  name: string;
  description: string;
  category: string;
  job_type: string;
  work_location: string;
  cover_letter_template: string;
  notes_template: string;
  default_resume: string | null;
  default_tags: ApplicationTag[];
  checklist: string[];
  use_count: number;
  is_favorite: boolean;
  created_at: string;
  updated_at: string;
}

interface CoverLetterTemplate {
  id: string;
  name: string;
  description: string;
  content: string;
  category: string;
  use_count: number;
  is_default: boolean;
  created_at: string;
}

// API functions
const templatesApi = {
  list: async (): Promise<ApplicationTemplate[]> => {
    const response = await apiClient.get('/applications/templates/');
    return response.data;
  },
  create: async (data: Partial<ApplicationTemplate>): Promise<ApplicationTemplate> => {
    const response = await apiClient.post('/applications/templates/', data);
    return response.data;
  },
  update: async (id: string, data: Partial<ApplicationTemplate>): Promise<ApplicationTemplate> => {
    const response = await apiClient.patch(`/applications/templates/${id}/`, data);
    return response.data;
  },
  delete: async (id: string): Promise<void> => {
    await apiClient.delete(`/applications/templates/${id}/`);
  },
  use: async (id: string, applicationData: Record<string, unknown>): Promise<unknown> => {
    const response = await apiClient.post(`/applications/templates/${id}/use/`, applicationData);
    return response.data;
  },
  coverLetters: {
    list: async (): Promise<CoverLetterTemplate[]> => {
      const response = await apiClient.get('/applications/cover-letter-templates/');
      return response.data;
    },
    create: async (data: Partial<CoverLetterTemplate>): Promise<CoverLetterTemplate> => {
      const response = await apiClient.post('/applications/cover-letter-templates/', data);
      return response.data;
    },
    update: async (id: string, data: Partial<CoverLetterTemplate>): Promise<CoverLetterTemplate> => {
      const response = await apiClient.patch(`/applications/cover-letter-templates/${id}/`, data);
      return response.data;
    },
    delete: async (id: string): Promise<void> => {
      await apiClient.delete(`/applications/cover-letter-templates/${id}/`);
    },
    render: async (id: string, context: Record<string, string>): Promise<{ rendered: string }> => {
      const response = await apiClient.post('/applications/cover-letter-templates/render/', {
        template_id: id,
        context,
      });
      return response.data;
    },
  },
};

// Application Template Editor
function TemplateEditor({
  template,
  onSave,
  onClose,
}: {
  template?: ApplicationTemplate;
  onSave: (data: Partial<ApplicationTemplate>) => void;
  onClose: () => void;
}) {
  const [name, setName] = useState(template?.name || '');
  const [description, setDescription] = useState(template?.description || '');
  const [category, setCategory] = useState(template?.category || '');
  const [jobType, setJobType] = useState(template?.job_type || '');
  const [workLocation, setWorkLocation] = useState(template?.work_location || '');
  const [coverLetterTemplate, setCoverLetterTemplate] = useState(template?.cover_letter_template || '');
  const [notesTemplate, setNotesTemplate] = useState(template?.notes_template || '');
  const [checklist, setChecklist] = useState<string[]>(template?.checklist || []);
  const [newChecklistItem, setNewChecklistItem] = useState('');

  const handleAddChecklistItem = () => {
    if (newChecklistItem.trim()) {
      setChecklist([...checklist, newChecklistItem.trim()]);
      setNewChecklistItem('');
    }
  };

  const handleRemoveChecklistItem = (index: number) => {
    setChecklist(checklist.filter((_, i) => i !== index));
  };

  const handleSave = () => {
    if (!name.trim()) {
      toast.error('Please enter a template name');
      return;
    }
    onSave({
      name,
      description,
      category,
      job_type: jobType,
      work_location: workLocation,
      cover_letter_template: coverLetterTemplate,
      notes_template: notesTemplate,
      checklist,
    });
  };

  return (
    <div className="space-y-6">
      <div className="grid grid-cols-2 gap-4">
        <div className="space-y-2">
          <Label>Template Name *</Label>
          <Input
            placeholder="e.g., Software Engineer Application"
            value={name}
            onChange={(e) => setName(e.target.value)}
          />
        </div>
        <div className="space-y-2">
          <Label>Category</Label>
          <Input
            placeholder="e.g., Tech, Marketing, Finance"
            value={category}
            onChange={(e) => setCategory(e.target.value)}
          />
        </div>
      </div>

      <div className="space-y-2">
        <Label>Description</Label>
        <Textarea
          placeholder="Describe when to use this template..."
          value={description}
          onChange={(e) => setDescription(e.target.value)}
          rows={2}
        />
      </div>

      <div className="grid grid-cols-2 gap-4">
        <div className="space-y-2">
          <Label>Default Job Type</Label>
          <Select value={jobType} onValueChange={setJobType}>
            <SelectTrigger>
              <SelectValue placeholder="Select job type" />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value="full_time">Full Time</SelectItem>
              <SelectItem value="part_time">Part Time</SelectItem>
              <SelectItem value="contract">Contract</SelectItem>
              <SelectItem value="internship">Internship</SelectItem>
              <SelectItem value="freelance">Freelance</SelectItem>
            </SelectContent>
          </Select>
        </div>
        <div className="space-y-2">
          <Label>Default Work Location</Label>
          <Select value={workLocation} onValueChange={setWorkLocation}>
            <SelectTrigger>
              <SelectValue placeholder="Select work location" />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value="onsite">On-site</SelectItem>
              <SelectItem value="remote">Remote</SelectItem>
              <SelectItem value="hybrid">Hybrid</SelectItem>
            </SelectContent>
          </Select>
        </div>
      </div>

      <Separator />

      <div className="space-y-2">
        <Label>Cover Letter Template</Label>
        <p className="text-xs text-muted-foreground">
          Use {'{{company_name}}'}, {'{{job_title}}'}, {'{{hiring_manager}}'} as placeholders
        </p>
        <Textarea
          placeholder="Dear {{hiring_manager}},

I am excited to apply for the {{job_title}} position at {{company_name}}..."
          value={coverLetterTemplate}
          onChange={(e) => setCoverLetterTemplate(e.target.value)}
          rows={6}
        />
      </div>

      <div className="space-y-2">
        <Label>Default Notes Template</Label>
        <Textarea
          placeholder="Enter default notes for applications using this template..."
          value={notesTemplate}
          onChange={(e) => setNotesTemplate(e.target.value)}
          rows={3}
        />
      </div>

      <div className="space-y-2">
        <Label>Application Checklist</Label>
        <div className="flex gap-2">
          <Input
            placeholder="Add checklist item..."
            value={newChecklistItem}
            onChange={(e) => setNewChecklistItem(e.target.value)}
            onKeyDown={(e) => e.key === 'Enter' && handleAddChecklistItem()}
          />
          <Button type="button" onClick={handleAddChecklistItem}>
            <Plus className="h-4 w-4" />
          </Button>
        </div>
        {checklist.length > 0 && (
          <ul className="space-y-1 mt-2">
            {checklist.map((item, index) => (
              <li
                key={index}
                className="flex items-center justify-between bg-muted/50 rounded px-3 py-2 text-sm"
              >
                <span>{item}</span>
                <Button
                  variant="ghost"
                  size="sm"
                  onClick={() => handleRemoveChecklistItem(index)}
                >
                  <Trash2 className="h-4 w-4" />
                </Button>
              </li>
            ))}
          </ul>
        )}
      </div>

      <DialogFooter>
        <Button variant="outline" onClick={onClose}>
          Cancel
        </Button>
        <Button onClick={handleSave}>
          {template ? 'Update Template' : 'Create Template'}
        </Button>
      </DialogFooter>
    </div>
  );
}

// Main Templates Component
export function ApplicationTemplates() {
  const [isOpen, setIsOpen] = useState(false);
  const [editingTemplate, setEditingTemplate] = useState<ApplicationTemplate | null>(null);
  const queryClient = useQueryClient();

  // Fetch templates
  const { data: templates = [], isLoading } = useQuery({
    queryKey: ['application-templates'],
    queryFn: templatesApi.list,
  });

  // Create mutation
  const createMutation = useMutation({
    mutationFn: templatesApi.create,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['application-templates'] });
      toast.success('Template created');
      setIsOpen(false);
    },
    onError: () => {
      toast.error('Failed to create template');
    },
  });

  // Update mutation
  const updateMutation = useMutation({
    mutationFn: ({ id, data }: { id: string; data: Partial<ApplicationTemplate> }) =>
      templatesApi.update(id, data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['application-templates'] });
      toast.success('Template updated');
      setEditingTemplate(null);
    },
    onError: () => {
      toast.error('Failed to update template');
    },
  });

  // Delete mutation
  const deleteMutation = useMutation({
    mutationFn: templatesApi.delete,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['application-templates'] });
      toast.success('Template deleted');
    },
    onError: () => {
      toast.error('Failed to delete template');
    },
  });

  const handleSave = useCallback(
    (data: Partial<ApplicationTemplate>) => {
      if (editingTemplate) {
        updateMutation.mutate({ id: editingTemplate.id, data });
      } else {
        createMutation.mutate(data);
      }
    },
    [editingTemplate, createMutation, updateMutation]
  );

  const handleClose = useCallback(() => {
    setIsOpen(false);
    setEditingTemplate(null);
  }, []);

  // Group templates by category
  const templatesByCategory = templates.reduce((acc, template) => {
    const cat = template.category || 'Uncategorized';
    if (!acc[cat]) acc[cat] = [];
    acc[cat].push(template);
    return acc;
  }, {} as Record<string, ApplicationTemplate[]>);

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-2xl font-bold">Application Templates</h2>
          <p className="text-muted-foreground">
            Create reusable templates for common application types
          </p>
        </div>
        <Dialog open={isOpen || !!editingTemplate} onOpenChange={(open) => {
          if (!open) handleClose();
          else setIsOpen(true);
        }}>
          <DialogTrigger asChild>
            <Button className="gap-2">
              <Plus className="h-4 w-4" />
              New Template
            </Button>
          </DialogTrigger>
          <DialogContent className="max-w-2xl max-h-[90vh] overflow-y-auto">
            <DialogHeader>
              <DialogTitle>
                {editingTemplate ? 'Edit Template' : 'Create Template'}
              </DialogTitle>
              <DialogDescription>
                {editingTemplate
                  ? 'Update your application template'
                  : 'Create a reusable template for job applications'}
              </DialogDescription>
            </DialogHeader>
            <TemplateEditor
              template={editingTemplate || undefined}
              onSave={handleSave}
              onClose={handleClose}
            />
          </DialogContent>
        </Dialog>
      </div>

      {isLoading ? (
        <div className="flex items-center justify-center py-12">
          <Loader2 className="h-8 w-8 animate-spin text-muted-foreground" />
        </div>
      ) : templates.length === 0 ? (
        <Card className="text-center py-12">
          <CardContent>
            <FolderOpen className="h-12 w-12 mx-auto text-muted-foreground mb-4" />
            <h3 className="font-semibold text-lg">No templates yet</h3>
            <p className="text-muted-foreground mb-4">
              Create your first template to speed up your application process
            </p>
            <Button onClick={() => setIsOpen(true)}>
              <Plus className="h-4 w-4 mr-2" />
              Create Template
            </Button>
          </CardContent>
        </Card>
      ) : (
        <div className="space-y-6">
          {Object.entries(templatesByCategory).map(([category, categoryTemplates]) => (
            <div key={category} className="space-y-3">
              <h3 className="font-semibold text-sm text-muted-foreground uppercase tracking-wide">
                {category}
              </h3>
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                {categoryTemplates.map((template) => (
                  <Card key={template.id} className="group">
                    <CardHeader className="pb-2">
                      <div className="flex items-start justify-between">
                        <div className="flex-1">
                          <CardTitle className="text-lg">{template.name}</CardTitle>
                          {template.description && (
                            <CardDescription className="line-clamp-2">
                              {template.description}
                            </CardDescription>
                          )}
                        </div>
                        <DropdownMenu>
                          <DropdownMenuTrigger asChild>
                            <Button
                              variant="ghost"
                              size="icon"
                              className="opacity-0 group-hover:opacity-100 transition-opacity"
                            >
                              <MoreHorizontal className="h-4 w-4" />
                            </Button>
                          </DropdownMenuTrigger>
                          <DropdownMenuContent align="end">
                            <DropdownMenuItem onClick={() => setEditingTemplate(template)}>
                              <Edit className="h-4 w-4 mr-2" />
                              Edit
                            </DropdownMenuItem>
                            <DropdownMenuItem>
                              <Copy className="h-4 w-4 mr-2" />
                              Duplicate
                            </DropdownMenuItem>
                            <DropdownMenuSeparator />
                            <DropdownMenuItem
                              className="text-red-600"
                              onClick={() => deleteMutation.mutate(template.id)}
                            >
                              <Trash2 className="h-4 w-4 mr-2" />
                              Delete
                            </DropdownMenuItem>
                          </DropdownMenuContent>
                        </DropdownMenu>
                      </div>
                    </CardHeader>
                    <CardContent className="pb-2">
                      <div className="flex flex-wrap gap-2">
                        {template.job_type && (
                          <Badge variant="secondary">{template.job_type}</Badge>
                        )}
                        {template.work_location && (
                          <Badge variant="outline">{template.work_location}</Badge>
                        )}
                        {template.checklist.length > 0 && (
                          <Badge variant="outline">
                            {template.checklist.length} checklist items
                          </Badge>
                        )}
                      </div>
                    </CardContent>
                    <CardFooter className="flex items-center justify-between pt-2 border-t">
                      <span className="text-xs text-muted-foreground">
                        Used {template.use_count} times
                      </span>
                      <Button variant="ghost" size="sm" className="gap-1">
                        Use Template
                        <ChevronRight className="h-4 w-4" />
                      </Button>
                    </CardFooter>
                  </Card>
                ))}
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}

// Cover Letter Templates Component
export function CoverLetterTemplates() {
  const [isOpen, setIsOpen] = useState(false);
  const [editingTemplate, setEditingTemplate] = useState<CoverLetterTemplate | null>(null);
  const [name, setName] = useState('');
  const [description, setDescription] = useState('');
  const [content, setContent] = useState('');
  const [category, setCategory] = useState('');
  const queryClient = useQueryClient();

  const { data: templates = [], isLoading } = useQuery({
    queryKey: ['cover-letter-templates'],
    queryFn: templatesApi.coverLetters.list,
  });

  const createMutation = useMutation({
    mutationFn: templatesApi.coverLetters.create,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['cover-letter-templates'] });
      toast.success('Template created');
      resetForm();
    },
  });

  const updateMutation = useMutation({
    mutationFn: ({ id, data }: { id: string; data: Partial<CoverLetterTemplate> }) =>
      templatesApi.coverLetters.update(id, data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['cover-letter-templates'] });
      toast.success('Template updated');
      resetForm();
    },
  });

  const deleteMutation = useMutation({
    mutationFn: templatesApi.coverLetters.delete,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['cover-letter-templates'] });
      toast.success('Template deleted');
    },
  });

  const resetForm = () => {
    setIsOpen(false);
    setEditingTemplate(null);
    setName('');
    setDescription('');
    setContent('');
    setCategory('');
  };

  const handleEdit = (template: CoverLetterTemplate) => {
    setEditingTemplate(template);
    setName(template.name);
    setDescription(template.description);
    setContent(template.content);
    setCategory(template.category);
    setIsOpen(true);
  };

  const handleSave = () => {
    if (!name.trim() || !content.trim()) {
      toast.error('Please fill in required fields');
      return;
    }

    const data = { name, description, content, category };
    if (editingTemplate) {
      updateMutation.mutate({ id: editingTemplate.id, data });
    } else {
      createMutation.mutate(data);
    }
  };

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-2xl font-bold">Cover Letter Templates</h2>
          <p className="text-muted-foreground">
            Manage reusable cover letter templates with dynamic placeholders
          </p>
        </div>
        <Dialog open={isOpen} onOpenChange={(open) => {
          if (!open) resetForm();
          else setIsOpen(true);
        }}>
          <DialogTrigger asChild>
            <Button className="gap-2">
              <Plus className="h-4 w-4" />
              New Template
            </Button>
          </DialogTrigger>
          <DialogContent className="max-w-2xl max-h-[90vh] overflow-y-auto">
            <DialogHeader>
              <DialogTitle>
                {editingTemplate ? 'Edit Cover Letter' : 'Create Cover Letter Template'}
              </DialogTitle>
            </DialogHeader>
            <div className="space-y-4">
              <div className="grid grid-cols-2 gap-4">
                <div className="space-y-2">
                  <Label>Name *</Label>
                  <Input
                    value={name}
                    onChange={(e) => setName(e.target.value)}
                    placeholder="e.g., Software Engineer Cover Letter"
                  />
                </div>
                <div className="space-y-2">
                  <Label>Category</Label>
                  <Input
                    value={category}
                    onChange={(e) => setCategory(e.target.value)}
                    placeholder="e.g., Tech, General"
                  />
                </div>
              </div>
              <div className="space-y-2">
                <Label>Description</Label>
                <Input
                  value={description}
                  onChange={(e) => setDescription(e.target.value)}
                  placeholder="When to use this template..."
                />
              </div>
              <div className="space-y-2">
                <Label>Content *</Label>
                <p className="text-xs text-muted-foreground">
                  Available placeholders: {'{{company_name}}'}, {'{{job_title}}'}, {'{{hiring_manager}}'}
                </p>
                <Textarea
                  value={content}
                  onChange={(e) => setContent(e.target.value)}
                  rows={12}
                  placeholder="Dear {{hiring_manager}},

I am writing to express my interest in the {{job_title}} position at {{company_name}}..."
                />
              </div>
            </div>
            <DialogFooter>
              <Button variant="outline" onClick={resetForm}>Cancel</Button>
              <Button onClick={handleSave}>
                {editingTemplate ? 'Update' : 'Create'}
              </Button>
            </DialogFooter>
          </DialogContent>
        </Dialog>
      </div>

      {isLoading ? (
        <div className="flex items-center justify-center py-12">
          <Loader2 className="h-8 w-8 animate-spin text-muted-foreground" />
        </div>
      ) : templates.length === 0 ? (
        <Card className="text-center py-12">
          <CardContent>
            <FileText className="h-12 w-12 mx-auto text-muted-foreground mb-4" />
            <h3 className="font-semibold text-lg">No cover letter templates</h3>
            <p className="text-muted-foreground mb-4">
              Create templates with placeholders to speed up your applications
            </p>
            <Button onClick={() => setIsOpen(true)}>
              <Plus className="h-4 w-4 mr-2" />
              Create Template
            </Button>
          </CardContent>
        </Card>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          {templates.map((template) => (
            <Card key={template.id} className="group">
              <CardHeader className="pb-2">
                <div className="flex items-start justify-between">
                  <div>
                    <CardTitle className="text-lg flex items-center gap-2">
                      {template.name}
                      {template.is_default && (
                        <Badge variant="secondary">Default</Badge>
                      )}
                    </CardTitle>
                    {template.category && (
                      <CardDescription>{template.category}</CardDescription>
                    )}
                  </div>
                  <DropdownMenu>
                    <DropdownMenuTrigger asChild>
                      <Button
                        variant="ghost"
                        size="icon"
                        className="opacity-0 group-hover:opacity-100 transition-opacity"
                      >
                        <MoreHorizontal className="h-4 w-4" />
                      </Button>
                    </DropdownMenuTrigger>
                    <DropdownMenuContent align="end">
                      <DropdownMenuItem onClick={() => handleEdit(template)}>
                        <Edit className="h-4 w-4 mr-2" />
                        Edit
                      </DropdownMenuItem>
                      <DropdownMenuItem>
                        <Copy className="h-4 w-4 mr-2" />
                        Duplicate
                      </DropdownMenuItem>
                      <DropdownMenuSeparator />
                      <DropdownMenuItem
                        className="text-red-600"
                        onClick={() => deleteMutation.mutate(template.id)}
                      >
                        <Trash2 className="h-4 w-4 mr-2" />
                        Delete
                      </DropdownMenuItem>
                    </DropdownMenuContent>
                  </DropdownMenu>
                </div>
              </CardHeader>
              <CardContent>
                <p className="text-sm text-muted-foreground line-clamp-3">
                  {template.content.substring(0, 150)}...
                </p>
              </CardContent>
              <CardFooter className="text-xs text-muted-foreground border-t pt-3">
                Used {template.use_count} times
              </CardFooter>
            </Card>
          ))}
        </div>
      )}
    </div>
  );
}

export default ApplicationTemplates;
