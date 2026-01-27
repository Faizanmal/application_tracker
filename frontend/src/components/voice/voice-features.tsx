'use client';

import { useEffect, useState, useCallback, useRef } from 'react';
import {
  Mic,
  MicOff,
  Volume2,
  VolumeX,
  Play,
  Pause,
  Square,
  Loader2,
  Waveform,
  Settings,
} from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Textarea } from '@/components/ui/textarea';
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from '@/components/ui/dialog';
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select';
import { Badge } from '@/components/ui/badge';
import { Slider } from '@/components/ui/slider';
import { toast } from 'sonner';
import { cn } from '@/lib/utils';

// Types
interface SpeechRecognitionEvent extends Event {
  results: SpeechRecognitionResultList;
  resultIndex: number;
}

interface SpeechRecognitionResultList {
  length: number;
  item(index: number): SpeechRecognitionResult;
  [index: number]: SpeechRecognitionResult;
}

interface SpeechRecognitionResult {
  isFinal: boolean;
  length: number;
  item(index: number): SpeechRecognitionAlternative;
  [index: number]: SpeechRecognitionAlternative;
}

interface SpeechRecognitionAlternative {
  transcript: string;
  confidence: number;
}

interface VoiceCommand {
  patterns: string[];
  action: string;
  description: string;
  handler?: () => void;
}

// Voice Recognition Hook
export function useVoiceRecognition(options?: {
  continuous?: boolean;
  interimResults?: boolean;
  lang?: string;
  onResult?: (transcript: string, isFinal: boolean) => void;
  onCommand?: (command: string) => void;
}) {
  const [isListening, setIsListening] = useState(false);
  const [isSupported, setIsSupported] = useState(false);
  const [transcript, setTranscript] = useState('');
  const [interimTranscript, setInterimTranscript] = useState('');
  const [error, setError] = useState<string | null>(null);
  
  const recognitionRef = useRef<any>(null);

  useEffect(() => {
    if (typeof window !== 'undefined') {
      const SpeechRecognition = 
        (window as any).SpeechRecognition || (window as any).webkitSpeechRecognition;
      
      if (SpeechRecognition) {
        setIsSupported(true);
        recognitionRef.current = new SpeechRecognition();
        recognitionRef.current.continuous = options?.continuous ?? false;
        recognitionRef.current.interimResults = options?.interimResults ?? true;
        recognitionRef.current.lang = options?.lang ?? 'en-US';

        recognitionRef.current.onresult = (event: SpeechRecognitionEvent) => {
          let finalTranscript = '';
          let interim = '';

          for (let i = event.resultIndex; i < event.results.length; i++) {
            const result = event.results[i];
            if (result.isFinal) {
              finalTranscript += result[0].transcript;
            } else {
              interim += result[0].transcript;
            }
          }

          if (finalTranscript) {
            setTranscript((prev) => prev + finalTranscript);
            options?.onResult?.(finalTranscript, true);
            
            // Check for voice commands
            const normalizedCommand = finalTranscript.toLowerCase().trim();
            options?.onCommand?.(normalizedCommand);
          }
          
          setInterimTranscript(interim);
          if (interim) {
            options?.onResult?.(interim, false);
          }
        };

        recognitionRef.current.onerror = (event: any) => {
          setError(event.error);
          setIsListening(false);
        };

        recognitionRef.current.onend = () => {
          setIsListening(false);
        };
      }
    }

    return () => {
      if (recognitionRef.current) {
        recognitionRef.current.abort();
      }
    };
  }, [options?.continuous, options?.interimResults, options?.lang]);

  const startListening = useCallback(() => {
    if (!recognitionRef.current) return;
    
    setError(null);
    setTranscript('');
    setInterimTranscript('');
    
    try {
      recognitionRef.current.start();
      setIsListening(true);
    } catch (err) {
      console.error('Speech recognition start error:', err);
    }
  }, []);

  const stopListening = useCallback(() => {
    if (!recognitionRef.current) return;
    
    recognitionRef.current.stop();
    setIsListening(false);
  }, []);

  const toggleListening = useCallback(() => {
    if (isListening) {
      stopListening();
    } else {
      startListening();
    }
  }, [isListening, startListening, stopListening]);

  return {
    isListening,
    isSupported,
    transcript,
    interimTranscript,
    error,
    startListening,
    stopListening,
    toggleListening,
    resetTranscript: () => setTranscript(''),
  };
}

