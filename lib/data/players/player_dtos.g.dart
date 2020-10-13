// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_dtos.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlayerDtoAdapter extends TypeAdapter<PlayerDto> {
  @override
  final int typeId = 0;

  @override
  PlayerDto read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlayerDto()
      ..name = fields[0] as String
      ..color = fields[1] as int;
  }

  @override
  void write(BinaryWriter writer, PlayerDto obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.color);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayerDtoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
