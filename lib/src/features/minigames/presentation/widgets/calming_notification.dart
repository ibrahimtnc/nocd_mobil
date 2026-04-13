import 'package:flutter/material.dart';
import 'package:ocdcoach/src/core/theme/app_colors.dart';
import 'package:ocdcoach/src/core/theme/app_text_styles.dart';

/// Calming notification widget
/// Shows supportive messages during the mini-game
class CalmingNotification extends StatelessWidget {
  final String message;
  final Duration duration;

  const CalmingNotification({
    super.key,
    required this.message,
    this.duration = const Duration(seconds: 4),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.95),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.favorite,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              message,
              style: AppTextStyles.bodyMedium(
                color: Colors.white,
              ).copyWith(
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  static void show(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
  }) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 16,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: CalmingNotification(
            message: message,
            duration: duration,
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(duration, () {
      overlayEntry.remove();
    });
  }
}

