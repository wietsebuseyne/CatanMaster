import 'package:catan_master/core/exceptions.dart';
import 'package:catan_master/feature/game/data/dto/game_dtos.dart';
import 'package:hive/hive.dart';

//TODO use a different ID in Game that stays consistent over edits
abstract class GameDatasource {
  Future<List<GameDto>> getGames();

  Stream<List<GameDto>> watchGames();

  Future<void> createGame(GameDto game);

  Future<void> updateGame(int oldGameTime, GameDto game);

  Future<void> deleteGame(int time);
}

class HiveGameDatasource extends GameDatasource {
  final Box<GameDto> _box;

  HiveGameDatasource(this._box);

  @override
  Future<List<GameDto>> getGames() async {
    return _box.values.toList();
  }

  @override
  Stream<List<GameDto>> watchGames() {
    return _box.watch().map((_) => _box.values.toList());
  }

  @override
  Future<void> createGame(GameDto game) {
    if (_box.containsKey(game.time.toString())) {
      throw CacheException("Already contains a game with time ${game.time}");
    }
    return _box.put(game.time.toString(), game);
  }

  @override
  Future<void> updateGame(int oldGameTime, GameDto game) async {
    if (!_box.containsKey(oldGameTime.toString())) {
      throw CacheException("No game with time $oldGameTime exists");
    }
    await _box.delete(oldGameTime.toString());
    await _box.put(game.time.toString(), game);
  }

  @override
  Future<void> deleteGame(int time) async {
    await _box.delete(time.toString());
  }
}
