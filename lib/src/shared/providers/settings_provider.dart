import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ocdcoach/src/core/constants/app_constants.dart';
import 'package:ocdcoach/src/core/storage/hive_service.dart';
import 'package:ocdcoach/src/shared/models/settings_model.dart';

part 'settings_provider.g.dart';

/// Settings provider
/// Manages app settings including language preference
@riverpod
class Settings extends _$Settings {
  @override
  SettingsModel build() {
    final settingsBox = HiveService.settingsBox;
    if (settingsBox.isEmpty) {
      // Create default settings
      final defaultSettings = SettingsModel(language: AppConstants.defaultLanguage);
      settingsBox.put('settings', defaultSettings);
      return defaultSettings;
    }
    return settingsBox.get('settings') ?? SettingsModel(language: AppConstants.defaultLanguage);
  }

  /// Update language preference
  Future<void> updateLanguage(String language) async {
    if (!AppConstants.supportedLanguages.contains(language)) {
      return;
    }

    final newSettings = state.copyWith(language: language);
    await HiveService.settingsBox.put('settings', newSettings);
    state = newSettings;
  }

  /// Get current language
  String get currentLanguage => state.language;
}

extension SettingsModelExtension on SettingsModel {
  SettingsModel copyWith({String? language}) {
    return SettingsModel(
      language: language ?? this.language,
    );
  }
}

