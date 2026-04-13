import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ocdcoach/src/core/constants/app_constants.dart';
import 'package:ocdcoach/src/core/theme/app_colors.dart';
import 'package:ocdcoach/src/core/storage/hive_service.dart';
import 'package:ocdcoach/src/core/widgets/main_scaffold.dart';
import 'package:ocdcoach/src/features/home/presentation/providers/home_provider.dart';
import 'package:ocdcoach/src/shared/providers/localization_provider.dart';
import 'package:ocdcoach/src/features/home/presentation/widgets/anxiety_slider.dart';
import 'package:ocdcoach/src/features/home/presentation/widgets/thought_input.dart';
import 'package:ocdcoach/src/features/negotiation/presentation/widgets/negotiation_bottom_sheet.dart';

/// Home screen - The Trigger
/// User enters anxiety level and describes their worry
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeProvider);
    final homeNotifier = ref.read(homeProvider.notifier);
    final localizationAsync = ref.watch(localizationProvider);

    // Get user nickname
    final userBox = HiveService.userBox;
    final user = userBox.get('user');
    final defaultNickname = localizationAsync.when(
      data: (service) => service.getString('friend'),
      loading: () => 'Friend',
      error: (_, __) => 'Friend',
    );
    final nickname = user?.nickname ?? defaultNickname;

    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final horizontalPadding = isTablet ? 48.0 : AppConstants.largePadding;

    return MainScaffold(
      currentIndex: 0,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: AppConstants.largePadding,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isTablet ? 800 : double.infinity,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Header - Phase 4: Left aligned, dark text
                localizationAsync.when(
                  data: (service) => Text(
                    '${service.getString('hello')}, $nickname',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: AppColors.textPrimary, // Dark text - Phase 4
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  loading: () => Text(
                    'Hello, $nickname',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  error: (_, __) => Text(
                    'Hello, $nickname',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                const SizedBox(height: 32),
                // Anxiety Slider
                AnxietySlider(
                  value: homeState.anxietyLevel,
                  onChanged: (level) {
                    homeNotifier.updateAnxietyLevel(level);
                  },
                ),
                const SizedBox(height: 32),
                // Thought Input
                Expanded(
                  child: ThoughtInput(
                    value: homeState.thought,
                    onChanged: (thought) {
                      homeNotifier.updateThought(thought);
                    },
                  ),
                ),
                const SizedBox(height: 24),
                // Analyze Button
                ElevatedButton(
                  onPressed: homeState.canAnalyze
                      ? () {
                          // Show negotiation bottom sheet
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => NegotiationBottomSheet(
                              thought: homeState.thought,
                              anxietyLevel: homeState.anxietyLevel,
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                  ),
                  child: localizationAsync.when(
                    data: (service) => Text(service.getString('analyze_thought')),
                    loading: () => const Text('Analyze Thought'),
                    error: (_, __) => const Text('Analyze Thought'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

