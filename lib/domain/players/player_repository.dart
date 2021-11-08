import 'package:catan_master/core/failures.dart';
import 'package:catan_master/domain/players/player.dart';
import 'package:dartz/dartz.dart';

abstract class PlayerRepository {
  Future<Either<Failure, List<Player>>> getPlayers();

  Future<Either<Failure, void>> addPlayer(Player player);

  Future<Either<Failure, void>> editPlayer(Player player);

  Future<Either<Failure, void>> deletePlayer(Player player);
}

/// When you try to delete a player which still has games assigned to him
class PlayerHasGamesFailure extends Failure {
  const PlayerHasGamesFailure(Player player, {required int nbGames})
      : super(
            "Player '$player' has $nbGames game(s).\nOnly players with no games can be deleted. "
            "Either delete all the games or remove '$player' from those games.");
}
