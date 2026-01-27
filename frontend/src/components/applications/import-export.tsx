'use client';

import { useState, useRef, useCallback } from 'react';
import {
  Upload,
  Download,
  FileSpreadsheet,
  FileJson,
  FileText,
  Loader2,
  CheckCircle,
  XCircle,
  AlertCircle,
  ExternalLink,
} from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Progress } from '@/components/ui/progress';
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
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select';
import {
  Tabs,
  TabsContent,
  TabsList,
  TabsTrigger,
} from '@/components/ui/tabs';
import { Switch } from '@/components/ui/switch';
import { toast } from 'sonner';
import { useMutation, useQueryClient } from '@tanstack/react-query';
import { apiClient } from '@/lib/api';

// Types
interface ImportResult {
  created_count: number;
  updated_count: number;
  skipped_count: number;
  errors: string[];
  message: string;
}

interface ExportOptions {
  format: 'csv' | 'json';
  include_archived: boolean;
  status?: string[];
  date_from?: string;
  date_to?: string;
}

// Import Component
export function ImportApplications() {
  const [isOpen, setIsOpen] = useState(false);
  const [file, setFile] = useState<File | null>(null);
  const [source, setSource] = useState<string>('csv');
  const [updateExisting, setUpdateExisting] = useState(false);
  const [importResult, setImportResult] = useState<ImportResult | null>(null);
  const fileInputRef = useRef<HTMLInputElement>(null);
  const queryClient = useQueryClient();

  const importMutation = useMutation({
    mutationFn: async ({
      file,
      source,
      updateExisting,
    }: {
      file: File;
      source: string;
      updateExisting: boolean;
    }) => {
      const formData = new FormData();
      formData.append('file', file);
      formData.append('source', source);
      formData.append('update_existing', String(updateExisting));

      const response = await apiClient.post('/applications/import/', formData, {
        headers: { 'Content-Type': 'multipart/form-data' },
      });
      return response.data as ImportResult;
    },
    onSuccess: (result) => {
      setImportResult(result);
      queryClient.invalidateQueries({ queryKey: ['applications'] });
      queryClient.invalidateQueries({ queryKey: ['kanban'] });
      queryClient.invalidateQueries({ queryKey: ['dashboard'] });
      toast.success(result.message);
    },
    onError: (error: Error) => {
      toast.error(`Import failed: ${error.message}`);
    },
  });

  const handleFileChange = useCallback((e: React.ChangeEvent<HTMLInputElement>) => {
    const selectedFile = e.target.files?.[0];
    if (selectedFile) {
      setFile(selectedFile);
      setImportResult(null);
    }
  }, []);

  const handleImport = useCallback(() => {
    if (!file) {
      toast.error('Please select a file');
      return;
    }
    importMutation.mutate({ file, source, updateExisting });
  }, [file, source, updateExisting, importMutation]);

  const handleClose = useCallback(() => {
    setIsOpen(false);
    setFile(null);
    setImportResult(null);
    setSource('csv');
    setUpdateExisting(false);
  }, []);

  const getSourceIcon = (src: string) => {
    switch (src) {
      case 'csv':
        return <FileSpreadsheet className="h-4 w-4" />;
      case 'json':
        return <FileJson className="h-4 w-4" />;
      default:
        return <FileText className="h-4 w-4" />;
    }
  };

  return (
    <Dialog open={isOpen} onOpenChange={setIsOpen}>
      <DialogTrigger asChild>
        <Button variant="outline" className="gap-2">
          <Upload className="h-4 w-4" />
          Import
        </Button>
      </DialogTrigger>
      <DialogContent className="sm:max-w-[500px]">
        <DialogHeader>
          <DialogTitle>Import Applications</DialogTitle>
          <DialogDescription>
            Import your job applications from CSV files or other job trackers
          </DialogDescription>
        </DialogHeader>

        {!importResult ? (
          <div className="space-y-6 py-4">
            {/* Source Selection */}
            <div className="space-y-2">
              <Label>Import Source</Label>
              <Select value={source} onValueChange={setSource}>
                <SelectTrigger>
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="csv">
                    <div className="flex items-center gap-2">
                      <FileSpreadsheet className="h-4 w-4" />
                      CSV File
                    </div>
                  </SelectItem>
                  <SelectItem value="linkedin">
                    <div className="flex items-center gap-2">
                      <ExternalLink className="h-4 w-4" />
                      LinkedIn Export
                    </div>
                  </SelectItem>
                  <SelectItem value="indeed">
                    <div className="flex items-center gap-2">
                      <ExternalLink className="h-4 w-4" />
                      Indeed Export
                    </div>
                  </SelectItem>
                  <SelectItem value="json">
                    <div className="flex items-center gap-2">
                      <FileJson className="h-4 w-4" />
                      JSON File
                    </div>
                  </SelectItem>
                </SelectContent>
              </Select>
            </div>

            {/* File Upload */}
            <div className="space-y-2">
              <Label>File</Label>
              <div
                className="border-2 border-dashed rounded-lg p-6 text-center cursor-pointer hover:border-primary/50 transition-colors"
                onClick={() => fileInputRef.current?.click()}
              >
                <input
                  ref={fileInputRef}
                  type="file"
                  accept=".csv,.json"
                  onChange={handleFileChange}
                  className="hidden"
                />
                {file ? (
                  <div className="flex items-center justify-center gap-2">
                    {getSourceIcon(source)}
                    <span className="font-medium">{file.name}</span>
                    <Badge variant="secondary">
                      {(file.size / 1024).toFixed(1)} KB
                    </Badge>
                  </div>
                ) : (
                  <div className="space-y-2">
                    <Upload className="h-8 w-8 mx-auto text-muted-foreground" />
                    <p className="text-sm text-muted-foreground">
                      Click or drag file to upload
                    </p>
                    <p className="text-xs text-muted-foreground">
                      Supports CSV and JSON files
                    </p>
                  </div>
                )}
              </div>
            </div>

            {/* Options */}
            <div className="flex items-center justify-between">
              <div className="space-y-0.5">
                <Label>Update existing applications</Label>
                <p className="text-xs text-muted-foreground">
                  Update applications that already exist based on company and job title
                </p>
              </div>
              <Switch
                checked={updateExisting}
                onCheckedChange={setUpdateExisting}
              />
            </div>

            {/* Help Text */}
            <div className="bg-muted/50 rounded-lg p-4 text-sm space-y-2">
              <p className="font-medium">Expected CSV columns:</p>
              <p className="text-muted-foreground">
                company, job_title, status, location, url, applied_date, salary, notes
              </p>
            </div>
          </div>
        ) : (
          /* Import Results */
          <div className="space-y-6 py-4">
            <div className="flex items-center justify-center">
              {importResult.errors.length === 0 ? (
                <CheckCircle className="h-12 w-12 text-green-500" />
              ) : (
                <AlertCircle className="h-12 w-12 text-yellow-500" />
              )}
            </div>

            <div className="text-center">
              <h3 className="font-semibold text-lg">{importResult.message}</h3>
            </div>

            <div className="grid grid-cols-3 gap-4 text-center">
              <div className="bg-green-50 dark:bg-green-950 rounded-lg p-3">
                <p className="text-2xl font-bold text-green-600">{importResult.created_count}</p>
                <p className="text-xs text-muted-foreground">Created</p>
              </div>
              <div className="bg-blue-50 dark:bg-blue-950 rounded-lg p-3">
                <p className="text-2xl font-bold text-blue-600">{importResult.updated_count}</p>
                <p className="text-xs text-muted-foreground">Updated</p>
              </div>
              <div className="bg-gray-50 dark:bg-gray-800 rounded-lg p-3">
                <p className="text-2xl font-bold text-gray-600">{importResult.skipped_count}</p>
                <p className="text-xs text-muted-foreground">Skipped</p>
              </div>
            </div>

            {importResult.errors.length > 0 && (
              <div className="bg-red-50 dark:bg-red-950 rounded-lg p-3 space-y-2">
                <p className="font-medium text-red-600 flex items-center gap-2">
                  <XCircle className="h-4 w-4" />
                  Errors ({importResult.errors.length})
                </p>
                <ul className="text-sm text-red-600 space-y-1">
                  {importResult.errors.slice(0, 5).map((error, i) => (
                    <li key={i}>• {error}</li>
                  ))}
                  {importResult.errors.length > 5 && (
                    <li>...and {importResult.errors.length - 5} more</li>
                  )}
                </ul>
              </div>
            )}
          </div>
        )}

        <DialogFooter>
          {!importResult ? (
            <>
              <Button variant="outline" onClick={handleClose}>
                Cancel
              </Button>
              <Button
                onClick={handleImport}
                disabled={!file || importMutation.isPending}
              >
                {importMutation.isPending && (
                  <Loader2 className="h-4 w-4 mr-2 animate-spin" />
                )}
                Import Applications
              </Button>
            </>
          ) : (
            <Button onClick={handleClose}>Done</Button>
          )}
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}

// Export Component
export function ExportApplications() {
  const [isOpen, setIsOpen] = useState(false);
  const [format, setFormat] = useState<'csv' | 'json'>('csv');
  const [includeArchived, setIncludeArchived] = useState(false);
  const [isExporting, setIsExporting] = useState(false);

  const handleExport = async () => {
    setIsExporting(true);
    try {
      const params = new URLSearchParams({
        format,
        include_archived: String(includeArchived),
      });

      const response = await apiClient.get(`/applications/export/?${params}`, {
        responseType: 'blob',
      });

      // Create download link
      const url = window.URL.createObjectURL(new Blob([response.data]));
      const link = document.createElement('a');
      link.href = url;
      link.setAttribute(
        'download',
        `applications_${new Date().toISOString().split('T')[0]}.${format}`
      );
      document.body.appendChild(link);
      link.click();
      link.remove();
      window.URL.revokeObjectURL(url);

      toast.success('Export completed');
      setIsOpen(false);
    } catch (error) {
      toast.error('Export failed');
    } finally {
      setIsExporting(false);
    }
  };

  return (
    <Dialog open={isOpen} onOpenChange={setIsOpen}>
      <DialogTrigger asChild>
        <Button variant="outline" className="gap-2">
          <Download className="h-4 w-4" />
          Export
        </Button>
      </DialogTrigger>
      <DialogContent className="sm:max-w-[400px]">
        <DialogHeader>
          <DialogTitle>Export Applications</DialogTitle>
          <DialogDescription>
            Download your application data in various formats
          </DialogDescription>
        </DialogHeader>

        <div className="space-y-6 py-4">
          {/* Format Selection */}
          <div className="space-y-2">
            <Label>Export Format</Label>
            <Tabs value={format} onValueChange={(v) => setFormat(v as 'csv' | 'json')}>
              <TabsList className="grid w-full grid-cols-2">
                <TabsTrigger value="csv" className="gap-2">
                  <FileSpreadsheet className="h-4 w-4" />
                  CSV
                </TabsTrigger>
                <TabsTrigger value="json" className="gap-2">
                  <FileJson className="h-4 w-4" />
                  JSON
                </TabsTrigger>
              </TabsList>
            </Tabs>
          </div>

          {/* Options */}
          <div className="flex items-center justify-between">
            <div className="space-y-0.5">
              <Label>Include archived applications</Label>
              <p className="text-xs text-muted-foreground">
                Export archived applications along with active ones
              </p>
            </div>
            <Switch
              checked={includeArchived}
              onCheckedChange={setIncludeArchived}
            />
          </div>

          {/* Format Info */}
          <div className="bg-muted/50 rounded-lg p-4 text-sm space-y-2">
            {format === 'csv' ? (
              <>
                <p className="font-medium">CSV Format</p>
                <p className="text-muted-foreground">
                  Best for spreadsheet applications like Excel or Google Sheets.
                  Includes all application fields.
                </p>
              </>
            ) : (
              <>
                <p className="font-medium">JSON Format</p>
                <p className="text-muted-foreground">
                  Best for data migration or backup. Includes all fields and
                  preserves data types.
                </p>
              </>
            )}
          </div>
        </div>

        <DialogFooter>
          <Button variant="outline" onClick={() => setIsOpen(false)}>
            Cancel
          </Button>
          <Button onClick={handleExport} disabled={isExporting}>
            {isExporting && <Loader2 className="h-4 w-4 mr-2 animate-spin" />}
            Download {format.toUpperCase()}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}

// Combined Import/Export Toolbar
export function ImportExportToolbar() {
  return (
    <div className="flex items-center gap-2">
      <ImportApplications />
      <ExportApplications />
    </div>
  );
}

// Import/Export Dropdown Menu
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu';

export function ImportExportMenu() {
  const [importOpen, setImportOpen] = useState(false);
  const [exportOpen, setExportOpen] = useState(false);

  return (
    <>
      <DropdownMenu>
        <DropdownMenuTrigger asChild>
          <Button variant="outline" size="icon" className="shadow-sm">
            <Download className="h-4 w-4" />
          </Button>
        </DropdownMenuTrigger>
        <DropdownMenuContent align="end">
          <DropdownMenuItem onClick={() => setImportOpen(true)}>
            <Upload className="mr-2 h-4 w-4" />
            Import Applications
          </DropdownMenuItem>
          <DropdownMenuItem onClick={() => setExportOpen(true)}>
            <Download className="mr-2 h-4 w-4" />
            Export Applications
          </DropdownMenuItem>
          <DropdownMenuSeparator />
          <DropdownMenuItem asChild>
            <a href="/templates/import-template.csv" download>
              <FileSpreadsheet className="mr-2 h-4 w-4" />
              Download CSV Template
            </a>
          </DropdownMenuItem>
        </DropdownMenuContent>
      </DropdownMenu>
      
      {/* Import Dialog controlled separately */}
      <Dialog open={importOpen} onOpenChange={setImportOpen}>
        <DialogContent className="sm:max-w-[600px]">
          <DialogHeader>
            <DialogTitle>Import Applications</DialogTitle>
            <DialogDescription>
              Import your job applications from a CSV, JSON file or from job boards.
            </DialogDescription>
          </DialogHeader>
          {/* Re-use import form content here or create a separate component */}
          <div className="py-4">
            <ImportApplications />
          </div>
        </DialogContent>
      </Dialog>
      
      {/* Export Dialog controlled separately */}
      <Dialog open={exportOpen} onOpenChange={setExportOpen}>
        <DialogContent className="sm:max-w-[500px]">
          <DialogHeader>
            <DialogTitle>Export Applications</DialogTitle>
            <DialogDescription>
              Export your applications to CSV or JSON format.
            </DialogDescription>
          </DialogHeader>
          <div className="py-4">
            <ExportApplications />
          </div>
        </DialogContent>
      </Dialog>
    </>
  );
}

export default ImportExportToolbar;
