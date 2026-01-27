import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:csv/csv.dart';
import '../../data/models/application.dart';
import '../../data/services/offline_storage_service.dart';
import '../../data/services/sync_service.dart';

/// Import source types
enum ImportSource {
  csv,
  json,
  linkedin,
  indeed,
}

/// Import result
class ImportResult {
  final int total;
  final int successful;
  final int failed;
  final List<String> errors;

  const ImportResult({
    required this.total,
    required this.successful,
    required this.failed,
    required this.errors,
  });
}

/// Export format types
enum ExportFormat {
  csv,
  json,
}

/// Import/Export service
class ImportExportService {
  final OfflineStorageService _storage;

  ImportExportService(this._storage);

  /// Import applications from file
  Future<ImportResult> importApplications({
    required String filePath,
    required ImportSource source,
  }) async {
    final file = File(filePath);
    final content = await file.readAsString();
    
    switch (source) {
      case ImportSource.csv:
        return _importFromCsv(content);
      case ImportSource.json:
        return _importFromJson(content);
      case ImportSource.linkedin:
        return _importFromLinkedIn(content);
      case ImportSource.indeed:
        return _importFromIndeed(content);
    }
  }

  Future<ImportResult> _importFromCsv(String content) async {
    final errors = <String>[];
    int successful = 0;
    int failed = 0;

    try {
      final rows = const CsvToListConverter().convert(content);
      if (rows.isEmpty) {
        return ImportResult(
          total: 0,
          successful: 0,
          failed: 0,
          errors: ['Empty CSV file'],
        );
      }

      final headers = rows.first.map((e) => e.toString().toLowerCase()).toList();
      final companyIndex = headers.indexOf('company') != -1 
          ? headers.indexOf('company') 
          : headers.indexOf('company_name');
      final titleIndex = headers.indexOf('title') != -1
          ? headers.indexOf('title')
          : headers.indexOf('job_title');
      final statusIndex = headers.indexOf('status');
      final urlIndex = headers.indexOf('url') != -1
          ? headers.indexOf('url')
          : headers.indexOf('job_url');
      final notesIndex = headers.indexOf('notes');

      if (companyIndex == -1 || titleIndex == -1) {
        return ImportResult(
          total: 0,
          successful: 0,
          failed: 0,
          errors: ['CSV must contain "company" and "title" columns'],
        );
      }

      for (int i = 1; i < rows.length; i++) {
        try {
          final row = rows[i];
          final id = _storage.generateId();
          
          final application = Application(
            id: id,
            companyName: row[companyIndex].toString(),
            jobTitle: row[titleIndex].toString(),
            status: statusIndex != -1
                ? ApplicationStatus.values.firstWhere(
                    (e) => e.name.toLowerCase() == row[statusIndex].toString().toLowerCase(),
                    orElse: () => ApplicationStatus.draft,
                  )
                : ApplicationStatus.draft,
            jobUrl: urlIndex != -1 ? row[urlIndex]?.toString() : null,
            notes: notesIndex != -1 ? row[notesIndex]?.toString() : null,
            source: 'csv_import',
          );

          await _storage.saveApplication(application);
          successful++;
        } catch (e) {
          failed++;
          errors.add('Row ${i + 1}: $e');
        }
      }
    } catch (e) {
      return ImportResult(
        total: 0,
        successful: 0,
        failed: 0,
        errors: ['Failed to parse CSV: $e'],
      );
    }

    return ImportResult(
      total: successful + failed,
      successful: successful,
      failed: failed,
      errors: errors,
    );
  }

