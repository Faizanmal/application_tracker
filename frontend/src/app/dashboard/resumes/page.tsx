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
  Sparkles,
  Zap,
  Target,
} from 'lucide-react';

import { Button } from '@/components/ui/button';
import { CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { Skeleton } from '@/components/ui/skeleton';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Textarea } from '@/components/ui/textarea';
import { Switch } from '@/components/ui/switch';
import { AnimatedCard } from '@/components/ui/animated-card';
import { GradientButton, AnimatedNumber, EmptyState as AnimatedEmptyState } from '@/components/ui/animated-elements';
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
    return <FileText className="h-6 w-6 text-white" />;
  }
  return <File className="h-6 w-6 text-white" />;
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
      <AnimatedCard variant="interactive" hoverEffect="lift" className={`${resume.is_default ? 'ring-2 ring-primary' : ''}`}>
        <CardContent className="p-4">
          <div className="flex items-start gap-4">
            {/* File Icon */}
            <div className={`p-3 rounded-xl shadow-md ${resume.original_filename.endsWith('.pdf') ? 'bg-gradient-to-br from-red-500 to-rose-600' : 'bg-gradient-to-br from-blue-500 to-indigo-600'}`}>
              {getFileIcon(resume.original_filename)}
            </div>

            {/* Content */}
            <div className="flex-1 min-w-0">
              <div className="flex items-center gap-2 mb-1">
                <h3 className="font-semibold truncate">{resume.name}</h3>
                {resume.is_default && (
                  <Badge className="bg-gradient-to-r from-primary to-purple-600 text-white hover:from-primary/90 hover:to-purple-600/90">
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
      </AnimatedCard>

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
        <GradientButton disabled={disabled}>
          <Upload className="mr-2 h-4 w-4" />
          Upload Resume
        </GradientButton>
      </DialogTrigger>
      <DialogContent className="sm:max-w-[500px]">
        <form onSubmit={handleSubmit}>
          <DialogHeader>
            <DialogTitle className="flex items-center gap-2">
              <div className="p-2 bg-gradient-to-br from-primary to-purple-600 rounded-lg">
                <Upload className="h-4 w-4 text-white" />
              </div>
              Upload Resume
            </DialogTitle>
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
            <GradientButton type="submit" disabled={!file || uploadResume.isPending}>
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
            </GradientButton>
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
      {/* Header with Gradient */}
      <div className="relative overflow-hidden rounded-2xl bg-gradient-to-r from-rose-600 via-pink-600 to-fuchsia-600 p-8">
        <div className="absolute top-0 right-0 w-64 h-64 bg-white/10 rounded-full blur-3xl -translate-y-1/2 translate-x-1/2" />
        <div className="absolute bottom-0 left-0 w-48 h-48 bg-white/5 rounded-full blur-2xl translate-y-1/2 -translate-x-1/2" />
        <div className="absolute top-1/2 right-1/4 w-32 h-32 bg-pink-400/20 rounded-full blur-xl" />
        
        <div className="relative flex flex-col sm:flex-row sm:items-center sm:justify-between gap-6">
          <div className="animate-fade-in-up">
            <h1 className="text-3xl font-bold text-white flex items-center gap-3">
              <div className="p-2 bg-white/20 rounded-xl backdrop-blur-sm">
                <FileText className="h-7 w-7" />
              </div>
              Resumes
            </h1>
            <p className="text-white/80 mt-2 max-w-md">
              Manage your resume versions for different applications
            </p>
          </div>
          <div className="animate-fade-in-up stagger-2">
            <UploadResumeDialog disabled={!canUploadMore} />
          </div>
        </div>

        <div className="relative grid grid-cols-2 sm:grid-cols-3 gap-4 mt-6 animate-fade-in-up stagger-3">
          <div className="bg-white/10 backdrop-blur-sm rounded-xl p-4 border border-white/20">
            <p className="text-white/70 text-sm">Total Resumes</p>
            <p className="text-2xl font-bold text-white">
              <AnimatedNumber value={resumeList.length} />
            </p>
          </div>
          <div className="bg-white/10 backdrop-blur-sm rounded-xl p-4 border border-white/20">
            <p className="text-white/70 text-sm">Default Set</p>
            <p className="text-2xl font-bold text-white">
              {resumeList.some(r => r.is_default) ? 'Yes' : 'No'}
            </p>
          </div>
          <div className="bg-white/10 backdrop-blur-sm rounded-xl p-4 border border-white/20 col-span-2 sm:col-span-1">
            <p className="text-white/70 text-sm">Total Uses</p>
            <p className="text-2xl font-bold text-white">
              <AnimatedNumber value={resumeList.reduce((sum, r) => sum + r.usage_count, 0)} />
            </p>
          </div>
        </div>
      </div>

      {/* Limit Warning */}
      {!isPro && resumeList.length >= FREE_RESUME_LIMIT && (
        <AnimatedCard variant="default" className="border-yellow-300 bg-yellow-50">
          <CardContent className="p-4">
            <div className="flex items-center gap-3">
              <div className="p-2 bg-gradient-to-br from-yellow-500 to-amber-600 rounded-xl">
                <AlertCircle className="h-5 w-5 text-white" />
              </div>
              <div className="flex-1">
                <p className="font-medium text-yellow-800">Resume limit reached</p>
                <p className="text-sm text-yellow-700">
                  Free accounts can store up to {FREE_RESUME_LIMIT} resumes. Upgrade to Pro for unlimited storage.
                </p>
              </div>
              <GradientButton size="sm">
                <Sparkles className="mr-2 h-4 w-4" />
                Upgrade to Pro
              </GradientButton>
            </div>
          </CardContent>
        </AnimatedCard>
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
        <AnimatedEmptyState
          icon={<FileText className="h-12 w-12" />}
          title="No resumes yet"
          description="Upload your first resume to start applying for jobs"
          action={<UploadResumeDialog />}
        />
      )}

      {/* Tips Section */}
      <AnimatedCard variant="default" className="animate-fade-in-up">
        <CardHeader>
          <CardTitle className="flex items-center gap-2 text-lg">
            <div className="p-2 bg-gradient-to-br from-primary to-purple-600 rounded-lg">
              <Zap className="h-4 w-4 text-white" />
            </div>
            Resume Tips
          </CardTitle>
        </CardHeader>
        <CardContent>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
            <div className="p-5 rounded-xl bg-gradient-to-br from-blue-50 to-indigo-50 border border-blue-200 hover:shadow-md transition-all">
              <div className="flex items-center gap-2 mb-2">
                <div className="p-1.5 bg-blue-500 rounded-lg">
                  <Target className="h-4 w-4 text-white" />
                </div>
                <h4 className="font-medium text-blue-900">Tailor for Each Role</h4>
              </div>
              <p className="text-sm text-blue-700">
                Create versions targeting specific job types or industries
              </p>
            </div>
            <div className="p-5 rounded-xl bg-gradient-to-br from-green-50 to-emerald-50 border border-green-200 hover:shadow-md transition-all">
              <div className="flex items-center gap-2 mb-2">
                <div className="p-1.5 bg-green-500 rounded-lg">
                  <Sparkles className="h-4 w-4 text-white" />
                </div>
                <h4 className="font-medium text-green-900">Keep It Updated</h4>
              </div>
              <p className="text-sm text-green-700">
                Regularly update with new skills and achievements
              </p>
            </div>
            <div className="p-5 rounded-xl bg-gradient-to-br from-purple-50 to-violet-50 border border-purple-200 hover:shadow-md transition-all">
              <div className="flex items-center gap-2 mb-2">
                <div className="p-1.5 bg-purple-500 rounded-lg">
                  <Zap className="h-4 w-4 text-white" />
                </div>
                <h4 className="font-medium text-purple-900">Use Keywords</h4>
              </div>
              <p className="text-sm text-purple-700">
                Include relevant keywords from job descriptions
              </p>
            </div>
          </div>
        </CardContent>
      </AnimatedCard>
    </div>
  );
}
