import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/animations.dart';
import '../../widgets/enhanced_widgets.dart';

/// Gamification screen with achievements, streaks, and leaderboard
class GamificationScreen extends ConsumerStatefulWidget {
  const GamificationScreen({super.key});

  @override
  ConsumerState<GamificationScreen> createState() => _GamificationScreenState();
}

class _GamificationScreenState extends ConsumerState<GamificationScreen>
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
              expandedHeight: 280,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFFFD700), Color(0xFFFF8C00)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Decorative Elements
                      Positioned(
                        top: -30,
                        right: -30,
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 100,
                        left: -40,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                      ),
                      // Trophy Icon Floating
                      Positioned(
                        top: 80,
                        right: 30,
                        child: FloatingAnimation(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              '🏆',
                              style: TextStyle(fontSize: 32),
                            ),
                          ),
                        ),
                      ),
                      // Main Content
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20),
                              // Level Badge
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.3),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        const Text(
                                          '⭐',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        const SizedBox(width: 8),
                                        const Text(
                                          'Level 12',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ).animate().fadeIn().slideX(begin: -0.3, end: 0),
                                ],
                              ),
                              const SizedBox(height: 16),
                              // XP Progress
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Job Hunter Pro',
                                          style: theme.textTheme.headlineSmall?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.2, end: 0),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            AnimatedCounter(
                                              value: 2450,
                                              textStyle: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 24,
                                              ),
                                            ),
                                            Text(
                                              ' / 3000 XP',
                                              style: TextStyle(
                                                color: Colors.white.withOpacity(0.8),
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ).animate().fadeIn(delay: 200.ms),
                                        const SizedBox(height: 12),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: LinearProgressIndicator(
                                            value: 0.82,
                                            backgroundColor: Colors.white.withOpacity(0.2),
                                            valueColor: const AlwaysStoppedAnimation(Colors.white),
                                            minHeight: 12,
                                          ),
                                        ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.3, end: 0),
                                        const SizedBox(height: 8),
                                        Text(
                                          '550 XP to Level 13 🚀',
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(0.8),
                                            fontSize: 13,
                                          ),
                                        ).animate().fadeIn(delay: 400.ms),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
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
                    tabs: const [
                      Tab(text: 'Achievements'),
                      Tab(text: 'Streaks'),
                      Tab(text: 'Challenges'),
                      Tab(text: 'Leaderboard'),
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
            _AchievementsTab(),
            _StreaksTab(),
            _ChallengesTab(),
            _LeaderboardTab(),
          ],
        ),
      ),
    );
  }
}

class _AchievementsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Stats Row
        Row(
          children: [
            Expanded(
              child: _MiniStatCard(
                icon: '🏅',
                value: '24',
                label: 'Earned',
                color: AppTheme.successColor,
              ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.2, end: 0),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MiniStatCard(
                icon: '🔒',
                value: '18',
                label: 'Locked',
                color: AppTheme.textTertiary,
              ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MiniStatCard(
                icon: '💎',
                value: '3',
                label: 'Rare',
                color: const Color(0xFF9B59B6),
              ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2, end: 0),
            ),
          ],
        ),
        
        const SizedBox(height: 24),
        
        // Recent Achievements
        Text(
          'Recently Unlocked',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ).animate().fadeIn(delay: 400.ms),
        
        const SizedBox(height: 16),
        
        ...List.generate(5, (index) {
          return _AchievementCard(index: index, unlocked: true)
              .animate()
              .fadeIn(delay: Duration(milliseconds: 500 + 100 * index))
              .slideX(begin: 0.1, end: 0);
        }),
        
        const SizedBox(height: 24),
        
        // Locked Achievements
        Text(
          'Up Next',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ).animate().fadeIn(delay: 900.ms),
        
        const SizedBox(height: 16),
        
        ...List.generate(3, (index) {
          return _AchievementCard(index: index + 5, unlocked: false)
              .animate()
              .fadeIn(delay: Duration(milliseconds: 1000 + 100 * index))
              .slideX(begin: 0.1, end: 0);
        }),
      ],
    );
  }
}

