import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ocdcoach/app.dart';
import 'package:ocdcoach/src/core/firebase/firebase_service.dart';
import 'package:ocdcoach/src/core/services/localization_service.dart';
import 'package:ocdcoach/src/core/storage/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for local storage
  await HiveService.init();

  // Initialize Firebase
  await FirebaseService.init();

  // Initialize Localization Service
  final settingsBox = HiveService.settingsBox;
  final defaultLanguage = settingsBox.get('settings')?.language ?? 'en';
  await LocalizationService.instance.loadLanguage(defaultLanguage);

  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}
