import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/theme/app_theme.dart';
import '../../widgets/enhanced_widgets.dart';

/// Integrations screen for managing third-party connections
class IntegrationsScreen extends ConsumerStatefulWidget {
  const IntegrationsScreen({super.key});

  @override
  ConsumerState<IntegrationsScreen> createState() => _IntegrationsScreenState();
}

class _IntegrationsScreenState extends ConsumerState<IntegrationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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
                      colors: [Color(0xFF4158D0), Color(0xFFC850C0), Color(0xFFFFCC70)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Decorative Elements
                      Positioned(
                        top: -40,
                        right: -40,
                        child: Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 60,
                        left: -30,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.1),
                          ),
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
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: const Icon(
                                      Icons.hub,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Integrations',
                                        style: theme.textTheme.headlineSmall?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Connect your favorite services',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.8),
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
                      Tab(text: 'Email'),
                      Tab(text: 'Calendar'),
                      Tab(text: 'Communication'),
                      Tab(text: 'API'),
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
            _EmailTab(),
            _CalendarTab(),
            _CommunicationTab(),
            _APITab(),
          ],
        ),
      ),
    );
  }
}

class _EmailTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Connected Email
        Text(
          'Connected Account',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ).animate().fadeIn(),
        
        const SizedBox(height: 16),
        
        _ConnectedIntegrationCard(
          name: 'Gmail',
          email: 'john.doe@gmail.com',
          icon: Icons.mail,
          color: const Color(0xFFEA4335),
          lastSync: '2 min ago',
          isConnected: true,
        ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1, end: 0),
        
        const SizedBox(height: 24),
        
        // Other Email Providers
        Text(
          'Other Providers',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ).animate().fadeIn(delay: 200.ms),
        
        const SizedBox(height: 16),
        
        _IntegrationCard(
          name: 'Outlook',
          description: 'Connect your Microsoft email',
          icon: Icons.mail_outline,
          color: const Color(0xFF0078D4),
          isConnected: false,
        ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.1, end: 0),
        
        _IntegrationCard(
          name: 'Yahoo Mail',
          description: 'Connect your Yahoo email',
          icon: Icons.mail_outline,
          color: const Color(0xFF6001D2),
          isConnected: false,
        ).animate().fadeIn(delay: 400.ms).slideX(begin: 0.1, end: 0),
        
        _IntegrationCard(
          name: 'iCloud Mail',
          description: 'Connect your Apple email',
          icon: Icons.mail_outline,
          color: const Color(0xFF555555),
          isConnected: false,
        ).animate().fadeIn(delay: 500.ms).slideX(begin: 0.1, end: 0),
        
        const SizedBox(height: 24),
        
        // Email Settings
        Text(
          'Email Settings',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ).animate().fadeIn(delay: 600.ms),
        
        const SizedBox(height: 16),
        
        _SettingTile(
          icon: Icons.sync,
          title: 'Auto-sync Emails',
          subtitle: 'Automatically import job-related emails',
          trailing: Switch(
            value: true,
            onChanged: (v) {},
            activeColor: AppTheme.primaryColor,
          ),
        ).animate().fadeIn(delay: 700.ms),
        
        _SettingTile(
          icon: Icons.label,
          title: 'Auto-label',
          subtitle: 'Categorize emails by job application',
          trailing: Switch(
            value: true,
            onChanged: (v) {},
            activeColor: AppTheme.primaryColor,
          ),
        ).animate().fadeIn(delay: 800.ms),
      ],
    );
  }
}

class _ConnectedIntegrationCard extends StatelessWidget {
  final String name;
  final String email;
  final IconData icon;
  final Color color;
  final String lastSync;
  final bool isConnected;

