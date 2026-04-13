import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ocdcoach/src/core/theme/app_text_styles.dart';
import 'package:ocdcoach/src/shared/providers/localization_provider.dart';

/// Thought input widget
/// Large text input area for describing the worry
class ThoughtInput extends ConsumerWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const ThoughtInput({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizationAsync = ref.watch(localizationProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        localizationAsync.when(
          data: (service) => Text(
            service.getString('the_worry'),
            style: AppTextStyles.h3(),
          ),
          loading: () => Text(
            'The Worry',
            style: AppTextStyles.h3(),
          ),
          error: (_, __) => Text(
            'The Worry',
            style: AppTextStyles.h3(),
          ),
        ),
        const SizedBox(height: 16),
        localizationAsync.when(
          data: (service) => TextField(
            onChanged: onChanged,
            maxLines: 8,
            decoration: InputDecoration(
              hintText: service.getString('describe_thought'),
              border: const OutlineInputBorder(),
            ),
            style: AppTextStyles.bodyMedium(),
          ),
          loading: () => TextField(
            onChanged: onChanged,
            maxLines: 8,
            decoration: const InputDecoration(
              hintText: 'Describe the thought...',
              border: OutlineInputBorder(),
            ),
            style: AppTextStyles.bodyMedium(),
          ),
          error: (_, __) => TextField(
            onChanged: onChanged,
            maxLines: 8,
            decoration: const InputDecoration(
              hintText: 'Describe the thought...',
              border: OutlineInputBorder(),
            ),
            style: AppTextStyles.bodyMedium(),
          ),
        ),
      ],
    );
  }
}

