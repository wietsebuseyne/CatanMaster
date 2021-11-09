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
      username: fields[0] as String?,
      name: fields[1] as String?,
      gender: fields[3] as String?,
      color: fields[2] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, PlayerDto obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.username)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.color)
      ..writeByte(3)
      ..write(obj.gender);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is PlayerDtoAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayerDto _$PlayerDtoFromJson(Map<String, dynamic> json) => PlayerDto(
      username: json['username'] as String?,
      name: json['name'] as String?,
      gender: json['gender'] as String?,
      color: json['color'] as int?,
    );

Map<String, dynamic> _$PlayerDtoToJson(PlayerDto instance) => <String, dynamic>{
      'username': instance.username,
      'name': instance.name,
      'color': instance.color,
      'gender': instance.gender,
    };