  const _ConnectedIntegrationCard({
    required this.name,
    required this.email,
    required this.icon,
    required this.color,
    required this.lastSync,
    required this.isConnected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        border: Border.all(color: AppTheme.successColor.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.successColor.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.successColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: AppTheme.successColor,
                                size: 12,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Connected',
                                style: TextStyle(
                                  color: AppTheme.successColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(email, style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_vert),
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.sync, size: 14, color: AppTheme.textTertiary),
                  const SizedBox(width: 6),
                  Text(
                    'Last synced: $lastSync',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text('Sync Now'),
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.errorColor,
                    ),
                    child: const Text('Disconnect'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _IntegrationCard extends StatelessWidget {
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final bool isConnected;

  const _IntegrationCard({
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.isConnected,
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
                  name,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(description, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Connect'),
          ),
        ],
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;

  const _SettingTile({
    required this.icon,
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
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryColor, size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
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

class _CalendarTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Calendar Providers
        Text(
          'Calendar Integration',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ).animate().fadeIn(),
        
        const SizedBox(height: 16),
        
        _CalendarIntegrationCard(
          name: 'Google Calendar',
          icon: Icons.calendar_today,
          color: const Color(0xFF4285F4),
          isConnected: true,
          eventsSync: 24,
        ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1, end: 0),
        
        _IntegrationCard(
          name: 'Outlook Calendar',
          description: 'Sync with Microsoft Calendar',
          icon: Icons.calendar_today,
          color: const Color(0xFF0078D4),
          isConnected: false,
        ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.1, end: 0),
        
        _IntegrationCard(
          name: 'Apple Calendar',
          description: 'Sync with iCloud Calendar',
          icon: Icons.calendar_today,
          color: const Color(0xFF555555),
          isConnected: false,
        ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.1, end: 0),
        
        const SizedBox(height: 24),
        
        // Calendar Settings
        Text(
          'Sync Preferences',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ).animate().fadeIn(delay: 400.ms),
        
        const SizedBox(height: 16),
        
        _SettingTile(
          icon: Icons.event,
          title: 'Sync Interviews',
          subtitle: 'Add interview events to calendar',
          trailing: Switch(
            value: true,
            onChanged: (v) {},
            activeColor: AppTheme.primaryColor,
          ),
        ).animate().fadeIn(delay: 500.ms),
        
        _SettingTile(
          icon: Icons.notifications,
          title: 'Reminders',
          subtitle: 'Create calendar reminders',
          trailing: Switch(
            value: true,
            onChanged: (v) {},
            activeColor: AppTheme.primaryColor,
          ),
        ).animate().fadeIn(delay: 600.ms),
        
        _SettingTile(
          icon: Icons.access_time,
          title: 'Default Reminder Time',
          subtitle: '30 minutes before',
          trailing: const Icon(Icons.chevron_right, color: AppTheme.textTertiary),
        ).animate().fadeIn(delay: 700.ms),
      ],
    );
  }
}

class _CalendarIntegrationCard extends StatelessWidget {
  final String name;
  final IconData icon;
  final Color color;
  final bool isConnected;
  final int eventsSync;

  const _CalendarIntegrationCard({
    required this.name,
    required this.icon,
    required this.color,
    required this.isConnected,
    required this.eventsSync,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        border: Border.all(color: AppTheme.successColor.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.check_circle,
                          color: AppTheme.successColor,
                          size: 16,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$eventsSync events synced',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: () {},
                child: const Text('Settings'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CommunicationTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Communication Platforms
        Text(
          'Communication Platforms',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ).animate().fadeIn(),
        
        const SizedBox(height: 16),
        
        _CommunicationCard(
          name: 'Slack',
          description: 'Get job updates in Slack',
          logoText: 'S',
          color: const Color(0xFF4A154B),
          isConnected: true,
        ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1, end: 0),
        
        _CommunicationCard(
          name: 'Discord',
          description: 'Connect your Discord server',
          logoText: 'D',
          color: const Color(0xFF5865F2),
          isConnected: false,
        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),
        
        _CommunicationCard(
          name: 'Microsoft Teams',
          description: 'Integrate with Teams',
          logoText: 'T',
          color: const Color(0xFF6264A7),
          isConnected: false,
        ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1, end: 0),
        
        const SizedBox(height: 24),
        
        // Job Platforms
        Text(
          'Job Platforms',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ).animate().fadeIn(delay: 400.ms),
        
        const SizedBox(height: 16),
        
        _CommunicationCard(
          name: 'LinkedIn',
          description: 'Import jobs from LinkedIn',
          logoText: 'in',
          color: const Color(0xFF0077B5),
          isConnected: true,
        ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.1, end: 0),
        
        _CommunicationCard(
          name: 'Indeed',
          description: 'Sync with Indeed applications',
          logoText: 'I',
          color: const Color(0xFF2557A7),
          isConnected: false,
        ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.1, end: 0),
        
        _CommunicationCard(
          name: 'Glassdoor',
          description: 'Get company insights',
          logoText: 'G',
          color: const Color(0xFF0CAA41),
          isConnected: false,
        ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.1, end: 0),
      ],
    );
  }
}

class _CommunicationCard extends StatelessWidget {
  final String name;
  final String description;
  final String logoText;
  final Color color;
  final bool isConnected;

  const _CommunicationCard({
    required this.name,
    required this.description,
    required this.logoText,
    required this.color,
    required this.isConnected,
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
          color: isConnected
              ? AppTheme.successColor.withOpacity(0.5)
              : theme.dividerColor,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                logoText,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (isConnected) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.successColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Connected',
                          style: TextStyle(
                            color: AppTheme.successColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(description, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          isConnected
              ? IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.settings),
                  style: IconButton.styleFrom(
                    backgroundColor: AppTheme.dividerColor.withOpacity(0.5),
                  ),
                )
              : ElevatedButton(
                  onPressed: () {},
                  child: const Text('Connect'),
                ),
        ],
      ),
    );
  }
}

class _APITab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // API Keys Section
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0F2027), Color(0xFF203A43)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.vpn_key, color: Colors.white, size: 24),
                      const SizedBox(width: 12),
                      Text(
                        'API Access',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.successColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Pro Plan',
                      style: TextStyle(
                        color: AppTheme.successColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Access the JobScouter API to build custom integrations',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('Generate New Key'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF0F2027),
                ),
              ),
            ],
          ),
        ).animate().fadeIn().scale(begin: const Offset(0.95, 0.95)),
        
        const SizedBox(height: 24),
        
        // Active API Keys
        Text(
          'Active API Keys',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ).animate().fadeIn(delay: 200.ms),
        
        const SizedBox(height: 16),
        
        ...List.generate(3, (index) {
          return _APIKeyCard(index: index)
              .animate()
              .fadeIn(delay: Duration(milliseconds: 300 + 100 * index))
              .slideX(begin: 0.1, end: 0);
        }),
        
        const SizedBox(height: 24),
        
        // Webhooks
        Text(
          'Webhooks',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ).animate().fadeIn(delay: 600.ms),
        
        const SizedBox(height: 16),
        
        ...List.generate(2, (index) {
          return _WebhookCard(index: index)
              .animate()
              .fadeIn(delay: Duration(milliseconds: 700 + 100 * index))
              .slideY(begin: 0.1, end: 0);
        }),
        
        const SizedBox(height: 16),
        
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add),
          label: const Text('Add Webhook'),
        ).animate().fadeIn(delay: 900.ms),
        
        const SizedBox(height: 24),
        
        // API Docs Link
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              const Icon(Icons.menu_book, color: AppTheme.primaryColor),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'API Documentation',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Learn how to use the JobScouter API',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.open_in_new, color: AppTheme.primaryColor),
            ],
          ),
        ).animate().fadeIn(delay: 1000.ms),
      ],
    );
  }
}

