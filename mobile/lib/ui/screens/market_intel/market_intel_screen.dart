import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/animations.dart';
import '../../widgets/enhanced_widgets.dart';

/// Market Intelligence screen for job market insights
class MarketIntelScreen extends ConsumerStatefulWidget {
  const MarketIntelScreen({super.key});

  @override
  ConsumerState<MarketIntelScreen> createState() => _MarketIntelScreenState();
}

class _MarketIntelScreenState extends ConsumerState<MarketIntelScreen>
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
                      colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Decorative grid pattern
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _GridPainter(),
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
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.insights,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Market Intelligence',
                                        style: theme.textTheme.headlineSmall?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Real-time job market insights',
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
                      Tab(text: 'Trends'),
                      Tab(text: 'Salaries'),
                      Tab(text: 'Companies'),
                      Tab(text: 'Skills'),
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
            _TrendsTab(),
            _SalariesTab(),
            _CompaniesTab(),
            _SkillsTab(),
          ],
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..strokeWidth = 1;

    for (var i = 0; i < size.width; i += 30) {
      canvas.drawLine(
        Offset(i.toDouble(), 0),
        Offset(i.toDouble(), size.height),
        paint,
      );
    }
    for (var i = 0; i < size.height; i += 30) {
      canvas.drawLine(
        Offset(0, i.toDouble()),
        Offset(size.width, i.toDouble()),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TrendsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Market Summary Cards
        Row(
          children: [
            Expanded(
              child: _TrendCard(
                title: 'Job Openings',
                value: '2.4M',
                change: '+12%',
                isPositive: true,
                icon: Icons.work_outline,
              ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.2, end: 0),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _TrendCard(
                title: 'Avg. Salary',
                value: '\$125K',
                change: '+8%',
                isPositive: true,
                icon: Icons.attach_money,
              ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _TrendCard(
                title: 'Remote Jobs',
                value: '35%',
                change: '-3%',
                isPositive: false,
                icon: Icons.home_outlined,
              ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2, end: 0),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _TrendCard(
                title: 'Hiring Rate',
                value: '68%',
                change: '+5%',
                isPositive: true,
                icon: Icons.trending_up,
              ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),
            ),
          ],
        ),
        
        const SizedBox(height: 24),
        
        // Trending Job Titles
        SectionHeader(
          title: 'Trending Job Titles',
          actionText: 'See All',
          onActionPressed: () {},
        ).animate().fadeIn(delay: 500.ms),
        
        const SizedBox(height: 16),
        
        ...List.generate(5, (index) {
          return _TrendingJobCard(index: index)
              .animate()
              .fadeIn(delay: Duration(milliseconds: 600 + 100 * index))
              .slideX(begin: 0.1, end: 0);
        }),
        
        const SizedBox(height: 24),
        
        // Industry Insights
        SectionHeader(
          title: 'Industry Growth',
          actionText: 'Details',
          onActionPressed: () {},
        ).animate().fadeIn(delay: 1000.ms),
        
        const SizedBox(height: 16),
        
        ...List.generate(4, (index) {
          return _IndustryCard(index: index)
              .animate()
              .fadeIn(delay: Duration(milliseconds: 1100 + 100 * index))
              .slideY(begin: 0.1, end: 0);
        }),
      ],
    );
  }
}

class _TrendCard extends StatelessWidget {
  final String title;
  final String value;
  final String change;
  final bool isPositive;
  final IconData icon;

