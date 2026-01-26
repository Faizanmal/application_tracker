import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/validators.dart';
import '../../../data/models/models.dart';
import '../../../providers/providers.dart';
import '../../widgets/loading_overlay.dart';

/// Create interview screen
class CreateInterviewScreen extends ConsumerStatefulWidget {
  final String? applicationId;

  const CreateInterviewScreen({
    super.key,
    this.applicationId,
  });

  @override
  ConsumerState<CreateInterviewScreen> createState() =>
      _CreateInterviewScreenState();
}

class _CreateInterviewScreenState extends ConsumerState<CreateInterviewScreen> {
  final _formKey = GlobalKey<FormState>();
  final _locationController = TextEditingController();
  final _meetingLinkController = TextEditingController();
  final _interviewerNameController = TextEditingController();
  final _interviewerRoleController = TextEditingController();
  final _notesController = TextEditingController();

  String? _selectedApplicationId;
  String _interviewType = 'video';
  DateTime _scheduledDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _scheduledTime = const TimeOfDay(hour: 10, minute: 0);
  int _duration = 60;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedApplicationId = widget.applicationId;
    _loadApplications();
  }

  @override
  void dispose() {
    _locationController.dispose();
    _meetingLinkController.dispose();
    _interviewerNameController.dispose();
    _interviewerRoleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadApplications() async {
    await ref.read(applicationsProvider.notifier).loadApplications();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedApplicationId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an application')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final scheduledAt = DateTime(
        _scheduledDate.year,
        _scheduledDate.month,
        _scheduledDate.day,
        _scheduledTime.hour,
        _scheduledTime.minute,
      );

      final request = CreateInterviewRequest(
        applicationId: int.parse(_selectedApplicationId!),
        interviewType: _interviewType,
        scheduledAt: scheduledAt,
        duration: _duration,
        location: _locationController.text.isNotEmpty
            ? _locationController.text.trim()
            : null,
        meetingLink: _meetingLinkController.text.isNotEmpty
            ? _meetingLinkController.text.trim()
            : null,
        interviewerName: _interviewerNameController.text.isNotEmpty
            ? _interviewerNameController.text.trim()
            : null,
        interviewerRole: _interviewerRoleController.text.isNotEmpty
            ? _interviewerRoleController.text.trim()
            : null,
        notes: _notesController.text.isNotEmpty
            ? _notesController.text.trim()
            : null,
      );

      await ref.read(interviewsProvider.notifier).createInterview(request);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Interview scheduled!')),
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

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _scheduledDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      setState(() => _scheduledDate = date);
    }
  }

  Future<void> _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _scheduledTime,
    );

    if (time != null) {
      setState(() => _scheduledTime = time);
    }
  }

  @override
  Widget build(BuildContext context) {
    final applicationsState = ref.watch(applicationsProvider);

    return LoadingOverlay(
      isLoading: _isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Schedule Interview'),
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
                // Application selection
                Text(
                  'Application',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: DropdownButtonFormField<String>(
                      value: _selectedApplicationId,
                      decoration: const InputDecoration(
                        labelText: 'Select Application *',
                        border: InputBorder.none,
                      ),
                      hint: const Text('Choose an application'),
                      isExpanded: true,
                      items: applicationsState.applications.map((app) {
                        return DropdownMenuItem(
                          value: app.id.toString(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                app.jobTitle,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                app.companyName,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _selectedApplicationId = value);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Interview type
                Text(
                  'Interview Details',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),

                // Interview type chips
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: InterviewType.values.map((type) {
                    final isSelected = type.value == _interviewType;
                    return ChoiceChip(
                      selected: isSelected,
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            type.icon,
                            size: 18,
                            color: isSelected
                                ? Colors.white
                                : AppTheme.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(type.label),
                        ],
                      ),
                      selectedColor: type.color,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => _interviewType = type.value);
                        }
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // Date and time
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _selectDate,
                        icon: const Icon(Icons.calendar_today),
                        label: Text(
                          '${_scheduledDate.month}/${_scheduledDate.day}/${_scheduledDate.year}',
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _selectTime,
                        icon: const Icon(Icons.access_time),
                        label: Text(_scheduledTime.format(context)),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Duration
                DropdownButtonFormField<int>(
                  value: _duration,
                  decoration: const InputDecoration(
                    labelText: 'Duration',
                    prefixIcon: Icon(Icons.timer_outlined),
                  ),
                  items: const [
                    DropdownMenuItem(value: 15, child: Text('15 minutes')),
                    DropdownMenuItem(value: 30, child: Text('30 minutes')),
                    DropdownMenuItem(value: 45, child: Text('45 minutes')),
                    DropdownMenuItem(value: 60, child: Text('1 hour')),
                    DropdownMenuItem(value: 90, child: Text('1.5 hours')),
                    DropdownMenuItem(value: 120, child: Text('2 hours')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _duration = value);
                    }
                  },
                ),
                const SizedBox(height: 24),

                // Location / Meeting link based on interview type
                if (_interviewType == 'onsite') ...[
                  TextFormField(
                    controller: _locationController,
                    decoration: const InputDecoration(
                      labelText: 'Location *',
                      prefixIcon: Icon(Icons.location_on_outlined),
                      hintText: 'Office address',
                    ),
                    validator: (v) =>
                        Validators.required(v, fieldName: 'Location'),
                  ),
                ] else if (_interviewType == 'video' ||
                    _interviewType == 'technical') ...[
                  TextFormField(
                    controller: _meetingLinkController,
                    decoration: const InputDecoration(
                      labelText: 'Meeting Link',
                      prefixIcon: Icon(Icons.videocam_outlined),
                      hintText: 'https://zoom.us/...',
                    ),
                    keyboardType: TextInputType.url,
                    validator: Validators.url,
                  ),
                ] else if (_interviewType == 'phone') ...[
                  const ListTile(
                    leading: Icon(Icons.info_outline),
                    title: Text('Phone interview'),
                    subtitle:
                        Text('The recruiter will call you at the scheduled time'),
                  ),
                ],
                const SizedBox(height: 24),

                // Interviewer info
                Text(
                  'Interviewer (Optional)',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _interviewerNameController,
                  decoration: const InputDecoration(
                    labelText: 'Interviewer Name',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _interviewerRoleController,
                  decoration: const InputDecoration(
                    labelText: 'Interviewer Role',
                    prefixIcon: Icon(Icons.badge_outlined),
                    hintText: 'e.g., Hiring Manager, Tech Lead',
                  ),
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 24),

                // Notes
                Text(
                  'Notes (Optional)',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),

                TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    labelText: 'Notes',
                    hintText: 'Add any notes or preparation points...',
                    alignLabelWithHint: true,
                  ),
                  maxLines: 4,
                ),
                const SizedBox(height: 32),

                // Submit
                ElevatedButton(
                  onPressed: _handleSubmit,
                  child: const Text('Schedule Interview'),
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
