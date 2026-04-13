import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ocdcoach/src/core/theme/app_colors.dart';
import 'package:ocdcoach/src/core/theme/app_text_styles.dart';
import 'package:ocdcoach/src/core/widgets/content_card.dart';
import 'package:ocdcoach/src/features/analysis/domain/models/analysis_response_model.dart';
import 'package:ocdcoach/src/features/chat/presentation/providers/chat_provider.dart';

/// Therapeutic chat bottom sheet
/// Provides Socratic questioning when user is still anxious
class TherapeuticChatSheet extends ConsumerStatefulWidget {
  final AnalysisResponseModel? previousAnalysis;

  const TherapeuticChatSheet({
    super.key,
    this.previousAnalysis,
  });

  @override
  ConsumerState<TherapeuticChatSheet> createState() =>
      _TherapeuticChatSheetState();
}

class _TherapeuticChatSheetState
    extends ConsumerState<TherapeuticChatSheet> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    _messageController.clear();
    ref
        .read(chatProvider(previousAnalysis: widget.previousAnalysis).notifier)
        .sendMessage(message);

    // Scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(
      chatProvider(previousAnalysis: widget.previousAnalysis),
    );

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(32.0),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(32.0),
        ),
        child: Container(
          color: AppColors.background,
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface, // Solid white - Phase 4
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.secondary, // Soft border
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.psychology,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Therapeutic Chat',
                        style: AppTextStyles.h3(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                      color: AppColors.textPrimary,
                    ),
                  ],
                ),
              ),
              // Messages
              Expanded(
                child: chatState.messages.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.chat_bubble_outline,
                              size: 64,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'What specifically feels unresolved?',
                              style: AppTextStyles.bodyLarge(
                                color: AppColors.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount: chatState.messages.length,
                        itemBuilder: (context, index) {
                          final message = chatState.messages[index];
                          return _MessageBubble(message: message);
                        },
                      ),
              ),
              // Loading indicator
              if (chatState.isLoading)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              // Error message
              if (chatState.error != null)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    chatState.error!,
                    style: AppTextStyles.bodySmall(
                      color: AppColors.anxietyHigh,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              // Input field
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface, // Solid white - Phase 4
                  border: Border(
                    top: BorderSide(
                      color: AppColors.secondary, // Soft border
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Type your message...',
                          filled: true,
                          fillColor: AppColors.secondary, // Soft blue-green background
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        style: AppTextStyles.bodyMedium(
                          color: AppColors.textPrimary,
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: _sendMessage,
                      icon: const Icon(Icons.send),
                      color: AppColors.white,
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.primary, // Solid primary color
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final dynamic message; // ChatMessageModel

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser as bool;
    final content = message.content as String;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: ContentCard(
          padding: const EdgeInsets.all(12),
          child: Text(
            content,
            style: AppTextStyles.bodyMedium(
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

