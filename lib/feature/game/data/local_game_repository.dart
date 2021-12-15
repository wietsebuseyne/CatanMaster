import 'dart:collection';

import 'package:catan_master/core/failures.dart';
import 'package:catan_master/feature/game/data/game_datasource.dart';
import 'package:catan_master/feature/game/data/dto/game_dtos.dart';
import 'package:catan_master/feature/game/domain/game.dart';
import 'package:catan_master/feature/game/domain/game_repository.dart';
import 'package:catan_master/feature/player/domain/player.dart';
import 'package:catan_master/feature/player/domain/player_repository.dart';
import 'package:dartz/dartz.dart';

class LocalGameRepository extends GameRepository {
  final GameDatasource gameDatasource;
  final PlayerRepository playerRepository;
  final ListQueue<Game> deletedGames = ListQueue();

  LocalGameRepository({required this.gameDatasource, required this.playerRepository});

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
    return (await playerRepository.getPlayers()).fold(
      (l) async => Left(l),
      (r) async => await _getGamesInternal(r),
    );
  }

  Future<Either<Failure, List<Game>>> _getGamesInternal(List<Player> players) async {
    try {
      Map<String?, Player?> playerMap = {for (var p in players) p.username: p};

      var gamesDtos = await gameDatasource.getGames();
      GameMapper mapper = GameMapper(playerMap);
      return Right(gamesDtos.map(mapper.map).toList().fold(
        <Game>[],
        (List<Game> list, failureOrGame) {
          return failureOrGame.fold((l) {
            //TODO save this error to another repository
            // This repository can then alert the user of these mapping errors
            // and provide solutions (for example: add Player with name ...)
            return list;
          }, (r) => list..add(r));
        },
      ));
    } on Exception catch (e) {
      return Left(Failure(e.toString()));
    }
  }

/*
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
      await localDatasource.deletePlayer(PlayerDto.fromDomain(player));
      return const Right(null);
    } on Exception catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Player>>> getPlayers() async {
    try {
      return Right((await localDatasource.getPlayers()).map((p) => p.toDomain()).toList());
    } on Exception catch (e) {
      return Left(Failure(e.toString()));
    }
  }*/

}
