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
      time: fields[0] as int?,
      players: (fields[1] as List?)?.cast<String>(),
      winner: fields[2] as String?,
      expansions: (fields[3] as List?)?.cast<String>(),
      scenarios: (fields[5] as List?)?.cast<String>(),
      scores: (fields[4] as Map?)?.cast<String, int>(),
    );
  }

  @override
  void write(BinaryWriter writer, GameDto obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.time)
      ..writeByte(1)
      ..write(obj.players)
      ..writeByte(2)
      ..write(obj.winner)
      ..writeByte(3)
      ..write(obj.expansions)
      ..writeByte(5)
      ..write(obj.scenarios)
      ..writeByte(4)
      ..write(obj.scores);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is GameDtoAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameDto _$GameDtoFromJson(Map<String, dynamic> json) => GameDto(
      time: json['time'] as int?,
      players: (json['players'] as List<dynamic>?)?.map((e) => e as String).toList(),
      winner: json['winner'] as String?,
      expansions: (json['expansions'] as List<dynamic>?)?.map((e) => e as String).toList(),
      scenarios: (json['scenarios'] as List<dynamic>?)?.map((e) => e as String).toList(),
      scores: (json['scores'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as int),
      ),
    );

Map<String, dynamic> _$GameDtoToJson(GameDto instance) => <String, dynamic>{
      'time': instance.time,
      'players': instance.players,
      'winner': instance.winner,
      'expansions': instance.expansions,
      'scenarios': instance.scenarios,
      'scores': instance.scores,
    };
