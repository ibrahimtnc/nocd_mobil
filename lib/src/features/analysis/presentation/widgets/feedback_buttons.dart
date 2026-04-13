import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:confetti/confetti.dart';
import 'package:go_router/go_router.dart';
import 'package:ocdcoach/src/core/constants/app_constants.dart';
import 'package:ocdcoach/src/core/theme/app_colors.dart';
import 'package:ocdcoach/src/core/theme/app_text_styles.dart';
import 'package:ocdcoach/src/core/widgets/content_card.dart';
import 'package:ocdcoach/src/shared/providers/localization_provider.dart';

/// Feedback buttons widget
/// Shows "I feel better" and "I'm still anxious" buttons
class FeedbackButtons extends ConsumerStatefulWidget {
  final VoidCallback? onSatisfied;
  final VoidCallback? onNotSatisfied;

  const FeedbackButtons({
    super.key,
    this.onSatisfied,
    this.onNotSatisfied,
  });

  @override
  ConsumerState<FeedbackButtons> createState() => _FeedbackButtonsState();
}

class _FeedbackButtonsState extends ConsumerState<FeedbackButtons> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _handleSatisfied() {
    _confettiController.play();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (widget.onSatisfied != null) {
        widget.onSatisfied!();
      } else {
        context.go('/home');
      }
    });
  }

  void _handleNotSatisfied() {
    if (widget.onNotSatisfied != null) {
      widget.onNotSatisfied!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = ref.watch(localizationProvider);
    
    return localization.when(
      data: (loc) => Stack(
        children: [
          ContentCard(
            padding: const EdgeInsets.all(AppConstants.largePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loc.getString('did_this_help'),
                  style: AppTextStyles.h3(color: AppColors.textPrimary),
                ),
                const SizedBox(height: 20),
                // Buttons in column for better layout on small screens
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _handleSatisfied,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.anxietyLow,
                          foregroundColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          loc.getString('i_feel_better'),
                          style: AppTextStyles.button(color: AppColors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: _handleNotSatisfied,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          side: const BorderSide(
                            color: AppColors.textSecondary,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          loc.getString('still_anxious'),
                          style: AppTextStyles.button(color: AppColors.textPrimary),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Confetti overlay
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: 3.14 / 2,
              maxBlastForce: 5,
              minBlastForce: 2,
              emissionFrequency: 0.05,
              numberOfParticles: 50,
              gravity: 0.1,
            ),
          ),
        ],
      ),
      loading: () => ContentCard(
        padding: const EdgeInsets.all(AppConstants.largePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Did this help?',
              style: AppTextStyles.h3(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _handleSatisfied,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.anxietyLow,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('I feel better / Understood'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: _handleNotSatisfied,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      side: const BorderSide(
                        color: AppColors.textSecondary,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('I\'m still anxious / Not satisfied'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      error: (_, __) => ContentCard(
        padding: const EdgeInsets.all(AppConstants.largePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Did this help?',
              style: AppTextStyles.h3(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _handleSatisfied,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.anxietyLow,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('I feel better / Understood'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: _handleNotSatisfied,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      side: const BorderSide(
                        color: AppColors.textSecondary,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('I\'m still anxious / Not satisfied'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

