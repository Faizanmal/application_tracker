'use client';

import { useEffect, useCallback, useState, createContext, useContext } from 'react';
import {
  Keyboard,
  HelpCircle,
  Sun,
  Moon,
  Eye,
  Type,
} from 'lucide-react';
import { Button } from '@/components/ui/button';
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
} from '@/components/ui/dialog';
import { Label } from '@/components/ui/label';
import { Switch } from '@/components/ui/switch';
import { Slider } from '@/components/ui/slider';
import { Separator } from '@/components/ui/separator';
import { toast } from 'sonner';
import { useRouter } from 'next/navigation';

// Types
interface KeyboardShortcut {
  key: string;
  modifier?: 'ctrl' | 'alt' | 'shift' | 'meta';
  description: string;
  action: () => void;
  scope?: 'global' | 'kanban' | 'list' | 'detail';
}

interface AccessibilitySettings {
  highContrast: boolean;
  reducedMotion: boolean;
  largeText: boolean;
  screenReaderOptimized: boolean;
  focusIndicators: boolean;
  textScale: number;
}

// Default accessibility settings
const DEFAULT_SETTINGS: AccessibilitySettings = {
  highContrast: false,
  reducedMotion: false,
  largeText: false,
  screenReaderOptimized: false,
  focusIndicators: true,
  textScale: 100,
};

// Accessibility Context
const AccessibilityContext = createContext<{
  settings: AccessibilitySettings;
  updateSettings: (settings: Partial<AccessibilitySettings>) => void;
}>({
  settings: DEFAULT_SETTINGS,
  updateSettings: () => {},
});

export const useAccessibility = () => useContext(AccessibilityContext);

// Accessibility Provider
export function AccessibilityProvider({ children }: { children: React.ReactNode }) {
  const [settings, setSettings] = useState<AccessibilitySettings>(() => {
    if (typeof window !== 'undefined') {
      const saved = localStorage.getItem('accessibility-settings');
      if (saved) {
        try {
          return { ...DEFAULT_SETTINGS, ...JSON.parse(saved) };
        } catch {
          return DEFAULT_SETTINGS;
        }
      }
    }
    return DEFAULT_SETTINGS;
  });

  // Apply settings to document
  useEffect(() => {
    const root = document.documentElement;
    
    // High contrast
    root.classList.toggle('high-contrast', settings.highContrast);
    
    // Reduced motion
    root.classList.toggle('reduced-motion', settings.reducedMotion);
    
    // Large text
    root.classList.toggle('large-text', settings.largeText);
    
    // Focus indicators
    root.classList.toggle('enhanced-focus', settings.focusIndicators);
    
    // Text scale
    root.style.setProperty('--text-scale', `${settings.textScale / 100}`);
    
    // Save to localStorage
    localStorage.setItem('accessibility-settings', JSON.stringify(settings));
  }, [settings]);

  const updateSettings = useCallback((newSettings: Partial<AccessibilitySettings>) => {
    setSettings(prev => ({ ...prev, ...newSettings }));
  }, []);

  return (
    <AccessibilityContext.Provider value={{ settings, updateSettings }}>
      {children}
    </AccessibilityContext.Provider>
  );
}

