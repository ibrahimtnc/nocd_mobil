import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// Success animation widget
/// Plays once when the analysis screen opens
class SuccessAnimation extends StatefulWidget {
  final VoidCallback? onComplete;

  const SuccessAnimation({
    super.key,
    this.onComplete,
  });

  @override
  State<SuccessAnimation> createState() => _SuccessAnimationState();
}

class _SuccessAnimationState extends State<SuccessAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _hasPlayed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Play animation once
    _controller.forward().then((_) {
      if (mounted && widget.onComplete != null) {
        widget.onComplete!();
      }
      _hasPlayed = true;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasPlayed) {
      return const SizedBox.shrink();
    }

    return Center(
      child: SizedBox(
        width: 200,
        height: 200,
        child: Lottie.asset(
          'assets/animations/Success.json',
          controller: _controller,
          fit: BoxFit.contain,
          repeat: false,
        ),
      ),
    );
  }
}

