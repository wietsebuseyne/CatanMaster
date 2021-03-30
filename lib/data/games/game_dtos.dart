import 'package:catan_master/core/enum_utils.dart';
import 'package:catan_master/core/failures.dart';
import 'package:catan_master/domain/games/game.dart';
import 'package:catan_master/domain/players/player.dart';
import 'package:dartz/dartz.dart';
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
  @HiveField(4)
  Map<String, int>? scores;

  GameDto({this.time, this.players, this.winner, this.expansions, this.scores});

  GameDto.fromDomain(Game game) :
        this.time = game.date.millisecondsSinceEpoch,
        this.players = List.unmodifiable(game.players.map((g) => g.username)),
        this.winner = game.winner.username,
        this.expansions = List.unmodifiable(game.expansions.map(EnumUtils.convertToString)),
        this.scores = game.scores.map((player, score) => MapEntry(player.username, score));

  factory GameDto.fromJson(Map<String, dynamic> json) => _$GameDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GameDtoToJson(this);

}

class GameMapper {

  final Map<String, Player> playerMap;

  GameMapper(Map<String?, Player?> playerMap) : this.playerMap = Map.unmodifiable(playerMap);

  Either<MapFailure, Game> map(GameDto gameDto) {
    final List<String>? playerStrings = gameDto.players;
    if (playerStrings == null) {
      return Left(MapFailure("Players should be null"));
    }
    if (!playerStrings.contains(gameDto.winner)) {
      return Left(MapFailure("Game of ${gameDto.time}: Winner [${gameDto.winner}] should be one of the players [${playerStrings.join(", ")}]"));
    }
    if (gameDto.time == null) {
      return Left(MapFailure("Time should not be null"));
    }
    List<Player> players = <Player>[];
    for(String playerString in playerStrings) {
      Player? player = playerMap[playerString];
      if (player == null) {
        return Left(MapFailure("Not all players [${playerStrings.join(", ")}] are in the player map!"));
      } else {
        players.add(player);
      }
    }

    List<CatanExpansion> expansions = <CatanExpansion>[];
    List<String>? expStrings = gameDto.expansions;
    try {
      if (expStrings != null) {
        for (String exp in expStrings) {
          expansions.add(EnumUtils.fromString(
              CatanExpansion.values,
              exp,
              orElse: () => throw FormatException("Invalid expansion: $exp")
          ));
        }
      }
    } on FormatException catch(e) {
      return Left(MapFailure(e.message));
    }

    //TODO catch DomainExceptions
    Map<String, int>? scores = gameDto.scores;
    if (scores != null && scores.isNotEmpty) {
      if (players.any((p) => scores[p.username] == null)) {
        return Left(MapFailure("Score for a player was null"));
      }
      return Right(Game.withScores(
          scores: Map.fromIterable(players, key: (p) => p, value: (p) => scores[p.username]!),
          date: DateTime.fromMillisecondsSinceEpoch(gameDto.time!),
          expansions: expansions
      ));
    }

    return Right(Game.noScores(
      players: players,
      date: DateTime.fromMillisecondsSinceEpoch(gameDto.time!),
      winner: playerMap[gameDto.winner!],
      expansions: expansions
    ));
  }

}