import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ocdcoach/src/core/constants/app_constants.dart';
import 'package:ocdcoach/src/core/theme/app_colors.dart';
import 'package:ocdcoach/src/core/theme/app_text_styles.dart';
import 'package:ocdcoach/src/shared/providers/localization_provider.dart';
import 'package:ocdcoach/src/core/services/localization_service.dart';

/// Negotiation bottom sheet
/// The "Hook" - asks user to wait before getting analysis
class NegotiationBottomSheet extends ConsumerStatefulWidget {
  final String thought;
  final int anxietyLevel;

  const NegotiationBottomSheet({
    super.key,
    required this.thought,
    required this.anxietyLevel,
  });

  @override
  ConsumerState<NegotiationBottomSheet> createState() => _NegotiationBottomSheetState();
}

class _NegotiationBottomSheetState extends ConsumerState<NegotiationBottomSheet> {
  bool _showDownsell = false;

  void _handleYes() {
    Navigator.of(context).pop();
    context.go(
      '/minigame?duration=${AppConstants.defaultWaitDuration}&thought=${Uri.encodeComponent(widget.thought)}&anxietyLevel=${widget.anxietyLevel}',
    );
  }

  void _handleNo() {
    setState(() {
      _showDownsell = true;
    });
  }

  void _handleDownsellAccept() {
    Navigator.of(context).pop();
    context.go(
      '/minigame?duration=${AppConstants.downsellWaitDuration}&thought=${Uri.encodeComponent(widget.thought)}&anxietyLevel=${widget.anxietyLevel}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizationAsync = ref.watch(localizationProvider);
    
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(32.0),
        ),
      ),
      padding: const EdgeInsets.all(AppConstants.largePadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Grabber handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Center(
            child: Icon(
              Icons.drag_handle,
              color: AppColors.lightGrey,
              size: 24,
            ),
          ),
          const SizedBox(height: 24),
          localizationAsync.when(
            data: (localization) => _buildContent(localization),
            loading: () => _buildContentFallback(),
            error: (_, __) => _buildContentFallback(),
          ),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }

  Widget _buildContent(LocalizationService localization) {
    if (!_showDownsell) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AI Coach Message
          Text(
            localization.getString('negotiation_title'),
            style: AppTextStyles.h3(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 16),
          Text(
            localization.getString('negotiation_message'),
            style: AppTextStyles.bodyLarge(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 32),
          // Buttons
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: _handleNo,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: Text(localization.getString('no_too_hard')),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _handleYes,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: Text(localization.getString('yes_i_can_try')),
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Downsell Message
          Text(
            localization.getString('downsell_title'),
            style: AppTextStyles.h3(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 16),
          Text(
            localization.getString('downsell_message'),
            style: AppTextStyles.bodyLarge(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _handleDownsellAccept,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 56),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            child: Text(localization.getString('yes_lets_try')),
          ),
        ],
      );
    }
  }

  Widget _buildContentFallback() {
    if (!_showDownsell) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AI Coach Message
          Text(
            'I know you want certainty right now.',
            style: AppTextStyles.h3(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 16),
          Text(
            'But let\'s try to delay the compulsion. Can we wait **2 minutes** together?',
            style: AppTextStyles.bodyLarge(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 32),
          // Buttons
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: _handleNo,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: const Text('No, it\'s too hard'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _handleYes,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: const Text('Yes, I can try'),
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Downsell Message
          Text(
            'That\'s okay. Let\'s start smaller.',
            style: AppTextStyles.h3(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 16),
          Text(
            'Can we just do **30 seconds** of deep breathing together?',
            style: AppTextStyles.bodyLarge(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _handleDownsellAccept,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 56),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            child: const Text('Yes, let\'s try'),
          ),
        ],
      );
    }
  }
}

