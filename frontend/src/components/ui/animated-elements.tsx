'use client';

import * as React from 'react';
import { cn } from '@/lib/utils';

interface AnimatedNumberProps {
  value: number;
  duration?: number;
  formatFn?: (value: number) => string;
  className?: string;
  prefix?: string;
  suffix?: string;
}

export function AnimatedNumber({
  value,
  duration = 1000,
  formatFn = (n) => n.toLocaleString(),
  className,
  prefix = '',
  suffix = '',
}: AnimatedNumberProps) {
  const [displayValue, setDisplayValue] = React.useState(0);
  const startTimeRef = React.useRef<number | null>(null);
  const previousValueRef = React.useRef(0);

  React.useEffect(() => {
    const startValue = previousValueRef.current;
    const endValue = value;
    startTimeRef.current = null;

    const animate = (timestamp: number) => {
      if (!startTimeRef.current) {
        startTimeRef.current = timestamp;
      }

      const progress = Math.min((timestamp - startTimeRef.current) / duration, 1);
      const easeOutQuart = 1 - Math.pow(1 - progress, 4);
      const currentValue = Math.floor(startValue + (endValue - startValue) * easeOutQuart);

      setDisplayValue(currentValue);

      if (progress < 1) {
        requestAnimationFrame(animate);
      } else {
        previousValueRef.current = endValue;
      }
    };

    requestAnimationFrame(animate);
  }, [value, duration]);

  return (
    <span className={cn('stat-number tabular-nums', className)}>
      {prefix}{formatFn(displayValue)}{suffix}
    </span>
  );
}

interface AnimatedProgressProps {
  value: number;
  max?: number;
  showLabel?: boolean;
  size?: 'sm' | 'md' | 'lg';
  variant?: 'default' | 'gradient' | 'success' | 'warning' | 'danger';
  animated?: boolean;
  className?: string;
}

export function AnimatedProgress({
  value,
  max = 100,
  showLabel = false,
  size = 'md',
  variant = 'default',
  animated = true,
  className,
}: AnimatedProgressProps) {
  const percentage = Math.min(Math.max((value / max) * 100, 0), 100);

  const sizeClasses = {
    sm: 'h-1.5',
    md: 'h-2.5',
    lg: 'h-4',
  };

  const variantClasses = {
    default: 'bg-primary',
    gradient: 'gradient-primary',
    success: 'bg-emerald-500',
    warning: 'bg-amber-500',
    danger: 'bg-red-500',
  };

  return (
    <div className={cn('w-full', className)}>
      {showLabel && (
        <div className="flex justify-between mb-1">
          <span className="text-sm text-muted-foreground">Progress</span>
          <span className="text-sm font-medium">{Math.round(percentage)}%</span>
        </div>
      )}
      <div className={cn('w-full bg-muted rounded-full overflow-hidden', sizeClasses[size])}>
        <div
          className={cn(
            'h-full rounded-full transition-all duration-700 ease-out',
            variantClasses[variant],
            animated && 'progress-animated'
          )}
          style={{ width: `${percentage}%` }}
        />
      </div>
    </div>
  );
}

interface AnimatedBadgeProps extends React.HTMLAttributes<HTMLSpanElement> {
  variant?: 'default' | 'gradient' | 'outline' | 'glow';
  pulse?: boolean;
  size?: 'sm' | 'md' | 'lg';
}

export function AnimatedBadge({
  className,
  variant = 'default',
  pulse = false,
  size = 'md',
  children,
  ...props
}: AnimatedBadgeProps) {
  const variantClasses = {
    default: 'bg-primary text-primary-foreground',
    gradient: 'gradient-primary text-white',
    outline: 'border-2 border-primary text-primary bg-transparent',
    glow: 'bg-primary text-primary-foreground badge-glow',
  };

  const sizeClasses = {
    sm: 'text-xs px-2 py-0.5',
    md: 'text-sm px-2.5 py-0.5',
    lg: 'text-base px-3 py-1',
  };

  return (
    <span
      className={cn(
        'inline-flex items-center font-medium rounded-full transition-all',
        variantClasses[variant],
        sizeClasses[size],
        pulse && 'badge-pulse',
        className
      )}
      {...props}
    >
      {children}
    </span>
  );
}

interface AnimatedIconProps {
  icon: React.ElementType;
  animation?: 'bounce' | 'pulse' | 'spin' | 'float' | 'none';
  className?: string;
  size?: number;
}

export function AnimatedIcon({
  icon: Icon,
  animation = 'none',
  className,
  size = 24,
}: AnimatedIconProps) {
  const animationClasses = {
    bounce: 'animate-bounce',
    pulse: 'animate-pulse',
    spin: 'animate-spin',
    float: 'animate-float',
    none: '',
  };

  return (
    <Icon
      className={cn(animationClasses[animation], className)}
      style={{ width: size, height: size }}
    />
  );
}

interface GradientButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: 'primary' | 'secondary' | 'accent';
  size?: 'sm' | 'md' | 'lg';
  loading?: boolean;
  shine?: boolean;
}

