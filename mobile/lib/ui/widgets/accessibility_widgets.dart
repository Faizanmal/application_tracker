import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Accessibility settings state
class AccessibilityState {
  final bool highContrast;
  final bool reduceMotion;
  final double textScale;
  final bool screenReaderEnabled;
  final bool boldText;
  final bool largeText;

  const AccessibilityState({
    this.highContrast = false,
    this.reduceMotion = false,
    this.textScale = 1.0,
    this.screenReaderEnabled = false,
    this.boldText = false,
    this.largeText = false,
  });

  AccessibilityState copyWith({
    bool? highContrast,
    bool? reduceMotion,
    double? textScale,
    bool? screenReaderEnabled,
    bool? boldText,
    bool? largeText,
  }) {
    return AccessibilityState(
      highContrast: highContrast ?? this.highContrast,
      reduceMotion: reduceMotion ?? this.reduceMotion,
      textScale: textScale ?? this.textScale,
      screenReaderEnabled: screenReaderEnabled ?? this.screenReaderEnabled,
      boldText: boldText ?? this.boldText,
      largeText: largeText ?? this.largeText,
    );
  }
}

/// Accessibility settings notifier
class AccessibilityNotifier extends StateNotifier<AccessibilityState> {
  AccessibilityNotifier() : super(const AccessibilityState());

  void setHighContrast(bool value) {
    state = state.copyWith(highContrast: value);
  }

  void setReduceMotion(bool value) {
    state = state.copyWith(reduceMotion: value);
  }

  void setTextScale(double value) {
    state = state.copyWith(textScale: value.clamp(0.8, 2.0));
  }

  void setBoldText(bool value) {
    state = state.copyWith(boldText: value);
  }

  void setLargeText(bool value) {
    state = state.copyWith(largeText: value);
  }

  void reset() {
    state = const AccessibilityState();
  }
}

/// Accessibility provider
final accessibilityProvider =
    StateNotifierProvider<AccessibilityNotifier, AccessibilityState>((ref) {
  return AccessibilityNotifier();
});

/// Keyboard shortcut definition
class KeyboardShortcut {
  final String label;
  final String description;
  final LogicalKeySet keys;
  final VoidCallback? action;

  const KeyboardShortcut({
    required this.label,
    required this.description,
    required this.keys,
    this.action,
  });
}

/// Keyboard shortcuts service
class KeyboardShortcutsService {
  static final List<KeyboardShortcut> shortcuts = [
    KeyboardShortcut(
      label: 'New Application',
      description: 'Create a new job application',
      keys: LogicalKeySet(
        LogicalKeyboardKey.control,
        LogicalKeyboardKey.keyN,
      ),
    ),
    KeyboardShortcut(
      label: 'Search',
      description: 'Open search',
      keys: LogicalKeySet(
        LogicalKeyboardKey.control,
        LogicalKeyboardKey.keyK,
      ),
    ),
    KeyboardShortcut(
      label: 'Save',
      description: 'Save current form',
      keys: LogicalKeySet(
        LogicalKeyboardKey.control,
        LogicalKeyboardKey.keyS,
      ),
    ),
    KeyboardShortcut(
      label: 'Go Home',
      description: 'Navigate to home',
      keys: LogicalKeySet(
        LogicalKeyboardKey.control,
        LogicalKeyboardKey.keyH,
      ),
    ),
    KeyboardShortcut(
      label: 'Applications',
      description: 'View applications',
      keys: LogicalKeySet(
        LogicalKeyboardKey.control,
        LogicalKeyboardKey.digit1,
      ),
    ),
    KeyboardShortcut(
      label: 'Interviews',
      description: 'View interviews',
      keys: LogicalKeySet(
        LogicalKeyboardKey.control,
        LogicalKeyboardKey.digit2,
      ),
    ),
    KeyboardShortcut(
      label: 'Analytics',
      description: 'View analytics',
      keys: LogicalKeySet(
        LogicalKeyboardKey.control,
        LogicalKeyboardKey.digit3,
      ),
    ),
    KeyboardShortcut(
      label: 'Settings',
      description: 'Open settings',
      keys: LogicalKeySet(
        LogicalKeyboardKey.control,
        LogicalKeyboardKey.comma,
      ),
    ),
    KeyboardShortcut(
      label: 'Shortcuts Help',
      description: 'Show keyboard shortcuts',
      keys: LogicalKeySet(
        LogicalKeyboardKey.shift,
        LogicalKeyboardKey.slash,
      ),
    ),
  ];
}

/// Keyboard shortcuts help dialog
class KeyboardShortcutsDialog extends StatelessWidget {
  const KeyboardShortcutsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.keyboard),
          const SizedBox(width: 12),
          const Text('Keyboard Shortcuts'),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: KeyboardShortcutsService.shortcuts.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final shortcut = KeyboardShortcutsService.shortcuts[index];
            return ListTile(
              title: Text(shortcut.label),
              subtitle: Text(shortcut.description),
              trailing: _KeyboardShortcutChip(keys: shortcut.keys),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}

class _KeyboardShortcutChip extends StatelessWidget {
  final LogicalKeySet keys;

  const _KeyboardShortcutChip({required this.keys});

  @override
  Widget build(BuildContext context) {
    final keyLabels = keys.keys.map(_getKeyLabel).toList();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: keyLabels
          .map((label) => Container(
                margin: const EdgeInsets.only(left: 4),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ))
          .toList(),
    );
  }

  String _getKeyLabel(LogicalKeyboardKey key) {
    if (key == LogicalKeyboardKey.control) return 'Ctrl';
    if (key == LogicalKeyboardKey.shift) return 'Shift';
    if (key == LogicalKeyboardKey.alt) return 'Alt';
    if (key == LogicalKeyboardKey.meta) return '⌘';
    if (key == LogicalKeyboardKey.comma) return ',';
    if (key == LogicalKeyboardKey.slash) return '?';
    if (key.keyLabel.startsWith('Digit')) {
      return key.keyLabel.replaceFirst('Digit ', '');
    }
    return key.keyLabel.replaceFirst('Key ', '');
  }
}

