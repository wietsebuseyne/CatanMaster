import 'package:catan_master/domain/games/game.dart';
import 'package:catan_master/domain/players/player.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

part 'player_dtos.g.dart';
/*
part 'player_dtos.freezed.dart';
part 'player_dtos.g.dart';

// https://github.com/ResoCoder/finished-flutter-firebase-ddd-course/blob/master/lib/data/notes/note_dtos.dart
@freezed
abstract class PlayerDto with _$PlayerDto {

  factory PlayerDto({
    @required String name,
    @required int color
  }) = _PlayerDto;

  factory PlayerDto.fromJson(Map<String, dynamic> json) =>
      _$PlayerDtoFromJson(json);

//  factory PlayerDto.fromFirestore(DocumentSnapshot doc) {
//    return NoteDto.fromJson(doc.data).copyWith(id: doc.documentID);
//  }
}*/

@HiveType(typeId: 0)
class PlayerDto extends HiveObject {

  @HiveField(0)
  String name;
  @HiveField(1)
  int color;

  PlayerDto();

  PlayerDto.fromDomain(Player player) : this.name = player.name, this.color = player.color.value;

  Player toDomain() => Player(name: name, color: Color(color));

  PlayerWithGames toDomainWithGames(List<Game> games) => PlayerWithGames(name: name, color: Color(color), games: games);

}