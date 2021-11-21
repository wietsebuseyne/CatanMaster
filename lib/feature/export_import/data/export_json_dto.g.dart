// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'export_json_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExportJsonDtoV1 _$ExportJsonDtoV1FromJson(Map<String, dynamic> json) => ExportJsonDtoV1(
      games: (json['games'] as List<dynamic>?)?.map((e) => GameDto.fromJson(e as Map<String, dynamic>)).toList(),
      players: (json['players'] as List<dynamic>?)?.map((e) => PlayerDto.fromJson(e as Map<String, dynamic>)).toList(),
    );

Map<String, dynamic> _$ExportJsonDtoV1ToJson(ExportJsonDtoV1 instance) => <String, dynamic>{
      'games': instance.games?.map((e) => e.toJson()).toList(),
      'players': instance.players?.map((e) => e.toJson()).toList(),
    };
