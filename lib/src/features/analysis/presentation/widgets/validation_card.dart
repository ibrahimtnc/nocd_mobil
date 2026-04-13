import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ocdcoach/src/core/constants/app_constants.dart';
import 'package:ocdcoach/src/core/theme/app_colors.dart';
import 'package:ocdcoach/src/core/theme/app_text_styles.dart';
import 'package:ocdcoach/src/core/widgets/bento_card.dart';
import 'package:ocdcoach/src/shared/providers/localization_provider.dart';

/// Validation card widget
/// Shows empathetic validation message with waiting time
class ValidationCard extends ConsumerWidget {
  final String message;
  final int waitDurationSeconds;

  const ValidationCard({
    super.key,
    required this.message,
    required this.waitDurationSeconds,
  });

  String _formatDuration(int seconds, String locale) {
    if (seconds < 60) {
      return locale == 'tr' 
          ? '$seconds saniye'
          : '$seconds ${seconds == 1 ? 'second' : 'seconds'}';
    }
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    if (remainingSeconds == 0) {
      return locale == 'tr'
          ? '$minutes ${minutes == 1 ? 'dakika' : 'dakika'}'
          : '$minutes ${minutes == 1 ? 'minute' : 'minutes'}';
    }
    return locale == 'tr'
        ? '$minutes dakika $remainingSeconds saniye'
        : '$minutes ${minutes == 1 ? 'minute' : 'minutes'} $remainingSeconds ${remainingSeconds == 1 ? 'second' : 'seconds'}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = ref.watch(localizationProvider);
    
    return localization.when(
      data: (loc) {
        final durationText = _formatDuration(waitDurationSeconds, loc.currentLanguage);
        final waitedText = loc.getString('you_waited_duration').replaceAll('{0}', durationText);
        
        return BentoCard(
          padding: const EdgeInsets.all(24),
          backgroundColor: AppColors.primary.withOpacity(0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Message text
              Text(
                message,
                style: AppTextStyles.bodyLarge(
                  color: AppColors.textPrimary,
                ).copyWith(
                  height: 1.6,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 16),
              // Wait duration badge - centered
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.timer_outlined,
                        size: 18,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        waitedText,
                        style: AppTextStyles.bodyMedium(
                          color: AppColors.primary,
                        ).copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => BentoCard(
        padding: const EdgeInsets.all(AppConstants.largePadding),
        backgroundColor: AppColors.primary.withOpacity(0.03),
        child: Text(
          message,
          style: AppTextStyles.bodyLarge(
            color: AppColors.textPrimary,
          ),
        ),
      ),
      error: (_, __) => BentoCard(
        padding: const EdgeInsets.all(AppConstants.largePadding),
        backgroundColor: AppColors.primary.withOpacity(0.03),
        child: Text(
          message,
          style: AppTextStyles.bodyLarge(
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
