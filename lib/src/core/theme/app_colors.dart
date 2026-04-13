import 'package:flutter/material.dart';

/// Color palette for OCD Coach app
/// Editorial Paper design system - Phase 5
class AppColors {
  AppColors._();

  // Phase 5 Color Palette - Editorial Paper
  // Background: Warm Paper White
  static const Color background = Color(0xFFF7F7F5);
  
  // Surface Cards: Pure White
  static const Color surface = Color(0xFFFFFFFF);
  
  // Primary Brand: Deep Hunter Green
  static const Color primary = Color(0xFF3A5A40);
  
  // Secondary: Muted Sage
  static const Color secondary = Color(0xFFA3B18A);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF1A2C2A); // Dark Charcoal - For headings
  static const Color textSecondary = Color(0xFF4A5568); // Slate Grey - For body text
  
  // Border for Bento Cards
  static Color get borderSubtle => Colors.black.withOpacity(0.05);
  
  // Legacy colors for compatibility
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color lightGrey = Color(0xFFE0E0E0);
  static const Color darkGrey = Color(0xFF424242);
  static const Color textLight = Color(0xFFBDBDBD);
  
  // Anxiety Colors (kept for functionality)
  static const Color anxietyHigh = Color(0xFFE2725B); // Terracotta
  static const Color anxietyLow = Color(0xFF88D8B0); // Soft Teal
  static const Color accent = Color(0xFF967BB6); // Muted Lavender (kept for compatibility)

  /// Get anxiety color based on level (1-10)
  /// Returns gradient from anxietyLow (1) to anxietyHigh (10)
  static Color getAnxietyColor(int level) {
    if (level <= 1) return anxietyLow;
    if (level >= 10) return anxietyHigh;

    // Interpolate between low and high
    final ratio = (level - 1) / 9;
    return Color.lerp(anxietyLow, anxietyHigh, ratio)!;
  }
}

