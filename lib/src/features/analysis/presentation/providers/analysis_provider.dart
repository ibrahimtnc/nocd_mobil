import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ocdcoach/src/features/analysis/data/services/openai_service.dart';
import 'package:ocdcoach/src/features/analysis/domain/models/analysis_response_model.dart';
import 'package:ocdcoach/src/shared/providers/settings_provider.dart';

part 'analysis_provider.g.dart';

/// Analysis provider with pre-fetching support
/// Keep alive to cache results during minigame
@Riverpod(keepAlive: true)
class AnalysisCache extends _$AnalysisCache {
  @override
  Future<AnalysisResponseModel?> build({
    required String thought,
    required int anxietyLevel,
  }) async {
    // Get current language from settings
    final settings = ref.watch(settingsProvider);
    final language = settings.language;

    return await OpenAIService.analyzeThought(
      thought: thought,
      anxietyLevel: anxietyLevel,
      language: language,
    );
  }

}

/// Legacy provider for backward compatibility
@riverpod
Future<AnalysisResponseModel?> analysis(
  AnalysisRef ref, {
  required String thought,
  required int anxietyLevel,
}) async {
  // Use the cache provider
  return await ref.read(
    analysisCacheProvider(
      thought: thought,
      anxietyLevel: anxietyLevel,
    ).future,
  );
}

