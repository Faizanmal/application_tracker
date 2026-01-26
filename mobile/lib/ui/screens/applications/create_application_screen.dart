import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/validators.dart';
import '../../../data/models/models.dart';
import '../../../providers/providers.dart';
import '../../widgets/loading_overlay.dart';

/// Create application screen
class CreateApplicationScreen extends ConsumerStatefulWidget {
  const CreateApplicationScreen({super.key});

  @override
  ConsumerState<CreateApplicationScreen> createState() =>
      _CreateApplicationScreenState();
}

class _CreateApplicationScreenState
    extends ConsumerState<CreateApplicationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _companyController = TextEditingController();
  final _jobTitleController = TextEditingController();
  final _locationController = TextEditingController();
  final _jobUrlController = TextEditingController();
  final _salaryMinController = TextEditingController();
  final _salaryMaxController = TextEditingController();
  final _notesController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _contactNameController = TextEditingController();
  final _contactEmailController = TextEditingController();
  final _sourceController = TextEditingController();

  String _status = 'saved';
  String? _workMode;
  String? _jobType;
  DateTime? _appliedAt;
  DateTime? _deadline;
  bool _isLoading = false;
  bool _showAdvanced = false;

  @override
  void dispose() {
    _companyController.dispose();
    _jobTitleController.dispose();
    _locationController.dispose();
    _jobUrlController.dispose();
    _salaryMinController.dispose();
    _salaryMaxController.dispose();
    _notesController.dispose();
    _descriptionController.dispose();
    _contactNameController.dispose();
    _contactEmailController.dispose();
    _sourceController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final request = CreateApplicationRequest(
        companyName: _companyController.text.trim(),
        jobTitle: _jobTitleController.text.trim(),
        status: _status,
        location: _locationController.text.isNotEmpty
            ? _locationController.text.trim()
            : null,
        jobUrl:
            _jobUrlController.text.isNotEmpty ? _jobUrlController.text.trim() : null,
        workMode: _workMode,
        jobType: _jobType,
        salaryMin: _salaryMinController.text.isNotEmpty
            ? int.tryParse(_salaryMinController.text.replaceAll(RegExp(r'[^\d]'), ''))
            : null,
        salaryMax: _salaryMaxController.text.isNotEmpty
            ? int.tryParse(_salaryMaxController.text.replaceAll(RegExp(r'[^\d]'), ''))
            : null,
        notes:
            _notesController.text.isNotEmpty ? _notesController.text.trim() : null,
        description: _descriptionController.text.isNotEmpty
            ? _descriptionController.text.trim()
            : null,
        contactName: _contactNameController.text.isNotEmpty
            ? _contactNameController.text.trim()
            : null,
        contactEmail: _contactEmailController.text.isNotEmpty
            ? _contactEmailController.text.trim()
            : null,
        source:
            _sourceController.text.isNotEmpty ? _sourceController.text.trim() : null,
        appliedAt: _appliedAt,
        deadline: _deadline,
      );

      await ref.read(applicationsProvider.notifier).createApplication(request);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Application added successfully!')),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _selectDate(bool isAppliedDate) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      setState(() {
        if (isAppliedDate) {
          _appliedAt = date;
        } else {
          _deadline = date;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Application'),
          actions: [
            TextButton(
              onPressed: _handleSubmit,
              child: const Text('Save'),
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Required fields
                Text(
                  'Basic Information',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _companyController,
                  decoration: const InputDecoration(
                    labelText: 'Company Name *',
                    prefixIcon: Icon(Icons.business),
                  ),
                  textCapitalization: TextCapitalization.words,
                  validator: (v) => Validators.required(v, fieldName: 'Company name'),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _jobTitleController,
                  decoration: const InputDecoration(
                    labelText: 'Job Title *',
                    prefixIcon: Icon(Icons.work_outline),
                  ),
                  textCapitalization: TextCapitalization.words,
                  validator: (v) => Validators.required(v, fieldName: 'Job title'),
                ),
                const SizedBox(height: 16),

                // Status
                DropdownButtonFormField<String>(
                  value: _status,
                  decoration: const InputDecoration(
                    labelText: 'Status',
                    prefixIcon: Icon(Icons.flag_outlined),
                  ),
                  items: ApplicationStatus.values.map((s) {
                    return DropdownMenuItem(
                      value: s.value,
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: s.color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(s.label),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _status = value);
                    }
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(
                    labelText: 'Location',
                    prefixIcon: Icon(Icons.location_on_outlined),
                    hintText: 'e.g., San Francisco, CA',
                  ),
                ),
                const SizedBox(height: 16),

                // Work mode and job type
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _workMode,
                        decoration: const InputDecoration(
                          labelText: 'Work Mode',
                        ),
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text('Select...'),
                          ),
                          ...WorkMode.values.map((w) {
                            return DropdownMenuItem(
                              value: w.value,
                              child: Text(w.label),
                            );
                          }),
                        ],
                        onChanged: (value) {
                          setState(() => _workMode = value);
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _jobType,
                        decoration: const InputDecoration(
                          labelText: 'Job Type',
                        ),
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text('Select...'),
                          ),
                          ...JobType.values.map((j) {
                            return DropdownMenuItem(
                              value: j.value,
                              child: Text(j.label),
                            );
                          }),
                        ],
                        onChanged: (value) {
                          setState(() => _jobType = value);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Advanced toggle
                TextButton.icon(
                  onPressed: () => setState(() => _showAdvanced = !_showAdvanced),
                  icon: Icon(
                    _showAdvanced ? Icons.expand_less : Icons.expand_more,
                  ),
                  label: Text(
                    _showAdvanced ? 'Hide advanced' : 'Show advanced',
                  ),
                ),

                // Advanced fields
                if (_showAdvanced) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Additional Details',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _jobUrlController,
                    decoration: const InputDecoration(
                      labelText: 'Job Posting URL',
                      prefixIcon: Icon(Icons.link),
                    ),
                    keyboardType: TextInputType.url,
                    validator: Validators.url,
                  ),
                  const SizedBox(height: 16),

                  // Salary range
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _salaryMinController,
                          decoration: const InputDecoration(
                            labelText: 'Min Salary',
                            prefixIcon: Icon(Icons.attach_money),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _salaryMaxController,
                          decoration: const InputDecoration(
                            labelText: 'Max Salary',
                            prefixIcon: Icon(Icons.attach_money),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Dates
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _selectDate(true),
                          icon: const Icon(Icons.calendar_today),
                          label: Text(
                            _appliedAt != null
                                ? _appliedAt.toString().substring(0, 10)
                                : 'Applied Date',
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _selectDate(false),
                          icon: const Icon(Icons.timer_outlined),
                          label: Text(
                            _deadline != null
                                ? _deadline.toString().substring(0, 10)
                                : 'Deadline',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _sourceController,
                    decoration: const InputDecoration(
                      labelText: 'Source',
                      prefixIcon: Icon(Icons.source_outlined),
                      hintText: 'e.g., LinkedIn, Indeed, Referral',
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Contact info
                  Text(
                    'Contact Information',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _contactNameController,
                    decoration: const InputDecoration(
                      labelText: 'Contact Name',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _contactEmailController,
                    decoration: const InputDecoration(
                      labelText: 'Contact Email',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),

                  // Notes
                  Text(
                    'Notes',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _notesController,
                    decoration: const InputDecoration(
                      labelText: 'Notes',
                      hintText: 'Add any notes about this application...',
                      alignLabelWithHint: true,
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Job Description',
                      hintText: 'Paste the job description here...',
                      alignLabelWithHint: true,
                    ),
                    maxLines: 5,
                  ),
                ],
                const SizedBox(height: 32),

                // Submit button
                ElevatedButton(
                  onPressed: _handleSubmit,
                  child: const Text('Add Application'),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
