// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'relay.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RelayAdapter extends TypeAdapter<Relay> {
  @override
  final int typeId = 2;

  @override
  Relay read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Relay(
      fields[0] as String,
      fields[1] as bool,
      fields[2] as bool,
      fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Relay obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.url)
      ..writeByte(1)
      ..write(obj.read)
      ..writeByte(2)
      ..write(obj.write)
      ..writeByte(3)
      ..write(obj.active);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RelayAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
