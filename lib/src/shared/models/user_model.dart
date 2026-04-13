import 'package:hive/hive.dart';

part 'user_model.g.dart';

/// User model for local storage
@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  String nickname;

  @HiveField(1)
  bool hasCompletedOnboarding;

  @HiveField(2)
  DateTime? createdAt;

  UserModel({
    required this.nickname,
    this.hasCompletedOnboarding = false,
    this.createdAt,
  }) {
    createdAt ??= DateTime.now();
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      nickname: json['nickname'] as String,
      hasCompletedOnboarding: json['hasCompletedOnboarding'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nickname': nickname,
      'hasCompletedOnboarding': hasCompletedOnboarding,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}

