import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:ocdcoach/src/core/theme/app_colors.dart';

/// Neon Trace mini-game
/// User must trace a glowing line with their finger
class NeonTraceGame extends StatefulWidget {
  const NeonTraceGame({super.key});

  @override
  State<NeonTraceGame> createState() => _NeonTraceGameState();
}

class _NeonTraceGameState extends State<NeonTraceGame> {
  final List<Offset> _path = [];
  final List<Offset> _targetPath = [];
  bool _isDrawing = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_targetPath.isEmpty) {
      _generateTargetPath();
    }
  }

  void _generateTargetPath() {
    // Generate a simple curved path
    final size = MediaQuery.of(context).size;
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    for (int i = 0; i < 50; i++) {
      final t = i / 49.0;
      final x = centerX - 100 + (t * 200);
      final y = centerY - 50 + (50 * (t - 0.5) * (t - 0.5) * 4);
      _targetPath.add(Offset(x, y));
    }
  }

  void _onPanStart(DragStartDetails details) {
    setState(() {
      _isDrawing = true;
      _path.clear();
      _path.add(details.localPosition);
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_isDrawing) {
      setState(() {
        _path.add(details.localPosition);
      });
    }
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      _isDrawing = false;
      // Fade effect - clear path after a delay
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _path.clear();
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: CustomPaint(
        size: Size.infinite,
        painter: NeonTracePainter(
          targetPath: _targetPath,
          userPath: _path,
          isDrawing: _isDrawing,
        ),
      ),
    );
  }
}

class NeonTracePainter extends CustomPainter {
  final List<Offset> targetPath;
  final List<Offset> userPath;
  final bool isDrawing;

  NeonTracePainter({
    required this.targetPath,
    required this.userPath,
    required this.isDrawing,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw target path (glowing line)
    final targetPaint = Paint()
      ..color = AppColors.accent.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    if (targetPath.length > 1) {
      final path = ui.Path();
      path.moveTo(targetPath[0].dx, targetPath[0].dy);
      for (int i = 1; i < targetPath.length; i++) {
        path.lineTo(targetPath[i].dx, targetPath[i].dy);
      }
      canvas.drawPath(path, targetPaint);
    }

    // Draw user path (neon trace)
    if (userPath.length > 1) {
      final userPaint = Paint()
        ..color = AppColors.accent
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6.0
        ..strokeCap = StrokeCap.round;

      final path = ui.Path();
      path.moveTo(userPath[0].dx, userPath[0].dy);
      for (int i = 1; i < userPath.length; i++) {
        path.lineTo(userPath[i].dx, userPath[i].dy);
      }
      canvas.drawPath(path, userPaint);
    }
  }

  @override
  bool shouldRepaint(NeonTracePainter oldDelegate) {
    return oldDelegate.userPath != userPath ||
        oldDelegate.isDrawing != isDrawing;
  }
}

