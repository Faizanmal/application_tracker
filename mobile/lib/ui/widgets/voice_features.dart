import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Speech to text provider
final speechToTextProvider = Provider<SpeechToText>((ref) {
  return SpeechToText();
});

/// Text to speech provider
final flutterTtsProvider = Provider<FlutterTts>((ref) {
  final tts = FlutterTts();
  tts.setLanguage('en-US');
  tts.setSpeechRate(0.5);
  tts.setVolume(1.0);
  tts.setPitch(1.0);
  return tts;
});

/// Speech recognition state
class SpeechRecognitionState {
  final bool isListening;
  final bool isAvailable;
  final String currentText;
  final String error;

  const SpeechRecognitionState({
    this.isListening = false,
    this.isAvailable = false,
    this.currentText = '',
    this.error = '',
  });

  SpeechRecognitionState copyWith({
    bool? isListening,
    bool? isAvailable,
    String? currentText,
    String? error,
  }) {
    return SpeechRecognitionState(
      isListening: isListening ?? this.isListening,
      isAvailable: isAvailable ?? this.isAvailable,
      currentText: currentText ?? this.currentText,
      error: error ?? this.error,
    );
  }
}

/// Speech recognition notifier
class SpeechRecognitionNotifier extends StateNotifier<SpeechRecognitionState> {
  final SpeechToText _speech;

  SpeechRecognitionNotifier(this._speech) : super(const SpeechRecognitionState()) {
    _initialize();
  }

  Future<void> _initialize() async {
    final available = await _speech.initialize(
      onStatus: _onStatus,
      onError: _onError,
    );
    state = state.copyWith(isAvailable: available);
  }

  void _onStatus(String status) {
    if (status == 'done' || status == 'notListening') {
      state = state.copyWith(isListening: false);
    }
  }

  void _onError(dynamic error) {
    state = state.copyWith(
      isListening: false,
      error: error.toString(),
    );
  }

  Future<void> startListening({
    void Function(String)? onResult,
    String? localeId,
  }) async {
    if (!state.isAvailable) return;

    state = state.copyWith(isListening: true, currentText: '', error: '');

    await _speech.listen(
      onResult: (result) {
        state = state.copyWith(currentText: result.recognizedWords);
        if (result.finalResult) {
          onResult?.call(result.recognizedWords);
        }
      },
      localeId: localeId ?? 'en_US',
      listenMode: ListenMode.dictation,
      cancelOnError: true,
      partialResults: true,
    );
  }

  Future<void> stopListening() async {
    await _speech.stop();
    state = state.copyWith(isListening: false);
  }

  Future<void> cancelListening() async {
    await _speech.cancel();
    state = state.copyWith(isListening: false, currentText: '');
  }
}

/// Speech recognition provider
final speechRecognitionProvider =
    StateNotifierProvider<SpeechRecognitionNotifier, SpeechRecognitionState>((ref) {
  return SpeechRecognitionNotifier(ref.read(speechToTextProvider));
});

/// Voice input field widget
class VoiceInputField extends ConsumerStatefulWidget {
  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final int? maxLines;
  final InputDecoration? decoration;
  final void Function(String)? onChanged;
  final void Function(String)? onVoiceResult;

  const VoiceInputField({
    super.key,
    required this.controller,
    this.labelText,
    this.hintText,
    this.maxLines = 1,
    this.decoration,
    this.onChanged,
    this.onVoiceResult,
  });

  @override
  ConsumerState<VoiceInputField> createState() => _VoiceInputFieldState();
}

class _VoiceInputFieldState extends ConsumerState<VoiceInputField> {
  @override
  Widget build(BuildContext context) {
    final speechState = ref.watch(speechRecognitionProvider);

    return TextField(
      controller: widget.controller,
      maxLines: widget.maxLines,
      onChanged: widget.onChanged,
      decoration: (widget.decoration ?? InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
      )).copyWith(
        suffixIcon: speechState.isAvailable
            ? IconButton(
                icon: Icon(
                  speechState.isListening ? Icons.mic : Icons.mic_none,
                  color: speechState.isListening
                      ? Theme.of(context).colorScheme.primary
                      : null,
                ),
                onPressed: () async {
                  if (speechState.isListening) {
                    await ref.read(speechRecognitionProvider.notifier).stopListening();
                  } else {
                    await ref.read(speechRecognitionProvider.notifier).startListening(
                      onResult: (text) {
                        widget.controller.text = widget.controller.text + text;
                        widget.onVoiceResult?.call(text);
                      },
                    );
                  }
                },
              )
            : null,
        helperText: speechState.isListening ? 'Listening...' : null,
        errorText: speechState.error.isNotEmpty ? speechState.error : null,
      ),
    );
  }
}

/// Voice command handler
class VoiceCommandHandler {
  final List<VoiceCommand> commands;
  final void Function(String action, Map<String, dynamic>? params)? onCommand;

  VoiceCommandHandler({
    required this.commands,
    this.onCommand,
  });

  String? processCommand(String text) {
    final normalizedText = text.toLowerCase().trim();

    for (final command in commands) {
      for (final pattern in command.patterns) {
        if (normalizedText.contains(pattern.toLowerCase())) {
          // Extract any parameters from the text
          final params = command.extractParams?.call(normalizedText);
          onCommand?.call(command.action, params);
          return command.action;
        }
      }
    }

    return null;
  }
}

/// Voice command definition
class VoiceCommand {
  final String action;
  final List<String> patterns;
  final String description;
  final Map<String, dynamic>? Function(String text)? extractParams;

  const VoiceCommand({
    required this.action,
    required this.patterns,
    required this.description,
    this.extractParams,
  });
}

