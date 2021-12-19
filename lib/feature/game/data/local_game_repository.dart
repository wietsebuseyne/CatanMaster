import 'dart:collection';

import 'package:catan_master/core/failures.dart';
import 'package:catan_master/core/mapping.dart';
import 'package:catan_master/feature/game/data/dto/game_dtos.dart';
import 'package:catan_master/feature/game/data/game_datasource.dart';
import 'package:catan_master/feature/game/domain/game.dart';
import 'package:catan_master/feature/game/domain/game_repository.dart';
import 'package:catan_master/feature/player/data/player_datasource.dart';
import 'package:dartz/dartz.dart';
import 'package:stream_transform/stream_transform.dart';

class LocalGameRepository extends GameRepository {
  final GameDatasource gameDatasource;
  final PlayerDatasource playerDatasource;
  final ListQueue<Game> deletedGames = ListQueue();
  final MapperRegistry mappers;

  LocalGameRepository({required this.gameDatasource, required this.playerDatasource})
      : this.mappers = MapperRegistry.instance;

  @override
  Future<Either<Failure, List<Game>>> getGamesForPlayer(String username) async {
    return (await getGames()).fold(
      (failure) => Left(failure),
      (games) => Right(games.where((g) => g.players.map((p) => p.username).contains(username)).toList()),
    );
  }

  @override
  Future<Either<Failure, bool>> hasGames(String username) async {
    return (await getGames()).fold(
      (failure) => Left(failure),
      (games) => Right(games.any((g) => g.players.map((p) => p.username).contains(username))),
    );
  }

  @override
  Future<Either<Failure, void>> addGame(Game game) async {
    try {
      //TODO check player references here
      await gameDatasource.createGame(GameDto.fromDomain(game));
      return const Right(null);
    } on Exception catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteGame(Game game) async {
    try {
      await gameDatasource.deleteGame(game.date.millisecondsSinceEpoch);
      deletedGames.add(game);
      return const Right(null);
    } on Exception catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Game?>> undoDelete({Game? game}) async {
    if (game == null && deletedGames.isEmpty) return const Right(null);
    try {
      game ??= deletedGames.last;
      await gameDatasource.createGame(GameDto.fromDomain(game));
      deletedGames.remove(game);
      return Right(game);
    } on Exception catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> editGame(int oldTime, Game updatedGame) async {
    try {
      await gameDatasource.updateGame(oldTime, GameDto.fromDomain(updatedGame));
      return const Right(null);
    } on Exception catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Game>>> getGames() async {
    return _getGamesInternal(await gameDatasource.getGames());
  }

  @override
  Stream<Either<Failure, List<Game>>> watchGames({bool seeded = true}) async* {
    // update when player or game has an update
    yield* playerDatasource.watchPlayers(seeded: true).combineLatest<List<GameDto>, Either<Failure, List<Game>>>(
      gameDatasource.watchGames(seeded: seeded),
      (players, games) {
        return _getGamesInternal(games);
      },
    );
  }

  Future<Either<Failure, List<Game>>> _getGamesInternal(List<GameDto> dtos) async {
    try {
      return Right(await mappers.mapIterableWithoutFailures(dtos));
    } on Exception catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
