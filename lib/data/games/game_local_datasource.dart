import 'package:catan_master/core/exceptions.dart';
import 'package:catan_master/data/games/game_dtos.dart';
import 'package:hive/hive.dart';

abstract class GameLocalDatasource {

  Future<List<GameDto>> getGames();

  Future<void> createGame(GameDto game);

  Future<void> updateGame(int oldGameTime, GameDto game);

  Future<void> deleteAll();

  Future<void> deleteGame(int time);

}

class HiveGameLocalDatasource extends GameLocalDatasource {

  final Box<GameDto> _box;

  HiveGameLocalDatasource(this._box);

  @override
  Future<List<GameDto>> getGames() async {
    return _box.values.toList();
  }

  @override
  Future<void> createGame(GameDto game) {
    if (_box.containsKey(game.time)) {
      throw CacheException("Already contains a game with time ${game.time}");
    }
    return _box.put(game.time.toString(), game);
  }

  @override
  Future<void> updateGame(int oldGameTime, GameDto game) async {
    if (!_box.containsKey(oldGameTime)) {
      throw CacheException("No game with time $oldGameTime exists");
    }
    await _box.delete(oldGameTime);
    await _box.put(game.time, game);
    return null;
  }

  @override
  Future<void> deleteAll() async {
    await _box.clear();
    return null;
  }

  @override
  Future<void> deleteGame(int time) async {
    await _box.delete(time);
    return null;
  }

}