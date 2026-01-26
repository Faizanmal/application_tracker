'use client';

import * as React from 'react';
import { cn } from '@/lib/utils';

interface AnimatedCardProps extends React.HTMLAttributes<HTMLDivElement> {
  variant?: 'default' | 'glass' | 'gradient' | 'premium' | 'interactive';
  hoverEffect?: 'lift' | 'scale' | 'glow' | 'none';
  animateIn?: boolean;
  delay?: number;
}

const AnimatedCard = React.forwardRef<HTMLDivElement, AnimatedCardProps>(
  ({ className, variant = 'default', hoverEffect = 'lift', animateIn = true, delay = 0, children, style, ...props }, ref) => {
    const variantClasses = {
      default: 'bg-card border border-border rounded-xl shadow-sm',
      glass: 'glass-card',
      gradient: 'gradient-border bg-card rounded-xl shadow-md',
      premium: 'card-premium rounded-xl shadow-lg',
      interactive: 'card-interactive bg-card border border-border rounded-xl shadow-sm',
    };

    const hoverClasses = {
      lift: 'hover-lift',
      scale: 'hover-scale',
      glow: 'hover-glow',
      none: '',
    };

    return (
      <div
        ref={ref}
        className={cn(
          variantClasses[variant],
          hoverClasses[hoverEffect],
          animateIn && 'animate-fade-in-up opacity-0',
          className
        )}
        style={{
          ...style,
          animationDelay: animateIn ? `${delay}ms` : undefined,
          animationFillMode: 'forwards',
        }}
        {...props}
      >
        {children}
      </div>
    );
  }
);
AnimatedCard.displayName = 'AnimatedCard';

const AnimatedCardHeader = React.forwardRef<HTMLDivElement, React.HTMLAttributes<HTMLDivElement>>(
  ({ className, ...props }, ref) => (
    <div ref={ref} className={cn('flex flex-col space-y-1.5 p-6', className)} {...props} />
  )
);
AnimatedCardHeader.displayName = 'AnimatedCardHeader';

interface AnimatedCardTitleProps extends React.HTMLAttributes<HTMLHeadingElement> {
  gradient?: boolean;
}

const AnimatedCardTitle = React.forwardRef<HTMLHeadingElement, AnimatedCardTitleProps>(
  ({ className, gradient = false, ...props }, ref) => (
    <h3
      ref={ref}
      className={cn(
        'text-xl font-semibold leading-none tracking-tight',
        gradient && 'gradient-text',
        className
      )}
      {...props}
    />
  )
);
AnimatedCardTitle.displayName = 'AnimatedCardTitle';

const AnimatedCardDescription = React.forwardRef<HTMLParagraphElement, React.HTMLAttributes<HTMLParagraphElement>>(
  ({ className, ...props }, ref) => (
    <p ref={ref} className={cn('text-sm text-muted-foreground', className)} {...props} />
  )
);
AnimatedCardDescription.displayName = 'AnimatedCardDescription';

const AnimatedCardContent = React.forwardRef<HTMLDivElement, React.HTMLAttributes<HTMLDivElement>>(
  ({ className, ...props }, ref) => (
    <div ref={ref} className={cn('p-6 pt-0', className)} {...props} />
  )
);
AnimatedCardContent.displayName = 'AnimatedCardContent';

const AnimatedCardFooter = React.forwardRef<HTMLDivElement, React.HTMLAttributes<HTMLDivElement>>(
  ({ className, ...props }, ref) => (
    <div ref={ref} className={cn('flex items-center p-6 pt-0', className)} {...props} />
  )
);
AnimatedCardFooter.displayName = 'AnimatedCardFooter';

export {
  AnimatedCard,
  AnimatedCardHeader,
  AnimatedCardTitle,
  AnimatedCardDescription,
  AnimatedCardContent,
  AnimatedCardFooter,
};