// Keyboard Shortcuts Hook
export function useKeyboardShortcuts(shortcuts: KeyboardShortcut[]) {
  useEffect(() => {
    const handleKeyDown = (event: KeyboardEvent) => {
      // Skip if user is typing in an input
      if (
        event.target instanceof HTMLInputElement ||
        event.target instanceof HTMLTextAreaElement ||
        (event.target as HTMLElement).isContentEditable
      ) {
        return;
      }

      for (const shortcut of shortcuts) {
        const keyMatch = event.key.toLowerCase() === shortcut.key.toLowerCase();
        const ctrlMatch = !shortcut.modifier || shortcut.modifier !== 'ctrl' || (event.ctrlKey || event.metaKey);
        const altMatch = !shortcut.modifier || shortcut.modifier !== 'alt' || event.altKey;
        const shiftMatch = !shortcut.modifier || shortcut.modifier !== 'shift' || event.shiftKey;
        const metaMatch = !shortcut.modifier || shortcut.modifier !== 'meta' || event.metaKey;

        if (keyMatch && ctrlMatch && altMatch && shiftMatch && metaMatch) {
          // Check if modifier was required but key alone shouldn't trigger
          if (shortcut.modifier) {
            const modifierPressed = 
              (shortcut.modifier === 'ctrl' && (event.ctrlKey || event.metaKey)) ||
              (shortcut.modifier === 'alt' && event.altKey) ||
              (shortcut.modifier === 'shift' && event.shiftKey) ||
              (shortcut.modifier === 'meta' && event.metaKey);
            
            if (!modifierPressed) continue;
          }
          
          event.preventDefault();
          shortcut.action();
          return;
        }
      }
    };

    window.addEventListener('keydown', handleKeyDown);
    return () => window.removeEventListener('keydown', handleKeyDown);
  }, [shortcuts]);
}

// Keyboard Navigation Hook for Kanban
export function useKanbanKeyboardNavigation(
  applications: { id: string; status: string }[],
  statuses: string[],
  selectedId: string | null,
  onSelect: (id: string | null) => void,
  onMove: (id: string, direction: 'left' | 'right' | 'up' | 'down') => void,
  onOpen: (id: string) => void
) {
  useEffect(() => {
    const handleKeyDown = (event: KeyboardEvent) => {
      if (!selectedId) {
        // Select first application if none selected
        if (event.key === 'ArrowDown' || event.key === 'ArrowRight') {
          if (applications.length > 0) {
            onSelect(applications[0].id);
          }
        }
        return;
      }

      const currentApp = applications.find(a => a.id === selectedId);
      if (!currentApp) return;

      const currentStatusIndex = statuses.indexOf(currentApp.status);
      const appsInCurrentStatus = applications.filter(a => a.status === currentApp.status);
      const currentIndexInStatus = appsInCurrentStatus.findIndex(a => a.id === selectedId);

      switch (event.key) {
        case 'ArrowUp':
          event.preventDefault();
          if (currentIndexInStatus > 0) {
            onSelect(appsInCurrentStatus[currentIndexInStatus - 1].id);
          }
          break;
          
        case 'ArrowDown':
          event.preventDefault();
          if (currentIndexInStatus < appsInCurrentStatus.length - 1) {
            onSelect(appsInCurrentStatus[currentIndexInStatus + 1].id);
          }
          break;
          
        case 'ArrowLeft':
          event.preventDefault();
          if (event.shiftKey && currentStatusIndex > 0) {
            // Move to previous status
            onMove(selectedId, 'left');
          } else if (!event.shiftKey && currentStatusIndex > 0) {
            // Navigate to previous column
            const prevStatus = statuses[currentStatusIndex - 1];
            const appsInPrevStatus = applications.filter(a => a.status === prevStatus);
            if (appsInPrevStatus.length > 0) {
              onSelect(appsInPrevStatus[0].id);
            }
          }
          break;
          
        case 'ArrowRight':
          event.preventDefault();
          if (event.shiftKey && currentStatusIndex < statuses.length - 1) {
            // Move to next status
            onMove(selectedId, 'right');
          } else if (!event.shiftKey && currentStatusIndex < statuses.length - 1) {
            // Navigate to next column
            const nextStatus = statuses[currentStatusIndex + 1];
            const appsInNextStatus = applications.filter(a => a.status === nextStatus);
            if (appsInNextStatus.length > 0) {
              onSelect(appsInNextStatus[0].id);
            }
          }
          break;
          
        case 'Enter':
          event.preventDefault();
          onOpen(selectedId);
          break;
          
        case 'Escape':
          event.preventDefault();
          onSelect(null);
          break;
      }
    };

    window.addEventListener('keydown', handleKeyDown);
    return () => window.removeEventListener('keydown', handleKeyDown);
  }, [selectedId, applications, statuses, onSelect, onMove, onOpen]);
}

