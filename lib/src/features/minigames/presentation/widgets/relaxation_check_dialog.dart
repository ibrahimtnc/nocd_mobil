import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ocdcoach/src/core/constants/app_constants.dart';
import 'package:ocdcoach/src/core/theme/app_colors.dart';
import 'package:ocdcoach/src/core/theme/app_text_styles.dart';
import 'package:ocdcoach/src/core/widgets/content_card.dart';
import 'package:ocdcoach/src/core/services/localization_service.dart';
import 'package:ocdcoach/src/features/home/presentation/widgets/anxiety_slider.dart';
import 'package:ocdcoach/src/shared/providers/localization_provider.dart';

/// Relaxation check dialog
/// Measures anxiety level after the mini-game
class RelaxationCheckDialog extends ConsumerStatefulWidget {
  final int initialAnxietyLevel;
  final String? thought;
  final int durationSeconds;

  const RelaxationCheckDialog({
    super.key,
    required this.initialAnxietyLevel,
    this.thought,
    required this.durationSeconds,
  });

  @override
  ConsumerState<RelaxationCheckDialog> createState() => _RelaxationCheckDialogState();
}

class _RelaxationCheckDialogState extends ConsumerState<RelaxationCheckDialog> {
  int _currentAnxietyLevel = 5;
  bool _hasSelected = false;

  @override
  void initState() {
    super.initState();
    _currentAnxietyLevel = widget.initialAnxietyLevel;
  }

  void _handleContinue() {
    if (!_hasSelected) return;

    final localizationAsync = ref.read(localizationProvider);
    localizationAsync.whenData((localization) {
      final anxietyReduced = _currentAnxietyLevel < widget.initialAnxietyLevel;
      final anxietyReduction = widget.initialAnxietyLevel - _currentAnxietyLevel;
      final currentContext = context;

      Navigator.of(currentContext).pop();

      // Show feedback based on anxiety change BEFORE navigation
      if (anxietyReduced && anxietyReduction >= 2) {
        final message = localization.getString('calmed_down_message')
            .replaceAll('{0}', widget.initialAnxietyLevel.toString())
            .replaceAll('{1}', _currentAnxietyLevel.toString());
        _showFeedbackDialog(
          currentContext,
          localization.getString('you_calmed_down'),
          message,
          true,
          localization: localization,
          onContinue: (dialogContext) {
            // Navigate to analysis with updated anxiety level
            if (widget.thought != null) {
              dialogContext.go(
                '/analysis?thought=${Uri.encodeComponent(widget.thought!)}&anxietyLevel=$_currentAnxietyLevel&waitDuration=${widget.durationSeconds}',
              );
            } else {
              dialogContext.go('/home');
            }
          },
        );
      } else if (anxietyReduced) {
        final message = localization.getString('small_steps_message')
            .replaceAll('{0}', widget.initialAnxietyLevel.toString())
            .replaceAll('{1}', _currentAnxietyLevel.toString());
        _showFeedbackDialog(
          currentContext,
          localization.getString('small_steps_matter'),
          message,
          true,
          localization: localization,
          onContinue: (dialogContext) {
            // Navigate to analysis with updated anxiety level
            if (widget.thought != null) {
              dialogContext.go(
                '/analysis?thought=${Uri.encodeComponent(widget.thought!)}&anxietyLevel=$_currentAnxietyLevel&waitDuration=${widget.durationSeconds}',
              );
            } else {
              dialogContext.go('/home');
            }
          },
        );
      } else if (_currentAnxietyLevel == widget.initialAnxietyLevel) {
        final message = localization.getString('anxiety_stayed_message')
            .replaceAll('{0}', widget.initialAnxietyLevel.toString());
        _showFeedbackDialog(
          currentContext,
          localization.getString('thats_okay'),
          message,
          false,
          localization: localization,
          onContinue: (dialogContext) {
            // Navigate to analysis with updated anxiety level
            if (widget.thought != null) {
              dialogContext.go(
                '/analysis?thought=${Uri.encodeComponent(widget.thought!)}&anxietyLevel=$_currentAnxietyLevel&waitDuration=${widget.durationSeconds}',
              );
            } else {
              dialogContext.go('/home');
            }
          },
        );
      } else {
        // Anxiety increased - still navigate but with message
        _showFeedbackDialog(
          currentContext,
          localization.getString('thats_okay'),
          localization.getString('anxiety_fluctuated_message'),
          false,
          localization: localization,
          onContinue: (dialogContext) {
            // Navigate to analysis with updated anxiety level
            if (widget.thought != null) {
              dialogContext.go(
                '/analysis?thought=${Uri.encodeComponent(widget.thought!)}&anxietyLevel=$_currentAnxietyLevel&waitDuration=${widget.durationSeconds}',
              );
            } else {
              dialogContext.go('/home');
            }
          },
        );
      }
    });
  }

  void _showFeedbackDialog(
    BuildContext context,
    String title,
    String message,
    bool isPositive, {
    required LocalizationService localization,
    required void Function(BuildContext) onContinue,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: Text(
          title,
          style: AppTextStyles.h2(
            color: isPositive ? AppColors.primary : AppColors.textPrimary,
          ),
        ),
        content: Text(
          message,
          style: AppTextStyles.bodyMedium(
            color: AppColors.textPrimary,
          ).copyWith(
            height: 1.6,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              // Use dialogContext for navigation to ensure it's still valid
              onContinue(dialogContext);
            },
            child: Text(
              localization.getString('continue'),
              style: AppTextStyles.button(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizationAsync = ref.watch(localizationProvider);
    
    return localizationAsync.when(
      data: (localization) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: ContentCard(
          padding: const EdgeInsets.all(AppConstants.largePadding),
          margin: EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.self_improvement,
                      color: AppColors.primary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      localization.getString('how_are_you_feeling_now'),
                      style: AppTextStyles.h2(color: AppColors.textPrimary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                localization.getString('take_moment_check_anxiety'),
                style: AppTextStyles.bodyMedium(
                  color: AppColors.textSecondary,
                ).copyWith(
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              AnxietySlider(
                value: _currentAnxietyLevel,
                onChanged: (level) {
                  setState(() {
                    _currentAnxietyLevel = level;
                    _hasSelected = true;
                  });
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _hasSelected ? _handleContinue : null,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                  ),
                  child: Text(localization.getString('continue_to_analysis')),
                ),
              ),
            ],
          ),
        ),
      ),
      loading: () => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Padding(
          padding: EdgeInsets.all(24.0),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (_, __) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: ContentCard(
          padding: const EdgeInsets.all(AppConstants.largePadding),
          margin: EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.self_improvement,
                      color: AppColors.primary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'How are you feeling now?',
                      style: AppTextStyles.h2(color: AppColors.textPrimary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Take a moment to check in with yourself. How strong is your anxiety right now?',
                style: AppTextStyles.bodyMedium(
                  color: AppColors.textSecondary,
                ).copyWith(
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              AnxietySlider(
                value: _currentAnxietyLevel,
                onChanged: (level) {
                  setState(() {
                    _currentAnxietyLevel = level;
                    _hasSelected = true;
                  });
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _hasSelected ? _handleContinue : null,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                  ),
                  child: const Text('Continue to Analysis'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

