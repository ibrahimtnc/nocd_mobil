import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ocdcoach/src/core/constants/app_constants.dart';
import 'package:ocdcoach/src/core/theme/app_colors.dart';
import 'package:ocdcoach/src/core/theme/app_text_styles.dart';
import 'package:ocdcoach/src/core/widgets/bento_card.dart';
import 'package:ocdcoach/src/shared/providers/localization_provider.dart';

/// Expandable mechanics card
/// Shows detailed scientific explanation with expand/collapse
class ExpandableMechanicsCard extends ConsumerStatefulWidget {
  final String explanation;
  final String titleKey;

  const ExpandableMechanicsCard({
    super.key,
    required this.explanation,
    this.titleKey = 'the_science_behind_it',
  });

  @override
  ConsumerState<ExpandableMechanicsCard> createState() =>
      _ExpandableMechanicsCardState();
}

class _ExpandableMechanicsCardState extends ConsumerState<ExpandableMechanicsCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final localization = ref.watch(localizationProvider);
    
    return localization.when(
      data: (loc) => BentoCard(
        padding: const EdgeInsets.all(AppConstants.largePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Row(
                children: [
                  const Icon(
                    Icons.science,
                    color: AppColors.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      loc.getString(widget.titleKey),
                      style: AppTextStyles.h3(color: AppColors.textPrimary),
                    ),
                  ),
                  Icon(
                    _isExpanded
                        ? Icons.expand_less
                        : Icons.expand_more,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
            if (_isExpanded) ...[
              const SizedBox(height: 16),
              Text(
                widget.explanation,
                style: AppTextStyles.bodyMedium(
                  color: AppColors.textSecondary,
                ).copyWith(
                  height: 1.6,
                ),
              ),
            ],
          ],
        ),
      ),
      loading: () => BentoCard(
        padding: const EdgeInsets.all(AppConstants.largePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.science,
                  color: AppColors.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.titleKey == 'the_science_behind_it' 
                        ? 'The Science Behind It'
                        : 'Why This Happens (OCD Explained)',
                    style: AppTextStyles.h3(color: AppColors.textPrimary),
                  ),
                ),
                Icon(
                  _isExpanded
                      ? Icons.expand_less
                      : Icons.expand_more,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
            if (_isExpanded) ...[
              const SizedBox(height: 16),
              Text(
                widget.explanation,
                style: AppTextStyles.bodyMedium(
                  color: AppColors.textSecondary,
                ).copyWith(
                  height: 1.6,
                ),
              ),
            ],
          ],
        ),
      ),
      error: (_, __) => BentoCard(
        padding: const EdgeInsets.all(AppConstants.largePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.science,
                  color: AppColors.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.titleKey == 'the_science_behind_it' 
                        ? 'The Science Behind It'
                        : 'Why This Happens (OCD Explained)',
                    style: AppTextStyles.h3(color: AppColors.textPrimary),
                  ),
                ),
                Icon(
                  _isExpanded
                      ? Icons.expand_less
                      : Icons.expand_more,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
            if (_isExpanded) ...[
              const SizedBox(height: 16),
              Text(
                widget.explanation,
                style: AppTextStyles.bodyMedium(
                  color: AppColors.textSecondary,
                ).copyWith(
                  height: 1.6,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

