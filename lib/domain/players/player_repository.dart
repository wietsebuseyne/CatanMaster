import 'package:catan_master/core/failures.dart';
import 'package:catan_master/domain/players/player.dart';
import 'package:dartz/dartz.dart';

abstract class PlayerRepository {

  Future<Either<Failure, List<Player>>> getPlayers();

  Future<Either<Failure, void>> addPlayer(Player player);

  Future<Either<Failure, void>> editPlayer(Player player);

  Future<Either<Failure, void>> deletePlayer(Player player);

}