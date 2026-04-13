import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ocdcoach/src/core/constants/app_constants.dart';
import 'package:ocdcoach/src/core/services/sound_effect_service.dart';
import 'package:ocdcoach/src/core/theme/app_colors.dart';
import 'package:ocdcoach/src/core/theme/app_text_styles.dart';
import 'package:ocdcoach/src/core/widgets/content_card.dart';
import 'package:ocdcoach/src/shared/providers/localization_provider.dart';

/// Focus Match memory game
/// 4x4 grid with calming icons to match
class FocusMatchGame extends ConsumerStatefulWidget {
  const FocusMatchGame({super.key});

  @override
  ConsumerState<FocusMatchGame> createState() => _FocusMatchGameState();
}

class _FocusMatchGameState extends ConsumerState<FocusMatchGame>
    with SingleTickerProviderStateMixin {
  late List<MatchCard> _cards;
  int? _firstSelectedIndex;
  int? _secondSelectedIndex;
  int _matchedPairs = 0;
  late AnimationController _flipController;
  final SoundEffectService _soundService = SoundEffectService();

  // Calming icons
  final List<IconData> _icons = [
    Icons.eco, // leaf
    Icons.cloud,
    Icons.water_drop,
    Icons.wb_sunny,
    Icons.auto_awesome,
    Icons.spa,
    Icons.terrain,
    Icons.ac_unit,
  ];

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _initializeCards();
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _initializeCards() {
    final random = Random();
    final iconPairs = List.generate(8, (index) => _icons[index]);
    final allIcons = [...iconPairs, ...iconPairs];
    allIcons.shuffle(random);

    _cards = List.generate(
      16,
      (index) => MatchCard(
        icon: allIcons[index],
        isFlipped: false,
        isMatched: false,
      ),
    );
  }

  void _onCardTap(int index) {
    if (_cards[index].isFlipped || _cards[index].isMatched) return;
    if (_firstSelectedIndex != null && _secondSelectedIndex != null) return;

    // Play card flip sound
    _soundService.playCardFlip();

    setState(() {
      _cards[index] = _cards[index].copyWith(isFlipped: true);
    });

    if (_firstSelectedIndex == null) {
      _firstSelectedIndex = index;
    } else {
      _secondSelectedIndex = index;
      _checkMatch();
    }
  }

  void _checkMatch() {
    if (_firstSelectedIndex == null || _secondSelectedIndex == null) return;

    final firstCard = _cards[_firstSelectedIndex!];
    final secondCard = _cards[_secondSelectedIndex!];

    if (firstCard.icon == secondCard.icon) {
      // Match found - play success sound
      _soundService.playMatch();
      
      setState(() {
        _cards[_firstSelectedIndex!] = firstCard.copyWith(isMatched: true);
        _cards[_secondSelectedIndex!] = secondCard.copyWith(isMatched: true);
        _matchedPairs++;
      });

      _firstSelectedIndex = null;
      _secondSelectedIndex = null;

      if (_matchedPairs == 8) {
        // All pairs matched - play success sound
        _soundService.playSuccess();
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            _initializeCards();
            _matchedPairs = 0;
            setState(() {});
          }
        });
      }
    } else {
      // No match - flip back (no sound for mismatch)
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted) {
          setState(() {
            _cards[_firstSelectedIndex!] = firstCard.copyWith(isFlipped: false);
            _cards[_secondSelectedIndex!] =
                secondCard.copyWith(isFlipped: false);
            _firstSelectedIndex = null;
            _secondSelectedIndex = null;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizationAsync = ref.watch(localizationProvider);
    
    return Column(
      children: [
        // Tip overlay
        localizationAsync.when(
          data: (localization) => ContentCard(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    localization.getString('why_am_i_doing_this'),
                    style: AppTextStyles.bodySmall(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          loading: () => ContentCard(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Why am I doing this? We are delaying the urge to check, allowing your brain\'s alarm system to reset naturally.',
                    style: AppTextStyles.bodySmall(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          error: (_, __) => ContentCard(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Why am I doing this? We are delaying the urge to check, allowing your brain\'s alarm system to reset naturally.',
                    style: AppTextStyles.bodySmall(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Game grid
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: 16,
            itemBuilder: (context, index) {
              return _MatchCardWidget(
                card: _cards[index],
                onTap: () => _onCardTap(index),
              );
            },
          ),
        ),
      ],
    );
  }
}

class MatchCard {
  final IconData icon;
  final bool isFlipped;
  final bool isMatched;

  MatchCard({
    required this.icon,
    required this.isFlipped,
    required this.isMatched,
  });

  MatchCard copyWith({
    IconData? icon,
    bool? isFlipped,
    bool? isMatched,
  }) {
    return MatchCard(
      icon: icon ?? this.icon,
      isFlipped: isFlipped ?? this.isFlipped,
      isMatched: isMatched ?? this.isMatched,
    );
  }
}

class _MatchCardWidget extends StatefulWidget {
  final MatchCard card;
  final VoidCallback onTap;

  const _MatchCardWidget({
    required this.card,
    required this.onTap,
  });

  @override
  State<_MatchCardWidget> createState() => _MatchCardWidgetState();
}

class _MatchCardWidgetState extends State<_MatchCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _flipAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _flipController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void didUpdateWidget(_MatchCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.card.isFlipped != oldWidget.card.isFlipped) {
      if (widget.card.isFlipped) {
        _flipController.forward();
      } else {
        _flipController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _flipAnimation,
        builder: (context, child) {
          final isFlipped = _flipAnimation.value > 0.5;
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(_flipAnimation.value * 3.14159),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                color: isFlipped || widget.card.isMatched
                    ? AppColors.primary.withOpacity(0.2)
                    : AppColors.lightGrey.withOpacity(0.3),
                border: Border.all(
                  color: widget.card.isMatched
                      ? AppColors.primary
                      : AppColors.lightGrey,
                  width: 2,
                ),
              ),
              child: isFlipped || widget.card.isMatched
                  ? Icon(
                      widget.card.icon,
                      size: 40,
                      color: AppColors.primary,
                    )
                  : Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(AppConstants.defaultBorderRadius),
                        color: AppColors.lightGrey.withOpacity(0.5),
                      ),
                      child: const Icon(
                        Icons.help_outline,
                        size: 40,
                        color: AppColors.textSecondary,
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}

