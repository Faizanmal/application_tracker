'use client';

import { useState, useRef } from 'react';
import { format, parseISO } from 'date-fns';
import {
  FileText,
  Upload,
  Download,
  Trash2,
  MoreHorizontal,
  Star,
  Eye,
  Loader2,
  File,
  AlertCircle,
} from 'lucide-react';

import { Button } from '@/components/ui/button';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { Skeleton } from '@/components/ui/skeleton';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Textarea } from '@/components/ui/textarea';
import { Switch } from '@/components/ui/switch';
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu';
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
  useResumes, 
  useUploadResume, 
  useSetDefaultResume,
  useDeleteResume,
} from '@/hooks/use-queries';
import { useIsPro } from '@/lib/auth';
import type { Resume } from '@/types';

const FILE_SIZE_LIMIT = 5 * 1024 * 1024; // 5MB
const ALLOWED_TYPES = ['application/pdf', 'application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'];
const FREE_RESUME_LIMIT = 3;

function formatFileSize(bytes: number): string {
  if (bytes < 1024) return `${bytes} B`;
  if (bytes < 1024 * 1024) return `${(bytes / 1024).toFixed(1)} KB`;
  return `${(bytes / (1024 * 1024)).toFixed(1)} MB`;
}

function getFileIcon(fileName: string) {
  const ext = fileName.split('.').pop()?.toLowerCase();
  if (ext === 'pdf') {
    return <FileText className="h-8 w-8 text-red-500" />;
  }
  return <File className="h-8 w-8 text-blue-500" />;
}

function ResumeCard({ 
  resume, 
  onSetDefault,
  onDelete,
}: { 
  resume: Resume;
  onSetDefault: () => void;
  onDelete: () => void;
}) {
  const [deleteDialogOpen, setDeleteDialogOpen] = useState(false);
  const setDefaultResume = useSetDefaultResume();

  const handleSetDefault = () => {
    setDefaultResume.mutate(resume.id);
    onSetDefault();
  };

  return (
    <>
      <Card className={`transition-all hover:shadow-md ${resume.is_default ? 'ring-2 ring-primary' : ''}`}>
        <CardContent className="p-4">
          <div className="flex items-start gap-4">
            {/* File Icon */}
            <div className="p-3 rounded-lg bg-muted">
              {getFileIcon(resume.original_filename)}
            </div>

            {/* Content */}
            <div className="flex-1 min-w-0">
              <div className="flex items-center gap-2 mb-1">
                <h3 className="font-semibold truncate">{resume.name}</h3>
                {resume.is_default && (
                  <Badge className="bg-primary/10 text-primary hover:bg-primary/20">
                    <Star className="mr-1 h-3 w-3 fill-current" />
                    Default
                  </Badge>
                )}
              </div>

              <p className="text-sm text-muted-foreground truncate">
                {resume.original_filename}
              </p>

              {resume.description && (
                <p className="text-sm text-muted-foreground mt-1 line-clamp-2">
                  {resume.description}
                </p>
              )}

              <div className="flex items-center gap-4 mt-2 text-sm text-muted-foreground">
                <span>{formatFileSize(resume.file_size)}</span>
                <span>•</span>
                <span>Uploaded {format(parseISO(resume.created_at), 'MMM d, yyyy')}</span>
              </div>

              {resume.usage_count > 0 && (
                <p className="text-xs text-muted-foreground mt-1">
                  Used in {resume.usage_count} application{resume.usage_count > 1 ? 's' : ''}
                </p>
              )}
            </div>

            {/* Actions */}
            <DropdownMenu>
              <DropdownMenuTrigger asChild>
                <Button variant="ghost" size="icon">
                  <MoreHorizontal className="h-4 w-4" />
                </Button>
              </DropdownMenuTrigger>
              <DropdownMenuContent align="end">
                <DropdownMenuItem asChild>
                  <a href={resume.file} target="_blank" rel="noopener noreferrer">
                    <Eye className="mr-2 h-4 w-4" />
                    Preview
                  </a>
                </DropdownMenuItem>
                <DropdownMenuItem asChild>
                  <a href={resume.file} download={resume.original_filename}>
                    <Download className="mr-2 h-4 w-4" />
                    Download
                  </a>
                </DropdownMenuItem>
                <DropdownMenuSeparator />
                {!resume.is_default && (
                  <DropdownMenuItem onClick={handleSetDefault}>
                    <Star className="mr-2 h-4 w-4" />
                    Set as Default
                  </DropdownMenuItem>
                )}
                <DropdownMenuItem 
                  className="text-red-600"
                  onClick={() => setDeleteDialogOpen(true)}
                >
                  <Trash2 className="mr-2 h-4 w-4" />
                  Delete
                </DropdownMenuItem>
              </DropdownMenuContent>
            </DropdownMenu>
          </div>
        </CardContent>
      </Card>

      <AlertDialog open={deleteDialogOpen} onOpenChange={setDeleteDialogOpen}>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Delete Resume</AlertDialogTitle>
            <AlertDialogDescription>
              Are you sure you want to delete &quot;{resume.name}&quot;? This action cannot be undone.
              {resume.usage_count > 0 && (
                <span className="block mt-2 text-yellow-600">
                  ⚠️ This resume is currently used in {resume.usage_count} application(s).
                </span>
              )}
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel>Cancel</AlertDialogCancel>
            <AlertDialogAction
              onClick={onDelete}
              className="bg-red-600 hover:bg-red-700"
            >
              Delete
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </>
  );
}

