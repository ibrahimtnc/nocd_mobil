import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ocdcoach/src/features/analysis/domain/models/analysis_response_model.dart';
import 'package:ocdcoach/src/features/chat/data/services/chat_service.dart';
import 'package:ocdcoach/src/features/chat/domain/models/chat_message_model.dart';
import 'package:ocdcoach/src/shared/providers/settings_provider.dart';

part 'chat_provider.g.dart';

/// Chat provider state
class ChatState {
  final List<ChatMessageModel> messages;
  final bool isLoading;
  final String? error;

  ChatState({
    required this.messages,
    this.isLoading = false,
    this.error,
  });

  ChatState copyWith({
    List<ChatMessageModel>? messages,
    bool? isLoading,
    String? error,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

/// Chat provider
@riverpod
class Chat extends _$Chat {
  @override
  ChatState build({
    required AnalysisResponseModel? previousAnalysis,
  }) {
    return ChatState(messages: []);
  }

  /// Send a message
  Future<void> sendMessage(String userMessage) async {
    if (userMessage.trim().isEmpty) return;

    // Add user message to state
    final userMsg = ChatMessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: userMessage,
      isUser: true,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, userMsg],
      isLoading: true,
      error: null,
    );

    // Get current language
    final settings = ref.read(settingsProvider);
    final language = settings.language;

    // Send to service
    final response = await ChatService.sendMessage(
      userMessage: userMessage,
      previousAnalysis: previousAnalysis,
      conversationHistory: state.messages,
      language: language,
    );

    if (response != null) {
      state = state.copyWith(
        messages: [...state.messages, response],
        isLoading: false,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to get response. Please try again.',
      );
    }
  }

  /// Clear chat
  void clearChat() {
    state = ChatState(messages: []);
  }
}

