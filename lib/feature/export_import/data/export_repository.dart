import 'dart:async';
import 'dart:convert';

import 'package:catan_master/core/failures.dart';
import 'package:catan_master/data/games/game_datasource.dart';
import 'package:catan_master/data/players/player_datasource.dart';
import 'package:catan_master/feature/export_import/data/export_json_dto.dart';
import 'package:catan_master/feature/export_import/domain/export_repository.dart';
import 'package:dartz/dartz.dart';

class DefaultExportRepository extends ExportRepository {
  final PlayerDatasource playerDatasource;
  final GameDatasource gameDatasource;

  DefaultExportRepository({required this.playerDatasource, required this.gameDatasource});

  @override
  Future<Either<Failure, String>> exportData() async {
    final players = await playerDatasource.getPlayers();
    final games = await gameDatasource.getGames();

    final ExportJsonDtoV1 export = ExportJsonDtoV1(games: games, players: players);

    return Right(jsonEncode(export.toJson()));
  }
}
