import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/application.dart';
import '../../data/services/offline_storage_service.dart';
import '../../data/services/sync_service.dart';

/// Quick add FAB with expandable form
class QuickAddFAB extends ConsumerStatefulWidget {
  final VoidCallback? onApplicationAdded;

  const QuickAddFAB({
    super.key,
    this.onApplicationAdded,
  });

  @override
  ConsumerState<QuickAddFAB> createState() => _QuickAddFABState();
}

class _QuickAddFABState extends ConsumerState<QuickAddFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Quick action buttons
        ScaleTransition(
          scale: _scaleAnimation,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _QuickActionButton(
                icon: Icons.work,
                label: 'Full Form',
                onPressed: () {
                  _toggle();
                  _openFullForm(context);
                },
              ),
              const SizedBox(height: 8),
              _QuickActionButton(
                icon: Icons.flash_on,
                label: 'Quick Add',
                onPressed: () {
                  _toggle();
                  _showQuickAddSheet(context);
                },
              ),
              const SizedBox(height: 8),
              _QuickActionButton(
                icon: Icons.link,
                label: 'From URL',
                onPressed: () {
                  _toggle();
                  _showUrlDialog(context);
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
        // Main FAB
        FloatingActionButton(
          onPressed: _toggle,
          child: AnimatedRotation(
            turns: _isExpanded ? 0.125 : 0,
            duration: const Duration(milliseconds: 200),
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  void _openFullForm(BuildContext context) {
    Navigator.of(context).pushNamed('/applications/add');
  }

  void _showQuickAddSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => QuickAddSheet(
        onSaved: widget.onApplicationAdded,
      ),
    );
  }

  void _showUrlDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _UrlImportDialog(
        onImported: widget.onApplicationAdded,
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
              ),
            ],
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ),
        const SizedBox(width: 8),
        FloatingActionButton.small(
          heroTag: 'quick_action_$label',
          onPressed: onPressed,
          child: Icon(icon),
        ),
      ],
    );
  }
}

/// Quick add bottom sheet
class QuickAddSheet extends ConsumerStatefulWidget {
  final VoidCallback? onSaved;

  const QuickAddSheet({
    super.key,
    this.onSaved,
  });

  @override
  ConsumerState<QuickAddSheet> createState() => _QuickAddSheetState();
}

class _QuickAddSheetState extends ConsumerState<QuickAddSheet> {
  final _formKey = GlobalKey<FormState>();
  final _companyController = TextEditingController();
  final _jobTitleController = TextEditingController();
  final _urlController = TextEditingController();
  final _notesController = TextEditingController();
  ApplicationStatus _status = ApplicationStatus.draft;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadDraft();
  }

  Future<void> _loadDraft() async {
    final storage = OfflineStorageService();
    final draft = await storage.getQuickAddDraft();
    if (draft != null) {
      setState(() {
        _companyController.text = draft['company'] ?? '';
        _jobTitleController.text = draft['jobTitle'] ?? '';
        _urlController.text = draft['url'] ?? '';
        _notesController.text = draft['notes'] ?? '';
      });
    }
  }

  Future<void> _saveDraft() async {
    final storage = OfflineStorageService();
    await storage.saveQuickAddDraft({
      'company': _companyController.text,
      'jobTitle': _jobTitleController.text,
      'url': _urlController.text,
      'notes': _notesController.text,
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final storage = OfflineStorageService();
      final id = storage.generateId();

      final application = Application(
        id: id,
        companyName: _companyController.text.trim(),
        jobTitle: _jobTitleController.text.trim(),
        jobUrl: _urlController.text.trim().isEmpty ? null : _urlController.text.trim(),
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        status: _status,
        appliedDate: _status == ApplicationStatus.applied ? DateTime.now() : null,
      );

      // Save locally
      await storage.saveApplication(application);

      // Queue for sync
      final syncService = ref.read(syncServiceProvider.notifier);
      await syncService.queueOperation(
        operation: SyncOperation.create,
        entityType: 'application',
        entityId: id,
        data: application.toJson(),
      );

      // Clear draft
      await storage.clearQuickAddDraft();

      widget.onSaved?.call();

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added "${application.jobTitle}" at ${application.companyName}'),
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'View',
              onPressed: () {
                Navigator.of(context).pushNamed('/applications/$id');
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving application: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: 16 + bottomPadding,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Quick Add Application',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    _saveDraft();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _companyController,
              decoration: const InputDecoration(
                labelText: 'Company Name *',
                prefixIcon: Icon(Icons.business),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter company name';
                }
                return null;
              },
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _jobTitleController,
              decoration: const InputDecoration(
                labelText: 'Job Title *',
                prefixIcon: Icon(Icons.work),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter job title';
                }
                return null;
              },
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: 'Job URL (optional)',
                prefixIcon: Icon(Icons.link),
              ),
              keyboardType: TextInputType.url,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes (optional)',
                prefixIcon: Icon(Icons.notes),
              ),
              maxLines: 2,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const Text('Status: '),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Draft'),
                    selected: _status == ApplicationStatus.draft,
                    onSelected: (s) {
                      if (s) setState(() => _status = ApplicationStatus.draft);
                    },
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Applied'),
                    selected: _status == ApplicationStatus.applied,
                    onSelected: (s) {
                      if (s) setState(() => _status = ApplicationStatus.applied);
                    },
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Interviewing'),
                    selected: _status == ApplicationStatus.interviewing,
                    onSelected: (s) {
                      if (s) setState(() => _status = ApplicationStatus.interviewing);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _isSaving ? null : _save,
                child: _isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Save Application'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _companyController.dispose();
    _jobTitleController.dispose();
    _urlController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}

class _UrlImportDialog extends ConsumerStatefulWidget {
  final VoidCallback? onImported;

  const _UrlImportDialog({this.onImported});

  @override
  ConsumerState<_UrlImportDialog> createState() => _UrlImportDialogState();
}

class _UrlImportDialogState extends ConsumerState<_UrlImportDialog> {
  final _urlController = TextEditingController();
  bool _isLoading = false;

  Future<void> _import() async {
    final url = _urlController.text.trim();
    if (url.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      // In a real implementation, this would parse the job posting URL
      // For now, we'll just create a basic application with the URL
      final storage = OfflineStorageService();
      final id = storage.generateId();

      // Extract domain for company name
      final uri = Uri.tryParse(url);
      final company = uri?.host.replaceAll('www.', '').split('.').first ?? 'Unknown';

      final application = Application(
        id: id,
        companyName: company.substring(0, 1).toUpperCase() + company.substring(1),
        jobTitle: 'Imported Position',
        jobUrl: url,
        status: ApplicationStatus.draft,
        source: 'url_import',
      );

      await storage.saveApplication(application);

      final syncService = ref.read(syncServiceProvider.notifier);
      await syncService.queueOperation(
        operation: SyncOperation.create,
        entityType: 'application',
        entityId: id,
        data: application.toJson(),
      );

      widget.onImported?.call();

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Application imported. Tap to edit details.'),
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'Edit',
              onPressed: () {
                Navigator.of(context).pushNamed('/applications/$id/edit');
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error importing: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Import from URL'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Paste a job posting URL to automatically extract details.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _urlController,
            decoration: const InputDecoration(
              labelText: 'Job Posting URL',
              hintText: 'https://...',
              prefixIcon: Icon(Icons.link),
            ),
            keyboardType: TextInputType.url,
            autofocus: true,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _isLoading ? null : _import,
          child: _isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Import'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }
}