  const _TrendCard({
    required this.title,
    required this.value,
    required this.change,
    required this.isPositive,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
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
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: AppTheme.primaryColor, size: 18),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isPositive
                      ? AppTheme.successColor.withOpacity(0.1)
                      : AppTheme.errorColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                      size: 12,
                      color: isPositive ? AppTheme.successColor : AppTheme.errorColor,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      change,
                      style: TextStyle(
                        color: isPositive ? AppTheme.successColor : AppTheme.errorColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(title, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _TrendingJobCard extends StatelessWidget {
  final int index;

  const _TrendingJobCard({required this.index});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final jobs = [
      ('AI/ML Engineer', '+45%', '15K+ openings'),
      ('Full Stack Developer', '+28%', '42K+ openings'),
      ('Data Scientist', '+22%', '18K+ openings'),
      ('DevOps Engineer', '+35%', '12K+ openings'),
      ('Cloud Architect', '+52%', '8K+ openings'),
    ];
    final job = jobs[index % 5];

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
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                '#${index + 1}',
                style: const TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
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
                  job.$1,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(job.$3, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.successColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.trending_up, size: 14, color: AppTheme.successColor),
                const SizedBox(width: 4),
                Text(
                  job.$2,
                  style: const TextStyle(
                    color: AppTheme.successColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IndustryCard extends StatelessWidget {
  final int index;

  const _IndustryCard({required this.index});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final industries = [
      ('Technology', 0.85, '+18%', const Color(0xFF6366F1)),
      ('Healthcare', 0.72, '+12%', const Color(0xFF10B981)),
      ('Finance', 0.68, '+8%', const Color(0xFFF59E0B)),
      ('E-Commerce', 0.75, '+15%', const Color(0xFFEF4444)),
    ];
    final industry = industries[index % 4];

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
                industry.$1,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                industry.$3,
                style: TextStyle(
                  color: AppTheme.successColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: industry.$2,
              backgroundColor: AppTheme.dividerColor,
              valueColor: AlwaysStoppedAnimation(industry.$4),
              minHeight: 10,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${(industry.$2 * 100).toInt()}% growth potential',
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _SalariesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Salary Calculator CTA
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF11998E), Color(0xFF38EF7D)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.calculate_outlined, color: Colors.white, size: 32),
              const SizedBox(height: 12),
              const Text(
                'Salary Calculator',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Find out what you should be earning based on your skills and experience',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF11998E),
                ),
                child: const Text('Calculate My Worth'),
              ),
            ],
          ),
        ).animate().fadeIn().scale(begin: const Offset(0.95, 0.95)),
        
        const SizedBox(height: 24),
        
        // Salary by Role
        SectionHeader(
          title: 'Salary by Role',
          actionText: 'Filter',
          onActionPressed: () {},
        ).animate().fadeIn(delay: 200.ms),
        
        const SizedBox(height: 16),
        
        ...List.generate(6, (index) {
          return _SalaryRoleCard(index: index)
              .animate()
              .fadeIn(delay: Duration(milliseconds: 300 + 100 * index))
              .slideX(begin: 0.1, end: 0);
        }),
      ],
    );
  }
}

class _SalaryRoleCard extends StatelessWidget {
  final int index;

  const _SalaryRoleCard({required this.index});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final roles = [
      ('Software Engineer', '\$95K - \$150K', '\$120K', 'Entry - Senior'),
      ('Product Manager', '\$110K - \$180K', '\$145K', 'Entry - Director'),
      ('Data Scientist', '\$100K - \$170K', '\$135K', 'Entry - Lead'),
      ('DevOps Engineer', '\$105K - \$165K', '\$130K', 'Entry - Principal'),
      ('UX Designer', '\$80K - \$140K', '\$105K', 'Entry - Lead'),
      ('Engineering Manager', '\$150K - \$220K', '\$185K', 'Manager - VP'),
    ];
    final role = roles[index % 6];

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
                role.$1,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  role.$3,
                  style: const TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                role.$2,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                role.$4,
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Salary Range Visualization
          Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: AppTheme.dividerColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              FractionallySizedBox(
                widthFactor: 0.7 + (index * 0.05),
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CompaniesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Company Search
        TextField(
          decoration: InputDecoration(
            hintText: 'Search companies...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () {},
            ),
          ),
        ).animate().fadeIn(),
        
        const SizedBox(height: 24),
        
        // Top Hiring Companies
        SectionHeader(
          title: 'Top Hiring Companies',
          actionText: 'View All',
          onActionPressed: () {},
        ).animate().fadeIn(delay: 200.ms),
        
        const SizedBox(height: 16),
        
        ...List.generate(6, (index) {
          return _CompanyCard(index: index)
              .animate()
              .fadeIn(delay: Duration(milliseconds: 300 + 100 * index))
              .slideY(begin: 0.1, end: 0);
        }),
      ],
    );
  }
}

class _CompanyCard extends StatelessWidget {
  final int index;