class _MiniStatCard extends StatelessWidget {
  final String icon;
  final String value;
  final String label;
  final Color color;

  const _MiniStatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(label, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final int index;
  final bool unlocked;

  const _AchievementCard({required this.index, required this.unlocked});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final achievements = [
      ('First Application', 'Submit your first job application', '🎯', '+50 XP'),
      ('Interview Ready', 'Complete 5 interview preparations', '🎤', '+100 XP'),
      ('Networking Star', 'Connect with 10 professionals', '⭐', '+75 XP'),
      ('Early Bird', 'Apply within 1 hour of job posting', '🌅', '+150 XP'),
      ('Consistent Applier', '7-day application streak', '🔥', '+200 XP'),
      ('Resume Master', 'Get 90% resume score', '📄', '+250 XP'),
      ('Dream Company', 'Get an offer from a top company', '🏢', '+500 XP'),
      ('Interview Ace', 'Pass 10 interviews', '💼', '+300 XP'),
    ];
    final achievement = achievements[index % achievements.length];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: unlocked
            ? theme.cardColor
            : theme.cardColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        border: Border.all(
          color: unlocked
              ? const Color(0xFFFFD700).withOpacity(0.5)
              : theme.dividerColor,
        ),
        boxShadow: unlocked
            ? [
                BoxShadow(
                  color: const Color(0xFFFFD700).withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          // Badge Icon
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: unlocked
                  ? const LinearGradient(
                      colors: [Color(0xFFFFD700), Color(0xFFFF8C00)],
                    )
                  : null,
              color: unlocked ? null : AppTheme.dividerColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: unlocked
                  ? Text(
                      achievement.$3,
                      style: const TextStyle(fontSize: 28),
                    )
                  : Icon(
                      Icons.lock,
                      color: AppTheme.textTertiary,
                      size: 24,
                    ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement.$1,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: unlocked ? null : AppTheme.textTertiary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  achievement.$2,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: unlocked
                        ? AppTheme.textSecondary
                        : AppTheme.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: unlocked
                  ? AppTheme.successColor.withOpacity(0.1)
                  : AppTheme.dividerColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              achievement.$4,
              style: TextStyle(
                color: unlocked
                    ? AppTheme.successColor
                    : AppTheme.textTertiary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StreaksTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Current Streak Card
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          ),
          child: Column(
            children: [
              PulseAnimation(
                child: const Text(
                  '🔥',
                  style: TextStyle(fontSize: 64),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedCounter(
                    value: 15,
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    ' days',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Application Streak 🎉',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Personal Best: 21 days',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ).animate().fadeIn().scale(begin: const Offset(0.9, 0.9)),
        
        const SizedBox(height: 24),
        
        // Week View
        Text(
          'This Week',
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _DayCircle(day: 'M', completed: true),
              _DayCircle(day: 'T', completed: true),
              _DayCircle(day: 'W', completed: true),
              _DayCircle(day: 'T', completed: true),
              _DayCircle(day: 'F', completed: true),
              _DayCircle(day: 'S', completed: false, isToday: true),
              _DayCircle(day: 'S', completed: false),
            ],
          ),
        ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2, end: 0),
        
        const SizedBox(height: 24),
        
        // Streak Rewards
        Text(
          'Streak Rewards',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ).animate().fadeIn(delay: 400.ms),
        
        const SizedBox(height: 16),
        
        ...List.generate(4, (index) {
          return _StreakRewardCard(index: index)
              .animate()
              .fadeIn(delay: Duration(milliseconds: 500 + 100 * index))
              .slideX(begin: 0.1, end: 0);
        }),
      ],
    );
  }
}

class _DayCircle extends StatelessWidget {
  final String day;
  final bool completed;
  final bool isToday;

  const _DayCircle({
    required this.day,
    required this.completed,
    this.isToday = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: completed
                ? const LinearGradient(
                    colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
                  )
                : null,
            color: completed ? null : AppTheme.dividerColor,
            border: isToday
                ? Border.all(color: AppTheme.primaryColor, width: 2)
                : null,
          ),
          child: Center(
            child: completed
                ? const Icon(Icons.check, color: Colors.white, size: 20)
                : Text(
                    day,
                    style: TextStyle(
                      color: isToday
                          ? AppTheme.primaryColor
                          : AppTheme.textTertiary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
        if (!completed) ...[
          const SizedBox(height: 4),
          Text(
            day,
            style: TextStyle(
              fontSize: 12,
              color: isToday ? AppTheme.primaryColor : AppTheme.textTertiary,
            ),
          ),
        ],
      ],
    );
  }
}

class _StreakRewardCard extends StatelessWidget {
  final int index;

  const _StreakRewardCard({required this.index});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rewards = [
      ('7 Day Streak', '+100 XP Bonus', '🎁', true),
      ('14 Day Streak', '+250 XP Bonus', '🎊', true),
      ('21 Day Streak', 'Premium Badge', '👑', false),
      ('30 Day Streak', 'Exclusive Title', '💎', false),
    ];
    final reward = rewards[index];
    final progress = [1.0, 1.0, 0.71, 0.5][index];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        border: Border.all(
          color: reward.$4 ? AppTheme.successColor : theme.dividerColor,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: reward.$4
                  ? AppTheme.successColor.withOpacity(0.1)
                  : AppTheme.dividerColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                reward.$3,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reward.$1,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(reward.$2, style: theme.textTheme.bodySmall),
                if (!reward.$4) ...[
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: AppTheme.dividerColor,
                      valueColor: const AlwaysStoppedAnimation(AppTheme.primaryColor),
                      minHeight: 6,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (reward.$4)
            Icon(Icons.check_circle, color: AppTheme.successColor)
          else
            Text(
              '${(progress * 100).toInt()}%',
              style: theme.textTheme.labelSmall?.copyWith(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }
}

class _ChallengesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Active Challenge
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.flash_on, color: Colors.white, size: 16),
                        SizedBox(width: 4),
                        Text(
                          'ACTIVE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '2d 14h left',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                '🚀 Weekly Sprint Challenge',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Apply to 10 jobs this week and earn bonus XP!',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: 0.7,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        valueColor: const AlwaysStoppedAnimation(Colors.white),
                        minHeight: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    '7/10',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text('🎁', style: TextStyle(fontSize: 18)),
                      const SizedBox(width: 8),
                      Text(
                        '+500 XP',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF667EEA),
                    ),
                    child: const Text('Continue'),
                  ),
                ],
              ),
            ],
          ),
        ).animate().fadeIn().scale(begin: const Offset(0.95, 0.95)),
        
        const SizedBox(height: 24),
        
        // Available Challenges
        SectionHeader(
          title: 'Available Challenges',
          actionText: 'View All',
          onActionPressed: () {},
        ).animate().fadeIn(delay: 200.ms),
        
        const SizedBox(height: 16),
        
        ...List.generate(5, (index) {
          return _ChallengeCard(index: index)
              .animate()
              .fadeIn(delay: Duration(milliseconds: 300 + 100 * index))
              .slideY(begin: 0.1, end: 0);
        }),
      ],
    );
  }
}

