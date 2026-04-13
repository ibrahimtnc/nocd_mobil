import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ocdcoach/src/core/storage/hive_service.dart';
import 'package:ocdcoach/src/shared/models/user_model.dart';

part 'onboarding_provider.g.dart';

/// Onboarding state provider
@riverpod
class Onboarding extends _$Onboarding {
  @override
  bool build() {
    // Check if user has completed onboarding
    final userBox = HiveService.userBox;
    if (userBox.isEmpty) {
      return false;
    }
    final user = userBox.getAt(0);
    return user?.hasCompletedOnboarding ?? false;
  }

  /// Save user nickname and mark onboarding as complete
  Future<void> completeOnboarding(String nickname) async {
    final userBox = HiveService.userBox;
    final user = UserModel(
      nickname: nickname,
      hasCompletedOnboarding: true,
    );
    await userBox.put('user', user);
    state = true;
  }

  /// Get user nickname
  String? getNickname() {
    final userBox = HiveService.userBox;
    final user = userBox.get('user');
    return user?.nickname;
  }
}

