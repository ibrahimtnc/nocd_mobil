import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ocdcoach/src/core/constants/app_constants.dart';
import 'package:ocdcoach/src/core/storage/hive_service.dart';
import 'package:ocdcoach/src/core/theme/app_colors.dart';
import 'package:ocdcoach/src/core/widgets/main_scaffold.dart';
import 'package:ocdcoach/src/shared/providers/localization_provider.dart';
import 'package:ocdcoach/src/features/history/presentation/widgets/thought_entry_item.dart';

/// History screen
/// Lists past thought analyses
class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  void _refreshEntries() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final thoughtsBox = HiveService.thoughtsBox;
    final entries = thoughtsBox.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    final localizationAsync = ref.watch(localizationProvider);

    return MainScaffold(
      currentIndex: 1,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          title: localizationAsync.when(
            data: (service) => Text(
              service.getString('history'),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textPrimary,
                  ),
            ),
            loading: () => Text(
              'History',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textPrimary,
                  ),
            ),
            error: (_, __) => Text(
              'History',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textPrimary,
                  ),
            ),
          ),
        ),
        body: entries.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.history,
                      size: 64,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(height: 16),
                    localizationAsync.when(
                      data: (service) => Text(
                        'No history yet',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                      loading: () => Text(
                        'No history yet',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                      error: (_, __) => Text(
                        'No history yet',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  final entry = entries[index];
                  return ThoughtEntryItem(
                    entry: entry,
                    onTap: () {
                      context.go(
                        '/analysis?thought=${Uri.encodeComponent(entry.thought)}&anxietyLevel=${entry.anxietyLevel}&waitDuration=${entry.waitDurationSeconds}&entryId=${entry.id}',
                      );
                    },
                    onDelete: () {
                      // Show confirmation dialog
                      localizationAsync.whenData((loc) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(loc.getString('delete_entry')),
                            content: Text(loc.getString('delete_entry_confirmation')),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text(loc.getString('cancel')),
                              ),
                              TextButton(
                                onPressed: () {
                                  HiveService.thoughtsBox.delete(entry.id);
                                  Navigator.of(context).pop();
                                  _refreshEntries();
                                },
                                child: Text(
                                  loc.getString('delete'),
                                  style: const TextStyle(color: AppColors.anxietyHigh),
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                    },
                  );
                },
              ),
      ),
    );
  }
}

