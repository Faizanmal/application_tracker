import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/theme/app_theme.dart';
import '../../widgets/enhanced_widgets.dart';

/// Privacy & Security screen for managing security settings
class PrivacyScreen extends ConsumerStatefulWidget {
  const PrivacyScreen({super.key});

  @override
  ConsumerState<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends ConsumerState<PrivacyScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _twoFactorEnabled = true;
  bool _biometricEnabled = false;
  bool _loginNotifications = true;
  bool _dataSharing = false;
  bool _analyticsEnabled = true;
  bool _marketingEmails = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 200,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF1A1A2E), Color(0xFF16213E), Color(0xFF0F3460)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Lock Icon Background
                      Positioned(
                        right: -30,
                        bottom: 40,
                        child: Icon(
                          Icons.shield,
                          size: 180,
                          color: Colors.white.withOpacity(0.05),
                        ),
                      ),
                      // Content
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: const Icon(
                                      Icons.security,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Privacy & Security',
                                        style: theme.textTheme.headlineSmall?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Manage your account security',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.7),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ).animate().fadeIn().slideY(begin: 0.2, end: 0),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: Container(
                  color: theme.scaffoldBackgroundColor,
                  child: TabBar(
                    controller: _tabController,
                    labelColor: AppTheme.primaryColor,
                    unselectedLabelColor: AppTheme.textTertiary,
                    indicatorColor: AppTheme.primaryColor,
                    indicatorWeight: 3,
                    isScrollable: true,
                    tabs: const [
                      Tab(text: 'Security'),
                      Tab(text: 'Privacy'),
                      Tab(text: 'Data'),
                      Tab(text: 'Activity'),
                    ],
                  ),
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _SecurityTab(
              twoFactorEnabled: _twoFactorEnabled,
              biometricEnabled: _biometricEnabled,
              loginNotifications: _loginNotifications,
              onTwoFactorChanged: (v) => setState(() => _twoFactorEnabled = v),
              onBiometricChanged: (v) => setState(() => _biometricEnabled = v),
              onLoginNotificationsChanged: (v) => setState(() => _loginNotifications = v),
            ),
            _PrivacyTab(
              dataSharing: _dataSharing,
              analyticsEnabled: _analyticsEnabled,
              marketingEmails: _marketingEmails,
              onDataSharingChanged: (v) => setState(() => _dataSharing = v),
              onAnalyticsChanged: (v) => setState(() => _analyticsEnabled = v),
              onMarketingChanged: (v) => setState(() => _marketingEmails = v),
            ),
            _DataTab(),
            _ActivityTab(),
          ],
        ),
      ),
    );
  }
}

class _SecurityTab extends StatelessWidget {
  final bool twoFactorEnabled;
  final bool biometricEnabled;
  final bool loginNotifications;
  final ValueChanged<bool> onTwoFactorChanged;
  final ValueChanged<bool> onBiometricChanged;
  final ValueChanged<bool> onLoginNotificationsChanged;

  const _SecurityTab({
    required this.twoFactorEnabled,
    required this.biometricEnabled,
    required this.loginNotifications,
    required this.onTwoFactorChanged,
    required this.onBiometricChanged,
    required this.onLoginNotificationsChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Security Score
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF10B981), Color(0xFF059669)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: CircularProgressIndicator(
                        value: 0.85,
                        strokeWidth: 8,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        valueColor: const AlwaysStoppedAnimation(Colors.white),
                      ),
                    ),
                    const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '85',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Score',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Good Security',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Enable biometric login to improve your security score',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ).animate().fadeIn().scale(begin: const Offset(0.95, 0.95)),
        
        const SizedBox(height: 24),
        
        // Authentication
        Text(
          'Authentication',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ).animate().fadeIn(delay: 200.ms),
        
        const SizedBox(height: 16),
        
        _SecuritySettingCard(
          icon: Icons.smartphone,
          iconColor: AppTheme.primaryColor,
          title: 'Two-Factor Authentication',
          subtitle: 'Add an extra layer of security',
          trailing: Switch(
            value: twoFactorEnabled,
            onChanged: onTwoFactorChanged,
            activeColor: AppTheme.primaryColor,
          ),
        ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.1, end: 0),
        
        _SecuritySettingCard(
          icon: Icons.fingerprint,
          iconColor: const Color(0xFF9B59B6),
          title: 'Biometric Login',
          subtitle: 'Use fingerprint or face ID',
          trailing: Switch(
            value: biometricEnabled,
            onChanged: onBiometricChanged,
            activeColor: AppTheme.primaryColor,
          ),
        ).animate().fadeIn(delay: 400.ms).slideX(begin: 0.1, end: 0),
        
        _SecuritySettingCard(
          icon: Icons.notifications_active,
          iconColor: AppTheme.warningColor,
          title: 'Login Notifications',
          subtitle: 'Get notified of new logins',
          trailing: Switch(
            value: loginNotifications,
            onChanged: onLoginNotificationsChanged,
            activeColor: AppTheme.primaryColor,
          ),
        ).animate().fadeIn(delay: 500.ms).slideX(begin: 0.1, end: 0),
        
