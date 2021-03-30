import 'package:catan_master/core/failures.dart';
import 'package:catan_master/data/players/player_datasource.dart';
import 'package:catan_master/data/players/player_dtos.dart';
import 'package:catan_master/domain/players/player.dart';
import 'package:catan_master/domain/players/player_repository.dart';
import 'package:dartz/dartz.dart';

class CachedPlayerRepository extends PlayerRepository {

  final PlayerDatasource localDatasource;

  CachedPlayerRepository(this.localDatasource);

  @override
  Future<Either<Failure, List<Player>>> getPlayers() async {
    try {
      var dtos = await localDatasource.getPlayers();
      return Right(dtos.map((p) => p.toDomain()).toList());
    } on Exception catch (e) {
      return Left(Failure(e.toString()));
    } on Error catch (error) {
      return Left(Failure(error.toString()));
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
      return Right(localDatasource.createPlayer(PlayerDto.fromDomain(player)));
    } on Exception catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> editPlayer(Player player) async {
    try {
      var players = await localDatasource.getPlayers();
      if (players.any((p) => p.username != player.username && p.name?.toLowerCase() == player.name.toLowerCase())) {
        return Left(Failure("A player with name '${player.name}' already exists"));
      }
      return Right(localDatasource.updatePlayer(PlayerDto.fromDomain(player)));
    } on Exception catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deletePlayer(Player player) async {
    try {
      await localDatasource.deletePlayer(PlayerDto.fromDomain(player));
      return Right(null);
    } on Exception catch (e) {
      return Left(Failure(e.toString()));
    }
  }

}