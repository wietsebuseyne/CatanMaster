// import 'dart:async';
//
// import 'package:catan_master/core/core.dart';
// import 'package:catan_master/data/players/player_datasource.dart';
// import 'package:catan_master/data/players/player_dtos.dart';
// import 'package:firebase_database/firebase_database.dart';
//
// class FirebasePlayerDatasource extends PlayerDatasource {
//
//   final FirebaseDatabase database;
//   DatabaseReference _playersRef;
//
//   FirebasePlayerDatasource(this.database) {
//     _playersRef = database.reference().child("test/players");
//     _playersRef.keepSynced(true);
//   }
//
//   @override
//   Future<void> deletePlayer(PlayerDto player) {
//     return _playersRef.child(player.name).remove();
//   }
//
//   @override
//   Future<PlayerDto> getPlayer(String username) async {
//     var data = await _playersRef.child(username).once();
//     return PlayerDto(username: username, name: data.value["name"], color: data.value["color"]);
//   }
//
//   @override
//   Future<List<PlayerDto>> getPlayers() async {
//     var dataSnapshot = await _playersRef.once();
//     Map values = dataSnapshot.value;
//
//     return values.entries.map(
//             (entry) => PlayerDto(username: entry.key, name: entry.value["name"], color: entry.value["color"])
//     ).toList();
//   }
//
//   @override
//   Future<void> createPlayer(PlayerDto player) async {
//     var current = await _playersRef.child(player.name).once();
//     if (current.value != null) {
//       //TODO throw AlreadyExistsException and let the bloc handle the message to prevent duplication
//       throw CacheException("Player with username '${player.username}' already exists.");
//     }
//     return _playersRef.child(player.name).update(player.toJson());
//   }
//
//   @override
//   Future<void> updatePlayer(PlayerDto player) async {
//     var current = await _playersRef.child(player.name).once();
//     if (current.value == null) {
//       throw CacheException("No player with username '${player.username}' found.");
//     }
//     return _playersRef.child(player.name).update(player.toJson());
//   }
//
// }