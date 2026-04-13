import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:ocdcoach/src/core/constants/app_constants.dart';
import 'package:ocdcoach/src/core/theme/app_colors.dart';
import 'package:ocdcoach/src/core/theme/app_text_styles.dart';
import 'package:ocdcoach/src/core/widgets/content_card.dart';

/// Pulse animated probability chart
/// Shows actual risk vs safety with pulse animation
class PulseChart extends StatefulWidget {
  final double safetyPercentage;
  final double riskPercentage;
  final double? perceivedRiskPercentage;
  final String? analysisSummary;

  const PulseChart({
    super.key,
    required this.safetyPercentage,
    required this.riskPercentage,
    this.perceivedRiskPercentage,
    this.analysisSummary,
  });

  @override
  State<PulseChart> createState() => _PulseChartState();
}

class _PulseChartState extends State<PulseChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ContentCard(
      padding: const EdgeInsets.all(AppConstants.largePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Probability Analysis',
            style: AppTextStyles.h3(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 24),
          AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: SizedBox(
                  height: 200,
                  child: PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(
                          value: widget.safetyPercentage,
                          color: AppColors.primary, // Bold Sage Green - Phase 4
                          title: '${widget.safetyPercentage.toStringAsFixed(1)}%',
                          radius: 80,
                          titleStyle: AppTextStyles.bodyMedium(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        PieChartSectionData(
                          value: widget.riskPercentage,
                          color: AppColors.textSecondary, // Bold Grey - Phase 4
                          title: '${widget.riskPercentage.toStringAsFixed(1)}%',
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
              );
            },
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              '${widget.safetyPercentage.toStringAsFixed(1)}%',
              style: AppTextStyles.h2(
                color: AppColors.primary, // Sage Green - Phase 4
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
                AppColors.primary, // Sage Green - Phase 4
                widget.safetyPercentage,
              ),
              const SizedBox(width: 24),
              _buildLegendItem(
                'Theoretical Risk',
                AppColors.textSecondary, // Grey - Phase 4
                widget.riskPercentage,
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (widget.analysisSummary != null &&
              widget.analysisSummary!.isNotEmpty)
            Text(
              widget.analysisSummary!,
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

