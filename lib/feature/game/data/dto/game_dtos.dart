import 'package:catan_master/core/enum_utils.dart';
import 'package:catan_master/feature/game/domain/game.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'game_dtos.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 1)
class GameDto extends HiveObject {
  //Primary key
  @HiveField(0)
  int? time;
  @HiveField(1)
  List<String>? players;
  @HiveField(2)
  String? winner;
  @HiveField(3)
  List<String>? expansions;
  @HiveField(5)
  List<String>? scenarios;
  @HiveField(4)
  Map<String, int>? scores;

  GameDto({this.time, this.players, this.winner, this.expansions, this.scenarios, this.scores});

  GameDto.fromDomain(Game game)
      : this.time = game.date.millisecondsSinceEpoch,
        this.players = List.unmodifiable(game.players.map((g) => g.username)),
        this.winner = game.winner.username,
        this.expansions = List.unmodifiable(game.expansions.map(EnumUtils.convertToString)),
        this.scenarios = List.unmodifiable(game.scenarios.map(EnumUtils.convertToString)),
        this.scores = game.scores.map((player, score) => MapEntry(player.username, score));

  factory GameDto.fromJson(Map<String, dynamic> json) => _$GameDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GameDtoToJson(this);
}
