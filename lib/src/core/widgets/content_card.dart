import 'package:flutter/material.dart';
import 'package:ocdcoach/src/core/theme/app_colors.dart';

/// ContentCard widget - Phase 5 Editorial Design
/// Bento Card style: no shadow, subtle border, clean editorial look
class ContentCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;

  const ContentCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.borderRadius,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final defaultBorderRadius = borderRadius ?? BorderRadius.circular(20);

    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surface, // Pure white
        borderRadius: defaultBorderRadius,
        border: Border.all(
          color: AppColors.borderSubtle,
          width: 1,
        ),
        // No shadow - clean editorial look
      ),
      child: ClipRRect(
        borderRadius: defaultBorderRadius,
        child: Padding(
          padding: padding ?? const EdgeInsets.all(24),
          child: child,
        ),
      ),
    );
  }
}

