import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/validators.dart';
import '../../../data/models/models.dart';
import '../../../providers/providers.dart';
import '../../widgets/loading_overlay.dart';

/// Profile edit screen
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _linkedInController;
  late TextEditingController _portfolioController;
  late TextEditingController _bioController;

  bool _isLoading = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(currentUserProvider);
    _fullNameController = TextEditingController(text: user?.fullName ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
    _linkedInController = TextEditingController(text: user?.linkedinUrl ?? '');
    _portfolioController = TextEditingController(text: user?.portfolioUrl ?? '');
    _bioController = TextEditingController(text: user?.bio ?? '');

    // Listen for changes
    _fullNameController.addListener(_onFieldChanged);
    _phoneController.addListener(_onFieldChanged);
    _linkedInController.addListener(_onFieldChanged);
    _portfolioController.addListener(_onFieldChanged);
    _bioController.addListener(_onFieldChanged);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _linkedInController.dispose();
    _portfolioController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _onFieldChanged() {
    if (!_hasChanges) {
      setState(() => _hasChanges = true);
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final request = UpdateProfileRequest(
        fullName: _fullNameController.text.trim(),
        phone: _phoneController.text.isNotEmpty
            ? _phoneController.text.trim()
            : null,
        linkedinUrl: _linkedInController.text.isNotEmpty
            ? _linkedInController.text.trim()
            : null,
        portfolioUrl: _portfolioController.text.isNotEmpty
            ? _portfolioController.text.trim()
            : null,
        bio: _bioController.text.isNotEmpty ? _bioController.text.trim() : null,
      );

      await ref.read(authProvider.notifier).updateProfile(request);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
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

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Profile'),
          actions: [
            if (_hasChanges)
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
                // Avatar
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: AppTheme.primaryColor,
                        child: Text(
                          _fullNameController.text.isNotEmpty
                              ? _fullNameController.text[0].toUpperCase()
                              : 'U',
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Basic info section
                Text(
                  'Basic Information',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _fullNameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name *',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  textCapitalization: TextCapitalization.words,
                  validator: (v) => Validators.required(v, fieldName: 'Full name'),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                    enabled: false,
                  ),
                  enabled: false,
                ),
                const SizedBox(height: 8),
                Text(
                  'Email cannot be changed',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textTertiary,
                      ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    prefixIcon: Icon(Icons.phone_outlined),
                    hintText: '+1 (555) 123-4567',
                  ),
                  keyboardType: TextInputType.phone,
                  validator: Validators.phone,
                ),
                const SizedBox(height: 24),

                // Links section
                Text(
                  'Links',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _linkedInController,
                  decoration: const InputDecoration(
                    labelText: 'LinkedIn URL',
                    prefixIcon: Icon(Icons.link),
                    hintText: 'https://linkedin.com/in/yourprofile',
                  ),
                  keyboardType: TextInputType.url,
                  validator: Validators.url,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _portfolioController,
                  decoration: const InputDecoration(
                    labelText: 'Portfolio / Website URL',
                    prefixIcon: Icon(Icons.language),
                    hintText: 'https://yourportfolio.com',
                  ),
                  keyboardType: TextInputType.url,
                  validator: Validators.url,
                ),
                const SizedBox(height: 24),

                // Bio section
                Text(
                  'About',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _bioController,
                  decoration: const InputDecoration(
                    labelText: 'Bio',
                    hintText: 'Tell us a bit about yourself...',
                    alignLabelWithHint: true,
                  ),
                  maxLines: 4,
                  maxLength: 500,
                ),
                const SizedBox(height: 32),

                // Submit button
                ElevatedButton(
                  onPressed: _hasChanges ? _handleSubmit : null,
                  child: const Text('Save Changes'),
                ),
                const SizedBox(height: 16),

                // Danger zone
                const Divider(height: 48),
                Text(
                  'Danger Zone',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.errorColor,
                      ),
                ),
                const SizedBox(height: 16),

                OutlinedButton(
                  onPressed: () => _showDeleteAccountDialog(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.errorColor,
                    side: BorderSide(color: AppTheme.errorColor),
                  ),
                  child: const Text('Delete Account'),
                ),
                const SizedBox(height: 8),
                Text(
                  'This action cannot be undone. All your data will be permanently deleted.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textTertiary,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implement account deletion
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Account deletion feature coming soon'),
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete Account'),
          ),
        ],
      ),
    );
  }
}
