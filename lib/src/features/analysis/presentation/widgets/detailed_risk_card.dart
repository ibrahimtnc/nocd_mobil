import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ocdcoach/src/core/constants/app_constants.dart';
import 'package:ocdcoach/src/core/theme/app_colors.dart';
import 'package:ocdcoach/src/core/theme/app_text_styles.dart';
import 'package:ocdcoach/src/core/widgets/bento_card.dart';
import 'package:ocdcoach/src/shared/providers/localization_provider.dart';

/// Detailed Risk Analysis Card
/// Shows comprehensive risk comparison with clear visualizations
/// Phase 5: Editorial style with Bento Card
class DetailedRiskCard extends ConsumerWidget {
  final double perceivedRiskPercent;
  final String perceivedReason;
  final double actualRiskPercent;
  final String actualReason;
  final String comparisonAnalogy;
  final double safetyPercent;
  final String analysisSummary;
  final int anxietyLevel;

  const DetailedRiskCard({
    super.key,
    required this.perceivedRiskPercent,
    required this.perceivedReason,
    required this.actualRiskPercent,
    required this.actualReason,
    required this.comparisonAnalogy,
    required this.safetyPercent,
    required this.analysisSummary,
    required this.anxietyLevel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final riskDifference = perceivedRiskPercent - actualRiskPercent;
    final isHighAnxiety = anxietyLevel >= 7;
    final localization = ref.watch(localizationProvider);

    return localization.when(
      data: (loc) {
        final whatYouFeel = loc.getString('what_you_feel');
        final actualReality = loc.getString('actual_reality');
        final safetyLevel = loc.getString('safety_level');
        final whatThisMeans = loc.getString('what_this_means');
        final riskDiffMessage = riskDifference > 30
            ? loc.getString('risk_difference_message').replaceAll('{0}', riskDifference.toStringAsFixed(1))
            : null;

        // Clamp percentages for realistic display
        final displayPerceived = perceivedRiskPercent.clamp(0.0, 100.0);
        final displayActual = actualRiskPercent.clamp(0.0, 100.0);
        final displaySafety = safetyPercent.clamp(0.0, 100.0);

        return BentoCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header - Consistent icon and title
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.analytics,
                      color: AppColors.primary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      loc.getString('risk_analysis'),
                      style: AppTextStyles.h2(color: AppColors.textPrimary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Perceived vs Actual Risk Comparison
              Row(
                children: [
                  Expanded(
                    child: _buildRiskBox(
                      whatYouFeel,
                      displayPerceived,
                      AppColors.anxietyHigh,
                      perceivedReason,
                      isHighRisk: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildRiskBox(
                      actualReality,
                      displayActual,
                      AppColors.primary,
                      actualReason,
                      isHighRisk: false,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Comparison Analogy - Editorial highlight
              if (comparisonAnalogy.isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.borderSubtle,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.auto_awesome,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          comparisonAnalogy,
                          style: AppTextStyles.bodyMedium(
                            color: AppColors.textPrimary,
                          ).copyWith(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w500,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
              
              // Safety Percentage with visual indicator
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.borderSubtle,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.shield,
                        color: AppColors.primary,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            safetyLevel,
                            style: AppTextStyles.bodyMedium(
                              color: AppColors.textSecondary,
                            ).copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${displaySafety.toStringAsFixed(1)}%',
                                style: AppTextStyles.h1(
                                  color: AppColors.primary,
                                ).copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28,
                                  height: 1.0,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 2),
                                child: Icon(
                                  Icons.check_circle,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: displaySafety / 100,
                              minHeight: 6,
                              backgroundColor: AppColors.primary.withOpacity(0.2),
                              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              
              // Analysis Summary
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: (isHighAnxiety
                      ? AppColors.anxietyHigh.withOpacity(0.08)
                      : AppColors.secondary.withOpacity(0.2)),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.borderSubtle,
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: (isHighAnxiety
                                ? AppColors.anxietyHigh
                                : AppColors.primary).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.psychology_outlined,
                            color: isHighAnxiety
                                ? AppColors.anxietyHigh
                                : AppColors.primary,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            whatThisMeans,
                            style: AppTextStyles.h3(
                              color: AppColors.textPrimary,
                            ).copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      analysisSummary,
                      style: AppTextStyles.bodyMedium(
                        color: AppColors.textPrimary,
                      ).copyWith(
                        height: 1.6,
                      ),
                    ),
                    if (riskDiffMessage != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColors.borderSubtle,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.lightbulb,
                                color: AppColors.primary,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                riskDiffMessage,
                                style: AppTextStyles.bodyMedium(
                                  color: AppColors.textPrimary,
                                ).copyWith(
                                  height: 1.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
      loading: () => _buildLoadingCard(),
      error: (_, __) => _buildLoadingCard(),
    );
  }

  Widget _buildLoadingCard() {
    return BentoCard(
      padding: const EdgeInsets.all(AppConstants.largePadding),
      child: Column(
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
                  Icons.analytics,
                  color: AppColors.primary,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Risk Analysis',
                  style: AppTextStyles.h2(color: AppColors.textPrimary),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRiskBox(
    String label,
    double percentage,
    Color color,
    String reason, {
    required bool isHighRisk,
  }) {
    // Clamp percentage to 0-100 for display
    final displayPercentage = percentage.clamp(0.0, 100.0);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(isHighRisk ? 0.08 : 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.borderSubtle,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label with icon
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isHighRisk ? Icons.warning_amber_rounded : Icons.insights,
                  color: color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.bodyMedium(
                    color: AppColors.textPrimary,
                  ).copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Large percentage display
          Text(
            '${displayPercentage.toStringAsFixed(1)}%',
            style: AppTextStyles.h1(color: color).copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 32,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 10),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: displayPercentage / 100,
              minHeight: 6,
              backgroundColor: color.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          const SizedBox(height: 10),
          // Reason
          Text(
            reason,
            style: AppTextStyles.bodySmall(
              color: AppColors.textSecondary,
            ).copyWith(
              height: 1.4,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
