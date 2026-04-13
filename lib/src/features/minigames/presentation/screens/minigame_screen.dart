import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ocdcoach/src/core/constants/app_constants.dart';
import 'package:ocdcoach/src/core/services/sound_effect_service.dart';
import 'package:ocdcoach/src/core/theme/app_colors.dart';
import 'package:ocdcoach/src/core/theme/app_text_styles.dart';
import 'package:ocdcoach/src/features/analysis/presentation/providers/analysis_provider.dart';
import 'package:ocdcoach/src/features/minigames/domain/minigame_selector.dart';
import 'package:ocdcoach/src/features/minigames/presentation/widgets/bio_sync_breath_game.dart';
import 'package:ocdcoach/src/features/minigames/presentation/widgets/calming_notification.dart';
import 'package:ocdcoach/src/features/minigames/presentation/widgets/countdown_timer.dart';
import 'package:ocdcoach/src/features/minigames/presentation/widgets/focus_match_game.dart';
import 'package:ocdcoach/src/features/minigames/presentation/widgets/relaxation_check_dialog.dart';
import 'package:ocdcoach/src/features/minigames/presentation/widgets/relaxing_music_player.dart';
import 'package:ocdcoach/src/features/minigames/presentation/widgets/zen_flow_game.dart';
import 'package:ocdcoach/src/shared/providers/localization_provider.dart';
import 'package:ocdcoach/src/core/services/localization_service.dart';

/// Mini-game screen
/// Shows a random mini-game with countdown timer
/// Pre-fetches analysis in the background
class MinigameScreen extends ConsumerStatefulWidget {
  final int durationSeconds;
  final String? thought;
  final int? anxietyLevel;

  const MinigameScreen({
    super.key,
    required this.durationSeconds,
    this.thought,
    this.anxietyLevel,
  });

  @override
  ConsumerState<MinigameScreen> createState() => _MinigameScreenState();
}