function UploadResumeDialog({ disabled }: { disabled?: boolean }) {
  const [open, setOpen] = useState(false);
  const [file, setFile] = useState<File | null>(null);
  const [formData, setFormData] = useState({
    name: '',
    description: '',
    is_default: false,
  });
  const [error, setError] = useState<string | null>(null);
  const fileInputRef = useRef<HTMLInputElement>(null);
  const uploadResume = useUploadResume();

  const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const selectedFile = e.target.files?.[0];
    setError(null);

    if (!selectedFile) return;

    if (!ALLOWED_TYPES.includes(selectedFile.type)) {
      setError('Please upload a PDF or Word document');
      return;
    }

    if (selectedFile.size > FILE_SIZE_LIMIT) {
      setError('File size must be less than 5MB');
      return;
    }

    setFile(selectedFile);
    // Auto-fill name from filename
    if (!formData.name) {
      const nameWithoutExt = selectedFile.name.replace(/\.[^/.]+$/, '');
      setFormData(prev => ({ ...prev, name: nameWithoutExt }));
    }
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!file) {
      setError('Please select a file');
      return;
    }

    const submitData = {
      file: file,
      name: formData.name || file.name,
      version: formData.description, // Using description as version for now
    };

    uploadResume.mutate(submitData, {
      onSuccess: () => {
        setOpen(false);
        setFile(null);
        setFormData({ name: '', description: '', is_default: false });
        setError(null);
      },
      onError: (err: unknown) => {
        const error = err as { response?: { data?: { message?: string } } };
        setError(error.response?.data?.message || 'Failed to upload resume');
      },
    });
  };

  const handleDrop = (e: React.DragEvent) => {
    e.preventDefault();
    const droppedFile = e.dataTransfer.files?.[0];
    if (droppedFile) {
      const event = { target: { files: [droppedFile] } } as unknown as React.ChangeEvent<HTMLInputElement>;
      handleFileChange(event);
    }
  };

  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <DialogTrigger asChild>
        <Button disabled={disabled}>
          <Upload className="mr-2 h-4 w-4" />
          Upload Resume
        </Button>
      </DialogTrigger>
      <DialogContent className="sm:max-w-[500px]">
        <form onSubmit={handleSubmit}>
          <DialogHeader>
            <DialogTitle>Upload Resume</DialogTitle>
            <DialogDescription>
              Upload a PDF or Word document. Max file size: 5MB.
            </DialogDescription>
          </DialogHeader>

          <div className="space-y-4 py-4">
            {/* Drop Zone */}
            <div
              className={`border-2 border-dashed rounded-lg p-8 text-center cursor-pointer transition-colors ${
                file ? 'border-primary bg-primary/5' : 'border-muted-foreground/25 hover:border-primary/50'
              }`}
              onClick={() => fileInputRef.current?.click()}
              onDrop={handleDrop}
              onDragOver={(e) => e.preventDefault()}
            >
              <input
                ref={fileInputRef}
                type="file"
                accept=".pdf,.doc,.docx"
                onChange={handleFileChange}
                className="hidden"
              />
              {file ? (
                <div className="flex flex-col items-center gap-2">
                  {getFileIcon(file.name)}
                  <p className="font-medium">{file.name}</p>
                  <p className="text-sm text-muted-foreground">{formatFileSize(file.size)}</p>
                  <Button type="button" variant="ghost" size="sm" onClick={(e) => {
                    e.stopPropagation();
                    setFile(null);
                  }}>
                    Choose different file
                  </Button>
                </div>
              ) : (
                <div className="flex flex-col items-center gap-2">
                  <Upload className="h-8 w-8 text-muted-foreground" />
                  <p className="font-medium">Drop your resume here</p>
                  <p className="text-sm text-muted-foreground">or click to browse</p>
                </div>
              )}
            </div>

            {error && (
              <div className="flex items-center gap-2 text-sm text-red-600">
                <AlertCircle className="h-4 w-4" />
                {error}
              </div>
            )}

            {/* Name */}
            <div className="space-y-2">
              <Label htmlFor="name">Name</Label>
              <Input
                id="name"
                value={formData.name}
                onChange={(e) => setFormData(prev => ({ ...prev, name: e.target.value }))}
                placeholder="e.g., Software Engineer Resume"
              />
            </div>

            {/* Description */}
            <div className="space-y-2">
              <Label htmlFor="description">Description (optional)</Label>
              <Textarea
                id="description"
                value={formData.description}
                onChange={(e) => setFormData(prev => ({ ...prev, description: e.target.value }))}
                placeholder="Add notes about this resume version..."
                rows={3}
              />
            </div>

            {/* Set as Default */}
            <div className="flex items-center justify-between">
              <div className="space-y-0.5">
                <Label htmlFor="is_default">Set as default</Label>
                <p className="text-sm text-muted-foreground">
                  Use this resume automatically for new applications
                </p>
              </div>
              <Switch
                id="is_default"
                checked={formData.is_default}
                onCheckedChange={(checked) => setFormData(prev => ({ ...prev, is_default: checked }))}
              />
            </div>
          </div>

          <DialogFooter>
            <Button type="button" variant="outline" onClick={() => setOpen(false)}>
              Cancel
            </Button>
            <Button type="submit" disabled={!file || uploadResume.isPending}>
              {uploadResume.isPending ? (
                <>
                  <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                  Uploading...
                </>
              ) : (
                <>
                  <Upload className="mr-2 h-4 w-4" />
                  Upload
                </>
              )}
            </Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  );
}