        const SizedBox(height: 24),
        
        // Password & Sessions
        Text(
          'Password & Sessions',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ).animate().fadeIn(delay: 600.ms),
        
        const SizedBox(height: 16),
        
        _SecurityActionCard(
          icon: Icons.lock_outline,
          title: 'Change Password',
          subtitle: 'Last changed 45 days ago',
          onTap: () {},
        ).animate().fadeIn(delay: 700.ms).slideX(begin: 0.1, end: 0),
        
        _SecurityActionCard(
          icon: Icons.devices,
          title: 'Active Sessions',
          subtitle: '3 devices currently logged in',
          onTap: () {},
        ).animate().fadeIn(delay: 800.ms).slideX(begin: 0.1, end: 0),
        
        _SecurityActionCard(
          icon: Icons.logout,
          title: 'Sign Out All Devices',
          subtitle: 'Log out from all other sessions',
          isDestructive: true,
          onTap: () {},
        ).animate().fadeIn(delay: 900.ms).slideX(begin: 0.1, end: 0),
      ],
    );
  }
}

class _SecuritySettingCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Widget trailing;

  const _SecuritySettingCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(subtitle, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}

class _SecurityActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isDestructive;
  final VoidCallback onTap;

  const _SecurityActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.isDestructive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isDestructive ? AppTheme.errorColor : AppTheme.primaryColor;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppTheme.radiusLg),
              border: Border.all(color: theme.dividerColor),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isDestructive ? color : null,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(subtitle, style: theme.textTheme.bodySmall),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: AppTheme.textTertiary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PrivacyTab extends StatelessWidget {
  final bool dataSharing;
  final bool analyticsEnabled;
  final bool marketingEmails;
  final ValueChanged<bool> onDataSharingChanged;
  final ValueChanged<bool> onAnalyticsChanged;
  final ValueChanged<bool> onMarketingChanged;

  const _PrivacyTab({
    required this.dataSharing,
    required this.analyticsEnabled,
    required this.marketingEmails,
    required this.onDataSharingChanged,
    required this.onAnalyticsChanged,
    required this.onMarketingChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // GDPR Compliance Badge
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
            border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.verified_user, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'GDPR Compliant',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Your data is protected under GDPR regulations',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ).animate().fadeIn().slideY(begin: 0.2, end: 0),
        
        const SizedBox(height: 24),
        
        // Data Preferences
        Text(
          'Data Preferences',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ).animate().fadeIn(delay: 200.ms),
        
        const SizedBox(height: 16),
        
        _SecuritySettingCard(
          icon: Icons.share,
          iconColor: AppTheme.infoColor,
          title: 'Data Sharing',
          subtitle: 'Share anonymous data for research',
          trailing: Switch(
            value: dataSharing,
            onChanged: onDataSharingChanged,
            activeColor: AppTheme.primaryColor,
          ),
        ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.1, end: 0),
        
        _SecuritySettingCard(
          icon: Icons.analytics,
          iconColor: const Color(0xFF9B59B6),
          title: 'Usage Analytics',
          subtitle: 'Help improve the app experience',
          trailing: Switch(
            value: analyticsEnabled,
            onChanged: onAnalyticsChanged,
            activeColor: AppTheme.primaryColor,
          ),
        ).animate().fadeIn(delay: 400.ms).slideX(begin: 0.1, end: 0),
        
        _SecuritySettingCard(
          icon: Icons.email,
          iconColor: AppTheme.warningColor,
          title: 'Marketing Emails',
          subtitle: 'Receive promotional content',
          trailing: Switch(
            value: marketingEmails,
            onChanged: onMarketingChanged,
            activeColor: AppTheme.primaryColor,
          ),
        ).animate().fadeIn(delay: 500.ms).slideX(begin: 0.1, end: 0),
        
        const SizedBox(height: 24),
        
        // Profile Visibility
        Text(
          'Profile Visibility',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ).animate().fadeIn(delay: 600.ms),
        
        const SizedBox(height: 16),
        
        _VisibilityOption(
          title: 'Public Profile',
          description: 'Anyone can view your profile',
          isSelected: false,
        ).animate().fadeIn(delay: 700.ms),
        
        _VisibilityOption(
          title: 'Connections Only',
          description: 'Only your connections can see your profile',
          isSelected: true,
        ).animate().fadeIn(delay: 800.ms),
        
        _VisibilityOption(
          title: 'Private',
          description: 'Hide your profile from everyone',
          isSelected: false,
        ).animate().fadeIn(delay: 900.ms),
      ],
    );
  }
}

class _VisibilityOption extends StatelessWidget {
  final String title;
  final String description;
  final bool isSelected;

