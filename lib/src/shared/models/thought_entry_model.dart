import 'package:hive/hive.dart';

part 'thought_entry_model.g.dart';

/// Thought entry model for local storage
@HiveType(typeId: 1)
class ThoughtEntryModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String thought;

  @HiveField(2)
  int anxietyLevel;

  @HiveField(3)
  DateTime createdAt;

  @HiveField(4)
  int waitDurationSeconds;

  @HiveField(5)
  String? analysisResult; // JSON string of AnalysisResponseModel

  ThoughtEntryModel({
    required this.id,
    required this.thought,
    required this.anxietyLevel,
    required this.createdAt,
    required this.waitDurationSeconds,
    this.analysisResult,
  });

  factory ThoughtEntryModel.fromJson(Map<String, dynamic> json) {
    return ThoughtEntryModel(
      id: json['id'] as String,
      thought: json['thought'] as String,
      anxietyLevel: json['anxietyLevel'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      waitDurationSeconds: json['waitDurationSeconds'] as int,
      analysisResult: json['analysisResult'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'thought': thought,
      'anxietyLevel': anxietyLevel,
      'createdAt': createdAt.toIso8601String(),
      'waitDurationSeconds': waitDurationSeconds,
      'analysisResult': analysisResult,
    };
  }
}

