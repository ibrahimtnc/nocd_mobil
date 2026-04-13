import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_provider.g.dart';

/// Home screen state provider
@riverpod
class Home extends _$Home {
  @override
  HomeState build() {
    return const HomeState(
      anxietyLevel: 5,
      thought: '',
    );
  }

  void updateAnxietyLevel(int level) {
    state = state.copyWith(anxietyLevel: level);
  }

  void updateThought(String thought) {
    state = state.copyWith(thought: thought);
  }

  void reset() {
    state = const HomeState(
      anxietyLevel: 5,
      thought: '',
    );
  }
}

/// Home screen state
class HomeState {
  final int anxietyLevel;
  final String thought;

  const HomeState({
    required this.anxietyLevel,
    required this.thought,
  });

  HomeState copyWith({
    int? anxietyLevel,
    String? thought,
  }) {
    return HomeState(
      anxietyLevel: anxietyLevel ?? this.anxietyLevel,
      thought: thought ?? this.thought,
    );
  }

  bool get canAnalyze => thought.trim().isNotEmpty;
}