// Keyboard Shortcuts Help Dialog
export function KeyboardShortcutsHelp() {
  const [isOpen, setIsOpen] = useState(false);

  // Register ? to open help
  useKeyboardShortcuts([
    {
      key: '?',
      description: 'Show keyboard shortcuts',
      action: () => setIsOpen(true),
    },
  ]);

  const shortcuts = [
    { category: 'Navigation', items: [
      { keys: ['?'], description: 'Show keyboard shortcuts' },
      { keys: ['g', 'h'], description: 'Go to dashboard' },
      { keys: ['g', 'a'], description: 'Go to applications' },
      { keys: ['g', 'i'], description: 'Go to interviews' },
      { keys: ['g', 's'], description: 'Go to settings' },
    ]},
    { category: 'Applications', items: [
      { keys: ['n'], description: 'New application' },
      { keys: ['/', 'Ctrl+K'], description: 'Search' },
      { keys: ['f'], description: 'Toggle filters' },
      { keys: ['v'], description: 'Toggle view (Kanban/List)' },
    ]},
    { category: 'Kanban Board', items: [
      { keys: ['↑', '↓'], description: 'Navigate within column' },
      { keys: ['←', '→'], description: 'Navigate between columns' },
      { keys: ['Shift+←', 'Shift+→'], description: 'Move card to adjacent column' },
      { keys: ['Enter'], description: 'Open selected application' },
      { keys: ['Esc'], description: 'Deselect' },
    ]},
    { category: 'Actions', items: [
      { keys: ['s'], description: 'Star/unstar selected' },
      { keys: ['e'], description: 'Edit selected' },
      { keys: ['a'], description: 'Archive selected' },
      { keys: ['Delete'], description: 'Delete selected' },
    ]},
  ];

  return (
    <>
      <Button
        variant="ghost"
        size="icon"
        onClick={() => setIsOpen(true)}
        aria-label="Keyboard shortcuts"
      >
        <Keyboard className="h-5 w-5" />
      </Button>

      <Dialog open={isOpen} onOpenChange={setIsOpen}>
        <DialogContent className="max-w-2xl max-h-[80vh] overflow-y-auto">
          <DialogHeader>
            <DialogTitle className="flex items-center gap-2">
              <Keyboard className="h-5 w-5" />
              Keyboard Shortcuts
            </DialogTitle>
            <DialogDescription>
              Use these shortcuts to navigate and manage applications quickly
            </DialogDescription>
          </DialogHeader>

          <div className="space-y-6">
            {shortcuts.map((section) => (
              <div key={section.category}>
                <h3 className="font-semibold text-sm text-muted-foreground uppercase tracking-wide mb-3">
                  {section.category}
                </h3>
                <div className="space-y-2">
                  {section.items.map((shortcut, index) => (
                    <div
                      key={index}
                      className="flex items-center justify-between py-2 px-3 rounded-lg bg-muted/50"
                    >
                      <span className="text-sm">{shortcut.description}</span>
                      <div className="flex gap-1">
                        {shortcut.keys.map((key, keyIndex) => (
                          <span key={keyIndex}>
                            {keyIndex > 0 && (
                              <span className="text-muted-foreground mx-1">or</span>
                            )}
                            <kbd className="px-2 py-1 text-xs font-semibold bg-background border rounded shadow-sm">
                              {key}
                            </kbd>
                          </span>
                        ))}
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            ))}
          </div>
        </DialogContent>
      </Dialog>
    </>
  );
}

// Accessibility Settings Panel
export function AccessibilitySettings() {
  const [isOpen, setIsOpen] = useState(false);
  const { settings, updateSettings } = useAccessibility();

  return (
    <>
      <Button
        variant="ghost"
        size="icon"
        onClick={() => setIsOpen(true)}
        aria-label="Accessibility settings"
      >
        <Eye className="h-5 w-5" />
      </Button>

      <Dialog open={isOpen} onOpenChange={setIsOpen}>
        <DialogContent className="max-w-md">
          <DialogHeader>
            <DialogTitle className="flex items-center gap-2">
              <Eye className="h-5 w-5" />
              Accessibility Settings
            </DialogTitle>
            <DialogDescription>
              Customize the interface for your accessibility needs
            </DialogDescription>
          </DialogHeader>

          <div className="space-y-6 py-4">
            {/* High Contrast */}
            <div className="flex items-center justify-between">
              <div className="space-y-0.5">
                <Label className="flex items-center gap-2">
                  <Sun className="h-4 w-4" />
                  High Contrast Mode
                </Label>
                <p className="text-xs text-muted-foreground">
                  Increase contrast between elements
                </p>
              </div>
              <Switch
                checked={settings.highContrast}
                onCheckedChange={(checked) => updateSettings({ highContrast: checked })}
                aria-label="Toggle high contrast mode"
              />
            </div>

            <Separator />

            {/* Reduced Motion */}
            <div className="flex items-center justify-between">
              <div className="space-y-0.5">
                <Label>Reduced Motion</Label>
                <p className="text-xs text-muted-foreground">
                  Minimize animations and transitions
                </p>
              </div>
              <Switch
                checked={settings.reducedMotion}
                onCheckedChange={(checked) => updateSettings({ reducedMotion: checked })}
                aria-label="Toggle reduced motion"
              />
            </div>

            <Separator />

            {/* Text Scale */}
            <div className="space-y-3">
              <div className="flex items-center justify-between">
                <Label className="flex items-center gap-2">
                  <Type className="h-4 w-4" />
                  Text Size
                </Label>
                <span className="text-sm text-muted-foreground">
                  {settings.textScale}%
                </span>
              </div>
              <Slider
                value={[settings.textScale]}
                onValueChange={([value]) => updateSettings({ textScale: value })}
                min={75}
                max={150}
                step={5}
                aria-label="Adjust text size"
              />
              <div className="flex justify-between text-xs text-muted-foreground">
                <span>75%</span>
                <span>100%</span>
                <span>150%</span>
              </div>
            </div>

            <Separator />

            {/* Focus Indicators */}
            <div className="flex items-center justify-between">
              <div className="space-y-0.5">
                <Label>Enhanced Focus Indicators</Label>
                <p className="text-xs text-muted-foreground">
                  Show prominent focus outlines for keyboard navigation
                </p>
              </div>
              <Switch
                checked={settings.focusIndicators}
                onCheckedChange={(checked) => updateSettings({ focusIndicators: checked })}
                aria-label="Toggle enhanced focus indicators"
              />
            </div>

            <Separator />

            {/* Screen Reader Optimization */}
            <div className="flex items-center justify-between">
              <div className="space-y-0.5">
                <Label>Screen Reader Optimized</Label>
                <p className="text-xs text-muted-foreground">
                  Additional ARIA labels and live regions
                </p>
              </div>
              <Switch
                checked={settings.screenReaderOptimized}
                onCheckedChange={(checked) => updateSettings({ screenReaderOptimized: checked })}
                aria-label="Toggle screen reader optimization"
              />
            </div>

            <Separator />

            {/* Reset Button */}
            <Button
              variant="outline"
              className="w-full"
              onClick={() => updateSettings(DEFAULT_SETTINGS)}
            >
              Reset to Defaults
            </Button>
          </div>
        </DialogContent>
      </Dialog>
    </>
  );
}

// Skip to Content Link
export function SkipToContent() {
  return (
    <a
      href="#main-content"
      className="sr-only focus:not-sr-only focus:absolute focus:top-4 focus:left-4 focus:z-50 focus:px-4 focus:py-2 focus:bg-primary focus:text-primary-foreground focus:rounded-md focus:outline-none"
    >
      Skip to main content
    </a>
  );
}

// Live Region for Screen Readers
export function LiveRegion({
  message,
  politeness = 'polite',
}: {
  message: string;
  politeness?: 'polite' | 'assertive';
}) {
  return (
    <div
      role="status"
      aria-live={politeness}
      aria-atomic="true"
      className="sr-only"
    >
      {message}
    </div>
  );
}

export default KeyboardShortcutsHelp;
