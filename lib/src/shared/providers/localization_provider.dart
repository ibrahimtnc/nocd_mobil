import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ocdcoach/src/core/services/localization_service.dart';
import 'package:ocdcoach/src/shared/providers/settings_provider.dart';

part 'localization_provider.g.dart';

/// Localization provider
/// Manages localization service and watches for language changes
@riverpod
Future<LocalizationService> localization(LocalizationRef ref) async {
  final settings = ref.watch(settingsProvider);
  final localizationService = LocalizationService.instance;

  // Load language when provider is created or language changes
  await localizationService.loadLanguage(settings.language);

  return localizationService;
}

