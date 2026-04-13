import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ocdcoach/src/core/services/sound_effect_service.dart';
import 'package:ocdcoach/src/core/theme/app_colors.dart';
import 'package:ocdcoach/src/core/theme/app_text_styles.dart';
import 'package:ocdcoach/src/core/widgets/content_card.dart';
import 'package:ocdcoach/src/shared/providers/localization_provider.dart';

/// Shape types that can be recognized
enum ShapeType {
  circle,
  square,
  triangle,
  line,
  heart,
  spiral,
  freeform, // For non-challenge prompts
}

/// Zen Flow drawing game
/// User draws lines that fade away slowly, like drawing in sand
/// Includes shape recognition challenges
class ZenFlowGame extends ConsumerStatefulWidget {
  const ZenFlowGame({super.key});

  @override
  ConsumerState<ZenFlowGame> createState() => _ZenFlowGameState();
}

class _ZenFlowGameState extends ConsumerState<ZenFlowGame>
    with TickerProviderStateMixin {
  final List<DrawingStroke> _strokes = [];
  late AnimationController _promptController;
  late AnimationController _successAnimationController;
  int _currentChallengeIndex = 0;
  List<ShapeChallenge> _challenges = [];
  final SoundEffectService _soundService = SoundEffectService();
  bool _showSuccessFeedback = false;
  int _successCount = 0;
  
  // Haptic feedback throttling - prevents excessive haptic calls
  DateTime _lastHapticTime = DateTime.now();
  static const Duration _hapticThrottleDuration = Duration(milliseconds: 80);

  @override
  void initState() {
    super.initState();
    _promptController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );
    
    _successAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_challenges.isEmpty) {
      _loadChallenges();
    }
  }

  void _loadChallenges() {
    final localizationAsync = ref.read(localizationProvider);
    localizationAsync.whenData((localization) {
      if (mounted) {
        setState(() {
          _challenges = [
            ShapeChallenge(
              prompt: localization.getString('shape_draw_circle'),
              shape: ShapeType.circle,
            ),
            ShapeChallenge(
              prompt: localization.getString('shape_draw_square'),
              shape: ShapeType.square,
            ),
            ShapeChallenge(
              prompt: localization.getString('shape_draw_triangle'),
              shape: ShapeType.triangle,
            ),
            ShapeChallenge(
              prompt: localization.getString('shape_draw_line'),
              shape: ShapeType.line,
            ),
            ShapeChallenge(
              prompt: localization.getString('shape_draw_heart'),
              shape: ShapeType.heart,
            ),
            ShapeChallenge(
              prompt: localization.getString('shape_draw_spiral'),
              shape: ShapeType.spiral,
            ),
            // Free drawing prompts
            ShapeChallenge(
              prompt: localization.getString('draw_something_calming'),
              shape: ShapeType.freeform,
            ),
            ShapeChallenge(
              prompt: localization.getString('let_hand_move'),
              shape: ShapeType.freeform,
            ),
          ];
          // Shuffle to make it more interesting
          _challenges.shuffle();
        });
      }
    });
  }

  @override
  void dispose() {
    _promptController.dispose();
    _successAnimationController.dispose();
    for (var stroke in _strokes) {
      stroke.fadeController.dispose();
    }
    super.dispose();
  }

  void _onPanStart(DragStartDetails details) {
    // Play haptic feedback when starting to draw
    _soundService.playDrawingHaptic();
    
    final stroke = DrawingStroke(
      points: [details.localPosition],
      fadeController: AnimationController(
        vsync: this,
        duration: const Duration(seconds: 5), // Longer fade for better recognition
      ),
    );

    setState(() {
      _strokes.add(stroke);
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_strokes.isNotEmpty) {
      setState(() {
        _strokes.last.points.add(details.localPosition);
      });
      
      // Throttled haptic feedback while drawing
      final now = DateTime.now();
      if (now.difference(_lastHapticTime) >= _hapticThrottleDuration) {
        _soundService.playDrawingHaptic();
        _lastHapticTime = now;
      }
    }
  }

  void _onPanEnd(DragEndDetails details) {
    if (_strokes.isEmpty) return;
    
    final currentStroke = _strokes.last;
    
    // Only check shape if we have a shape challenge (not freeform)
    if (_challenges.isNotEmpty) {
      final currentChallenge = _challenges[_currentChallengeIndex % _challenges.length];
      
      if (currentChallenge.shape != ShapeType.freeform) {
        // Check if the drawn shape matches the challenge
        final recognizedShape = ShapeRecognizer.recognize(currentStroke.points);
        
        if (recognizedShape == currentChallenge.shape) {
          _onShapeSuccess();
        }
      }
    }
    
    // Start fade animation
    currentStroke.fadeController.forward().then((_) {
      if (mounted) {
        setState(() {
          _strokes.remove(currentStroke);
        });
        currentStroke.fadeController.dispose();
      }
    });
  }

  void _onShapeSuccess() {
    // Play success sound and haptic
    _soundService.playMatch();
    HapticFeedback.heavyImpact();
    
    setState(() {
      _showSuccessFeedback = true;
      _successCount++;
    });
    
    // Animate success feedback
    _successAnimationController.forward(from: 0).then((_) {
      if (mounted) {
        setState(() {
          _showSuccessFeedback = false;
          // Move to next challenge
          _currentChallengeIndex++;
        });
      }
    });
  }

  String get _currentPrompt {
    if (_challenges.isEmpty) return '';
    return _challenges[_currentChallengeIndex % _challenges.length].prompt;
  }

  @override
  Widget build(BuildContext context) {
    final localizationAsync = ref.watch(localizationProvider);
    
    return Column(
      children: [
        // Tip overlay with success counter
        localizationAsync.when(
          data: (localization) => ContentCard(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    localization.getString('why_am_i_doing_this'),
                    style: AppTextStyles.bodySmall(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                if (_successCount > 0) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: AppColors.primary,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$_successCount',
                          style: AppTextStyles.bodySmall(
                            color: AppColors.primary,
                          ).copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          loading: () => ContentCard(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Why am I doing this? We are delaying the urge to check, allowing your brain\'s alarm system to reset naturally.',
                    style: AppTextStyles.bodySmall(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          error: (_, __) => ContentCard(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Why am I doing this? We are delaying the urge to check, allowing your brain\'s alarm system to reset naturally.',
                    style: AppTextStyles.bodySmall(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Dynamic prompt with animation
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            _currentPrompt.isEmpty ? '...' : _currentPrompt,
            key: ValueKey(_currentChallengeIndex),
            style: AppTextStyles.h3(color: AppColors.textPrimary),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 24),
        // Drawing canvas with success overlay
        Expanded(
          child: Stack(
            children: [
              GestureDetector(
                onPanStart: _onPanStart,
                onPanUpdate: _onPanUpdate,
                onPanEnd: _onPanEnd,
                child: CustomPaint(
                  painter: ZenFlowPainter(
                    strokes: _strokes,
                  ),
                  size: Size.infinite,
                ),
              ),
              // Success feedback overlay
              if (_showSuccessFeedback)
                AnimatedBuilder(
                  animation: _successAnimationController,
                  builder: (context, child) {
                    final scale = 1.0 + (_successAnimationController.value * 0.3);
                    final opacity = 1.0 - _successAnimationController.value;
                    return Center(
                      child: Transform.scale(
                        scale: scale,
                        child: Opacity(
                          opacity: opacity,
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.9),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 64,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Shape challenge data
class ShapeChallenge {
  final String prompt;
  final ShapeType shape;

  ShapeChallenge({
    required this.prompt,
    required this.shape,
  });
}

class DrawingStroke {
  final List<Offset> points;
  final AnimationController fadeController;

  DrawingStroke({
    required this.points,
    required this.fadeController,
  });
}

/// Shape recognition utility class
/// Uses geometric analysis to detect drawn shapes
class ShapeRecognizer {
  /// Minimum points required for recognition
  static const int _minPoints = 10;
  
  /// Tolerance for shape matching (0.0 - 1.0)
  static const double _tolerance = 0.35;

  /// Recognize the shape from a list of points
  static ShapeType recognize(List<Offset> points) {
    if (points.length < _minPoints) return ShapeType.freeform;

    // Check each shape type
    if (_isCircle(points)) return ShapeType.circle;
    if (_isSquare(points)) return ShapeType.square;
    if (_isTriangle(points)) return ShapeType.triangle;
    if (_isLine(points)) return ShapeType.line;
    if (_isHeart(points)) return ShapeType.heart;
    if (_isSpiral(points)) return ShapeType.spiral;

    return ShapeType.freeform;
  }

  /// Check if points form a circle
  /// A circle has: closed shape, consistent distance from center
  static bool _isCircle(List<Offset> points) {
    if (points.length < 15) return false;

    // Calculate centroid
    final centroid = _calculateCentroid(points);
    
    // Calculate distances from centroid
    final distances = points.map((p) => (p - centroid).distance).toList();
    final avgDistance = distances.reduce((a, b) => a + b) / distances.length;
    
    // Check if distances are consistent (low variance)
    final variance = distances.map((d) => pow(d - avgDistance, 2)).reduce((a, b) => a + b) / distances.length;
    final stdDev = sqrt(variance);
    final normalizedStdDev = stdDev / avgDistance;
    
    // Check if shape is closed (start and end are near)
    final isClosed = (points.first - points.last).distance < avgDistance * 0.5;
    
    return normalizedStdDev < _tolerance && isClosed;
  }

  /// Check if points form a square/rectangle
  /// A square has: 4 corners, roughly equal angles, closed shape
  static bool _isSquare(List<Offset> points) {
    if (points.length < 20) return false;

    // Find corners (points with high angle change)
    final corners = _findCorners(points, 4);
    if (corners.length < 4) return false;

    // Check if roughly closed
    final isClosed = (points.first - points.last).distance < 
        _calculateBoundingBoxSize(points) * 0.3;
    
    // Check angles at corners are roughly 90 degrees
    bool hasRightAngles = true;
    for (int i = 0; i < corners.length && hasRightAngles; i++) {
      final prevIdx = (i - 1 + corners.length) % corners.length;
      final nextIdx = (i + 1) % corners.length;
      
      final angle = _calculateAngle(
        points[corners[prevIdx]],
        points[corners[i]],
        points[corners[nextIdx]],
      );
      
      // Allow 60-120 degrees for "right" angles (generous tolerance)
      if (angle < 50 || angle > 130) {
        hasRightAngles = false;
      }
    }

    return isClosed && hasRightAngles;
  }

  /// Check if points form a triangle
  /// A triangle has: 3 corners, closed shape
  static bool _isTriangle(List<Offset> points) {
    if (points.length < 15) return false;

    // Find corners
    final corners = _findCorners(points, 3);
    if (corners.length < 3) return false;

    // Check if roughly closed
    final isClosed = (points.first - points.last).distance < 
        _calculateBoundingBoxSize(points) * 0.3;

    return isClosed && corners.length >= 3 && corners.length <= 4;
  }

  /// Check if points form a straight line
  static bool _isLine(List<Offset> points) {
    if (points.length < 5) return false;

    final start = points.first;
    final end = points.last;
    final lineLength = (end - start).distance;
    
    if (lineLength < 50) return false; // Too short
    
    // Calculate average distance from the line
    double totalDeviation = 0;
    for (final point in points) {
      final deviation = _pointToLineDistance(point, start, end);
      totalDeviation += deviation;
    }
    final avgDeviation = totalDeviation / points.length;
    
    return avgDeviation < lineLength * 0.15;
  }

  /// Check if points form a heart shape
  /// A heart has: two bumps at top, point at bottom
  static bool _isHeart(List<Offset> points) {
    if (points.length < 20) return false;

    final bbox = _calculateBoundingBox(points);
    final centroid = _calculateCentroid(points);
    
    // Check for closed shape
    final isClosed = (points.first - points.last).distance < 
        _calculateBoundingBoxSize(points) * 0.4;
    if (!isClosed) return false;

    // Check for point at bottom (lowest y point should be near center x)
    Offset lowestPoint = points.first;
    for (final p in points) {
      if (p.dy > lowestPoint.dy) lowestPoint = p;
    }
    
    final isBottomPointCentered = 
        (lowestPoint.dx - centroid.dx).abs() < bbox.width * 0.3;

    // Check for two bumps at top
    final topPoints = points.where((p) => p.dy < centroid.dy).toList();
    if (topPoints.isEmpty) return false;
    
    final leftTopPoints = topPoints.where((p) => p.dx < centroid.dx).toList();
    final rightTopPoints = topPoints.where((p) => p.dx > centroid.dx).toList();
    
    final hasTwoBumps = leftTopPoints.isNotEmpty && rightTopPoints.isNotEmpty;

    return isClosed && isBottomPointCentered && hasTwoBumps;
  }

  /// Check if points form a spiral
  /// A spiral has: increasing/decreasing distance from center, multiple rotations
  static bool _isSpiral(List<Offset> points) {
    if (points.length < 30) return false;

    final centroid = _calculateCentroid(points);
    
    // Calculate distances and angles from centroid
    final distances = points.map((p) => (p - centroid).distance).toList();
    
    // Check for monotonic change in distance (increasing or decreasing)
    int increasingCount = 0;
    int decreasingCount = 0;
    
    for (int i = 1; i < distances.length; i++) {
      if (distances[i] > distances[i - 1]) {
        increasingCount++;
      } else {
        decreasingCount++;
      }
    }
    
    final monotonicRatio = max(increasingCount, decreasingCount) / distances.length;
    
    // Check for multiple rotations (angle should cover more than 360 degrees)
    double totalAngle = 0;
    for (int i = 1; i < points.length; i++) {
      final prev = points[i - 1] - centroid;
      final curr = points[i] - centroid;
      final angle = atan2(curr.dy, curr.dx) - atan2(prev.dy, prev.dx);
      totalAngle += angle.abs();
    }
    
    final hasMultipleRotations = totalAngle > pi * 2;

    return monotonicRatio > 0.6 && hasMultipleRotations;
  }

  /// Calculate centroid of points
  static Offset _calculateCentroid(List<Offset> points) {
    double sumX = 0, sumY = 0;
    for (final p in points) {
      sumX += p.dx;
      sumY += p.dy;
    }
    return Offset(sumX / points.length, sumY / points.length);
  }

  /// Calculate bounding box
  static Rect _calculateBoundingBox(List<Offset> points) {
    double minX = double.infinity, maxX = double.negativeInfinity;
    double minY = double.infinity, maxY = double.negativeInfinity;
    
    for (final p in points) {
      minX = min(minX, p.dx);
      maxX = max(maxX, p.dx);
      minY = min(minY, p.dy);
      maxY = max(maxY, p.dy);
    }
    
    return Rect.fromLTRB(minX, minY, maxX, maxY);
  }

  /// Calculate diagonal size of bounding box
  static double _calculateBoundingBoxSize(List<Offset> points) {
    final bbox = _calculateBoundingBox(points);
    return sqrt(bbox.width * bbox.width + bbox.height * bbox.height);
  }

  /// Find corner points (high curvature points)
  static List<int> _findCorners(List<Offset> points, int targetCorners) {
    final curvatures = <int, double>{};
    final windowSize = max(3, points.length ~/ 10);
    
    for (int i = windowSize; i < points.length - windowSize; i++) {
      final angle = _calculateAngle(
        points[i - windowSize],
        points[i],
        points[i + windowSize],
      );
      curvatures[i] = 180 - angle; // Higher value = sharper corner
    }
    
    // Find peaks in curvature
    final sortedIndices = curvatures.keys.toList()
      ..sort((a, b) => curvatures[b]!.compareTo(curvatures[a]!));
    
    final corners = <int>[];
    final minDistance = points.length ~/ (targetCorners + 1);
    
    for (final idx in sortedIndices) {
      if (curvatures[idx]! < 30) break; // Not sharp enough
      
      bool tooClose = false;
      for (final corner in corners) {
        if ((idx - corner).abs() < minDistance) {
          tooClose = true;
          break;
        }
      }
      
      if (!tooClose) {
        corners.add(idx);
        if (corners.length >= targetCorners) break;
      }
    }
    
    corners.sort();
    return corners;
  }

  /// Calculate angle at point b (in degrees)
  static double _calculateAngle(Offset a, Offset b, Offset c) {
    final ba = a - b;
    final bc = c - b;
    
    final dotProduct = ba.dx * bc.dx + ba.dy * bc.dy;
    final magnitudeBA = ba.distance;
    final magnitudeBC = bc.distance;
    
    if (magnitudeBA == 0 || magnitudeBC == 0) return 180;
    
    final cosAngle = (dotProduct / (magnitudeBA * magnitudeBC)).clamp(-1.0, 1.0);
    return acos(cosAngle) * 180 / pi;
  }

  /// Calculate perpendicular distance from point to line
  static double _pointToLineDistance(Offset point, Offset lineStart, Offset lineEnd) {
    final lineVec = lineEnd - lineStart;
    final pointVec = point - lineStart;
    
    final lineLength = lineVec.distance;
    if (lineLength == 0) return pointVec.distance;
    
    final t = ((pointVec.dx * lineVec.dx + pointVec.dy * lineVec.dy) / 
        (lineLength * lineLength)).clamp(0.0, 1.0);
    
    final projection = lineStart + Offset(lineVec.dx * t, lineVec.dy * t);
    return (point - projection).distance;
  }
}

class ZenFlowPainter extends CustomPainter {
  final List<DrawingStroke> strokes;

  ZenFlowPainter({required this.strokes});

  @override
  void paint(Canvas canvas, Size size) {
    for (var stroke in strokes) {
      if (stroke.points.length < 2) continue;

      final opacity = 1.0 - stroke.fadeController.value;
      if (opacity <= 0) continue;

      // Create glowing brush effect
      final paint = Paint()
        ..color = AppColors.primary.withOpacity(opacity * 0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4.0
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      // Outer glow
      final glowPaint = Paint()
        ..color = AppColors.accent.withOpacity(opacity * 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8.0
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      final path = ui.Path();
      path.moveTo(stroke.points[0].dx, stroke.points[0].dy);

      for (int i = 1; i < stroke.points.length; i++) {
        path.lineTo(stroke.points[i].dx, stroke.points[i].dy);
      }

      // Draw glow first
      canvas.drawPath(path, glowPaint);
      // Draw main line
      canvas.drawPath(path, paint);

      // Add particle trails (small dots along the path)
      for (int i = 0; i < stroke.points.length; i += 5) {
        final point = stroke.points[i];
        final particlePaint = Paint()
          ..color = AppColors.accent.withOpacity(opacity * 0.5);
        canvas.drawCircle(point, 2.0, particlePaint);
      }
    }
  }

  @override
  bool shouldRepaint(ZenFlowPainter oldDelegate) {
    return oldDelegate.strokes.length != strokes.length ||
        strokes.any((stroke) => stroke.fadeController.isAnimating);
  }
}

