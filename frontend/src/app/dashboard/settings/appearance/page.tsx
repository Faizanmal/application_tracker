'use client';

import { useState } from 'react';
import { Loader2, Sun, Moon, Monitor, Palette } from 'lucide-react';

import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Label } from '@/components/ui/label';
import { RadioGroup, RadioGroupItem } from '@/components/ui/radio-group';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select';
import { toast } from 'sonner';
import { cn } from '@/lib/utils';

type Theme = 'light' | 'dark' | 'system';
type AccentColor = 'blue' | 'purple' | 'green' | 'orange' | 'pink' | 'slate';

const ACCENT_COLORS: { value: AccentColor; label: string; class: string }[] = [
  { value: 'blue', label: 'Blue', class: 'bg-blue-500' },
  { value: 'purple', label: 'Purple', class: 'bg-purple-500' },
  { value: 'green', label: 'Green', class: 'bg-green-500' },
  { value: 'orange', label: 'Orange', class: 'bg-orange-500' },
  { value: 'pink', label: 'Pink', class: 'bg-pink-500' },
  { value: 'slate', label: 'Slate', class: 'bg-slate-500' },
];

const FONT_SIZES = [
  { value: 'small', label: 'Small' },
  { value: 'medium', label: 'Medium (Default)' },
  { value: 'large', label: 'Large' },
];

const DENSITIES = [
  { value: 'comfortable', label: 'Comfortable', description: 'More spacing, easier to read' },
  { value: 'compact', label: 'Compact', description: 'Less spacing, more content visible' },
];

