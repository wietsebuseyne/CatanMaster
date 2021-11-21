import 'package:catan_master/data/games/game_dtos.dart';
import 'package:catan_master/data/players/player_dtos.dart';
import 'package:json_annotation/json_annotation.dart';

part 'export_json_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class ExportJsonDtoV1 {
  int get version => 1;

  List<GameDto>? games;
  List<PlayerDto>? players;

  ExportJsonDtoV1({this.games, this.players});

  factory ExportJsonDtoV1.fromJson(Map<String, dynamic> json) => _$ExportJsonDtoV1FromJson(json);

  Map<String, dynamic> toJson() => _$ExportJsonDtoV1ToJson(this);
}