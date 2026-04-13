import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ocdcoach/src/core/constants/app_constants.dart';
import 'package:ocdcoach/src/features/analysis/domain/models/analysis_response_model.dart';

/// OpenAI service
/// Handles API calls to Firebase Function (which proxies OpenAI)
class OpenAIService {
  /// Recursively converts Map<Object?, Object?> to Map<String, dynamic>
  static Map<String, dynamic> _convertToMapStringDynamic(dynamic data) {
    if (data is Map) {
      final result = <String, dynamic>{};
      data.forEach((key, value) {
        final stringKey = key?.toString() ?? '';
        if (value is Map) {
          result[stringKey] = _convertToMapStringDynamic(value);
        } else if (value is List) {
          result[stringKey] = value.map((item) {
            if (item is Map) {
              return _convertToMapStringDynamic(item);
            }
            return item;
          }).toList();
        } else {
          result[stringKey] = value;
        }
      });
      return result;
    }
    return {};
  }
  /// Analyze thought using OpenAI via Firebase Function
  /// Returns AnalysisResponseModel or null on error
  static Future<AnalysisResponseModel?> analyzeThought({
    required String thought,
    required int anxietyLevel,
    String language = AppConstants.defaultLanguage,
  }) async {
    try {
      // Ensure user is authenticated (anonymous is fine)
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        // Try to sign in anonymously
        await FirebaseAuth.instance.signInAnonymously();
      }

      // Validate language
      final targetLanguage = AppConstants.supportedLanguages.contains(language)
          ? language
          : AppConstants.defaultLanguage;

      // Get Firebase Functions instance
      final functions = FirebaseFunctions.instance;

      // Call the Firebase Function
      final callable = functions.httpsCallable('analyzeThought');
      final result = await callable.call({
        'userText': thought,
        'anxietyLevel': anxietyLevel,
        'language': targetLanguage,
      });

      // Check for emergency response
      // Convert result.data to Map<String, dynamic> safely (recursively)
      final rawData = result.data;
      if (rawData == null || rawData is! Map) {
        print('OpenAI Service Error: Invalid response data type');
        return null;
      }
      
      final data = _convertToMapStringDynamic(rawData);
      if (data.containsKey('error') && data['error'] == 'EMERGENCY_HELP') {
        // Handle emergency case - return null and let UI handle it
        return null;
      }

      // Parse the response
      return AnalysisResponseModel.fromJson(data);
    } catch (e) {
      print('OpenAI Service Error: $e');
      return null;
    }
  }
}