export default function AppearanceSettingsPage() {
  const [theme, setTheme] = useState<Theme>('system');
  const [accentColor, setAccentColor] = useState<AccentColor>('blue');
  const [fontSize, setFontSize] = useState('medium');
  const [density, setDensity] = useState('comfortable');
  const [isSaving, setIsSaving] = useState(false);

  const handleSave = async () => {
    setIsSaving(true);
    try {
      // TODO: Save preferences to API
      await new Promise(resolve => setTimeout(resolve, 1000));
      toast.success('Appearance settings saved');
    } catch (_error) {
      toast.error('Failed to save settings');
    } finally {
      setIsSaving(false);
    }
  };

  return (
    <div className="space-y-6">
      {/* Theme */}
      <Card>
        <CardHeader>
          <CardTitle>Theme</CardTitle>
          <CardDescription>
            Choose your preferred color scheme
          </CardDescription>
        </CardHeader>
        <CardContent>
          <RadioGroup
            value={theme}
            onValueChange={(value) => setTheme(value as Theme)}
            className="grid grid-cols-3 gap-4"
          >
            <Label
              htmlFor="theme-light"
              className={cn(
                'flex flex-col items-center gap-3 p-4 rounded-lg border-2 cursor-pointer transition-all',
                theme === 'light' ? 'border-primary bg-primary/5' : 'border-muted hover:border-primary/50'
              )}
            >
              <RadioGroupItem value="light" id="theme-light" className="sr-only" />
              <div className="p-3 rounded-full bg-amber-100">
                <Sun className="h-6 w-6 text-amber-600" />
              </div>
              <div className="text-center">
                <p className="font-medium">Light</p>
                <p className="text-xs text-muted-foreground">Bright and clear</p>
              </div>
            </Label>

            <Label
              htmlFor="theme-dark"
              className={cn(
                'flex flex-col items-center gap-3 p-4 rounded-lg border-2 cursor-pointer transition-all',
                theme === 'dark' ? 'border-primary bg-primary/5' : 'border-muted hover:border-primary/50'
              )}
            >
              <RadioGroupItem value="dark" id="theme-dark" className="sr-only" />
              <div className="p-3 rounded-full bg-slate-800">
                <Moon className="h-6 w-6 text-slate-200" />
              </div>
              <div className="text-center">
                <p className="font-medium">Dark</p>
                <p className="text-xs text-muted-foreground">Easy on the eyes</p>
              </div>
            </Label>

            <Label
              htmlFor="theme-system"
              className={cn(
                'flex flex-col items-center gap-3 p-4 rounded-lg border-2 cursor-pointer transition-all',
                theme === 'system' ? 'border-primary bg-primary/5' : 'border-muted hover:border-primary/50'
              )}
            >
              <RadioGroupItem value="system" id="theme-system" className="sr-only" />
              <div className="p-3 rounded-full bg-gray-200">
                <Monitor className="h-6 w-6 text-gray-600" />
              </div>
              <div className="text-center">
                <p className="font-medium">System</p>
                <p className="text-xs text-muted-foreground">Match your device</p>
              </div>
            </Label>
          </RadioGroup>
        </CardContent>
      </Card>

      {/* Accent Color */}
      <Card>
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <Palette className="h-5 w-5" />
            Accent Color
          </CardTitle>
          <CardDescription>
            Personalize your interface with your favorite color
          </CardDescription>
        </CardHeader>
        <CardContent>
          <div className="flex flex-wrap gap-4">
            {ACCENT_COLORS.map((color) => (
              <button
                key={color.value}
                onClick={() => setAccentColor(color.value)}
                className={cn(
                  'flex flex-col items-center gap-2 p-3 rounded-lg border-2 transition-all',
                  accentColor === color.value
                    ? 'border-foreground'
                    : 'border-transparent hover:border-muted'
                )}
              >
                <div className={cn('h-10 w-10 rounded-full', color.class)} />
                <span className="text-sm">{color.label}</span>
              </button>
            ))}
          </div>
        </CardContent>
      </Card>

      {/* Font Size */}
      <Card>
        <CardHeader>
          <CardTitle>Font Size</CardTitle>
          <CardDescription>
            Adjust the text size throughout the application
          </CardDescription>
        </CardHeader>
        <CardContent>
          <Select value={fontSize} onValueChange={setFontSize}>
            <SelectTrigger className="w-full max-w-xs">
              <SelectValue />
            </SelectTrigger>
            <SelectContent>
              {FONT_SIZES.map((size) => (
                <SelectItem key={size.value} value={size.value}>
                  {size.label}
                </SelectItem>
              ))}
            </SelectContent>
          </Select>
          
          {/* Preview */}
          <div className="mt-4 p-4 rounded-lg border bg-muted/50">
            <p className="text-muted-foreground mb-2">Preview:</p>
            <p className={cn(
              'font-medium',
              fontSize === 'small' && 'text-sm',
              fontSize === 'medium' && 'text-base',
              fontSize === 'large' && 'text-lg'
            )}>
              The quick brown fox jumps over the lazy dog
            </p>
          </div>
        </CardContent>
      </Card>

      {/* Density */}
      <Card>
        <CardHeader>
          <CardTitle>Display Density</CardTitle>
          <CardDescription>
            Choose how much content you want to see at once
          </CardDescription>
        </CardHeader>
        <CardContent>
          <RadioGroup
            value={density}
            onValueChange={setDensity}
            className="grid grid-cols-1 md:grid-cols-2 gap-4"
          >
            {DENSITIES.map((option) => (
              <Label
                key={option.value}
                htmlFor={`density-${option.value}`}
                className={cn(
                  'flex items-center gap-4 p-4 rounded-lg border-2 cursor-pointer transition-all',
                  density === option.value
                    ? 'border-primary bg-primary/5'
                    : 'border-muted hover:border-primary/50'
                )}
              >
                <RadioGroupItem value={option.value} id={`density-${option.value}`} />
                <div>
                  <p className="font-medium">{option.label}</p>
                  <p className="text-sm text-muted-foreground">{option.description}</p>
                </div>
              </Label>
            ))}
          </RadioGroup>
        </CardContent>
      </Card>

      {/* Kanban Board Preferences */}
      <Card>
        <CardHeader>
          <CardTitle>Kanban Board</CardTitle>
          <CardDescription>
            Customize your application board appearance
          </CardDescription>
        </CardHeader>
        <CardContent className="space-y-6">
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div className="space-y-2">
              <Label>Default View</Label>
              <Select defaultValue="kanban">
                <SelectTrigger>
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="kanban">Kanban Board</SelectItem>
                  <SelectItem value="list">List View</SelectItem>
                  <SelectItem value="table">Table View</SelectItem>
                </SelectContent>
              </Select>
            </div>

            <div className="space-y-2">
              <Label>Card Size</Label>
              <Select defaultValue="medium">
                <SelectTrigger>
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="small">Small</SelectItem>
                  <SelectItem value="medium">Medium</SelectItem>
                  <SelectItem value="large">Large</SelectItem>
                </SelectContent>
              </Select>
            </div>
          </div>

          <div className="space-y-2">
            <Label>Show on Cards</Label>
            <div className="flex flex-wrap gap-2">
              {['Company Logo', 'Salary Range', 'Tags', 'Next Interview', 'Applied Date'].map((option) => (
                <button
                  key={option}
                  className="px-3 py-1 rounded-full border text-sm hover:bg-muted transition-colors"
                >
                  {option}
                </button>
              ))}
            </div>
          </div>
        </CardContent>
      </Card>

      {/* Save Button */}
      <div className="flex justify-end">
        <Button onClick={handleSave} disabled={isSaving}>
          {isSaving ? (
            <>
              <Loader2 className="mr-2 h-4 w-4 animate-spin" />
              Saving...
            </>
          ) : (
            'Save Preferences'
          )}
        </Button>
      </div>
    </div>
  );
}
