import 'package:catan_master/data/games/game_dtos.dart';
import 'package:catan_master/data/players/player_dtos.dart';
import 'package:json_annotation/json_annotation.dart';

part 'export_json_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class ExportJsonDto {

  int? version;

  List<GameDto>? games;
  List<PlayerDto>? players;

  ExportJsonDto({this.version, this.games, this.players});

  factory ExportJsonDto.fromJson(Map<String, dynamic> json) => _$ExportJsonDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ExportJsonDtoToJson(this);
}