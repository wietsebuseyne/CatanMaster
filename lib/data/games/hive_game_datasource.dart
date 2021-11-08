import 'package:catan_master/core/exceptions.dart';
import 'package:catan_master/data/games/game_datasource.dart';
import 'package:catan_master/data/games/game_dtos.dart';
import 'package:hive/hive.dart';

class HiveGameDatasource extends GameDatasource {
  final Box<GameDto> _box;

  HiveGameDatasource(this._box);

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
    if (!_box.containsKey(oldGameTime.toString())) {
      throw CacheException("No game with time $oldGameTime exists");
    }
    await _box.delete(oldGameTime);
    await _box.put(game.time.toString(), game);
  }

  @override
  Future<void> deleteGame(int time) async {
    await _box.delete(time.toString());
  }
}
