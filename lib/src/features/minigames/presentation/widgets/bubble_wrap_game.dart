import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ocdcoach/src/core/constants/app_constants.dart';
import 'package:ocdcoach/src/core/theme/app_colors.dart';

/// Bubble Wrap mini-game
/// Tactile game with pop animations and haptic feedback
class BubbleWrapGame extends StatefulWidget {
  const BubbleWrapGame({super.key});

  @override
  State<BubbleWrapGame> createState() => _BubbleWrapGameState();
}

class _BubbleWrapGameState extends State<BubbleWrapGame>
    with SingleTickerProviderStateMixin {
  final Set<int> _poppedBubbles = {};
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _popBubble(int index) {
    if (_poppedBubbles.contains(index)) return;

    setState(() {
      _poppedBubbles.add(index);
    });

    // Haptic feedback
    HapticFeedback.heavyImpact();

    // Animation
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.background,
            AppColors.primary.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
      ),
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: 30,
        itemBuilder: (context, index) {
          final isPopped = _poppedBubbles.contains(index);

          return GestureDetector(
            onTap: () => _popBubble(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              decoration: BoxDecoration(
                color: isPopped
                    ? AppColors.lightGrey
                    : AppColors.primary.withOpacity(0.3),
                // Make bubbles slightly oval for organic look
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: isPopped ? AppColors.grey : AppColors.primary,
                  width: 2,
                ),
                boxShadow: isPopped
                    ? null
                    : [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
              ),
              child: isPopped
                  ? const Icon(
                      Icons.check,
                      color: AppColors.grey,
                      size: 20,
                    )
                  : null,
            ),
          );
        },
      ),
    );
  }
}

