import 'package:catan_master/data/players/player_dtos.dart';

abstract class PlayerDatasource {

  Future<List<PlayerDto>> getPlayers();

  Future<void> createPlayer(PlayerDto player);

  Future<void> updatePlayer(PlayerDto player);

  Future<PlayerDto/*!*/> getPlayer(String username);

  Future<void> deletePlayer(PlayerDto player);

}