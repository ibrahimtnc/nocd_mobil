import 'package:flutter/material.dart';
import 'package:ocdcoach/src/core/constants/app_constants.dart';
import 'package:ocdcoach/src/core/theme/app_colors.dart';
import 'package:ocdcoach/src/core/theme/app_text_styles.dart';

/// Breath Synchronizer mini-game
/// Breathing exercise with expanding/shrinking circle
class BreathSynchronizerGame extends StatefulWidget {
  const BreathSynchronizerGame({super.key});

  @override
  State<BreathSynchronizerGame> createState() => _BreathSynchronizerGameState();
}

class _BreathSynchronizerGameState extends State<BreathSynchronizerGame>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  String _breathText = 'Inhale...';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: AppConstants.breathingCycleSeconds * 2),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.addListener(() {
      final value = _controller.value;
      if (value < 0.5) {
        setState(() {
          _breathText = 'Inhale...';
        });
      } else if (value < 0.75) {
        setState(() {
          _breathText = 'Hold...';
        });
      } else {
        setState(() {
          _breathText = 'Exhale...';
        });
      }
    });

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Container(
                width: 200 * _scaleAnimation.value,
                height: 200 * _scaleAnimation.value,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary,
                    width: 3,
                  ),
                ),
                child: Center(
                  child: Container(
                    width: 150 * _scaleAnimation.value,
                    height: 150 * _scaleAnimation.value,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 32),
          Text(
            _breathText,
            style: AppTextStyles.h2(color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