  Future<ImportResult> _importFromJson(String content) async {
    final errors = <String>[];
    int successful = 0;
    int failed = 0;

    try {
      final data = jsonDecode(content);
      final applications = data is List ? data : [data];

      for (int i = 0; i < applications.length; i++) {
        try {
          final item = applications[i] as Map<String, dynamic>;
          final id = _storage.generateId();
          
          final application = Application(
            id: id,
            companyName: item['company_name'] ?? item['company'] ?? 'Unknown',
            jobTitle: item['job_title'] ?? item['title'] ?? 'Unknown',
            status: ApplicationStatus.values.firstWhere(
              (e) => e.name == (item['status'] ?? 'draft'),
              orElse: () => ApplicationStatus.draft,
            ),
            jobUrl: item['job_url'] ?? item['url'],
            notes: item['notes'],
            source: 'json_import',
          );

          await _storage.saveApplication(application);
          successful++;
        } catch (e) {
          failed++;
          errors.add('Item ${i + 1}: $e');
        }
      }
    } catch (e) {
      return ImportResult(
        total: 0,
        successful: 0,
        failed: 0,
        errors: ['Failed to parse JSON: $e'],
      );
    }

    return ImportResult(
      total: successful + failed,
      successful: successful,
      failed: failed,
      errors: errors,
    );
  }

  Future<ImportResult> _importFromLinkedIn(String content) async {
    // LinkedIn export is typically CSV with specific column names
    final errors = <String>[];
    int successful = 0;
    int failed = 0;

    try {
      final rows = const CsvToListConverter().convert(content);
      if (rows.isEmpty) {
        return ImportResult(
          total: 0,
          successful: 0,
          failed: 0,
          errors: ['Empty file'],
        );
      }

      final headers = rows.first.map((e) => e.toString().toLowerCase()).toList();
      
      // LinkedIn column mappings
      final companyIndex = headers.indexOf('company name');
      final titleIndex = headers.indexOf('job title');
      final appliedDateIndex = headers.indexOf('applied on');
      final statusIndex = headers.indexOf('application status');

      if (companyIndex == -1 || titleIndex == -1) {
        return ImportResult(
          total: 0,
          successful: 0,
          failed: 0,
          errors: ['Not a valid LinkedIn export file'],
        );
      }

      for (int i = 1; i < rows.length; i++) {
        try {
          final row = rows[i];
          final id = _storage.generateId();

          DateTime? appliedDate;
          if (appliedDateIndex != -1 && row[appliedDateIndex] != null) {
            try {
              appliedDate = DateTime.parse(row[appliedDateIndex].toString());
            } catch (_) {}
          }
          
          final application = Application(
            id: id,
            companyName: row[companyIndex].toString(),
            jobTitle: row[titleIndex].toString(),
            status: statusIndex != -1
                ? _mapLinkedInStatus(row[statusIndex].toString())
                : ApplicationStatus.applied,
            appliedDate: appliedDate,
            source: 'linkedin',
          );

          await _storage.saveApplication(application);
          successful++;
        } catch (e) {
          failed++;
          errors.add('Row ${i + 1}: $e');
        }
      }
    } catch (e) {
      return ImportResult(
        total: 0,
        successful: 0,
        failed: 0,
        errors: ['Failed to parse LinkedIn export: $e'],
      );
    }

    return ImportResult(
      total: successful + failed,
      successful: successful,
      failed: failed,
      errors: errors,
    );
  }

  ApplicationStatus _mapLinkedInStatus(String status) {
    switch (status.toLowerCase()) {
      case 'applied':
        return ApplicationStatus.applied;
      case 'viewed':
      case 'in review':
        return ApplicationStatus.screening;
      case 'interview':
        return ApplicationStatus.interviewing;
      case 'offer':
        return ApplicationStatus.offered;
      case 'rejected':
      case 'not selected':
        return ApplicationStatus.rejected;
      default:
        return ApplicationStatus.applied;
    }
  }

  Future<ImportResult> _importFromIndeed(String content) async {
    // Similar to LinkedIn, Indeed has specific format
    return _importFromCsv(content);
  }

  /// Export applications to file
  Future<String> exportApplications({
    required List<Application> applications,
    required ExportFormat format,
    String? fileName,
  }) async {
    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final name = fileName ?? 'applications_$timestamp';
    
    String content;
    String extension;

    switch (format) {
      case ExportFormat.csv:
        content = _toCsv(applications);
        extension = 'csv';
        break;
      case ExportFormat.json:
        content = _toJson(applications);
        extension = 'json';
        break;
    }

    final file = File('${directory.path}/$name.$extension');
    await file.writeAsString(content);
    return file.path;
  }