export default function ResumesPage() {
  const { data: resumes, isLoading } = useResumes();
  const deleteResume = useDeleteResume();
  const isPro = useIsPro();

  const resumeList = resumes?.results || [];
  const canUploadMore = isPro || resumeList.length < FREE_RESUME_LIMIT;

  const handleDelete = (id: number) => {
    deleteResume.mutate(id);
  };

  return (
    <div className="p-6 space-y-6">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <h1 className="text-2xl font-bold">Resumes</h1>
          <p className="text-muted-foreground">
            Manage your resume versions for different applications
          </p>
        </div>
        <UploadResumeDialog disabled={!canUploadMore} />
      </div>

      {/* Limit Warning */}
      {!isPro && resumeList.length >= FREE_RESUME_LIMIT && (
        <Card className="border-yellow-300 bg-yellow-50">
          <CardContent className="p-4">
            <div className="flex items-center gap-3">
              <AlertCircle className="h-5 w-5 text-yellow-600" />
              <div className="flex-1">
                <p className="font-medium text-yellow-800">Resume limit reached</p>
                <p className="text-sm text-yellow-700">
                  Free accounts can store up to {FREE_RESUME_LIMIT} resumes. Upgrade to Pro for unlimited storage.
                </p>
              </div>
              <Button size="sm">Upgrade to Pro</Button>
            </div>
          </CardContent>
        </Card>
      )}

      {/* Usage Info */}
      {!isPro && (
        <div className="flex items-center gap-2 text-sm text-muted-foreground">
          <FileText className="h-4 w-4" />
          <span>{resumeList.length} of {FREE_RESUME_LIMIT} resumes used</span>
        </div>
      )}

      {/* Resume List */}
      {isLoading ? (
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          {[1, 2, 3].map((i) => (
            <Skeleton key={i} className="h-32 w-full" />
          ))}
        </div>
      ) : resumeList.length > 0 ? (
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          {resumeList.map((resume) => (
            <ResumeCard
              key={resume.id}
              resume={resume}
              onSetDefault={() => {}}
              onDelete={() => handleDelete(resume.id)}
            />
          ))}
        </div>
      ) : (
        <Card>
          <CardContent className="py-12 text-center">
            <FileText className="h-12 w-12 mx-auto mb-4 text-muted-foreground opacity-50" />
            <h3 className="text-lg font-semibold mb-2">No resumes yet</h3>
            <p className="text-muted-foreground mb-4">
              Upload your first resume to start applying for jobs
            </p>
            <UploadResumeDialog />
          </CardContent>
        </Card>
      )}

      {/* Tips Section */}
      <Card>
        <CardHeader>
          <CardTitle className="text-lg">Resume Tips</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
            <div className="p-4 rounded-lg bg-blue-50 border border-blue-200">
              <h4 className="font-medium text-blue-900 mb-1">Tailor for Each Role</h4>
              <p className="text-sm text-blue-700">
                Create versions targeting specific job types or industries
              </p>
            </div>
            <div className="p-4 rounded-lg bg-green-50 border border-green-200">
              <h4 className="font-medium text-green-900 mb-1">Keep It Updated</h4>
              <p className="text-sm text-green-700">
                Regularly update with new skills and achievements
              </p>
            </div>
            <div className="p-4 rounded-lg bg-purple-50 border border-purple-200">
              <h4 className="font-medium text-purple-900 mb-1">Use Keywords</h4>
              <p className="text-sm text-purple-700">
                Include relevant keywords from job descriptions
              </p>
            </div>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
