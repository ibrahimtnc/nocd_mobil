// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thought_entry_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ThoughtEntryModelAdapter extends TypeAdapter<ThoughtEntryModel> {
  @override
  final int typeId = 1;

  @override
  ThoughtEntryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ThoughtEntryModel(
      id: fields[0] as String,
      thought: fields[1] as String,
      anxietyLevel: fields[2] as int,
      createdAt: fields[3] as DateTime,
      waitDurationSeconds: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ThoughtEntryModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.thought)
      ..writeByte(2)
      ..write(obj.anxietyLevel)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.waitDurationSeconds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThoughtEntryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
