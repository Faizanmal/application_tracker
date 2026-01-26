import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/animations.dart';
import '../../widgets/enhanced_widgets.dart';

/// Career Development screen for tracking skills, learning, and goals
class CareerScreen extends ConsumerStatefulWidget {
  const CareerScreen({super.key});

  @override
  ConsumerState<CareerScreen> createState() => _CareerScreenState();
}

class _CareerScreenState extends ConsumerState<CareerScreen>
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
            // Gradient Header
            SliverAppBar(
              expandedHeight: 220,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF7C3AED), Color(0xFFDB2777)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Decorative Circles
                      Positioned(
                        top: -50,
                        right: -50,
                        child: Container(
                          width: 200,
                          height: 200,
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
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: const Icon(
                                      Icons.trending_up,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Career Development',
                                        style: theme.textTheme.headlineSmall?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Track your growth & achieve your goals',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.8),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ).animate().fadeIn().slideY(begin: 0.3, end: 0),
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
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                    tabs: const [
                      Tab(text: 'Skills'),
                      Tab(text: 'Learning'),
                      Tab(text: 'Portfolio'),
                      Tab(text: 'Goals'),
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
            _SkillsTab(),
            _LearningTab(),
            _PortfolioTab(),
            _GoalsTab(),
          ],
        ),
      ),
    );
  }
}

class _SkillsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Skill Score Overview
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
          child: Row(
            children: [
              // Score Circle
              SizedBox(
                width: 100,
                height: 100,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: CircularProgressIndicator(
                        value: 0.72,
                        strokeWidth: 8,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        valueColor: const AlwaysStoppedAnimation(Colors.white),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedCounter(
                          value: 72,
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                          suffix: '%',
                        ),
                        Text(
                          'Score',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 12,
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
                      'Skill Profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'You\'re ahead of 78% of candidates in your field',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Senior Level',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ).animate().fadeIn().scale(begin: const Offset(0.95, 0.95)),
        
        const SizedBox(height: 24),
        
        // Categories
        SectionHeader(
          title: 'Skill Categories',
          actionText: 'Add Skill',
          onActionPressed: () {},
        ).animate().fadeIn(delay: 200.ms),
        
        const SizedBox(height: 16),
        
        ...[
          _SkillCategoryCard(
            title: 'Programming Languages',
            skills: [
              _Skill('Python', 0.9, const Color(0xFF3776AB)),
              _Skill('JavaScript', 0.85, const Color(0xFFF7DF1E)),
              _Skill('TypeScript', 0.8, const Color(0xFF3178C6)),
              _Skill('Dart', 0.75, const Color(0xFF0175C2)),
            ],
            index: 0,
          ),
          _SkillCategoryCard(
            title: 'Frameworks & Libraries',
            skills: [
              _Skill('React', 0.85, const Color(0xFF61DAFB)),
              _Skill('Flutter', 0.8, const Color(0xFF02569B)),
              _Skill('Django', 0.75, const Color(0xFF092E20)),
              _Skill('Node.js', 0.7, const Color(0xFF339933)),
            ],
            index: 1,
          ),
          _SkillCategoryCard(
            title: 'Tools & Technologies',
            skills: [
              _Skill('Git', 0.9, const Color(0xFFF05032)),
              _Skill('Docker', 0.8, const Color(0xFF2496ED)),
              _Skill('AWS', 0.7, const Color(0xFFFF9900)),
              _Skill('PostgreSQL', 0.75, const Color(0xFF336791)),
            ],
            index: 2,
          ),
        ],
      ],
    );
  }
}

class _Skill {
  final String name;
  final double level;
  final Color color;

  _Skill(this.name, this.level, this.color);
}

class _SkillCategoryCard extends StatelessWidget {
  final String title;
  final List<_Skill> skills;
  final int index;

  const _SkillCategoryCard({
    required this.title,
    required this.skills,
    required this.index,
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
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          ...skills.map((skill) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(skill.name, style: theme.textTheme.bodyMedium),
                    Text(
                      '${(skill.level * 100).toInt()}%',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                AnimatedProgressBar(
                  progress: skill.level,
                  color: skill.color,
                  height: 8,
                ),
              ],
            ),
          )),
        ],
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: 300 + 100 * index)).slideX(begin: 0.1, end: 0);
  }
}

