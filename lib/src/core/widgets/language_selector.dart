import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ocdcoach/src/core/theme/app_colors.dart';
import 'package:ocdcoach/src/core/theme/app_text_styles.dart';
import 'package:ocdcoach/src/shared/providers/settings_provider.dart';

/// Language selector widget
/// Allows users to switch between Turkish and English
class LanguageSelector extends ConsumerWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(
              Icons.language,
              color: AppColors.primary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Language / Dil',
                style: AppTextStyles.bodyMedium(),
              ),
            ),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(
                  value: 'en',
                  label: Text('EN'),
                ),
                ButtonSegment(
                  value: 'tr',
                  label: Text('TR'),
                ),
              ],
              selected: {settings.language},
              onSelectionChanged: (Set<String> newSelection) {
                final selectedLanguage = newSelection.first;
                settingsNotifier.updateLanguage(selectedLanguage);
              },
            ),
          ],
        ),
      ),
    );
  }
}

