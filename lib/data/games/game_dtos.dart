import 'package:catan_master/core/enum_utils.dart';
import 'package:catan_master/core/failures.dart';
import 'package:catan_master/domain/games/game.dart';
import 'package:catan_master/domain/players/player.dart';
import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';

part 'game_dtos.g.dart';

@HiveType(typeId: 1)
class GameDto extends HiveObject {

  //Primary key
  @HiveField(0)
  int time;
  @HiveField(1)
  List<String> players;
  @HiveField(2)
  String winner;
  @HiveField(3)
  List<String> expansions;

  GameDto();

  GameDto.fromDomain(Game game) :
        this.time = game.date.millisecondsSinceEpoch,
        this.players = List.unmodifiable(game.players.map((g) => g.name)),
        this.winner = game.winner.name,
        this.expansions = List.unmodifiable(game.expansions.map(EnumUtils.convertToString));

}

class GameMapper {

  final Map<String, Player> playerMap;

  GameMapper(Map<String, Player> playerMap) : this.playerMap = Map.unmodifiable(playerMap);

  Either<MapFailure, Game> map(GameDto gameDto) {
    if (!gameDto.players.contains(gameDto.winner)) {
      return Left(MapFailure("Winner should be one of the players"));
    }
    if (gameDto.time == null) {
      return Left(MapFailure("Time should not be null"));
    }
    if (gameDto.players.any((p) => !playerMap.containsKey(p))) {
      return Left(MapFailure("Not all players are in the player map!"));
    }
    var expansions;
    try {
      expansions = gameDto.expansions.map((e) =>
          EnumUtils.fromString(
              CatanExpansion.values,
              e,
              orElse: () => throw FormatException("Invalid expansion")
          )).toList();
    } on FormatException catch(e) {
      return Left(MapFailure(e.message));
    }

    return Right(Game(
      players: gameDto.players.map((p) => playerMap[p]).toList(),
      date: DateTime.fromMillisecondsSinceEpoch(gameDto.time),
      winner: playerMap[gameDto.winner],
      expansions: expansions
    ));
  }

}