class _LearningTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Learning Streak
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.local_fire_department,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '🔥 12 Day Streak!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Keep learning to maintain your streak',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ).animate().fadeIn().slideY(begin: 0.2, end: 0),
        
        const SizedBox(height: 24),
        
        // Current Courses
        SectionHeader(
          title: 'In Progress',
          actionText: 'Browse',
          onActionPressed: () {},
        ).animate().fadeIn(delay: 200.ms),
        
        const SizedBox(height: 16),
        
        ...List.generate(3, (index) {
          return _CourseCard(index: index)
              .animate()
              .fadeIn(delay: Duration(milliseconds: 300 + 100 * index))
              .slideX(begin: 0.1, end: 0);
        }),
        
        const SizedBox(height: 24),
        
        // Recommended
        SectionHeader(
          title: 'Recommended for You',
          actionText: 'See All',
          onActionPressed: () {},
        ).animate().fadeIn(delay: 600.ms),
        
        const SizedBox(height: 16),
        
        SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return _RecommendedCourseCard(index: index)
                  .animate()
                  .fadeIn(delay: Duration(milliseconds: 700 + 50 * index))
                  .slideX(begin: 0.2, end: 0);
            },
          ),
        ),
      ],
    );
  }
}

class _CourseCard extends StatelessWidget {
  final int index;

