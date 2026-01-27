import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/accessibility_widgets.dart';

/// Accessibility settings screen
class AccessibilityScreen extends ConsumerWidget {
  const AccessibilityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accessibility'),
        actions: [
          IconButton(
            icon: const Icon(Icons.keyboard),
            tooltip: 'Keyboard Shortcuts',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const KeyboardShortcutsDialog(),
              );
            },
          ),
        ],
      ),
      body: const AccessibilitySettingsPanel(),
    );
  }
}
