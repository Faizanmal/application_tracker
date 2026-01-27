import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/application.dart';
import '../../data/services/offline_storage_service.dart';
import '../../data/services/sync_service.dart';

/// Application template model
class ApplicationTemplate {
  final String id;
  final String name;
  final String? description;
  final String? defaultCompany;
  final String? defaultJobTitle;
  final ApplicationStatus defaultStatus;
  final JobType? defaultJobType;
  final WorkLocationType? defaultWorkLocation;
  final List<String> defaultTags;
  final String? defaultNotes;
  final String category;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ApplicationTemplate({
    required this.id,
    required this.name,
    this.description,
    this.defaultCompany,
    this.defaultJobTitle,
    this.defaultStatus = ApplicationStatus.draft,
    this.defaultJobType,
    this.defaultWorkLocation,
    this.defaultTags = const [],
    this.defaultNotes,
    this.category = 'General',
    this.isDefault = false,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'default_company': defaultCompany,
        'default_job_title': defaultJobTitle,
        'default_status': defaultStatus.name,
        'default_job_type': defaultJobType?.name,
        'default_work_location': defaultWorkLocation?.name,
        'default_tags': defaultTags,
        'default_notes': defaultNotes,
        'category': category,
        'is_default': isDefault,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };

  factory ApplicationTemplate.fromJson(Map<String, dynamic> json) {
    return ApplicationTemplate(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      defaultCompany: json['default_company'],
      defaultJobTitle: json['default_job_title'],
      defaultStatus: ApplicationStatus.values.firstWhere(
        (e) => e.name == json['default_status'],
        orElse: () => ApplicationStatus.draft,
      ),
      defaultJobType: json['default_job_type'] != null
          ? JobType.values.firstWhere(
              (e) => e.name == json['default_job_type'],
              orElse: () => JobType.fullTime,
            )
          : null,
      defaultWorkLocation: json['default_work_location'] != null
          ? WorkLocationType.values.firstWhere(
              (e) => e.name == json['default_work_location'],
              orElse: () => WorkLocationType.onsite,
            )
          : null,
      defaultTags: (json['default_tags'] as List?)?.cast<String>() ?? [],
      defaultNotes: json['default_notes'],
      category: json['category'] ?? 'General',
      isDefault: json['is_default'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Application toApplication(String applicationId) {
    return Application(
      id: applicationId,
      companyName: defaultCompany ?? '',
      jobTitle: defaultJobTitle ?? '',
      status: defaultStatus,
      jobType: defaultJobType,
      workLocationType: defaultWorkLocation,
      tags: defaultTags,
      notes: defaultNotes,
    );
  }
}

/// Cover letter template model
class CoverLetterTemplate {
  final String id;
  final String name;
  final String content;
  final String? description;
  final String category;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CoverLetterTemplate({
    required this.id,
    required this.name,
    required this.content,
    this.description,
    this.category = 'General',
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'content': content,
        'description': description,
        'category': category,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };

  factory CoverLetterTemplate.fromJson(Map<String, dynamic> json) {
    return CoverLetterTemplate(
      id: json['id'],
      name: json['name'],
      content: json['content'],
      description: json['description'],
      category: json['category'] ?? 'General',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  /// Render template with placeholders replaced
  String render(Map<String, String> variables) {
    String rendered = content;
    for (final entry in variables.entries) {
      rendered = rendered.replaceAll('{{${entry.key}}}', entry.value);
    }
    return rendered;
  }
}

/// Templates provider
final templatesProvider = FutureProvider<List<ApplicationTemplate>>((ref) async {
  // In a real app, this would fetch from API/local storage
  return [
    ApplicationTemplate(
      id: '1',
      name: 'Tech Startup',
      description: 'For fast-paced startup roles',
      defaultStatus: ApplicationStatus.draft,
      defaultJobType: JobType.fullTime,
      defaultWorkLocation: WorkLocationType.remote,
      defaultTags: ['startup', 'tech'],
      category: 'Technology',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    ApplicationTemplate(
      id: '2',
      name: 'Enterprise',
      description: 'For large corporate positions',
      defaultStatus: ApplicationStatus.draft,
      defaultJobType: JobType.fullTime,
      defaultWorkLocation: WorkLocationType.hybrid,
      defaultTags: ['enterprise', 'corporate'],
      category: 'Corporate',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    ApplicationTemplate(
      id: '3',
      name: 'Contract Work',
      description: 'For freelance and contract roles',
      defaultStatus: ApplicationStatus.draft,
      defaultJobType: JobType.contract,
      defaultWorkLocation: WorkLocationType.remote,
      defaultTags: ['contract', 'freelance'],
      category: 'Freelance',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];
});

/// Cover letter templates provider
final coverLetterTemplatesProvider =
    FutureProvider<List<CoverLetterTemplate>>((ref) async {
  return [
    CoverLetterTemplate(
      id: '1',
      name: 'Standard Introduction',
      content: '''Dear Hiring Manager,

I am writing to express my interest in the {{position}} position at {{company}}. With my background in {{field}}, I am confident in my ability to contribute to your team.

{{body}}

Thank you for considering my application. I look forward to the opportunity to discuss how I can contribute to {{company}}'s success.

Best regards,
{{name}}''',
      category: 'General',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    CoverLetterTemplate(
      id: '2',
      name: 'Tech Position',
      content: '''Dear {{hiring_manager}},

I am excited to apply for the {{position}} role at {{company}}. As a passionate developer with {{years}} years of experience, I am eager to bring my expertise in {{skills}} to your innovative team.

{{body}}

I am particularly drawn to {{company}}'s commitment to {{company_value}}. I would welcome the opportunity to discuss how my skills align with your needs.

Best regards,
{{name}}''',
      category: 'Technology',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];
});

/// Template selection sheet
class TemplateSelectionSheet extends ConsumerWidget {
  final void Function(ApplicationTemplate) onTemplateSelected;

  const TemplateSelectionSheet({
    super.key,
    required this.onTemplateSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final templatesAsync = ref.watch(templatesProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                'Choose Template',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          templatesAsync.when(
            data: (templates) {
              final groupedTemplates = <String, List<ApplicationTemplate>>{};
              for (final template in templates) {
                groupedTemplates
                    .putIfAbsent(template.category, () => [])
                    .add(template);
              }

              return Expanded(
                child: ListView.builder(
                  itemCount: groupedTemplates.length,
                  itemBuilder: (context, index) {
                    final category = groupedTemplates.keys.elementAt(index);
                    final categoryTemplates = groupedTemplates[category]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            category,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                        ),
                        ...categoryTemplates.map((template) => Card(
                              child: ListTile(
                                leading: const Icon(Icons.description),
                                title: Text(template.name),
                                subtitle: template.description != null
                                    ? Text(
                                        template.description!,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      )
                                    : null,
                                trailing: Wrap(
                                  spacing: 4,
                                  children: template.defaultTags
                                      .take(2)
                                      .map((tag) => Chip(
                                            label: Text(
                                              tag,
                                              style: const TextStyle(fontSize: 10),
                                            ),
                                            padding: EdgeInsets.zero,
                                            visualDensity: VisualDensity.compact,
                                          ))
                                      .toList(),
                                ),
                                onTap: () {
                                  onTemplateSelected(template);
                                  Navigator.pop(context);
                                },
                              ),
                            )),
                        const SizedBox(height: 8),
                      ],
                    );
                  },
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
          ),
        ],
      ),
    );
  }
}

/// Cover letter template editor
class CoverLetterEditor extends StatefulWidget {
  final CoverLetterTemplate? template;
  final Map<String, String> initialVariables;
  final void Function(String content)? onContentChanged;

  const CoverLetterEditor({
    super.key,
    this.template,
    this.initialVariables = const {},
    this.onContentChanged,
  });

  @override
  State<CoverLetterEditor> createState() => _CoverLetterEditorState();
}

class _CoverLetterEditorState extends State<CoverLetterEditor> {
  late TextEditingController _contentController;
  late Map<String, TextEditingController> _variableControllers;
  List<String> _placeholders = [];

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(
      text: widget.template?.content ?? '',
    );
    _extractPlaceholders();
    _initVariableControllers();
  }

  void _extractPlaceholders() {
    final regex = RegExp(r'\{\{(\w+)\}\}');
    final matches = regex.allMatches(_contentController.text);
    _placeholders = matches.map((m) => m.group(1)!).toSet().toList();
  }

  void _initVariableControllers() {
    _variableControllers = {};
    for (final placeholder in _placeholders) {
      _variableControllers[placeholder] = TextEditingController(
        text: widget.initialVariables[placeholder] ?? '',
      );
    }
  }

  String _getRenderedContent() {
    String content = _contentController.text;
    for (final entry in _variableControllers.entries) {
      content = content.replaceAll('{{${entry.key}}}', entry.value.text);
    }
    return content;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            tabs: const [
              Tab(text: 'Edit'),
              Tab(text: 'Preview'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                // Edit Tab
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_placeholders.isNotEmpty) ...[
                        Text(
                          'Fill in the placeholders:',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 8),
                        ..._placeholders.map((placeholder) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: TextField(
                                controller: _variableControllers[placeholder],
                                decoration: InputDecoration(
                                  labelText: _formatPlaceholder(placeholder),
                                  hintText: 'Enter ${_formatPlaceholder(placeholder).toLowerCase()}',
                                ),
                                onChanged: (_) {
                                  widget.onContentChanged?.call(_getRenderedContent());
                                  setState(() {});
                                },
                              ),
                            )),
                        const Divider(height: 32),
                      ],
                      Text(
                        'Content:',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _contentController,
                        maxLines: 15,
                        decoration: const InputDecoration(
                          hintText: 'Enter your cover letter content...\nUse {{placeholder}} for variables',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          _extractPlaceholders();
                          _initVariableControllers();
                          widget.onContentChanged?.call(_getRenderedContent());
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
                // Preview Tab
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: SelectableText(
                      _getRenderedContent(),
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.6,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatPlaceholder(String placeholder) {
    return placeholder
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) =>
            word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1)}' : '')
        .join(' ');
  }

  @override
  void dispose() {
    _contentController.dispose();
    for (final controller in _variableControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}

/// Template manager screen
class TemplateManagerScreen extends ConsumerWidget {
  const TemplateManagerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Templates'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Application'),
              Tab(text: 'Cover Letter'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _ApplicationTemplatesTab(),
            _CoverLetterTemplatesTab(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Create new template
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class _ApplicationTemplatesTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final templatesAsync = ref.watch(templatesProvider);

    return templatesAsync.when(
      data: (templates) => ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: templates.length,
        itemBuilder: (context, index) {
          final template = templates[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                child: Text(template.name[0]),
              ),
              title: Text(template.name),
              subtitle: Text(template.description ?? template.category),
              trailing: PopupMenuButton(
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Text('Edit'),
                  ),
                  const PopupMenuItem(
                    value: 'duplicate',
                    child: Text('Duplicate'),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete'),
                  ),
                ],
              ),
              onTap: () {
                // Open template editor
              },
            ),
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}

class _CoverLetterTemplatesTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final templatesAsync = ref.watch(coverLetterTemplatesProvider);

    return templatesAsync.when(
      data: (templates) => ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: templates.length,
        itemBuilder: (context, index) {
          final template = templates[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const Icon(Icons.article),
              title: Text(template.name),
              subtitle: Text(template.category),
              trailing: PopupMenuButton(
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Text('Edit'),
                  ),
                  const PopupMenuItem(
                    value: 'duplicate',
                    child: Text('Duplicate'),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete'),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Scaffold(
                      appBar: AppBar(
                        title: Text(template.name),
                        actions: [
                          IconButton(
                            icon: const Icon(Icons.copy),
                            onPressed: () {
                              // Copy to clipboard
                            },
                          ),
                        ],
                      ),
                      body: CoverLetterEditor(template: template),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}