/// Accessibility settings panel
class AccessibilitySettingsPanel extends ConsumerWidget {
  const AccessibilitySettingsPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(accessibilityProvider);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Accessibility',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 24),

        // Visual Settings
        Text(
          'Visual',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        
        SwitchListTile(
          title: const Text('High Contrast'),
          subtitle: const Text('Increase contrast for better visibility'),
          value: settings.highContrast,
          onChanged: (value) {
            ref.read(accessibilityProvider.notifier).setHighContrast(value);
          },
        ),
        
        SwitchListTile(
          title: const Text('Bold Text'),
          subtitle: const Text('Make text bolder throughout the app'),
          value: settings.boldText,
          onChanged: (value) {
            ref.read(accessibilityProvider.notifier).setBoldText(value);
          },
        ),
        
        SwitchListTile(
          title: const Text('Large Text'),
          subtitle: const Text('Increase text size throughout the app'),
          value: settings.largeText,
          onChanged: (value) {
            ref.read(accessibilityProvider.notifier).setLargeText(value);
          },
        ),

        ListTile(
          title: const Text('Text Scale'),
          subtitle: Slider(
            value: settings.textScale,
            min: 0.8,
            max: 2.0,
            divisions: 12,
            label: '${(settings.textScale * 100).round()}%',
            onChanged: (value) {
              ref.read(accessibilityProvider.notifier).setTextScale(value);
            },
          ),
          trailing: Text('${(settings.textScale * 100).round()}%'),
        ),

        const Divider(height: 32),

        // Motion Settings
        Text(
          'Motion',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        
        SwitchListTile(
          title: const Text('Reduce Motion'),
          subtitle: const Text('Minimize animations and transitions'),
          value: settings.reduceMotion,
          onChanged: (value) {
            ref.read(accessibilityProvider.notifier).setReduceMotion(value);
          },
        ),

        const Divider(height: 32),

        // Keyboard Navigation
        Text(
          'Keyboard',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        
        ListTile(
          leading: const Icon(Icons.keyboard),
          title: const Text('Keyboard Shortcuts'),
          subtitle: const Text('View all available shortcuts'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => const KeyboardShortcutsDialog(),
            );
          },
        ),

        const Divider(height: 32),

        // Reset
        Center(
          child: OutlinedButton(
            onPressed: () {
              ref.read(accessibilityProvider.notifier).reset();
            },
            child: const Text('Reset to Defaults'),
          ),
        ),
      ],
    );
  }
}

/// Focus-aware widget wrapper
class FocusableWidget extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final String? semanticLabel;
  final bool autofocus;

  const FocusableWidget({
    super.key,
    required this.child,
    this.onTap,
    this.semanticLabel,
    this.autofocus = false,
  });

  @override
  State<FocusableWidget> createState() => _FocusableWidgetState();
}

class _FocusableWidgetState extends State<FocusableWidget> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.semanticLabel,
      button: widget.onTap != null,
      child: Focus(
        autofocus: widget.autofocus,
        onFocusChange: (focused) {
          setState(() => _isFocused = focused);
        },
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: _isFocused
                  ? Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    )
                  : null,
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

/// Skip to content widget for screen readers
class SkipToContentButton extends StatelessWidget {
  final VoidCallback onSkip;

  const SkipToContentButton({
    super.key,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Skip to main content',
      button: true,
      child: Focus(
        child: Builder(
          builder: (context) {
            final focusNode = Focus.of(context);
            if (!focusNode.hasFocus) {
              return const SizedBox.shrink();
            }
            return Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Theme.of(context).colorScheme.primary,
                padding: const EdgeInsets.all(16),
                child: TextButton(
                  onPressed: onSkip,
                  child: const Text(
                    'Skip to main content',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Accessible list navigation
class AccessibleListView extends StatefulWidget {
  final int itemCount;
  final Widget Function(BuildContext, int, bool) itemBuilder;
  final void Function(int)? onItemSelected;

  const AccessibleListView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.onItemSelected,
  });

  @override
  State<AccessibleListView> createState() => _AccessibleListViewState();
}

class _AccessibleListViewState extends State<AccessibleListView> {
  int _focusedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      child: KeyboardListener(
        focusNode: FocusNode(),
        onKeyEvent: _handleKeyEvent,
        child: ListView.builder(
          itemCount: widget.itemCount,
          itemBuilder: (context, index) {
            return Focus(
              onFocusChange: (focused) {
                if (focused) {
                  setState(() => _focusedIndex = index);
                }
              },
              child: widget.itemBuilder(context, index, _focusedIndex == index),
            );
          },
        ),
      ),
    );
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return;

    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      if (_focusedIndex < widget.itemCount - 1) {
        setState(() => _focusedIndex++);
      }
    } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      if (_focusedIndex > 0) {
        setState(() => _focusedIndex--);
      }
    } else if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.space) {
      if (_focusedIndex >= 0) {
        widget.onItemSelected?.call(_focusedIndex);
      }
    }
  }
}

/// Live region for screen reader announcements
class LiveRegion extends StatelessWidget {
  final String message;
  final bool assertive;

  const LiveRegion({
    super.key,
    required this.message,
    this.assertive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: ExcludeSemantics(
        child: Container(
          width: 1,
          height: 1,
          child: Text(message),
        ),
      ),
    );
  }

  static void announce(BuildContext context, String message) {
    SemanticsService.announce(message, TextDirection.ltr);
  }
}
