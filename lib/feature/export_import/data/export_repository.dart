import 'dart:async';
import 'dart:convert';

import 'package:catan_master/core/failures.dart';
import 'package:catan_master/feature/export_import/data/export_json_dto.dart';
import 'package:catan_master/feature/export_import/domain/export_repository.dart';
import 'package:catan_master/feature/export_import/domain/import_result.dart';
import 'package:catan_master/feature/game/data/dto/game_dtos.dart';
import 'package:catan_master/feature/game/data/game_datasource.dart';
import 'package:catan_master/feature/player/data/dto/player_dtos.dart';
import 'package:catan_master/feature/player/data/player_datasource.dart';
import 'package:catan_master/feature/player/domain/player.dart';
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

  @override
  Future<Either<Failure, ImportResult>> importData(String data) async {
    try {
      StringBuffer log = StringBuffer();
      int nbPlayers = 0;
      int nbGames = 0;

      final json = jsonDecode(data);
      if (json['version'] is! int) {
        return const Left(Failure('No data structure version specified'));
      }
      int version = json['version'] as int;
      log.writeln('I/ Data version: $version');
      switch (version) {
        case 1:
          final data = ExportJsonDtoV1.fromJson(json);
          Map<String, Player> playerMap = {};
          // 1. import players
          for (final p in data.players ?? <PlayerDto>[]) {
            try {
              Player player = p.toDomain();
              playerMap[player.username] = player;
              if (await playerDatasource.exists(player.username)) {
                log.writeln('W/ Player "${player.username}" already exists. Not overwriting.');
              } else {
                await playerDatasource.createPlayer(p);
                log.writeln('I/ Player "${player.username}" imported successfully.');
                nbPlayers++;
              }
            } catch (e) {
              log
                ..writeln('E/ Invalid player data:')
                ..writeln(p.toJson());
            }
          }
          // 2. import games
          GameMapper mapper = GameMapper(playerMap);
          for (final g in data.games ?? <GameDto>[]) {
            try {
              final mapped = mapper.map(g);
              await mapped.fold(
                (l) async => log.writeln('E/ Error while importing game: $l'),
                (r) async {
                  try {
                    await gameDatasource.createGame(g);
                    nbGames++;
                    log.writeln('I/ Game "${g.time}" imported successfully.');
                  } catch (e) {
                    log.writeln('E/ Error while creating game: $e');
                  }
                },
              );
            } catch (e) {
              log
                ..writeln('E/ Invalid game data:')
                ..writeln(g.toJson());
            }
          }
          break;
      }
      return Right(ImportResult(logs: log.toString(), nbPlayersImported: nbPlayers, nbGamesImported: nbGames));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
