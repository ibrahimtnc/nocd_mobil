import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ocdcoach/src/core/constants/app_constants.dart';
import 'package:ocdcoach/src/core/theme/app_colors.dart';
import 'package:ocdcoach/src/core/widgets/language_selector.dart';
import 'package:ocdcoach/src/core/widgets/main_scaffold.dart';
import 'package:ocdcoach/src/shared/providers/localization_provider.dart';
import 'package:ocdcoach/src/shared/providers/settings_provider.dart';

/// Settings screen
/// Allows users to configure app settings
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizationAsync = ref.watch(localizationProvider);

    return MainScaffold(
      currentIndex: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          title: localizationAsync.when(
            data: (service) => Text(
              service.getString('settings'),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textPrimary,
                  ),
            ),
            loading: () => Text(
              'Settings',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textPrimary,
                  ),
            ),
            error: (_, __) => Text(
              'Settings',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textPrimary,
                  ),
            ),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          children: [
            // Language Selector
            const LanguageSelector(),
            const SizedBox(height: 24),
            // Dark Mode Toggle
            Card(
              child: SwitchListTile(
                title: localizationAsync.when(
                  data: (service) => Text(
                    service.getString('dark_mode'),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  loading: () => const Text('Dark Mode'),
                  error: (_, __) => const Text('Dark Mode'),
                ),
                value: false, // TODO: Implement dark mode
                onChanged: (value) {
                  // TODO: Implement dark mode toggle
                },
              ),
            ),
            const SizedBox(height: 24),
            // About Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.largePadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    localizationAsync.when(
                      data: (service) => Text(
                        service.getString('about'),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      loading: () => Text(
                        'About',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      error: (_, __) => Text(
                        'About',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    const SizedBox(height: 16),
                    localizationAsync.when(
                      data: (service) => Text(
                        '${service.getString('app_version')}: ${AppConstants.version}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                      loading: () => Text(
                        'App Version: ${AppConstants.version}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                      error: (_, __) => Text(
                        'App Version: ${AppConstants.version}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

