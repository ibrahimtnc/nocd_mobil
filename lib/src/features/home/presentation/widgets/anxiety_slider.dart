import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ocdcoach/src/core/constants/app_constants.dart';
import 'package:ocdcoach/src/core/theme/app_colors.dart';
import 'package:ocdcoach/src/core/theme/app_text_styles.dart';
import 'package:ocdcoach/src/shared/providers/localization_provider.dart';

/// Anxiety level slider widget
/// Visual slider that changes color from Teal (1) to Terracotta (10)
class AnxietySlider extends ConsumerWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const AnxietySlider({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final anxietyColor = AppColors.getAnxietyColor(value);
    final localizationAsync = ref.watch(localizationProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        localizationAsync.when(
          data: (service) => Text(
            service.getString('anxiety_question'),
            style: AppTextStyles.h3(color: AppColors.textPrimary),
          ),
          loading: () => Text(
            'How strong is the anxiety right now?',
            style: AppTextStyles.h3(color: AppColors.textPrimary),
          ),
          error: (_, __) => Text(
            'How strong is the anxiety right now?',
            style: AppTextStyles.h3(color: AppColors.textPrimary),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Text(
              '1',
              style: AppTextStyles.bodyMedium(color: AppColors.anxietyLow),
            ),
            Expanded(
              child: Slider(
                value: value.toDouble(),
                min: AppConstants.minAnxietyLevel.toDouble(),
                max: AppConstants.maxAnxietyLevel.toDouble(),
                divisions: 9,
                label: value.toString(),
                activeColor: anxietyColor,
                inactiveColor: AppColors.lightGrey, // Thick, solid track - Phase 4
                onChanged: (newValue) {
                  onChanged(newValue.toInt());
                },
              ),
            ),
            Text(
              '10',
              style: AppTextStyles.bodyMedium(color: AppColors.anxietyHigh),
            ),
          ],
        ),
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: anxietyColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: localizationAsync.when(
              data: (service) => Text(
                '${service.getString('anxiety_level')} $value',
                style: AppTextStyles.bodyMedium(color: anxietyColor),
              ),
              loading: () => Text(
                'Level $value',
                style: AppTextStyles.bodyMedium(color: anxietyColor),
              ),
              error: (_, __) => Text(
                'Level $value',
                style: AppTextStyles.bodyMedium(color: anxietyColor),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

