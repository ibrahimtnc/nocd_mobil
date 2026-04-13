import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:ocdcoach/src/core/constants/app_constants.dart';

/// Glassmorphism card widget
/// Creates a frosted glass effect with blur and transparency
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Color? borderColor;
  final double borderWidth;
  final double blurIntensity;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.borderRadius,
    this.borderColor,
    this.borderWidth = 1.0,
    this.blurIntensity = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    final defaultBorderRadius = borderRadius ??
        BorderRadius.circular(AppConstants.defaultBorderRadius);

    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: defaultBorderRadius,
        border: Border.all(
          color: borderColor ?? Colors.white.withOpacity(0.3),
          width: borderWidth,
        ),
      ),
      child: ClipRRect(
        borderRadius: defaultBorderRadius,
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(
            sigmaX: blurIntensity,
            sigmaY: blurIntensity,
          ),
          child: Container(
            padding: padding ?? const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: defaultBorderRadius,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

