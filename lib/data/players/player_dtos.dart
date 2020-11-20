import 'package:catan_master/core/core.dart';
import 'package:catan_master/domain/players/player.dart';
import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
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

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 0)
class PlayerDto extends HiveObject {

  @HiveField(0)
  String username;
  @HiveField(1)
  String name;
  @HiveField(2)
  int color;
  @HiveField(3)
  String gender;

  PlayerDto({this.username, this.name, this.gender, this.color});

  PlayerDto.fromDomain(Player player) :
        this.username = player.username,
        this.name = player.name,
        this.gender = EnumUtils.convertToString(player.gender),
        this.color = player.color.value;

  Player toDomain() => Player(
      username: username,
      name: name,
      gender: EnumUtils.fromString(Gender.values, gender),
      color: Color(color).withAlpha(255)
  );

  factory PlayerDto.fromJson(Map<String, dynamic> json) => _$PlayerDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerDtoToJson(this);

}