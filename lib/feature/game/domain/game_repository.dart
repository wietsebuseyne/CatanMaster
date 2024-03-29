import 'package:catan_master/core/failures.dart';
import 'package:catan_master/feature/game/domain/game.dart';
import 'package:dartz/dartz.dart';

abstract class GameRepository {
  Future<Either<Failure, List<Game>>> getGames();

  Stream<Either<Failure, List<Game>>> watchGames({bool seeded = true});

  Future<Either<Failure, List<Game>>> getGamesForPlayer(String username);

  Future<Either<Failure, bool>> hasGames(String username);

  Future<Either<Failure, void>> addGame(Game game);

  Future<Either<Failure, void>> editGame(int oldTime, Game updatedGame);

  Future<Either<Failure, void>> deleteGame(Game game);

  Future<Either<Failure, void>> undoDelete({Game? game});
}
