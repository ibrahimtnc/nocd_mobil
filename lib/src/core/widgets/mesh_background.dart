import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// Animated mesh gradient background widget
/// Creates a premium, serene background with soft color transitions
class MeshBackground extends StatefulWidget {
  final Widget child;
  final Duration animationDuration;

  const MeshBackground({
    super.key,
    required this.child,
    this.animationDuration = const Duration(seconds: 8),
  });

  @override
  State<MeshBackground> createState() => _MeshBackgroundState();
}

class _MeshBackgroundState extends State<MeshBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          painter: MeshGradientPainter(
            animationValue: _animation.value,
          ),
          child: widget.child,
        );
      },
    );
  }
}

class MeshGradientPainter extends CustomPainter {
  final double animationValue;

  MeshGradientPainter({required this.animationValue});

  // Premium color palette
  static const Color softSage = Color(0xFFE0F2F1);
  static const Color mutedLavender = Color(0xFFEDE7F6);
  static const Color warmSand = Color(0xFFFFF8E1);

  @override
  void paint(Canvas canvas, Size size) {
    // Create animated gradient positions
    final offset1 = Offset(
      size.width * 0.2 + (animationValue * size.width * 0.1),
      size.height * 0.3 - (animationValue * size.height * 0.1),
    );
    final offset2 = Offset(
      size.width * 0.8 - (animationValue * size.width * 0.1),
      size.height * 0.7 + (animationValue * size.height * 0.1),
    );
    final offset3 = Offset(
      size.width * 0.5 + (animationValue * size.width * 0.05),
      size.height * 0.1 + (animationValue * size.height * 0.05),
    );

    // Create radial gradients for mesh effect
    final paint1 = Paint()
      ..shader = ui.Gradient.radial(
        offset1,
        size.width * 0.4,
        [
          softSage.withOpacity(0.8),
          softSage.withOpacity(0.0),
        ],
      );

    final paint2 = Paint()
      ..shader = ui.Gradient.radial(
        offset2,
        size.width * 0.5,
        [
          mutedLavender.withOpacity(0.7),
          mutedLavender.withOpacity(0.0),
        ],
      );

    final paint3 = Paint()
      ..shader = ui.Gradient.radial(
        offset3,
        size.width * 0.3,
        [
          warmSand.withOpacity(0.6),
          warmSand.withOpacity(0.0),
        ],
      );

    // Draw gradients
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint1,
    );
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint2,
    );
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint3,
    );

    // Base gradient overlay for smooth blending
    final baseGradient = Paint()
      ..shader = ui.Gradient.linear(
        Offset(0, 0),
        Offset(size.width, size.height),
        [
          softSage.withOpacity(0.3),
          mutedLavender.withOpacity(0.2),
          warmSand.withOpacity(0.3),
        ],
        [0.0, 0.5, 1.0],
      );

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      baseGradient,
    );
  }

  @override
  bool shouldRepaint(MeshGradientPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

