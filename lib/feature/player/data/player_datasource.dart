import 'package:catan_master/core/core.dart';
import 'package:catan_master/feature/player/data/dto/player_dtos.dart';
import 'package:hive/hive.dart';

abstract class PlayerDatasource {
  Future<List<PlayerDto>> getPlayers();

  Stream<List<PlayerDto>> watchPlayers();

  Future<void> createPlayer(PlayerDto player);

  Future<void> updatePlayer(PlayerDto player);

  Future<PlayerDto> getPlayer(String username);

  Future<void> deletePlayer(PlayerDto player);

  Future<bool> exists(String username);
}

class HivePlayerDatasource extends PlayerDatasource {
  final Box<PlayerDto> _box;

  HivePlayerDatasource(this._box);

  @override
  Future<void> deletePlayer(PlayerDto player) {
    return _box.delete(player.username);
  }

  @override
  Future<PlayerDto> getPlayer(String username) async {
    return _box.get(username)!;
  }

  @override
  Stream<List<PlayerDto>> watchPlayers() {
    return _box.watch().map((_) => _box.values.toList());
  }

  @override
  Future<List<PlayerDto>> getPlayers() async {
    return _box.values.toList();
  }

  @override
  Future<void> createPlayer(PlayerDto player) {
    if (_box.get(player.username) != null) {
      throw CacheException("Player with username '${player.username}' already exists.");
    }
    return _box.put(player.username, player);
  }

  @override
  Future<void> updatePlayer(PlayerDto player) {
    if (_box.get(player.username) == null) {
      throw CacheException("No player with username '${player.username}' found.");
    }
    return _box.put(player.username, player);
  }

  @override
  Future<bool> exists(String username) async {
    return _box.containsKey(username);
  }
}
