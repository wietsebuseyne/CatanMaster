import 'package:catan_master/core/core.dart';
import 'package:catan_master/core/mapping.dart';
import 'package:catan_master/core/validation.dart';
import 'package:catan_master/feature/game/data/dto/game_dtos.dart';
import 'package:catan_master/feature/game/domain/game.dart';
import 'package:catan_master/feature/player/domain/player.dart';
import 'package:catan_master/feature/player/domain/player_repository.dart';

class GameMapper with Mapper<GameDto, Game> {
  final PlayerRepository playerRepository;

  GameMapper({required this.playerRepository});

  @override
  Future<Game> mapOrThrow(GameDto dto, {required MapperRegistry mappers}) async {
    final playersMap = await playerRepository.getPlayersMap();
    final List<String> playerStrings = validateLength('players', dto.players, min: 2);

    // players
    List<Player> players = <Player>[];
    for (String playerString in playerStrings) {
      Player? player = playersMap[playerString]?.fold(
        (l) => throw DomainValidationException('players', 'Error mapping player <$playerString>'),
        (r) => r,
      );
      if (player == null) {
        throw DomainValidationException('players', 'Player <$playerString> not found');
      } else {
        players.add(player);
      }
    }

    List<CatanExpansion> expansions = <CatanExpansion>[];
    List<CatanScenario> scenarios = <CatanScenario>[];

    // expansions
    for (String exp in dto.expansions ?? []) {
      final expansion = EnumUtils.fromStringOrNull(CatanExpansion.values, exp);
      if (expansion != null && !expansions.contains(expansion)) {
        expansions.add(expansion);
      }
      if (exp.replaceAll('_', '').toLowerCase() == CatanScenario.legendOfTheConquerers.name.toLowerCase()) {
        scenarios.add(CatanScenario.legendOfTheConquerers);
      }
    }

    // scenarios
    for (String sce in dto.scenarios ?? []) {
      final scenario = EnumUtils.fromStringOrNull(CatanScenario.values, sce);
      if (scenario != null && !scenarios.contains(scenario)) {
        scenarios.add(scenario);
      }
    }
    if (scenarios.contains(CatanScenario.legendOfTheConquerers)) {
      if (!expansions.contains(CatanExpansion.citiesAndKnights)) {
        expansions.insert(0, CatanExpansion.citiesAndKnights);
      }
    }

    // scores
    Map<String, int>? scores = dto.scores;
    if (scores != null && scores.isNotEmpty) {
      if (players.any((p) => scores[p.username] == null)) {
        throw const DomainValidationException('scores', 'All players must have a score');
      }
      return Game.withScores(
        scores: {for (var p in players) p: scores[p.username]!},
        date: DateTime.fromMillisecondsSinceEpoch(dto.time!),
        expansions: expansions,
        scenarios: scenarios,
      );
    }

    Player? winner = playersMap[validateNotNull('winner', dto.winner)]?.fold(
      (l) => throw DomainValidationException('players', 'Error mapping player <${dto.winner}>'),
      (r) => r,
    );
    return Game.noScores(
      players: players,
      date: DateTime.fromMillisecondsSinceEpoch(dto.time!),
      winner: winner,
      expansions: expansions,
      scenarios: scenarios,
    );
  }
}
