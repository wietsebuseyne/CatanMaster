import 'package:catan_master/data/games/game_dtos.dart';

abstract class GameDatasource {
  Future<List<GameDto>> getGames();

  Future<void> createGame(GameDto game);

  Future<void> updateGame(int oldGameTime, GameDto game);

  Future<void> deleteGame(int time);
}
