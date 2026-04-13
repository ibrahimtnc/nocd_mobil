import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:ocdcoach/src/core/services/sound_effect_service.dart';
import 'package:ocdcoach/src/core/theme/app_colors.dart';
import 'package:ocdcoach/src/core/theme/app_text_styles.dart';
import 'package:ocdcoach/src/shared/providers/localization_provider.dart';

/// Interactive breathing Lottie widget
/// User controls the breathing animation by holding/releasing the screen
class InteractiveBreathingLottie extends ConsumerStatefulWidget {
  const InteractiveBreathingLottie({super.key});

  @override
  ConsumerState<InteractiveBreathingLottie> createState() =>
      _InteractiveBreathingLottieState();
}

class _InteractiveBreathingLottieState
    extends ConsumerState<InteractiveBreathingLottie>
    with SingleTickerProviderStateMixin {
  late AnimationController _lottieController;
  bool _isHolding = false;
  double _hapticIntensity = 0.0;
  final SoundEffectService _soundService = SoundEffectService();

  @override
  void initState() {
    super.initState();
    _lottieController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
  }

  @override
  void dispose() {
    _lottieController.dispose();
    super.dispose();
  }

  void _onPanStart(DragStartDetails details) {
    setState(() {
      _isHolding = true;
    });
    _lottieController.forward();
    _increaseHapticFeedback();
    // Play breath in sound
    _soundService.playBreathIn();
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      _isHolding = false;
    });
    _lottieController.reverse();
    _decreaseHapticFeedback();
    // Play breath out sound
    _soundService.playBreathOut();
  }

  void _onPanCancel() {
    setState(() {
      _isHolding = false;
    });
    _lottieController.reverse();
    _decreaseHapticFeedback();
  }

  void _increaseHapticFeedback() {
    if (!_isHolding) return;

    _hapticIntensity = (_hapticIntensity + 0.1).clamp(0.0, 1.0);

    if (_hapticIntensity < 0.3) {
      HapticFeedback.lightImpact();
    } else if (_hapticIntensity < 0.6) {
      HapticFeedback.mediumImpact();
    } else {
      HapticFeedback.heavyImpact();
    }

    if (_isHolding && _hapticIntensity < 1.0) {
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) _increaseHapticFeedback();
      });
    }
  }

  void _decreaseHapticFeedback() {
    _hapticIntensity = 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _onPanStart,
      onPanEnd: _onPanEnd,
      onPanCancel: _onPanCancel,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 300,
            height: 300,
            child: Lottie.asset(
              'assets/animations/breathing.json',
              controller: _lottieController,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 32),
          Consumer(
            builder: (context, ref, child) {
              final localizationAsync = ref.watch(localizationProvider);
              return localizationAsync.when(
                data: (localization) => Column(
                  children: [
                    Text(
                      _isHolding
                          ? localization.getString('hold_to_fill')
                          : localization.getString('hold_to_fill_lungs'),
                      style: AppTextStyles.h3(color: AppColors.textPrimary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isHolding
                          ? localization.getString('release_to_let_go')
                          : localization.getString('release_to_exhale'),
                      style: AppTextStyles.bodyMedium(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                loading: () => Column(
                  children: [
                    Text(
                      _isHolding
                          ? 'Hold to fill your lungs...'
                          : 'Press and hold to inhale',
                      style: AppTextStyles.h3(color: AppColors.textPrimary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isHolding
                          ? 'Release to let go of the thought'
                          : 'Release to exhale',
                      style: AppTextStyles.bodyMedium(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                error: (_, __) => Column(
                  children: [
                    Text(
                      _isHolding
                          ? 'Hold to fill your lungs...'
                          : 'Press and hold to inhale',
                      style: AppTextStyles.h3(color: AppColors.textPrimary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isHolding
                          ? 'Release to let go of the thought'
                          : 'Release to exhale',
                      style: AppTextStyles.bodyMedium(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

