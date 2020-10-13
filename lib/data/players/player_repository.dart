import 'package:catan_master/core/failures.dart';
import 'package:catan_master/data/players/player_dtos.dart';
import 'package:catan_master/data/players/player_local_datasource.dart';
import 'package:catan_master/domain/players/player.dart';
import 'package:catan_master/domain/players/player_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

class CachedPlayerRepository extends PlayerRepository {

  final PlayerLocalDatasource localDatasource;

  CachedPlayerRepository(@required this.localDatasource);

  @override
  Future<Either<Failure, List<Player>>> getPlayers() async {
    try {
      return Right((await localDatasource.getPlayers()).map((p) => p.toDomain()).toList());
    } on Exception catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  /*
  Future<Either<Failure, List<PlayerWithGames>>> getPlayersWithGames() async {
    try {
      var players = await localDatasource.getPlayers();
      Map<String, List<Game>> gameMap = {};
      for (var p in players) {
        gameMap[p.name] = (await gameRepository.getGamesForPlayer(p.name)).fold(
                (failure) => [], //TODO map failure
                (games) => games
        );

      }
      return Right(players.map((p) => p.toDomainWithGames(gameMap[p.name]));
    } on Exception catch (e) {
      return Left(Failure(e.toString()));
    }
  }
   */

  @override
  Future<Either<Failure, void>> addPlayer(Player player) async {
    try {
      return Right(localDatasource.createOrUpdatePlayer(PlayerDto.fromDomain(player)));
    } on Exception catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deletePlayer(Player player) async {
    try {
      //check games
      await localDatasource.deletePlayer(PlayerDto.fromDomain(player));
      return Right(null);
    } on Exception catch (e) {
      return Left(Failure(e.toString()));
    }
  }

}