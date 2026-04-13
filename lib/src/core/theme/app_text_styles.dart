import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography styles for OCD Coach app
/// Uses Outfit font family for modern, clean appearance
class AppTextStyles {
  AppTextStyles._();

  static TextStyle _baseStyle({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
  }) {
    return GoogleFonts.outfit(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height ?? 1.5,
    );
  }

  // Headings
  static TextStyle h1({Color? color}) => _baseStyle(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        color: color,
        height: 1.2,
      );

  static TextStyle h2({Color? color}) => _baseStyle(
        fontSize: 24,
        fontWeight: FontWeight.w800,
        color: color,
        height: 1.3,
      );

  static TextStyle h3({Color? color}) => _baseStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: color,
        height: 1.4,
      );

  // Body Text
  static TextStyle bodyLarge({Color? color}) => _baseStyle(
        fontSize: 18,
        fontWeight: FontWeight.normal,
        color: color,
      );

  static TextStyle bodyMedium({Color? color, FontWeight? fontWeight}) => _baseStyle(
        fontSize: 16,
        fontWeight: fontWeight ?? FontWeight.normal,
        color: color,
      );

  static TextStyle bodySmall({Color? color}) => _baseStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: color,
      );

  // Special
  static TextStyle button({Color? color}) => _baseStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: color,
      );

  static TextStyle caption({Color? color}) => _baseStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: color,
      );
}