// Text-to-Speech Hook
export function useTextToSpeech(options?: {
  rate?: number;
  pitch?: number;
  volume?: number;
  voice?: SpeechSynthesisVoice | null;
}) {
  const [isSpeaking, setIsSpeaking] = useState(false);
  const [isPaused, setIsPaused] = useState(false);
  const [isSupported, setIsSupported] = useState(false);
  const [voices, setVoices] = useState<SpeechSynthesisVoice[]>([]);
  const [selectedVoice, setSelectedVoice] = useState<SpeechSynthesisVoice | null>(
    options?.voice ?? null
  );
  
  const utteranceRef = useRef<SpeechSynthesisUtterance | null>(null);

  useEffect(() => {
    if (typeof window !== 'undefined' && 'speechSynthesis' in window) {
      setIsSupported(true);

      const loadVoices = () => {
        const availableVoices = speechSynthesis.getVoices();
        setVoices(availableVoices);
        
        // Select default voice
        if (!selectedVoice && availableVoices.length > 0) {
          const englishVoice = availableVoices.find(
            (v) => v.lang.startsWith('en') && v.default
          ) || availableVoices.find((v) => v.lang.startsWith('en'));
          setSelectedVoice(englishVoice || availableVoices[0]);
        }
      };

      loadVoices();
      speechSynthesis.addEventListener('voiceschanged', loadVoices);

      return () => {
        speechSynthesis.removeEventListener('voiceschanged', loadVoices);
        speechSynthesis.cancel();
      };
    }
  }, []);

  const speak = useCallback(
    (text: string) => {
      if (!isSupported) return;

      speechSynthesis.cancel();

      const utterance = new SpeechSynthesisUtterance(text);
      utterance.rate = options?.rate ?? 1;
      utterance.pitch = options?.pitch ?? 1;
      utterance.volume = options?.volume ?? 1;
      if (selectedVoice) utterance.voice = selectedVoice;

      utterance.onstart = () => setIsSpeaking(true);
      utterance.onend = () => {
        setIsSpeaking(false);
        setIsPaused(false);
      };
      utterance.onerror = () => {
        setIsSpeaking(false);
        setIsPaused(false);
      };

      utteranceRef.current = utterance;
      speechSynthesis.speak(utterance);
    },
    [isSupported, selectedVoice, options?.rate, options?.pitch, options?.volume]
  );

  const pause = useCallback(() => {
    if (isSpeaking) {
      speechSynthesis.pause();
      setIsPaused(true);
    }
  }, [isSpeaking]);

  const resume = useCallback(() => {
    if (isPaused) {
      speechSynthesis.resume();
      setIsPaused(false);
    }
  }, [isPaused]);

  const stop = useCallback(() => {
    speechSynthesis.cancel();
    setIsSpeaking(false);
    setIsPaused(false);
  }, []);

  return {
    isSpeaking,
    isPaused,
    isSupported,
    voices,
    selectedVoice,
    setSelectedVoice,
    speak,
    pause,
    resume,
    stop,
  };
}

// Voice Commands Hook
export function useVoiceCommands(commands: VoiceCommand[]) {
  const [lastCommand, setLastCommand] = useState<string | null>(null);

  const handleCommand = useCallback(
    (transcript: string) => {
      const normalizedTranscript = transcript.toLowerCase().trim();
      
      for (const command of commands) {
        for (const pattern of command.patterns) {
          if (normalizedTranscript.includes(pattern.toLowerCase())) {
            setLastCommand(command.action);
            command.handler?.();
            return command.action;
          }
        }
      }
      
      return null;
    },
    [commands]
  );

  return {
    lastCommand,
    handleCommand,
  };
}

// Voice Input Component
interface VoiceInputProps {
  value: string;
  onChange: (value: string) => void;
  placeholder?: string;
  className?: string;
  minHeight?: string;
}

