import 'package:catan_master/data/players/player_dtos.dart';

abstract class PlayerDatasource {

  Future<List<PlayerDto>> getPlayers();

  Future<void> createOrUpdatePlayer(PlayerDto player);

  Future<PlayerDto> getPlayer(String name);

  Future<void> deletePlayer(PlayerDto player);

}