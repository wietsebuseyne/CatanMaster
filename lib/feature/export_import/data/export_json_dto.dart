import 'package:catan_master/feature/game/data/dto/game_dtos.dart';
import 'package:catan_master/feature/player/data/dto/player_dtos.dart';
import 'package:json_annotation/json_annotation.dart';

part 'export_json_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class ExportJsonDtoV1 {
  int version;
  List<GameDto>? games;
  List<PlayerDto>? players;

  ExportJsonDtoV1({this.version = 1, this.games, this.players});

  factory ExportJsonDtoV1.fromJson(Map<String, dynamic> json) => _$ExportJsonDtoV1FromJson(json);

  Map<String, dynamic> toJson() => _$ExportJsonDtoV1ToJson(this);
}