export function VoiceInput({
  value,
  onChange,
  placeholder = 'Type or use voice input...',
  className,
  minHeight = '100px',
}: VoiceInputProps) {
  const {
    isListening,
    isSupported,
    transcript,
    interimTranscript,
    startListening,
    stopListening,
    resetTranscript,
  } = useVoiceRecognition({
    continuous: true,
    interimResults: true,
    onResult: (text, isFinal) => {
      if (isFinal) {
        onChange(value + text);
      }
    },
  });

  useEffect(() => {
    // Add transcript to value when final
    if (transcript) {
      resetTranscript();
    }
  }, [transcript, resetTranscript]);

  return (
    <div className={cn('relative', className)}>
      <Textarea
        value={value + interimTranscript}
        onChange={(e) => onChange(e.target.value.slice(0, -interimTranscript.length) || e.target.value)}
        placeholder={placeholder}
        style={{ minHeight }}
        className={cn(
          'pr-12',
          isListening && 'ring-2 ring-primary ring-offset-2'
        )}
      />
      {isSupported && (
        <Button
          type="button"
          variant={isListening ? 'destructive' : 'ghost'}
          size="icon"
          className="absolute bottom-2 right-2"
          onClick={isListening ? stopListening : startListening}
        >
          {isListening ? (
            <MicOff className="h-4 w-4" />
          ) : (
            <Mic className="h-4 w-4" />
          )}
        </Button>
      )}
      {isListening && (
        <div className="absolute top-2 right-2 flex items-center gap-1.5">
          <span className="relative flex h-2 w-2">
            <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-red-400 opacity-75" />
            <span className="relative inline-flex rounded-full h-2 w-2 bg-red-500" />
          </span>
          <span className="text-xs text-muted-foreground">Listening...</span>
        </div>
      )}
    </div>
  );
}

// Voice Command Button
interface VoiceCommandButtonProps {
  commands: VoiceCommand[];
  onCommand: (action: string) => void;
  className?: string;
}

export function VoiceCommandButton({
  commands,
  onCommand,
  className,
}: VoiceCommandButtonProps) {
  const [showCommands, setShowCommands] = useState(false);
  
  const { lastCommand, handleCommand } = useVoiceCommands(
    commands.map((cmd) => ({
      ...cmd,
      handler: () => onCommand(cmd.action),
    }))
  );

  const {
    isListening,
    isSupported,
    startListening,
    stopListening,
  } = useVoiceRecognition({
    continuous: false,
    onCommand: handleCommand,
  });

  if (!isSupported) {
    return null;
  }

  return (
    <div className="relative">
      <DropdownMenu open={showCommands} onOpenChange={setShowCommands}>
        <DropdownMenuTrigger asChild>
          <Button
            variant={isListening ? 'destructive' : 'outline'}
            size="sm"
            className={cn('gap-2', className)}
            onClick={(e) => {
              if (isListening) {
                e.preventDefault();
                stopListening();
              }
            }}
          >
            {isListening ? (
              <>
                <Waveform className="h-4 w-4 animate-pulse" />
                <span>Listening...</span>
              </>
            ) : (
              <>
                <Mic className="h-4 w-4" />
                <span>Voice Command</span>
              </>
            )}
          </Button>
        </DropdownMenuTrigger>
        <DropdownMenuContent align="end" className="w-64">
          <DropdownMenuLabel>Available Commands</DropdownMenuLabel>
          <DropdownMenuSeparator />
          {commands.map((cmd) => (
            <DropdownMenuItem
              key={cmd.action}
              onClick={() => {
                setShowCommands(false);
                startListening();
              }}
            >
              <div className="flex flex-col">
                <span className="font-medium">{cmd.description}</span>
                <span className="text-xs text-muted-foreground">
                  Say: "{cmd.patterns[0]}"
                </span>
              </div>
            </DropdownMenuItem>
          ))}
          <DropdownMenuSeparator />
          <DropdownMenuItem
            onClick={() => {
              setShowCommands(false);
              startListening();
            }}
          >
            <Mic className="h-4 w-4 mr-2" />
            Start Voice Command
          </DropdownMenuItem>
        </DropdownMenuContent>
      </DropdownMenu>
      
      {lastCommand && (
        <Badge variant="secondary" className="absolute -top-8 left-0">
          Last: {lastCommand}
        </Badge>
      )}
    </div>
  );
}

// Text-to-Speech Controls
interface TextToSpeechControlsProps {
  text: string;
  showSettings?: boolean;
  className?: string;
}

