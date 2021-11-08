import 'package:catan_master/core/core.dart';
import 'package:catan_master/data/players/player_datasource.dart';
import 'package:catan_master/data/players/player_dtos.dart';
import 'package:hive/hive.dart';

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
  Future<List<PlayerDto>> getPlayers() async {
    return _box.values.toList();
  }

  @override
  Future<void> createPlayer(PlayerDto player) {
    if (_box.get(player.username) != null) {
      throw CacheException(
          "Player with username '${player.username}' already exists.");
    }
    return _box.put(player.username, player);
  }

  @override
  Future<void> updatePlayer(PlayerDto player) {
    if (_box.get(player.username) == null) {
      throw CacheException(
          "No player with username '${player.username}' found.");
    }
    return _box.put(player.username, player);
  }
}