class _ChallengeCard extends StatelessWidget {
  final int index;

  const _ChallengeCard({required this.index});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final challenges = [
      ('Interview Prep Master', 'Complete 5 mock interviews', '🎤', '+300 XP', 'Medium'),
      ('Network Builder', 'Add 5 new connections', '🤝', '+200 XP', 'Easy'),
      ('Quick Applier', 'Apply within 30min of posting', '⚡', '+150 XP', 'Hard'),
      ('Resume Perfectionist', 'Achieve 95% resume score', '📝', '+400 XP', 'Hard'),
      ('Learning Streak', 'Learn for 7 days straight', '📚', '+250 XP', 'Medium'),
    ];
    final challenge = challenges[index % 5];
    final difficultyColors = {
      'Easy': AppTheme.successColor,
      'Medium': AppTheme.warningColor,
      'Hard': AppTheme.errorColor,
    };

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
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                challenge.$3,
                style: const TextStyle(fontSize: 28),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  challenge.$1,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(challenge.$2, style: theme.textTheme.bodySmall),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: difficultyColors[challenge.$5]!.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        challenge.$5,
                        style: TextStyle(
                          color: difficultyColors[challenge.$5],
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      challenge.$4,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.successColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Start'),
          ),
        ],
      ),
    );
  }
}

