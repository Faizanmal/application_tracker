import 'package:flutter/material.dart';

/// Animation utilities for consistent animations across the app
class AppAnimations {
  AppAnimations._();

  // ===== DURATIONS =====
  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationNormal = Duration(milliseconds: 300);
  static const Duration durationSlow = Duration(milliseconds: 500);
  static const Duration durationVerySlow = Duration(milliseconds: 800);

  // ===== CURVES =====
  static const Curve curveDefault = Curves.easeOutCubic;
  static const Curve curveEnter = Curves.easeOut;
  static const Curve curveExit = Curves.easeIn;
  static const Curve curveBounce = Curves.elasticOut;
  static const Curve curveSpring = Curves.easeOutBack;
  static const Curve curveSmooth = Curves.easeInOutCubic;

  /// Fade in animation
  static Widget fadeIn({
    required Widget child,
    Duration duration = durationNormal,
    Duration delay = Duration.zero,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration + delay,
      curve: curveDefault,
      builder: (context, value, child) {
        final opacity = delay == Duration.zero
            ? value
            : (value - delay.inMilliseconds / (duration + delay).inMilliseconds)
                .clamp(0.0, 1.0);
        return Opacity(opacity: opacity, child: child);
      },
      child: child,
    );
  }

  /// Slide up and fade in animation
  static Widget slideUp({
    required Widget child,
    Duration duration = durationNormal,
    double offset = 20.0,
    Curve curve = curveDefault,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, offset * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: child,
    );
  }

  /// Slide from left animation
  static Widget slideFromLeft({
    required Widget child,
    Duration duration = durationNormal,
    double offset = 30.0,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration,
      curve: curveDefault,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(-offset * (1 - value), 0),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: child,
    );
  }

  /// Slide from right animation
  static Widget slideFromRight({
    required Widget child,
    Duration duration = durationNormal,
    double offset = 30.0,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration,
      curve: curveDefault,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(offset * (1 - value), 0),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: child,
    );
  }

  /// Scale in animation
  static Widget scaleIn({
    required Widget child,
    Duration duration = durationNormal,
    double beginScale = 0.8,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration,
      curve: curveSpring,
      builder: (context, value, child) {
        final scale = beginScale + (1 - beginScale) * value;
        return Transform.scale(
          scale: scale,
          child: Opacity(opacity: value, child: child),
        );
      },
      child: child,
    );
  }

  /// Bounce animation
  static Widget bounce({
    required Widget child,
    Duration duration = durationSlow,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration,
      curve: curveBounce,
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: child,
    );
  }

  /// Shimmer effect for loading states
  static Widget shimmer({
    required Widget child,
    Color baseColor = const Color(0xFFE5E7EB),
    Color highlightColor = const Color(0xFFF3F4F6),
  }) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return LinearGradient(
          colors: [baseColor, highlightColor, baseColor],
          stops: const [0.0, 0.5, 1.0],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          tileMode: TileMode.mirror,
        ).createShader(bounds);
      },
      child: child,
    );
  }

  /// Staggered animation for list items
  static Duration staggeredDelay(int index, {Duration interval = const Duration(milliseconds: 50)}) {
    return Duration(milliseconds: interval.inMilliseconds * index);
  }
}

/// Animated counter widget
class AnimatedCounter extends StatelessWidget {
  final int value;
  final TextStyle? style;
  final Duration duration;
  final String prefix;
  final String suffix;

  const AnimatedCounter({
    super.key,
    required this.value,
    this.style,
    this.duration = const Duration(milliseconds: 800),
    this.prefix = '',
    this.suffix = '',
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value.toDouble()),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Text(
          '$prefix${value.toInt()}$suffix',
          style: style,
        );
      },
    );
  }
}

/// Animated progress bar
class AnimatedProgressBar extends StatelessWidget {
  final double value;
  final double height;
  final Color? backgroundColor;
  final Gradient? gradient;
  final Color? color;
  final Duration duration;
  final BorderRadius? borderRadius;

  const AnimatedProgressBar({
    super.key,
    required this.value,
    this.height = 8,
    this.backgroundColor,
    this.gradient,
    this.color,
    this.duration = const Duration(milliseconds: 600),
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(height / 2);
    
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colorScheme.surfaceContainerHighest,
        borderRadius: effectiveBorderRadius,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: value.clamp(0.0, 1.0)),
            duration: duration,
            curve: Curves.easeOutCubic,
            builder: (context, animatedValue, child) {
              return Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: constraints.maxWidth * animatedValue,
                  decoration: BoxDecoration(
                    gradient: gradient,
                    color: gradient == null ? (color ?? theme.colorScheme.primary) : null,
                    borderRadius: effectiveBorderRadius,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

/// Pulse animation widget
class PulseAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double minScale;
  final double maxScale;

  const PulseAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1500),
    this.minScale = 0.95,
    this.maxScale = 1.05,
  });

  @override
  State<PulseAnimation> createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<PulseAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true);
    
    _animation = Tween<double>(
      begin: widget.minScale,
      end: widget.maxScale,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: widget.child,
    );
  }
}

/// Floating animation widget
class FloatingAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double offset;

  const FloatingAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 2000),
    this.offset = 8.0,
  });

  @override
  State<FloatingAnimation> createState() => _FloatingAnimationState();
}

class _FloatingAnimationState extends State<FloatingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true);
    
    _animation = Tween<double>(
      begin: -widget.offset,
      end: widget.offset,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// Staggered list animation
class StaggeredList extends StatelessWidget {
  final List<Widget> children;
  final Duration delay;
  final Duration itemDuration;
  final double offsetY;

  const StaggeredList({
    super.key,
    required this.children,
    this.delay = const Duration(milliseconds: 50),
    this.itemDuration = const Duration(milliseconds: 300),
    this.offsetY = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(children.length, (index) {
        return TweenAnimationBuilder<double>(
          key: ValueKey(index),
          tween: Tween(begin: 0.0, end: 1.0),
          duration: itemDuration + Duration(milliseconds: delay.inMilliseconds * index),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            final progress = ((value - (delay.inMilliseconds * index / (itemDuration + delay * children.length).inMilliseconds))).clamp(0.0, 1.0);
            return Transform.translate(
              offset: Offset(0, offsetY * (1 - progress)),
              child: Opacity(opacity: progress, child: child),
            );
          },
          child: children[index],
        );
      }),
    );
  }
}

/// Glow effect widget
class GlowEffect extends StatelessWidget {
  final Widget child;
  final Color glowColor;
  final double blurRadius;
  final double spreadRadius;

  const GlowEffect({
    super.key,
    required this.child,
    required this.glowColor,
    this.blurRadius = 20,
    this.spreadRadius = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: glowColor.withOpacity(0.4),
            blurRadius: blurRadius,
            spreadRadius: spreadRadius,
          ),
        ],
      ),
      child: child,
    );
  }
}
