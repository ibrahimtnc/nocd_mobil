import 'package:flutter/material.dart';
import 'package:ocdcoach/src/core/theme/app_colors.dart';
import 'package:ocdcoach/src/core/theme/app_text_styles.dart';

/// Countdown timer widget
/// Shows remaining time in MM:SS format
class CountdownTimer extends StatelessWidget {
  final int remainingSeconds;

  const CountdownTimer({
    super.key,
    required this.remainingSeconds,
  });

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.timer,
            color: AppColors.primary,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            _formatTime(remainingSeconds),
            style: AppTextStyles.h3(color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