class _LeaderboardTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Top 3 Podium
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          ),
          child: Column(
            children: [
              const Text(
                'Weekly Leaderboard',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // 2nd Place
                  _PodiumItem(
                    rank: 2,
                    name: 'Michael K.',
                    xp: 4250,
                    height: 80,
                    color: const Color(0xFFC0C0C0),
                  ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.3, end: 0),
                  // 1st Place
                  _PodiumItem(
                    rank: 1,
                    name: 'Sarah C.',
                    xp: 5100,
                    height: 100,
                    color: const Color(0xFFFFD700),
                  ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.3, end: 0),
                  // 3rd Place
                  _PodiumItem(
                    rank: 3,
                    name: 'Emily R.',
                    xp: 3890,
                    height: 60,
                    color: const Color(0xFFCD7F32),
                  ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.3, end: 0),
                ],
              ),
            ],
          ),
        ).animate().fadeIn(),
        
        const SizedBox(height: 16),
        
        // Your Rank
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    '#8',
                    style: TextStyle(
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
                    const Text(
                      'Your Ranking',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '2,450 XP this week',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.arrow_upward, color: Colors.white, size: 14),
                    SizedBox(width: 4),
                    Text(
                      '+3',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),
        
        const SizedBox(height: 24),
        
        // Full Leaderboard
        SectionHeader(
          title: 'Full Rankings',
          actionText: 'All Time',
          onActionPressed: () {},
        ).animate().fadeIn(delay: 500.ms),
        
        const SizedBox(height: 16),
        
        ...List.generate(10, (index) {
          return _LeaderboardItem(rank: index + 4)
              .animate()
              .fadeIn(delay: Duration(milliseconds: 600 + 50 * index))
              .slideX(begin: 0.1, end: 0);
        }),
      ],
    );
  }
}

class _PodiumItem extends StatelessWidget {
  final int rank;
  final String name;
  final int xp;
  final double height;
  final Color color;

  const _PodiumItem({
    required this.rank,
    required this.name,
    required this.xp,
    required this.height,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final medals = ['', '🥇', '🥈', '🥉'];

    return Column(
      children: [
        Text(
          medals[rank],
          style: const TextStyle(fontSize: 24),
        ),
        const SizedBox(height: 8),
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.3),
            border: Border.all(color: color, width: 2),
          ),
          child: Center(
            child: Text(
              name.split(' ').map((e) => e[0]).join(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 70,
          height: height,
          decoration: BoxDecoration(
            color: color.withOpacity(0.3),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(8),
            ),
          ),
          child: Center(
            child: Text(
              '$xp',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LeaderboardItem extends StatelessWidget {
  final int rank;

  const _LeaderboardItem({required this.rank});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final names = [
      'Alex T.', 'Jordan P.', 'Taylor M.', 'Casey L.', 'Morgan S.',
      'Jamie R.', 'Riley K.', 'Drew H.', 'Avery N.', 'Quinn B.',
    ];
    final xpValues = [3200, 3100, 2950, 2800, 2650, 2500, 2350, 2200, 2050, 1900];

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppTheme.dividerColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '#$rank',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.primaryColor.withOpacity(0.1),
            ),
            child: Center(
              child: Text(
                names[(rank - 4) % names.length].split(' ').map((e) => e[0]).join(),
                style: const TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              names[(rank - 4) % names.length],
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            '${xpValues[(rank - 4) % xpValues.length]} XP',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