  String _toCsv(List<Application> applications) {
    final headers = [
      'Company',
      'Job Title',
      'Status',
      'URL',
      'Location',
      'Job Type',
      'Work Location',
      'Salary Min',
      'Salary Max',
      'Applied Date',
      'Notes',
      'Tags',
      'Created At',
    ];

    final rows = applications.map((app) => [
      app.companyName,
      app.jobTitle,
      app.status.name,
      app.jobUrl ?? '',
      app.location ?? '',
      app.jobType?.name ?? '',
      app.workLocationType?.name ?? '',
      app.salaryMin?.toString() ?? '',
      app.salaryMax?.toString() ?? '',
      app.appliedDate?.toIso8601String() ?? '',
      app.notes ?? '',
      app.tags.join(';'),
      app.createdAt.toIso8601String(),
    ]).toList();

    return const ListToCsvConverter().convert([headers, ...rows]);
  }

  String _toJson(List<Application> applications) {
    return jsonEncode(applications.map((app) => app.toJson()).toList());
  }
}

/// Import dialog
class ImportDialog extends ConsumerStatefulWidget {
  final VoidCallback? onImportComplete;

  const ImportDialog({
    super.key,
    this.onImportComplete,
  });

  @override
  ConsumerState<ImportDialog> createState() => _ImportDialogState();
}

class _ImportDialogState extends ConsumerState<ImportDialog> {
  ImportSource _selectedSource = ImportSource.csv;
  String? _selectedFilePath;
  bool _isImporting = false;
  ImportResult? _result;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', 'json'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFilePath = result.files.single.path;
      });
    }
  }

  Future<void> _import() async {
    if (_selectedFilePath == null) return;

    setState(() => _isImporting = true);

    try {
      final service = ImportExportService(OfflineStorageService());
      final result = await service.importApplications(
        filePath: _selectedFilePath!,
        source: _selectedSource,
      );

      setState(() => _result = result);

      if (result.successful > 0) {
        widget.onImportComplete?.call();
      }
    } catch (e) {
      setState(() {
        _result = ImportResult(
          total: 0,
          successful: 0,
          failed: 0,
          errors: ['Import failed: $e'],
        );
      });
    } finally {
      setState(() => _isImporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Import Applications'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_result == null) ...[
              const Text('Select import source:'),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ImportSource.values.map((source) {
                  return ChoiceChip(
                    label: Text(_formatSource(source)),
                    selected: _selectedSource == source,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedSource = source);
                      }
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _pickFile,
                icon: const Icon(Icons.file_upload),
                label: Text(_selectedFilePath != null
                    ? _selectedFilePath!.split('/').last
                    : 'Choose File'),
              ),
            ] else ...[
              if (_result!.successful > 0)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green.shade700),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Successfully imported ${_result!.successful} applications',
                          style: TextStyle(color: Colors.green.shade700),
                        ),
                      ),
                    ],
                  ),
                ),
              if (_result!.failed > 0) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.error, color: Colors.red.shade700),
                          const SizedBox(width: 12),
                          Text(
                            '${_result!.failed} failed',
                            style: TextStyle(color: Colors.red.shade700),
                          ),
                        ],
                      ),
                      if (_result!.errors.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        ..._result!.errors.take(3).map((error) => Text(
                              '• $error',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.red.shade700,
                              ),
                            )),
                        if (_result!.errors.length > 3)
                          Text(
                            '... and ${_result!.errors.length - 3} more',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.red.shade700,
                            ),
                          ),
                      ],
                    ],
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(_result != null ? 'Close' : 'Cancel'),
        ),
        if (_result == null)
          FilledButton(
            onPressed: _selectedFilePath != null && !_isImporting ? _import : null,
            child: _isImporting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Import'),
          ),
      ],
    );
  }

  String _formatSource(ImportSource source) {
    switch (source) {
      case ImportSource.csv:
        return 'CSV';
      case ImportSource.json:
        return 'JSON';
      case ImportSource.linkedin:
        return 'LinkedIn';
      case ImportSource.indeed:
        return 'Indeed';
    }
  }
}

