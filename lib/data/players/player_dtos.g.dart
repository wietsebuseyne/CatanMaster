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
    return PlayerDto(
      username: fields[2] as String,
      name: fields[0] as String,
      color: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, PlayerDto obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.color)
      ..writeByte(2)
      ..write(obj.username);
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

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayerDto _$PlayerDtoFromJson(Map<String, dynamic> json) {
  return PlayerDto(
    username: json['username'] as String,
    name: json['name'] as String,
    color: json['color'] as int,
  );
}

Map<String, dynamic> _$PlayerDtoToJson(PlayerDto instance) => <String, dynamic>{
      'name': instance.name,
      'color': instance.color,
      'username': instance.username,
    };
