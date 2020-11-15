import 'package:catan_master/core/failures.dart';
import 'package:catan_master/domain/games/game.dart';
import 'package:dartz/dartz.dart';

abstract class GameRepository {

  Future<Either<Failure, List<Game>>> getGames();

  Future<Either<Failure, List<Game>>> getGamesForPlayer(String player);

  Future<Either<Failure, void>> addGame(Game game);

  Future<Either<Failure, void>> editGame(int oldTime, Game updatedGame);

  Future<Either<Failure, void>> deleteGame(Game game);

  Future<Either<Failure, void>> undoDelete();

}