/// Export dialog
class ExportDialog extends ConsumerStatefulWidget {
  const ExportDialog({super.key});

  @override
  ConsumerState<ExportDialog> createState() => _ExportDialogState();
}

class _ExportDialogState extends ConsumerState<ExportDialog> {
  ExportFormat _selectedFormat = ExportFormat.csv;
  bool _isExporting = false;
  String? _exportedPath;

  Future<void> _export() async {
    setState(() => _isExporting = true);

    try {
      final storage = OfflineStorageService();
      final applications = await storage.getApplications();

      final service = ImportExportService(storage);
      final path = await service.exportApplications(
        applications: applications,
        format: _selectedFormat,
      );

      setState(() => _exportedPath = path);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isExporting = false);
    }
  }

  Future<void> _share() async {
    if (_exportedPath != null) {
      await Share.shareXFiles(
        [XFile(_exportedPath!)],
        subject: 'My Job Applications',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Export Applications'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_exportedPath == null) ...[
            const Text('Select export format:'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: ExportFormat.values.map((format) {
                return ChoiceChip(
                  label: Text(format.name.toUpperCase()),
                  selected: _selectedFormat == format,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _selectedFormat = format);
                    }
                  },
                );
              }).toList(),
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green.shade700),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text('Export completed!'),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
        if (_exportedPath == null)
          FilledButton(
            onPressed: !_isExporting ? _export : null,
            child: _isExporting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Export'),
          )
        else
          FilledButton.icon(
            onPressed: _share,
            icon: const Icon(Icons.share),
            label: const Text('Share'),
          ),
      ],
    );
  }
}

/// Import/Export Screen
class ImportExportScreen extends ConsumerWidget {
  const ImportExportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Import & Export'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Import section
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.file_download,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Import Data',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Import your job applications from various sources',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.table_chart),
                  title: const Text('Import from CSV'),
                  subtitle: const Text('Spreadsheet format'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => const ImportDialog(),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.code),
                  title: const Text('Import from JSON'),
                  subtitle: const Text('Structured data format'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => const ImportDialog(),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.business),
                  title: const Text('Import from LinkedIn'),
                  subtitle: const Text('LinkedIn job applications export'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => const ImportDialog(),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.work),
                  title: const Text('Import from Indeed'),
                  subtitle: const Text('Indeed job applications export'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => const ImportDialog(),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Export section
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.file_upload,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Export Data',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Export your data for backup or transfer',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.table_chart),
                  title: const Text('Export as CSV'),
                  subtitle: const Text('Compatible with spreadsheet apps'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => const ExportDialog(),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.code),
                  title: const Text('Export as JSON'),
                  subtitle: const Text('Full data export'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => const ExportDialog(),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Info section
          Card(
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Tips',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildTipItem(
                    context,
                    'CSV files should include headers in the first row',
                  ),
                  _buildTipItem(
                    context,
                    'Exports can be used to backup your data',
                  ),
                  _buildTipItem(
                    context,
                    'LinkedIn/Indeed exports work with their native export formats',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipItem(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

/// Import/Export button
class ImportExportButton extends StatelessWidget {
  final VoidCallback? onImportComplete;

  const ImportExportButton({
    super.key,
    this.onImportComplete,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.import_export),
      onSelected: (value) {
        switch (value) {
          case 'import':
            showDialog(
              context: context,
              builder: (context) => ImportDialog(
                onImportComplete: onImportComplete,
              ),
            );
            break;
          case 'export':
            showDialog(
              context: context,
              builder: (context) => const ExportDialog(),
            );
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'import',
          child: ListTile(
            leading: Icon(Icons.file_download),
            title: Text('Import'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
        const PopupMenuItem(
          value: 'export',
          child: ListTile(
            leading: Icon(Icons.file_upload),
            title: Text('Export'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }
}
