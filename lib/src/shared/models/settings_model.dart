import 'package:hive/hive.dart';

part 'settings_model.g.dart';

/// Settings model for local storage
@HiveType(typeId: 2)
class SettingsModel extends HiveObject {
  @HiveField(0)
  String language; // 'en' or 'tr'

  SettingsModel({
    this.language = 'en',
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      language: json['language'] as String? ?? 'en',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'language': language,
    };
  }
}