export function TextToSpeechControls({
  text,
  showSettings = false,
  className,
}: TextToSpeechControlsProps) {
  const [rate, setRate] = useState(1);
  const [pitch, setPitch] = useState(1);
  const [volume, setVolume] = useState(1);
  const [settingsOpen, setSettingsOpen] = useState(false);

  const {
    isSpeaking,
    isPaused,
    isSupported,
    voices,
    selectedVoice,
    setSelectedVoice,
    speak,
    pause,
    resume,
    stop,
  } = useTextToSpeech({ rate, pitch, volume });

  if (!isSupported) {
    return null;
  }

  return (
    <div className={cn('flex items-center gap-2', className)}>
      {!isSpeaking ? (
        <Button
          variant="outline"
          size="icon"
          onClick={() => speak(text)}
          title="Read aloud"
        >
          <Volume2 className="h-4 w-4" />
        </Button>
      ) : (
        <>
          <Button
            variant="outline"
            size="icon"
            onClick={isPaused ? resume : pause}
            title={isPaused ? 'Resume' : 'Pause'}
          >
            {isPaused ? (
              <Play className="h-4 w-4" />
            ) : (
              <Pause className="h-4 w-4" />
            )}
          </Button>
          <Button
            variant="outline"
            size="icon"
            onClick={stop}
            title="Stop"
          >
            <Square className="h-4 w-4" />
          </Button>
        </>
      )}

      {showSettings && (
        <Dialog open={settingsOpen} onOpenChange={setSettingsOpen}>
          <DialogTrigger asChild>
            <Button variant="ghost" size="icon">
              <Settings className="h-4 w-4" />
            </Button>
          </DialogTrigger>
          <DialogContent>
            <DialogHeader>
              <DialogTitle>Speech Settings</DialogTitle>
              <DialogDescription>
                Customize text-to-speech preferences
              </DialogDescription>
            </DialogHeader>

            <div className="space-y-4 py-4">
              <div className="space-y-2">
                <label className="text-sm font-medium">Voice</label>
                <Select
                  value={selectedVoice?.name || ''}
                  onValueChange={(name) => {
                    const voice = voices.find((v) => v.name === name);
                    if (voice) setSelectedVoice(voice);
                  }}
                >
                  <SelectTrigger>
                    <SelectValue placeholder="Select a voice" />
                  </SelectTrigger>
                  <SelectContent>
                    {voices.map((voice) => (
                      <SelectItem key={voice.name} value={voice.name}>
                        {voice.name} ({voice.lang})
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>

              <div className="space-y-2">
                <label className="text-sm font-medium">
                  Speed: {rate.toFixed(1)}x
                </label>
                <Slider
                  value={[rate]}
                  onValueChange={([value]) => setRate(value)}
                  min={0.5}
                  max={2}
                  step={0.1}
                />
              </div>

              <div className="space-y-2">
                <label className="text-sm font-medium">
                  Pitch: {pitch.toFixed(1)}
                </label>
                <Slider
                  value={[pitch]}
                  onValueChange={([value]) => setPitch(value)}
                  min={0.5}
                  max={2}
                  step={0.1}
                />
              </div>

              <div className="space-y-2">
                <label className="text-sm font-medium">
                  Volume: {Math.round(volume * 100)}%
                </label>
                <Slider
                  value={[volume]}
                  onValueChange={([value]) => setVolume(value)}
                  min={0}
                  max={1}
                  step={0.1}
                />
              </div>
            </div>

            <DialogFooter>
              <Button variant="outline" onClick={() => speak('This is a test.')}>
                Test Voice
              </Button>
              <Button onClick={() => setSettingsOpen(false)}>Done</Button>
            </DialogFooter>
          </DialogContent>
        </Dialog>
      )}
    </div>
  );
}

// Dictation Dialog
interface DictationDialogProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  onComplete: (text: string) => void;
  title?: string;
}

export function DictationDialog({
  open,
  onOpenChange,
  onComplete,
  title = 'Voice Dictation',
}: DictationDialogProps) {
  const [text, setText] = useState('');
  
  const {
    isListening,
    isSupported,
    interimTranscript,
    startListening,
    stopListening,
    resetTranscript,
  } = useVoiceRecognition({
    continuous: true,
    interimResults: true,
    onResult: (transcript, isFinal) => {
      if (isFinal) {
        setText((prev) => prev + transcript + ' ');
      }
    },
  });

  const handleComplete = () => {
    stopListening();
    onComplete(text.trim());
    setText('');
    resetTranscript();
    onOpenChange(false);
  };

  const handleCancel = () => {
    stopListening();
    setText('');
    resetTranscript();
    onOpenChange(false);
  };

  if (!isSupported) {
    return (
      <Dialog open={open} onOpenChange={onOpenChange}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>{title}</DialogTitle>
            <DialogDescription>
              Voice input is not supported in your browser. Please use a modern browser like Chrome, Edge, or Safari.
            </DialogDescription>
          </DialogHeader>
          <DialogFooter>
            <Button onClick={() => onOpenChange(false)}>Close</Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    );
  }

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="sm:max-w-lg">
        <DialogHeader>
          <DialogTitle className="flex items-center gap-2">
            <Mic className="h-5 w-5" />
            {title}
          </DialogTitle>
          <DialogDescription>
            Speak clearly into your microphone. Your words will appear below.
          </DialogDescription>
        </DialogHeader>

        <div className="py-4">
          <div
            className={cn(
              'min-h-[150px] p-4 rounded-lg border bg-muted/50 relative',
              isListening && 'ring-2 ring-primary'
            )}
          >
            <p className="whitespace-pre-wrap">
              {text}
              <span className="text-muted-foreground">{interimTranscript}</span>
            </p>
            
            {isListening && (
              <div className="absolute bottom-4 right-4 flex items-center gap-1.5">
                <span className="relative flex h-3 w-3">
                  <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-red-400 opacity-75" />
                  <span className="relative inline-flex rounded-full h-3 w-3 bg-red-500" />
                </span>
                <span className="text-sm text-muted-foreground">Recording...</span>
              </div>
            )}
          </div>

          <div className="flex justify-center mt-4">
            <Button
              variant={isListening ? 'destructive' : 'default'}
              size="lg"
              className="rounded-full w-16 h-16"
              onClick={isListening ? stopListening : startListening}
            >
              {isListening ? (
                <MicOff className="h-6 w-6" />
              ) : (
                <Mic className="h-6 w-6" />
              )}
            </Button>
          </div>
        </div>

        <DialogFooter>
          <Button variant="outline" onClick={handleCancel}>
            Cancel
          </Button>
          <Button onClick={handleComplete} disabled={!text.trim()}>
            Use Text
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}

// Application-specific voice commands
export const APPLICATION_VOICE_COMMANDS: VoiceCommand[] = [
  {
    patterns: ['new application', 'add application', 'create application'],
    action: 'new-application',
    description: 'Create new application',
  },
  {
    patterns: ['search', 'find', 'look for'],
    action: 'open-search',
    description: 'Open search',
  },
  {
    patterns: ['show interviews', 'view interviews', 'my interviews'],
    action: 'view-interviews',
    description: 'View interviews',
  },
  {
    patterns: ['show analytics', 'view analytics', 'statistics', 'stats'],
    action: 'view-analytics',
    description: 'View analytics',
  },
  {
    patterns: ['mark applied', 'set status applied'],
    action: 'status-applied',
    description: 'Set status to Applied',
  },
  {
    patterns: ['mark interviewing', 'set status interviewing'],
    action: 'status-interviewing',
    description: 'Set status to Interviewing',
  },
  {
    patterns: ['mark offered', 'set status offered'],
    action: 'status-offered',
    description: 'Set status to Offered',
  },
  {
    patterns: ['mark rejected', 'set status rejected'],
    action: 'status-rejected',
    description: 'Set status to Rejected',
  },
  {
    patterns: ['go back', 'back', 'previous'],
    action: 'go-back',
    description: 'Go back',
  },
  {
    patterns: ['show help', 'help', 'commands'],
    action: 'show-help',
    description: 'Show help',
  },
];

// Voice Search Button - Simple button for voice-to-text search
interface VoiceSearchButtonProps {
  onResult: (text: string) => void;
  className?: string;
}

export function VoiceSearchButton({ onResult, className }: VoiceSearchButtonProps) {
  const { isListening, transcript, startListening, stopListening } = useVoiceRecognition({
    continuous: false,
    onResult: (text) => {
      onResult(text);
    },
  });

  return (
    <Button
      type="button"
      variant={isListening ? 'secondary' : 'outline'}
      size="icon"
      className={className}
      onClick={() => (isListening ? stopListening() : startListening())}
      title={isListening ? 'Stop listening' : 'Voice search'}
    >
      <Mic className={`h-4 w-4 ${isListening ? 'text-red-500 animate-pulse' : ''}`} />
    </Button>
  );
}

// Voice Dictation Button - For longer dictation
interface VoiceDictationButtonProps {
  onResult: (text: string) => void;
  className?: string;
}

export function VoiceDictationButton({ onResult, className }: VoiceDictationButtonProps) {
  const [isOpen, setIsOpen] = useState(false);

  return (
    <>
      <Button
        type="button"
        variant="outline"
        size="icon"
        className={className}
        onClick={() => setIsOpen(true)}
        title="Dictation"
      >
        <Mic className="h-4 w-4" />
      </Button>
      <DictationDialog
        open={isOpen}
        onOpenChange={setIsOpen}
        onSave={(text) => {
          onResult(text);
          setIsOpen(false);
        }}
      />
    </>
  );
}

export default VoiceInput;
