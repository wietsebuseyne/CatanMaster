import 'package:catan_master/core/failures.dart';
import 'package:catan_master/core/usecase.dart';
import 'package:catan_master/domain/games/game_repository.dart';
import 'package:catan_master/domain/players/player.dart';
import 'package:catan_master/domain/players/player_repository.dart';
import 'package:dartz/dartz.dart';

class DeletePlayer extends UseCase<void, Player> {
  final PlayerRepository playerRepository;
  final GameRepository gameRepository;

  DeletePlayer({required this.playerRepository, required this.gameRepository});

  @override
  Future<Either<Failure, void>> call(Player player) async {
    return (await gameRepository.getGamesForPlayer(player.username)).fold((failure) => Left(failure), (games) {
      if (games.isNotEmpty) {
        return Left(PlayerHasGamesFailure(player, nbGames: games.length));
      }
      return playerRepository.deletePlayer(player);
    });
  }
}
