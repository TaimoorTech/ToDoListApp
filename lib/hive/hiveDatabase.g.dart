// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hiveDatabase.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveDatabaseAdapter extends TypeAdapter<HiveDatabase> {
  @override
  final int typeId = 1;

  @override
  HiveDatabase read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveDatabase(
      id: fields[0] as int,
      title: fields[1] as String,
      dueDate: fields[2] as String,
      finishedTime: fields[3] as String,
      status: fields[4] as String,
      isDone: fields[5] as String,
      imageTask: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HiveDatabase obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.dueDate)
      ..writeByte(3)
      ..write(obj.finishedTime)
      ..writeByte(4)
      ..write(obj.status)
      ..writeByte(5)
      ..write(obj.isDone)
      ..writeByte(6)
      ..write(obj.imageTask);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveDatabaseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
