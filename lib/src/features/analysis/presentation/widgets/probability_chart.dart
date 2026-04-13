import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:ocdcoach/src/core/constants/app_constants.dart';
import 'package:ocdcoach/src/core/theme/app_colors.dart';
import 'package:ocdcoach/src/core/theme/app_text_styles.dart';

/// Probability chart widget
/// Pie chart showing actual safety vs theoretical risk
class ProbabilityChart extends StatelessWidget {
  final double safetyPercentage;
  final double riskPercentage;
  final double? perceivedRiskPercentage;
  final String? analysisSummary;

  const ProbabilityChart({
    super.key,
    required this.safetyPercentage,
    required this.riskPercentage,
    this.perceivedRiskPercentage,
    this.analysisSummary,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: AppColors.anxietyLow.withOpacity(0.3),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.largePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Probability Analysis',
              style: AppTextStyles.h3(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: safetyPercentage,
                      color: AppColors.anxietyLow,
                      title: '${safetyPercentage.toStringAsFixed(1)}%',
                      radius: 80,
                      titleStyle: AppTextStyles.bodyMedium(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    PieChartSectionData(
                      value: riskPercentage,
                      color: AppColors.grey,
                      title: '${riskPercentage.toStringAsFixed(1)}%',
                      radius: 80,
                      titleStyle: AppTextStyles.bodySmall(
                        color: AppColors.white,
                      ),
                    ),
                  ],
                  sectionsSpace: 2,
                  centerSpaceRadius: 50,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                '${safetyPercentage.toStringAsFixed(1)}%',
                style: AppTextStyles.h2(
                  color: AppColors.anxietyLow,
                ).copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Legend
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem(
                  'Actual Safety',
                  AppColors.anxietyLow,
                  safetyPercentage,
                ),
                const SizedBox(width: 24),
                _buildLegendItem(
                  'Theoretical Risk',
                  AppColors.grey,
                  riskPercentage,
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (analysisSummary != null && analysisSummary!.isNotEmpty)
              Text(
                analysisSummary!,
                style: AppTextStyles.bodyMedium(
                  color: AppColors.textSecondary,
                ).copyWith(
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              )
            else
              Text(
                'Life is never 0% risk, but look how small the actual danger is.',
                style: AppTextStyles.bodySmall(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, double percentage) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: AppTextStyles.bodySmall(),
        ),
      ],
    );
  }
}