class _APIKeyCard extends StatelessWidget {
  final int index;

  const _APIKeyCard({required this.index});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final keys = [
      ('Production Key', 'sk_live_...8x4f', 'All permissions', '12.5K'),
      ('Development Key', 'sk_test_...2m9d', 'Read only', '1.2K'),
      ('Webhook Key', 'wh_key_...7j3k', 'Webhooks', '890'),
    ];
    final key = keys[index % 3];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                key.$1,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_vert, size: 20),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.dividerColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  key.$2,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {},
                  child: Icon(
                    Icons.copy,
                    size: 16,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  key.$3,
                  style: const TextStyle(
                    color: AppTheme.primaryColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '${key.$4} requests/mo',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WebhookCard extends StatelessWidget {
  final int index;

  const _WebhookCard({required this.index});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final webhooks = [
      ('Application Updates', 'https://myapp.com/webhook/applications', true),
      ('Interview Events', 'https://myapp.com/webhook/interviews', true),
    ];
    final webhook = webhooks[index % 2];

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
            child: const Icon(Icons.webhook, color: AppTheme.primaryColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  webhook.$1,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  webhook.$2,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontFamily: 'monospace',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Switch(
            value: webhook.$3,
            onChanged: (v) {},
            activeColor: AppTheme.primaryColor,
          ),
        ],
      ),
    );
  }
}
