import 'package:catan_master/core/mapping.dart';
import 'package:catan_master/feature/player/data/dto/player_dtos.dart';
import 'package:catan_master/feature/player/domain/player.dart';
import 'package:flutter/material.dart';

class PlayerMapper with Mapper<PlayerDto, Player> {
  const PlayerMapper();

  @override
  Future<Player> mapOrThrow(PlayerDto dto, {required MapperRegistry mappers}) async {
    return Player.orThrow(
      username: dto.username,
      name: dto.name,
      gender: Gender.values.byNameOr(dto.gender, orElse: () => Gender.x), //TODO log
      color: Color(dto.color ?? Colors.red.value),
    );
  }
}
