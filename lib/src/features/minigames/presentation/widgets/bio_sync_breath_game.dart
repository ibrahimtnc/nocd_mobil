import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ocdcoach/src/core/theme/app_colors.dart';
import 'package:ocdcoach/src/core/theme/app_text_styles.dart';
import 'package:ocdcoach/src/core/widgets/content_card.dart';
import 'package:ocdcoach/src/features/minigames/presentation/widgets/interactive_breathing_lottie.dart';
import 'package:ocdcoach/src/shared/providers/localization_provider.dart';

/// Bio-Sync Breath game
/// Interactive breathing exercise using Lottie animation
class BioSyncBreathGame extends ConsumerWidget {
  const BioSyncBreathGame({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizationAsync = ref.watch(localizationProvider);
    
    return Column(
      children: [
        // Tip overlay
        localizationAsync.when(
          data: (localization) => ContentCard(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    localization.getString('why_am_i_doing_this'),
                    style: AppTextStyles.bodySmall(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          loading: () => ContentCard(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Why am I doing this? We are delaying the urge to check, allowing your brain\'s alarm system to reset naturally.',
                    style: AppTextStyles.bodySmall(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          error: (_, __) => ContentCard(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Why am I doing this? We are delaying the urge to check, allowing your brain\'s alarm system to reset naturally.',
                    style: AppTextStyles.bodySmall(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Interactive breathing
        const Expanded(
          child: InteractiveBreathingLottie(),
        ),
      ],
    );
  }
}

