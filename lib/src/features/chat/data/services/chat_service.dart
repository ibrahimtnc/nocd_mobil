import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ocdcoach/src/core/constants/app_constants.dart';
import 'package:ocdcoach/src/features/analysis/domain/models/analysis_response_model.dart';
import 'package:ocdcoach/src/features/chat/domain/models/chat_message_model.dart';

/// Chat service
/// Handles API calls to Firebase Function for therapeutic chat
class ChatService {
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

  /// Send a chat message and get response
  static Future<ChatMessageModel?> sendMessage({
    required String userMessage,
    required AnalysisResponseModel? previousAnalysis,
    required List<ChatMessageModel> conversationHistory,
    String language = AppConstants.defaultLanguage,
  }) async {
    try {
      // Ensure user is authenticated
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        await FirebaseAuth.instance.signInAnonymously();
      }

      // Validate language
      final targetLanguage = AppConstants.supportedLanguages.contains(language)
          ? language
          : AppConstants.defaultLanguage;

      // Get Firebase Functions instance
      final functions = FirebaseFunctions.instance;

      // Prepare previous analysis data
      final previousAnalysisData = previousAnalysis != null
          ? {
              'empathetic_validation': previousAnalysis.empatheticValidation,
              'the_science_mechanism': previousAnalysis.theScienceMechanism,
              'the_brain_glitch': previousAnalysis.theBrainGlitch,
              'risk_analysis': {
                'perceived_risk_percent':
                    previousAnalysis.riskAnalysis.perceivedRiskPercent,
                'actual_risk_percent':
                    previousAnalysis.riskAnalysis.actualRiskPercent,
                'safety_percent': previousAnalysis.riskAnalysis.safetyPercent,
                'analysis_summary':
                    previousAnalysis.riskAnalysis.analysisSummary,
              },
              'actionable_takeaway': previousAnalysis.actionableTakeaway,
            }
          : null;

      // Prepare conversation history
      final history = conversationHistory
          .map<Map<String, String>>((msg) => {
                'role': msg.isUser ? 'user' : 'assistant',
                'content': msg.content,
              })
          .toList();

      // Call the Firebase Function
      final callable = functions.httpsCallable('therapeuticChat');
      final result = await callable.call({
        'userMessage': userMessage,
        'previousAnalysis': previousAnalysisData,
        'language': targetLanguage,
        'conversationHistory': history,
      });

      // Check for emergency response
      // Convert result.data to Map<String, dynamic> safely (recursively)
      final rawData = result.data;
      if (rawData == null || rawData is! Map) {
        print('Chat Service Error: Invalid response data type');
        return null;
      }
      
      final data = _convertToMapStringDynamic(rawData);
      if (data.containsKey('error') && data['error'] == 'EMERGENCY_HELP') {
        return null;
      }

      // Create chat message from response
      return ChatMessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: data['response'] as String? ?? '',
        isUser: false,
        timestamp: DateTime.now(),
        isQuestion: data['isQuestion'] as bool? ?? false,
      );
    } catch (e) {
      print('Chat Service Error: $e');
      return null;
    }
  }
}

