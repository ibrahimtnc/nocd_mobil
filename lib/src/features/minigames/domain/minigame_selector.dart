import 'dart:math';

/// Mini-game types
enum MiniGameType {
  zenFlow,
  bioSyncBreath,
  focusMatch,
  // Legacy types (for backward compatibility)
  bubbleWrap,
  neonTrace,
  breathSynchronizer,
}

/// Mini-game selector
/// Randomly selects a mini-game for distraction
class MiniGameSelector {
  static final Random _random = Random();

  /// Get a random mini-game type
  /// Prefers new games, but includes legacy for compatibility
  static MiniGameType getRandomGame() {
    // Use only new games
    final newGames = [
      MiniGameType.zenFlow,
      MiniGameType.bioSyncBreath,
      MiniGameType.focusMatch,
    ];
    return newGames[_random.nextInt(newGames.length)];
  }
}

