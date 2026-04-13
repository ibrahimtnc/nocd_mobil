import 'package:hive_flutter/hive_flutter.dart';
import 'package:ocdcoach/src/core/constants/app_constants.dart';
import 'package:ocdcoach/src/shared/models/settings_model.dart';
import 'package:ocdcoach/src/shared/models/thought_entry_model.dart';
import 'package:ocdcoach/src/shared/models/user_model.dart';

/// Hive storage service
/// Handles local data storage for user privacy
class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters
    Hive.registerAdapter(UserModelAdapter());
    Hive.registerAdapter(ThoughtEntryModelAdapter());
    Hive.registerAdapter(SettingsModelAdapter());

    // Open boxes
    await Hive.openBox<UserModel>(AppConstants.userBoxName);
    await Hive.openBox<ThoughtEntryModel>(AppConstants.thoughtsBoxName);
    await Hive.openBox<SettingsModel>(AppConstants.settingsBoxName);
  }

  static Box<UserModel> get userBox =>
      Hive.box<UserModel>(AppConstants.userBoxName);

  static Box<ThoughtEntryModel> get thoughtsBox =>
      Hive.box<ThoughtEntryModel>(AppConstants.thoughtsBoxName);

  static Box<SettingsModel> get settingsBox =>
      Hive.box<SettingsModel>(AppConstants.settingsBoxName);

  static Future<void> clearAll() async {
    await userBox.clear();
    await thoughtsBox.clear();
    await settingsBox.clear();
  }
}