/// Application-specific voice commands
class ApplicationVoiceCommands {
  static final List<VoiceCommand> commands = [
    VoiceCommand(
      action: 'new_application',
      patterns: ['new application', 'add application', 'create application'],
      description: 'Create a new job application',
    ),
    VoiceCommand(
      action: 'search',
      patterns: ['search for', 'find', 'look for'],
      description: 'Search applications',
      extractParams: (text) {
        final match = RegExp(r'(?:search for|find|look for)\s+(.+)').firstMatch(text);
        return match != null ? {'query': match.group(1)} : null;
      },
    ),
    VoiceCommand(
      action: 'show_interviews',
      patterns: ['show interviews', 'my interviews', 'upcoming interviews'],
      description: 'View interviews',
    ),
    VoiceCommand(
      action: 'show_analytics',
      patterns: ['show analytics', 'statistics', 'stats', 'dashboard'],
      description: 'View analytics',
    ),
    VoiceCommand(
      action: 'set_status',
      patterns: ['set status', 'change status', 'mark as'],
      description: 'Change application status',
      extractParams: (text) {
        final statuses = [
          'draft', 'applied', 'screening', 'interviewing',
          'offered', 'accepted', 'rejected', 'withdrawn'
        ];
        for (final status in statuses) {
          if (text.contains(status)) {
            return {'status': status};
          }
        }
        return null;
      },
    ),
    VoiceCommand(
      action: 'add_note',
      patterns: ['add note', 'new note', 'take note'],
      description: 'Add a note',
    ),
    VoiceCommand(
      action: 'go_back',
      patterns: ['go back', 'back', 'previous'],
      description: 'Navigate back',
    ),
    VoiceCommand(
      action: 'show_help',
      patterns: ['help', 'show commands', 'what can you do'],
      description: 'Show available commands',
    ),
  ];
}

/// Voice command button widget
class VoiceCommandButton extends ConsumerWidget {
  final void Function(String action, Map<String, dynamic>? params)? onCommand;

  const VoiceCommandButton({
    super.key,
    this.onCommand,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final speechState = ref.watch(speechRecognitionProvider);

    if (!speechState.isAvailable) {
      return const SizedBox.shrink();
    }

    return FloatingActionButton.small(
      heroTag: 'voice_command',
      onPressed: () => _showVoiceDialog(context, ref),
      backgroundColor: speechState.isListening
          ? Theme.of(context).colorScheme.primary
          : null,
      child: Icon(
        speechState.isListening ? Icons.mic : Icons.mic_none,
        color: speechState.isListening ? Colors.white : null,
      ),
    );
  }

  void _showVoiceDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => VoiceCommandDialog(
        onCommand: onCommand,
      ),
    );
  }
}

/// Voice command dialog
class VoiceCommandDialog extends ConsumerStatefulWidget {
  final void Function(String action, Map<String, dynamic>? params)? onCommand;

  const VoiceCommandDialog({
    super.key,
    this.onCommand,
  });

  @override
  ConsumerState<VoiceCommandDialog> createState() => _VoiceCommandDialogState();
}

class _VoiceCommandDialogState extends ConsumerState<VoiceCommandDialog> {
  late VoiceCommandHandler _commandHandler;
  String? _lastCommand;
  String _transcript = '';

  @override
  void initState() {
    super.initState();
    _commandHandler = VoiceCommandHandler(
      commands: ApplicationVoiceCommands.commands,
      onCommand: (action, params) {
        setState(() => _lastCommand = action);
        widget.onCommand?.call(action, params);
        // Auto-close after successful command
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) Navigator.of(context).pop();
        });
      },
    );
    _startListening();
  }

  Future<void> _startListening() async {
    await ref.read(speechRecognitionProvider.notifier).startListening(
      onResult: (text) {
        setState(() => _transcript = text);
        _commandHandler.processCommand(text);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final speechState = ref.watch(speechRecognitionProvider);

    return AlertDialog(
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: speechState.isListening
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
              shape: BoxShape.circle,
            ),
            child: Icon(
              speechState.isListening ? Icons.mic : Icons.mic_off,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Text(speechState.isListening ? 'Listening...' : 'Voice Command'),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_transcript.isNotEmpty || speechState.currentText.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _transcript.isNotEmpty ? _transcript : speechState.currentText,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            if (_lastCommand != null) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green),
                    const SizedBox(width: 8),
                    Text(
                      'Command: $_lastCommand',
                      style: const TextStyle(color: Colors.green),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            Text(
              'Available Commands:',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: ApplicationVoiceCommands.commands.length,
                itemBuilder: (context, index) {
                  final command = ApplicationVoiceCommands.commands[index];
                  return ListTile(
                    dense: true,
                    title: Text(command.description),
                    subtitle: Text(
                      '"${command.patterns.first}"',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            ref.read(speechRecognitionProvider.notifier).cancelListening();
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        if (!speechState.isListening)
          FilledButton(
            onPressed: _startListening,
            child: const Text('Try Again'),
          ),
      ],
    );
  }

  @override
  void dispose() {
    ref.read(speechRecognitionProvider.notifier).stopListening();
    super.dispose();
  }
}

/// Text to speech reader widget
class TextToSpeechReader extends ConsumerWidget {
  final String text;
  final Widget child;

  const TextToSpeechReader({
    super.key,
    required this.text,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(child: child),
        IconButton(
          icon: const Icon(Icons.volume_up),
          onPressed: () async {
            final tts = ref.read(flutterTtsProvider);
            await tts.speak(text);
          },
          tooltip: 'Read aloud',
        ),
      ],
    );
  }
}