export const GradientButton = React.forwardRef<HTMLButtonElement, GradientButtonProps>(
  ({ className, variant = 'primary', size = 'md', loading = false, shine = true, children, disabled, ...props }, ref) => {
    const variantClasses = {
      primary: 'from-indigo-500 to-purple-600',
      secondary: 'from-purple-500 to-pink-600',
      accent: 'from-cyan-500 to-blue-600',
    };

    const sizeClasses = {
      sm: 'h-8 px-3 text-sm',
      md: 'h-10 px-4',
      lg: 'h-12 px-6 text-lg',
    };

    return (
      <button
        ref={ref}
        className={cn(
          'relative inline-flex items-center justify-center font-medium text-white rounded-lg',
          'bg-gradient-to-r transition-all duration-300',
          'hover:shadow-lg hover:scale-[1.02] active:scale-[0.98]',
          'disabled:opacity-50 disabled:cursor-not-allowed disabled:hover:scale-100',
          variantClasses[variant],
          sizeClasses[size],
          shine && 'btn-shine overflow-hidden',
          className
        )}
        disabled={disabled || loading}
        {...props}
      >
        {loading ? (
          <svg className="animate-spin h-5 w-5" viewBox="0 0 24 24">
            <circle
              className="opacity-25"
              cx="12"
              cy="12"
              r="10"
              stroke="currentColor"
              strokeWidth="4"
              fill="none"
            />
            <path
              className="opacity-75"
              fill="currentColor"
              d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
            />
          </svg>
        ) : (
          children
        )}
      </button>
    );
  }
);
GradientButton.displayName = 'GradientButton';

interface FloatingActionButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  icon: React.ReactNode;
  position?: 'bottom-right' | 'bottom-left' | 'bottom-center';
  extended?: boolean;
  label?: string;
}

export function FloatingActionButton({
  icon,
  position = 'bottom-right',
  extended = false,
  label,
  className,
  ...props
}: FloatingActionButtonProps) {
  const positionClasses = {
    'bottom-right': 'right-6 bottom-6',
    'bottom-left': 'left-6 bottom-6',
    'bottom-center': 'left-1/2 -translate-x-1/2 bottom-6',
  };

  return (
    <button
      className={cn(
        'fixed z-50 flex items-center justify-center gap-2',
        'bg-gradient-to-r from-indigo-500 to-purple-600 text-white',
        'rounded-full shadow-lg transition-all duration-300',
        'hover:shadow-xl hover:scale-110 active:scale-95',
        extended ? 'px-6 h-14' : 'w-14 h-14',
        positionClasses[position],
        className
      )}
      {...props}
    >
      {icon}
      {extended && label && <span className="font-medium">{label}</span>}
    </button>
  );
}

interface AnimatedListProps {
  children: React.ReactNode;
  className?: string;
  staggerDelay?: number;
}

export function AnimatedList({ children, className, staggerDelay = 100 }: AnimatedListProps) {
  return (
    <div className={cn('space-y-4', className)}>
      {React.Children.map(children, (child, index) => (
        <div
          className="animate-fade-in-up opacity-0"
          style={{
            animationDelay: `${index * staggerDelay}ms`,
            animationFillMode: 'forwards',
          }}
        >
          {child}
        </div>
      ))}
    </div>
  );
}

interface EmptyStateProps {
  icon: React.ReactNode;
  title: string;
  description?: string;
  action?: React.ReactNode;
  className?: string;
}

export function EmptyState({
  icon,
  title,
  description,
  action,
  className,
}: EmptyStateProps) {
  return (
    <div className={cn('empty-state py-12', className)}>
      <div className="empty-state-icon mb-4 p-4 rounded-full bg-muted text-muted-foreground">
        {icon}
      </div>
      <h3 className="text-lg font-semibold mb-1">{title}</h3>
      {description && (
        <p className="text-muted-foreground text-center max-w-sm mb-4">{description}</p>
      )}
      {action}
    </div>
  );
}

export function GlassCard({ className, children, ...props }: React.HTMLAttributes<HTMLDivElement>) {
  return (
    <div
      className={cn(
        'glass-card p-6',
        'animate-fade-in-up',
        className
      )}
      {...props}
    >
      {children}
    </div>
  );
}

interface StatCardProps {
  title: string;
  value: number | string;
  icon: React.ReactNode;
  change?: { value: number; label: string };
  trend?: 'up' | 'down' | 'neutral';
  className?: string;
  delay?: number;
}

export function StatCard({
  title,
  value,
  icon,
  change,
  trend = 'neutral',
  className,
  delay = 0,
}: StatCardProps) {
  const trendColors = {
    up: 'text-emerald-500',
    down: 'text-red-500',
    neutral: 'text-muted-foreground',
  };

  return (
    <div
      className={cn(
        'relative overflow-hidden rounded-xl border bg-card p-6',
        'animate-fade-in-up opacity-0 hover-lift',
        className
      )}
      style={{
        animationDelay: `${delay}ms`,
        animationFillMode: 'forwards',
      }}
    >
      <div className="flex items-start justify-between">
        <div>
          <p className="text-sm font-medium text-muted-foreground">{title}</p>
          <p className="mt-2 text-3xl font-bold">
            {typeof value === 'number' ? (
              <AnimatedNumber value={value} />
            ) : (
              value
            )}
          </p>
          {change && (
            <p className={cn('mt-1 text-sm flex items-center gap-1', trendColors[trend])}>
              {trend === 'up' && '↑'}
              {trend === 'down' && '↓'}
              <span className="font-medium">{change.value > 0 ? '+' : ''}{change.value}</span>
              <span className="text-muted-foreground">{change.label}</span>
            </p>
          )}
        </div>
        <div className="p-3 rounded-lg bg-primary/10 text-primary">
          {icon}
        </div>
      </div>
      
      {/* Decorative gradient */}
      <div className="absolute -right-8 -bottom-8 w-32 h-32 rounded-full bg-primary/5 blur-2xl" />
    </div>
  );
}
