import 'package:catan_master/data/players/player_datasource.dart';
import 'package:catan_master/data/players/player_dtos.dart';
import 'package:hive/hive.dart';

class HivePlayerDatasource extends PlayerDatasource {

  final Box<PlayerDto> _box;

  HivePlayerDatasource(this._box);

  @override
  Future<void> deletePlayer(PlayerDto player) {
    return player.delete();
  }

  @override
  Future<PlayerDto> getPlayer(String username) async {
    return _box.get(username);
  }

  @override
  Future<List<PlayerDto>> getPlayers() async {
    return _box.values.toList();
  }

  @override
  Future<void> createOrUpdatePlayer(PlayerDto player) {
    return _box.put(player.username, player);
  }

}