import 'package:catan_master/data/players/player_dtos.dart';
import 'package:hive/hive.dart';

abstract class PlayerLocalDatasource {

  Future<List<PlayerDto>> getPlayers();

  Future<void> createOrUpdatePlayer(PlayerDto player);

  Future<PlayerDto> getPlayer(String name);

  Future<void> deletePlayer(PlayerDto player);

}

class HivePlayerLocalDatasource extends PlayerLocalDatasource {

  final Box<PlayerDto> _box;

  HivePlayerLocalDatasource(this._box);

  @override
  Future<void> deletePlayer(PlayerDto player) {
    return player.delete();
  }

  @override
  Future<PlayerDto> getPlayer(String name) async {
    return _box.get(name);
  }

  @override
  Future<List<PlayerDto>> getPlayers() async {
    return _box.values.toList();
  }

  @override
  Future<void> createOrUpdatePlayer(PlayerDto player) {
    return _box.put(player.name, player);
  }

}