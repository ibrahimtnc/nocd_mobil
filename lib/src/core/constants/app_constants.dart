/// App-wide constants
class AppConstants {
  AppConstants._();

  // Hive Box Names
  static const String userBoxName = 'userBox';
  static const String thoughtsBoxName = 'thoughtsBox';
  static const String settingsBoxName = 'settingsBox';

  // Timer Durations (in seconds)
  static const int defaultWaitDuration = 120; // 2 minutes
  static const int downsellWaitDuration = 30; // 30 seconds

  // Anxiety Levels
  static const int minAnxietyLevel = 1;
  static const int maxAnxietyLevel = 10;

  // UI Constants
  static const double defaultBorderRadius = 24.0;
  static const double defaultPadding = 16.0;
  static const double largePadding = 24.0;
  static const double smallPadding = 8.0;

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
  static const Duration longAnimation = Duration(milliseconds: 600);

  // Breathing Exercise
  static const int breathingCycleSeconds = 4; // 4 seconds inhale, 4 seconds exhale

  // Supported Languages
  static const String defaultLanguage = 'en';
  static const List<String> supportedLanguages = ['en', 'tr'];

  // App Version
  static const String version = '1.0.0';
}