  const _VisibilityOption({
    required this.title,
    required this.description,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        border: Border.all(
          color: isSelected ? AppTheme.primaryColor : theme.dividerColor,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? AppTheme.primaryColor : Colors.transparent,
              border: Border.all(
                color: isSelected ? AppTheme.primaryColor : AppTheme.textTertiary,
                width: 2,
              ),
            ),
            child: isSelected
                ? const Icon(Icons.check, color: Colors.white, size: 16)
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(description, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DataTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Data Export CTA
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.download, color: Colors.white, size: 32),
              const SizedBox(height: 12),
              const Text(
                'Export Your Data',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Download a copy of all your data including applications, contacts, and settings.',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.download),
                label: const Text('Request Export'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF667EEA),
                ),
              ),
            ],
          ),
        ).animate().fadeIn().scale(begin: const Offset(0.95, 0.95)),
        
        const SizedBox(height: 24),
        
        // Data Storage Info
        Text(
          'Data Storage',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ).animate().fadeIn(delay: 200.ms),
        
        const SizedBox(height: 16),
        
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
            border: Border.all(color: theme.dividerColor),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Storage Used',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '2.4 GB / 10 GB',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: const LinearProgressIndicator(
                  value: 0.24,
                  backgroundColor: AppTheme.dividerColor,
                  valueColor: AlwaysStoppedAnimation(AppTheme.primaryColor),
                  minHeight: 10,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _StorageItem(label: 'Applications', size: '1.2 GB', color: AppTheme.primaryColor),
                  _StorageItem(label: 'Documents', size: '800 MB', color: AppTheme.successColor),
                  _StorageItem(label: 'Other', size: '400 MB', color: AppTheme.warningColor),
                ],
              ),
            ],
          ),
        ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1, end: 0),
        
        const SizedBox(height: 24),
        
        // Export History
        Text(
          'Export History',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ).animate().fadeIn(delay: 400.ms),
        
        const SizedBox(height: 16),
        
        ...List.generate(3, (index) {
          return _ExportHistoryCard(index: index)
              .animate()
              .fadeIn(delay: Duration(milliseconds: 500 + 100 * index))
              .slideX(begin: 0.1, end: 0);
        }),
        
        const SizedBox(height: 24),
        
        // Danger Zone
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.errorColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
            border: Border.all(color: AppTheme.errorColor.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.warning, color: AppTheme.errorColor, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Danger Zone',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.errorColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.delete_forever),
                label: const Text('Delete All Data'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.errorColor,
                  side: BorderSide(color: AppTheme.errorColor),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'This action cannot be undone. All your data will be permanently deleted.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.errorColor,
                ),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 800.ms),
      ],
    );
  }
}

class _StorageItem extends StatelessWidget {
  final String label;
  final String size;
  final Color color;

  const _StorageItem({
    required this.label,
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          size,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(label, style: theme.textTheme.labelSmall),
      ],
    );
  }
}

class _ExportHistoryCard extends StatelessWidget {
  final int index;

  const _ExportHistoryCard({required this.index});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final exports = [
      ('Full Data Export', 'Jan 15, 2024', '2.1 GB', true),
      ('Applications Only', 'Dec 20, 2023', '1.5 GB', true),
      ('Contacts Export', 'Nov 8, 2023', '120 MB', false),
    ];
    final export = exports[index % 3];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.folder_zip, color: AppTheme.primaryColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  export.$1,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${export.$2} • ${export.$3}',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          if (export.$4)
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.download),
              style: IconButton.styleFrom(
                backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                foregroundColor: AppTheme.primaryColor,
              ),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.textTertiary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Expired',
                style: TextStyle(
                  color: AppTheme.textTertiary,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ActivityTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Recent Activity
        Text(
          'Recent Activity',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ).animate().fadeIn(),
        
        const SizedBox(height: 16),
        
        ...List.generate(10, (index) {
          return _ActivityItem(index: index)
              .animate()
              .fadeIn(delay: Duration(milliseconds: 100 + 50 * index))
              .slideX(begin: 0.1, end: 0);
        }),
        
        const SizedBox(height: 24),
        
        Center(
          child: TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.history),
            label: const Text('View Full History'),
          ),
        ).animate().fadeIn(delay: 600.ms),
      ],
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final int index;

  const _ActivityItem({required this.index});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activities = [
      ('Logged in from iPhone', 'San Francisco, CA', Icons.smartphone, '2 min ago'),
      ('Password changed', 'Security update', Icons.lock, '1 hour ago'),
      ('Profile updated', 'Changed email address', Icons.person, '3 hours ago'),
      ('Data export requested', 'Full data export', Icons.download, '1 day ago'),
      ('New device added', 'MacBook Pro', Icons.laptop, '2 days ago'),
      ('2FA enabled', 'SMS verification', Icons.security, '3 days ago'),
      ('Logged in from Chrome', 'New York, NY', Icons.computer, '4 days ago'),
      ('Privacy settings changed', 'Updated visibility', Icons.visibility, '5 days ago'),
      ('Session terminated', 'iPad removed', Icons.logout, '1 week ago'),
      ('Email verified', 'john@example.com', Icons.email, '2 weeks ago'),
    ];
    final activity = activities[index % 10];

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(activity.$3, color: AppTheme.primaryColor, size: 18),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.$1,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(activity.$2, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          Text(
            activity.$4,
            style: theme.textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}
