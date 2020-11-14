import 'package:catan_master/data/games/game_datasource.dart';
import 'package:catan_master/data/games/game_dtos.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseGameDatasource extends GameDatasource {

  final FirebaseDatabase database;
  DatabaseReference _gamesRef;

  FirebaseGameDatasource(this.database) {
    _gamesRef = database.reference().child("test/games");
    _gamesRef.keepSynced(true);
  }

  @override
  Future<void> createGame(GameDto game) {
    return _gamesRef.child(game.time.toString()).set(game);
  }

  @override
  Future<void> deleteGame(int time) {
    return _gamesRef.child(time.toString()).remove();
  }

  @override
  Future<List<GameDto>> getGames() async {
    Map data = (await _gamesRef.orderByKey().once()).value;
    return data.entries.map((entry) => GameDto(
      time: int.parse(entry.key),
      winner: entry.value["winner"],
      players: (entry.value["players"] as List).map((e) => e.toString()).toList(),
      expansions: (entry.value["expansions"] as List)?.map((e) => e.toString())?.toList() ??[],
    )).toList();
  }

  @override
  Future<void> updateGame(int oldGameTime, GameDto game) {
    return _gamesRef.child(oldGameTime.toString()).update(game.toJson());
  }

}