  const _CompanyCard({required this.index});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final companies = [
      ('Google', '1,200+ openings', '4.5', const Color(0xFF4285F4)),
      ('Meta', '850+ openings', '4.2', const Color(0xFF1877F2)),
      ('Apple', '920+ openings', '4.4', const Color(0xFF555555)),
      ('Amazon', '2,100+ openings', '3.9', const Color(0xFFFF9900)),
      ('Microsoft', '1,500+ openings', '4.3', const Color(0xFF00A4EF)),
      ('Netflix', '280+ openings', '4.6', const Color(0xFFE50914)),
    ];
    final company = companies[index % 6];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        children: [
          // Company Header
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: company.$4.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      company.$1[0],
                      style: TextStyle(
                        color: company.$4,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
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
                        company.$1,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(company.$2, style: theme.textTheme.bodySmall),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star, color: Color(0xFFFFD700), size: 18),
                        const SizedBox(width: 4),
                        Text(
                          company.$3,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text('rating', style: theme.textTheme.labelSmall),
                  ],
                ),
              ],
            ),
          ),
          // Quick Stats
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.dividerColor.withOpacity(0.3),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(AppTheme.radiusLg),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _CompanyStat(label: 'Avg. Salary', value: '\$${140 + index * 10}K'),
                _CompanyStat(label: 'Interview', value: '${3 + index} rounds'),
                _CompanyStat(label: 'Time to Hire', value: '${4 + index} weeks'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CompanyStat extends StatelessWidget {
  final String label;
  final String value;

  const _CompanyStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: theme.textTheme.labelSmall),
      ],
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
        // Top Skills Overview
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
              const Text(
                '🎯 Most In-Demand Skills',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Based on 1M+ job postings',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _SkillTag('Python', true),
                  _SkillTag('JavaScript', true),
                  _SkillTag('AWS', true),
                  _SkillTag('React', false),
                  _SkillTag('Docker', false),
                  _SkillTag('Kubernetes', false),
                ],
              ),
            ],
          ),
        ).animate().fadeIn().scale(begin: const Offset(0.95, 0.95)),
        
        const SizedBox(height: 24),
        
        // Skill Categories
        SectionHeader(
          title: 'Skill Categories',
          actionText: 'View All',
          onActionPressed: () {},
        ).animate().fadeIn(delay: 200.ms),
        
        const SizedBox(height: 16),
        
        ...List.generate(4, (index) {
          return _SkillCategoryCard(index: index)
              .animate()
              .fadeIn(delay: Duration(milliseconds: 300 + 100 * index))
              .slideY(begin: 0.1, end: 0);
        }),
        
        const SizedBox(height: 24),
        
        // Emerging Skills
        SectionHeader(
          title: 'Emerging Skills',
          actionText: 'Learn More',
          onActionPressed: () {},
        ).animate().fadeIn(delay: 600.ms),
        
        const SizedBox(height: 16),
        
        SizedBox(
          height: 140,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return _EmergingSkillCard(index: index)
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

class _SkillTag extends StatelessWidget {
  final String label;
  final bool hasSkill;

  const _SkillTag(this.label, this.hasSkill);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: hasSkill
            ? Colors.white
            : Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasSkill) ...[
            const Icon(Icons.check, size: 14, color: Color(0xFF667EEA)),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: TextStyle(
              color: hasSkill ? const Color(0xFF667EEA) : Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _SkillCategoryCard extends StatelessWidget {
  final int index;

  const _SkillCategoryCard({required this.index});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categories = [
      ('Programming Languages', ['Python', 'JavaScript', 'Java', 'Go'], Icons.code, const Color(0xFF6366F1)),
      ('Cloud & DevOps', ['AWS', 'Docker', 'Kubernetes', 'Terraform'], Icons.cloud, const Color(0xFF10B981)),
      ('Data & ML', ['TensorFlow', 'PyTorch', 'SQL', 'Spark'], Icons.analytics, const Color(0xFFF59E0B)),
      ('Frontend', ['React', 'TypeScript', 'Vue', 'Next.js'], Icons.web, const Color(0xFFEF4444)),
    ];
    final category = categories[index % 4];

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
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: category.$4.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(category.$3, color: category.$4, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                category.$1,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: category.$2.map((skill) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: category.$4.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                skill,
                style: TextStyle(
                  color: category.$4,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }
}

class _EmergingSkillCard extends StatelessWidget {
  final int index;

  const _EmergingSkillCard({required this.index});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final skills = [
      ('AI/ML Ops', '+120%', '🤖'),
      ('Rust', '+85%', '🦀'),
      ('Web3/Blockchain', '+65%', '⛓️'),
      ('Prompt Engineering', '+200%', '💬'),
      ('Edge Computing', '+75%', '🌐'),
    ];
    final skill = skills[index % 5];

    return Container(
      width: 130,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(skill.$3, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 8),
          Text(
            skill.$1,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(
                Icons.trending_up,
                size: 12,
                color: AppTheme.successColor,
              ),
              const SizedBox(width: 4),
              Text(
                skill.$2,
                style: const TextStyle(
                  color: AppTheme.successColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