  const _CourseCard({required this.index});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final courses = [
      ('System Design Interview', 'Educative', 0.65),
      ('Advanced Python', 'Udemy', 0.40),
      ('AWS Solutions Architect', 'Coursera', 0.25),
    ];
    final course = courses[index % 3];

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
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.play_circle_outline,
              color: AppTheme.primaryColor,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.$1,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  course.$2,
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: course.$3,
                          backgroundColor: AppTheme.dividerColor,
                          valueColor: const AlwaysStoppedAnimation(AppTheme.primaryColor),
                          minHeight: 6,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${(course.$3 * 100).toInt()}%',
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.play_arrow),
            style: IconButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _RecommendedCourseCard extends StatelessWidget {
  final int index;

  const _RecommendedCourseCard({required this.index});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final courses = [
      ('Docker Mastery', '15 hours'),
      ('Kubernetes Basics', '12 hours'),
      ('GraphQL Fundamentals', '8 hours'),
      ('React Native', '20 hours'),
      ('Machine Learning 101', '25 hours'),
    ];

    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
              gradient: index % 2 == 0
                  ? AppTheme.primaryGradient
                  : AppTheme.accentGradient,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppTheme.radiusLg),
              ),
            ),
            child: Center(
              child: Icon(
                Icons.school_outlined,
                color: Colors.white.withOpacity(0.5),
                size: 40,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  courses[index % 5].$1,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 12,
                      color: AppTheme.textTertiary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      courses[index % 5].$2,
                      style: theme.textTheme.labelSmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PortfolioTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Portfolio Stats
        Row(
          children: [
            Expanded(
              child: AnimatedStatCard(
                title: 'Projects',
                value: 12,
                icon: Icons.folder_outlined,
                gradient: AppTheme.primaryGradient,
              ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.2, end: 0),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AnimatedStatCard(
                title: 'Commits',
                value: 847,
                icon: Icons.commit,
                gradient: AppTheme.accentGradient,
              ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.2, end: 0),
            ),
          ],
        ),
        
        const SizedBox(height: 24),
        
        // Featured Projects
        SectionHeader(
          title: 'Featured Projects',
          actionText: 'Add Project',
          onActionPressed: () {},
        ).animate().fadeIn(delay: 300.ms),
        
        const SizedBox(height: 16),
        
        ...List.generate(4, (index) {
          return _ProjectCard(index: index)
              .animate()
              .fadeIn(delay: Duration(milliseconds: 400 + 100 * index))
              .slideY(begin: 0.1, end: 0);
        }),
      ],
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final int index;

  const _ProjectCard({required this.index});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final projects = [
      ('Job Tracker App', 'A Flutter app for tracking job applications', ['Flutter', 'Dart', 'Firebase']),
      ('E-Commerce API', 'REST API for an online marketplace', ['Python', 'Django', 'PostgreSQL']),
      ('Portfolio Website', 'Personal portfolio with Next.js', ['React', 'Next.js', 'Tailwind']),
      ('Chat Application', 'Real-time chat with WebSockets', ['Node.js', 'Socket.io', 'Redis']),
    ];
    final project = projects[index % 4];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        border: Border.all(color: theme.dividerColor),
        boxShadow: AppTheme.shadowSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Project Banner
          Container(
            height: 80,
            decoration: BoxDecoration(
              gradient: index % 2 == 0
                  ? const LinearGradient(
                      colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                    )
                  : const LinearGradient(
                      colors: [Color(0xFF11998E), Color(0xFF38EF7D)],
                    ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppTheme.radiusLg),
              ),
            ),
            child: Center(
              child: Icon(
                Icons.code,
                color: Colors.white.withOpacity(0.4),
                size: 36,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      project.$1,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.link, size: 20),
                          onPressed: () {},
                          visualDensity: VisualDensity.compact,
                        ),
                        IconButton(
                          icon: const Icon(Icons.code, size: 20),
                          onPressed: () {},
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  project.$2,
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: project.$3.map((tech) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      tech,
                      style: const TextStyle(
                        color: AppTheme.primaryColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GoalsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Current Goal Progress
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFF093FB), Color(0xFFF5576C)],
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
                  const Text(
                    '🎯 Q1 2024 Goals',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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
                    child: const Text(
                      '3/5 Complete',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: 0.6,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  valueColor: const AlwaysStoppedAnimation(Colors.white),
                  minHeight: 10,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '60% complete • 45 days remaining',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ).animate().fadeIn().scale(begin: const Offset(0.95, 0.95)),
        
        const SizedBox(height: 24),
        
        // Goals List
        SectionHeader(
          title: 'Active Goals',
          actionText: 'Add Goal',
          onActionPressed: () {},
        ).animate().fadeIn(delay: 200.ms),
        
        const SizedBox(height: 16),
        
        ...List.generate(5, (index) {
          return _GoalCard(index: index)
              .animate()
              .fadeIn(delay: Duration(milliseconds: 300 + 100 * index))
              .slideX(begin: 0.1, end: 0);
        }),
      ],
    );
  }
}

class _GoalCard extends StatelessWidget {
  final int index;

  const _GoalCard({required this.index});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final goals = [
      ('Complete AWS Certification', 'Get AWS Solutions Architect cert', 0.8, true),
      ('Apply to 50 Companies', '45/50 applications submitted', 0.9, false),
      ('Build 3 Side Projects', '2/3 projects completed', 0.67, false),
      ('Improve System Design Skills', '4 mock interviews done', 0.5, false),
      ('Network with 20 People', '12/20 connections made', 0.6, false),
    ];
    final goal = goals[index % 5];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        border: Border.all(
          color: goal.$4 ? AppTheme.successColor : theme.dividerColor,
        ),
      ),
      child: Row(
        children: [
          // Completion Indicator
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: goal.$4
                  ? AppTheme.successColor.withOpacity(0.1)
                  : AppTheme.primaryColor.withOpacity(0.1),
            ),
            child: goal.$4
                ? const Icon(
                    Icons.check_circle,
                    color: AppTheme.successColor,
                    size: 28,
                  )
                : Center(
                    child: Text(
                      '${(goal.$3 * 100).toInt()}%',
                      style: const TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  goal.$1,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    decoration: goal.$4 ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  goal.$2,
                  style: theme.textTheme.bodySmall,
                ),
                if (!goal.$4) ...[
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: goal.$3,
                      backgroundColor: AppTheme.dividerColor,
                      valueColor: const AlwaysStoppedAnimation(AppTheme.primaryColor),
                      minHeight: 6,
                    ),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}