class _MinigameScreenState extends ConsumerState<MinigameScreen> {
  late int _remainingSeconds;
  late MiniGameType _selectedGame;
  bool _isTimerComplete = false;
  bool _hasPrefetched = false;
  int _notificationIndex = 0;
  final RelaxingMusicPlayer _musicPlayer = RelaxingMusicPlayer();
  final SoundEffectService _soundService = SoundEffectService();

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.durationSeconds;
    _selectedGame = MiniGameSelector.getRandomGame();
    _startTimer();
    _prefetchAnalysis();
    _startCalmingNotifications();
    _startMusic();
  }

  void _startMusic() {
    // Start playing relaxing music at low volume
    _musicPlayer.setVolume(0.3); // 30% volume for background music
    _musicPlayer.play();
  }

  @override
  void dispose() {
    _musicPlayer.stop();
    super.dispose();
  }

  void _startCalmingNotifications() {
    // Show first notification after 10 seconds
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted && !_isTimerComplete) {
        _showNextNotification();
      }
    });
  }

  void _showNextNotification() {
    if (!mounted || _isTimerComplete) return;

    final localizationAsync = ref.read(localizationProvider);
    localizationAsync.whenData((localization) {
      // Get calming message keys
      final messageKeys = [
        'calming_message_1',
        'calming_message_2',
        'calming_message_3',
        'calming_message_4',
        'calming_message_5',
        'calming_message_6',
        'calming_message_7',
        'calming_message_8',
        'calming_message_9',
        'calming_message_10',
      ];
      
      final messageKey = messageKeys[_notificationIndex % messageKeys.length];
      final message = localization.getString(messageKey);
      CalmingNotification.show(context, message);

      _notificationIndex++;

      // Schedule next notification (every 20-30 seconds)
      if (!_isTimerComplete && _remainingSeconds > 20) {
        final nextDelay = 20 + (_notificationIndex % 3) * 5; // 20-30 seconds
        Future.delayed(Duration(seconds: nextDelay), () {
          if (mounted && !_isTimerComplete) {
            _showNextNotification();
          }
        });
      }
    });
  }

  void _prefetchAnalysis() {
    if (widget.thought != null &&
        widget.anxietyLevel != null &&
        !_hasPrefetched) {
      _hasPrefetched = true;
      // Pre-fetch analysis in the background immediately
      // Using .future triggers the build method and starts the API call
      // This ensures the analysis is ready when user finishes the minigame
      Future.microtask(() {
        ref.read(
          analysisCacheProvider(
            thought: widget.thought!,
            anxietyLevel: widget.anxietyLevel!,
          ).future,
        ).then((_) {
          // Analysis prefetched successfully
          if (mounted) {
            print('Analysis prefetched successfully');
          }
        }).catchError((error) {
          // Silently handle errors - analysis screen will handle them
          if (mounted) {
            print('Prefetch analysis error: $error');
          }
        });
      });
    }
  }

  void _startTimer() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() {
          _remainingSeconds--;
        });
        if (_remainingSeconds <= 0) {
          setState(() {
            _isTimerComplete = true;
          });
          // Play success sound when timer completes
          _soundService.playSuccess();
          return false;
        }
      }
      return mounted;
    });
  }

  void _navigateToAnalysis() {
    // Play click sound for button interaction
    _soundService.playClick();
    
    // Show relaxation check dialog first
    if (widget.anxietyLevel != null) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => RelaxationCheckDialog(
          initialAnxietyLevel: widget.anxietyLevel!,
          thought: widget.thought,
          durationSeconds: widget.durationSeconds,
        ),
      );
    } else {
      context.go('/home');
    }
  }

  Widget _buildGame() {
    switch (_selectedGame) {
      case MiniGameType.zenFlow:
        return const ZenFlowGame();
      case MiniGameType.bioSyncBreath:
        return const BioSyncBreathGame();
      case MiniGameType.focusMatch:
        return const FocusMatchGame();
      // Legacy games (fallback)
      case MiniGameType.bubbleWrap:
        return const FocusMatchGame(); // Use new game as fallback
      case MiniGameType.neonTrace:
        return const ZenFlowGame(); // Use new game as fallback
      case MiniGameType.breathSynchronizer:
        return const BioSyncBreathGame(); // Use new game as fallback
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizationAsync = ref.watch(localizationProvider);
    
    return Scaffold(
      backgroundColor: AppColors.secondary, // Solid muted color - Phase 4
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: localizationAsync.when(
            data: (localization) => Column(
              children: [
                // Countdown Timer
                CountdownTimer(remainingSeconds: _remainingSeconds),
                const SizedBox(height: 24),
                // Mini-game
                Expanded(
                  child: _buildGame(),
                ),
                const SizedBox(height: 24),
                // Analysis Ready Button
                if (_isTimerComplete)
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: AppColors.primary,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              localization.getString('great_job_completed_wait'),
                              style: AppTextStyles.bodyMedium(
                                color: AppColors.primary,
                              ).copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _navigateToAnalysis,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 56),
                        ),
                        child: Text(localization.getString('check_how_you_feel_now')),
                      ),
                    ],
                  )
                else
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.favorite,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            localization.getString('keep_going'),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w500,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            loading: () {
              // Use default localization service for fallback
              final defaultLoc = LocalizationService.instance;
              return Column(
                children: [
                  CountdownTimer(remainingSeconds: _remainingSeconds),
                  const SizedBox(height: 24),
                  Expanded(
                    child: _buildGame(),
                  ),
                  const SizedBox(height: 24),
                  if (_isTimerComplete)
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: AppColors.primary,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                defaultLoc.getString('great_job_completed_wait'),
                                style: AppTextStyles.bodyMedium(
                                  color: AppColors.primary,
                                ).copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _navigateToAnalysis,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 56),
                          ),
                          child: Text(defaultLoc.getString('check_how_you_feel_now')),
                        ),
                      ],
                    )
                  else
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.favorite,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              defaultLoc.getString('keep_going'),
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w500,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              );
            },
            error: (_, __) {
              // Use default localization service for fallback
              final defaultLoc = LocalizationService.instance;
              return Column(
                children: [
                  CountdownTimer(remainingSeconds: _remainingSeconds),
                  const SizedBox(height: 24),
                  Expanded(
                    child: _buildGame(),
                  ),
                  const SizedBox(height: 24),
                  if (_isTimerComplete)
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: AppColors.primary,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                defaultLoc.getString('great_job_completed_wait'),
                                style: AppTextStyles.bodyMedium(
                                  color: AppColors.primary,
                                ).copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _navigateToAnalysis,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 56),
                          ),
                          child: Text(defaultLoc.getString('check_how_you_feel_now')),
                        ),
                      ],
                    )
                  else
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.favorite,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              defaultLoc.getString('keep_going'),
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w500,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

