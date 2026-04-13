import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:ocdcoach/src/core/constants/app_constants.dart';

/// Localization service
/// Loads and manages JSON-based localization files
class LocalizationService {
  static LocalizationService? _instance;
  Map<String, dynamic> _localizedStrings = {};
  String _currentLanguage = AppConstants.defaultLanguage;

  LocalizationService._();

  /// Get singleton instance
  static LocalizationService get instance {
    _instance ??= LocalizationService._();
    return _instance!;
  }

  /// Load localization file for given language
  Future<void> loadLanguage(String language) async {
    if (!AppConstants.supportedLanguages.contains(language)) {
      language = AppConstants.defaultLanguage;
    }

    try {
      final String jsonString = await rootBundle.loadString(
        'assets/l10n/app_$language.json',
      );
      _localizedStrings = json.decode(jsonString) as Map<String, dynamic>;
      _currentLanguage = language;
    } catch (e) {
      // Fallback to default language if loading fails
      if (language != AppConstants.defaultLanguage) {
        await loadLanguage(AppConstants.defaultLanguage);
      } else {
        // If default also fails, use empty map
        _localizedStrings = {};
      }
    }
  }

  /// Get localized string by key
  String getString(String key) {
    return _localizedStrings[key] as String? ?? key;
  }

  /// Get current language
  String get currentLanguage => _currentLanguage;

  /// Check if language is loaded
  bool get isLoaded => _localizedStrings.isNotEmpty;
}




