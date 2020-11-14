// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_dtos.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GameDtoAdapter extends TypeAdapter<GameDto> {
  @override
  final int typeId = 1;

  @override
  GameDto read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GameDto(
      time: fields[0] as int,
      players: (fields[1] as List)?.cast<String>(),
      winner: fields[2] as String,
      expansions: (fields[3] as List)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, GameDto obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.time)
      ..writeByte(1)
      ..write(obj.players)
      ..writeByte(2)
      ..write(obj.winner)
      ..writeByte(3)
      ..write(obj.expansions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameDtoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameDto _$GameDtoFromJson(Map<String, dynamic> json) {
  return GameDto(
    time: json['time'] as int,
    players: (json['players'] as List)?.map((e) => e as String)?.toList(),
    winner: json['winner'] as String,
    expansions: (json['expansions'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$GameDtoToJson(GameDto instance) => <String, dynamic>{
      'time': instance.time,
      'players': instance.players,
      'winner': instance.winner,
      'expansions': instance.expansions,
    };
