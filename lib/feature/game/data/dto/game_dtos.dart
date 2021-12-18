import 'package:catan_master/core/enum_utils.dart';
import 'package:catan_master/core/failures.dart';
import 'package:catan_master/feature/game/domain/game.dart';
import 'package:catan_master/feature/player/domain/player.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
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

class GameMapper {
  final Map<String, Player> playerMap;

  GameMapper(Map<String?, Player?> playerMap) : this.playerMap = Map.unmodifiable(playerMap);

  Either<MapFailure, Game> map(GameDto gameDto) {
    final List<String>? playerStrings = gameDto.players;
    if (playerStrings == null) {
      return const Left(MapFailure("Players should be null"));
    }
    if (!playerStrings.contains(gameDto.winner)) {
      return Left(MapFailure(
          "Game of ${gameDto.time}: Winner [${gameDto.winner}] should be one of the players [${playerStrings.join(", ")}]"));
    }
    if (gameDto.time == null) {
      return const Left(MapFailure("Time should not be null"));
    }
    List<Player> players = <Player>[];
    for (String playerString in playerStrings) {
      Player? player = playerMap[playerString];
      if (player == null) {
        return Left(MapFailure("Not all players [${playerStrings.join(", ")}] are in the player map!"));
      } else {
        players.add(player);
      }
    }

    List<CatanExpansion> expansions = <CatanExpansion>[];
    List<CatanScenario> scenarios = <CatanScenario>[];

    List<String>? expStrings = gameDto.expansions;
    if (expStrings != null) {
      for (String exp in expStrings) {
        final expansion = EnumUtils.fromStringOrNull(CatanExpansion.values, exp);
        if (expansion != null && !expansions.contains(expansion)) {
          expansions.add(expansion);
        }
        if (exp.replaceAll('_', '').toLowerCase() == describeEnum(CatanScenario.legendOfTheConquerers).toLowerCase()) {
          scenarios.add(CatanScenario.legendOfTheConquerers);
        }
      }
    }

    List<String>? sceStrings = gameDto.scenarios;
    if (sceStrings != null) {
      for (String sce in sceStrings) {
        final scenario = EnumUtils.fromStringOrNull(CatanScenario.values, sce);
        if (scenario != null && !scenarios.contains(scenario)) {
          scenarios.add(scenario);
        }
      }
    }

    if (scenarios.contains(CatanScenario.legendOfTheConquerers)) {
      if (!expansions.contains(CatanExpansion.citiesAndKnights)) {
        expansions.insert(0, CatanExpansion.citiesAndKnights);
      }
    }

    //TODO catch DomainExceptions
    Map<String, int>? scores = gameDto.scores;
    if (scores != null && scores.isNotEmpty) {
      if (players.any((p) => scores[p.username] == null)) {
        return const Left(MapFailure("Score for a player was null"));
      }
      return Right(Game.withScores(
        scores: {for (var p in players) p: scores[p.username]!},
        date: DateTime.fromMillisecondsSinceEpoch(gameDto.time!),
        expansions: expansions,
        scenarios: scenarios,
      ));
    }

    return Right(
      Game.noScores(
        players: players,
        date: DateTime.fromMillisecondsSinceEpoch(gameDto.time!),
        winner: playerMap[gameDto.winner!],
        expansions: expansions,
        scenarios: scenarios,
      ),
    );
  }
}
