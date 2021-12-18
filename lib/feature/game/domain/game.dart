import 'package:catan_master/core/core.dart';
import 'package:catan_master/feature/player/domain/player.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Game extends Equatable {
  final DateTime date;
  final List<Player> players;
  final Player winner;
  final Map<Player, int> scores;
  final List<CatanExpansion> expansions;
  final List<CatanScenario> scenarios;

  bool get hasScores => scores.isNotEmpty;

  bool get hasExpansion => expansions.isNotEmpty;

  bool get hasScenario => scenarios.isNotEmpty;

  Game._({
    required this.date,
    required this.winner,
    required List<Player> players,
    Map<Player, int> scores = const {},
    required List<CatanExpansion> expansions,
    required List<CatanScenario> scenarios,
  })  : assert(players.isNotEmpty),
        this.players = List.unmodifiable(players..sort((p1, p2) => p1.name.compareTo(p2.name))),
        this.expansions = List.unmodifiable(expansions),
        this.scenarios = List.unmodifiable(scenarios),
        this.scores = Map.unmodifiable(scores);

  factory Game.noScores({
    required DateTime? date,
    required List<Player>? players,
    required Player? winner,
    required List<CatanExpansion> expansions,
    required List<CatanScenario> scenarios,
  }) {
    if (date == null) {
      throw const DomainException("Date must not be null", "date");
    }
    if (winner == null) {
      throw const DomainException("Winner must not be empty", "winner");
    }
    if (players == null) {
      throw const DomainException("Players cannot be null", "players");
    }
    if (players.isEmpty) {
      throw const DomainException("Players cannot be empty", "players");
    }
    if (!players.any((p) => p == winner)) {
      throw const DomainException("Winner must be one of the players", "winner");
    }

    return Game._(
      date: date,
      winner: winner,
      players: players,
      expansions: expansions,
      scenarios: scenarios,
    );
  }

  factory Game.withScores({
    required DateTime? date,
    required Map<Player, int> scores,
    required List<CatanExpansion>? expansions,
    required List<CatanScenario>? scenarios,
  }) {
    if (date == null) {
      throw const DomainException("Date must not be null", "date");
    }
    if (expansions == null) {
      throw const DomainException("expansions cannot be null", "expansions");
    }
    if (scenarios == null) {
      throw const DomainException("scenarios cannot be null", "expansions");
    }
    List<Player> players = scores.keys.toList();
    if (players.any((p) => !_isValidScore(scores[p]))) {
      var player = players.firstWhere((p) => !_isValidScore(scores[p]));
      throw DomainException("Invalid score '${scores[player]}' provided for player '$player'", "scores");
    }
    Player? winner;
    bool multiple = false;
    for (Player? p in players) {
      if (winner == null) {
        winner = p;
      } else if (scores[p]! > scores[winner]!) {
        multiple = false;
        winner = p;
      } else if (scores[p] == scores[winner]) {
        multiple = true;
      }
    }
    if (multiple) {
      throw const DomainException("Only one player can have the highest score", "scores");
    }

    return Game._(
      date: date,
      scores: Map.unmodifiable(scores),
      players: players,
      winner: winner!,
      expansions: expansions,
      scenarios: scenarios,
    );
  }

  List<Player> getPlayersByScoreOrName() {
    return hasScores ? getPlayersByScore() : players;
  }

  List<Player> getPlayersByScore() {
    if (!hasScores) throw StateError("This game has no scores");
    return List.of(players)..sort((p1, p2) => scores[p2]!.compareTo(scores[p1]!));
  }

  static bool _isValidScore(int? score) {
    return score != null && score > 0;
  }

  @override
  List<Object> get props => [date, players, winner, expansions, scores];

  @override
  String toString() => "Game at ${date.toIso8601String()} with [${players.join(', ')}]";
}

@immutable
class Games {
  final List<Game> games;

  Games(List<Game> games) : this.games = List.unmodifiable(games..sort((g1, g2) => g2.date.compareTo(g1.date)));

  Player? getCatanMaster() => getRanking().firstOrNull;

  Game? getGame(DateTime date) {
    return games.firstWhereOrNull((g) => g.date == date);
  }

  List<Game> getGamesForPlayer(Player player) {
    return games.where((g) => g.players.contains(player)).toList();
  }

  Games filterExpansion(Set<CatanExpansion?> expansions) {
    if (expansions.isEmpty) return this;
    return Games(games.where((g) {
      // Base game or any expansion in provided set
      return (g.expansions.isEmpty && expansions.contains(null)) || g.expansions.any((e) => expansions.contains(e));
    }).toList());
  }

  ///TODO expand with scores
  /// * handle same score / nb of games won
  /// * more points for game with more points
  /// * more points for expansion games
  List<Player> getRanking() {
    Map<Player, int> gamesWon = {};
    games.expand((g) => g.players).forEach((p) => gamesWon[p] = 0);
    for (var g in games) {
      gamesWon[g.winner] = gamesWon[g.winner]! + 1;
    }
    var entries = gamesWon.entries.toList();
    entries.sort((e1, e2) => e2.value.compareTo(e1.value));
    return entries.map((e) => e.key).toList();
  }

  Games add(Game newGame) => Games(List.from(games)..add(newGame));

  Games delete(Game? game) => Games(List.of(games)..remove(game));

  bool get isEmpty => games.isEmpty;

  int get length => games.length;

  Game operator [](int index) {
    return games[index];
  }

  @override
  String toString() => "[${games.join(", ")}]";
}

//TODO concept of "Base game" == no expansions
enum CatanExpansion {
  citiesAndKnights,
  seafarers,
  explorersAndPirates,
  tradersAndBarbarians,
  legendOfTheConquerers,
}

extension CatanScenarios on CatanExpansion {
  List<CatanScenario> get scenarios {
    switch (this) {
      case CatanExpansion.tradersAndBarbarians:
        return [
          CatanScenario.fishermenOfCatan,
          CatanScenario.riversOfCatan,
          CatanScenario.caravans,
          CatanScenario.barbarianAttack,
          CatanScenario.tradersAndBarbarians,
        ];
      case CatanExpansion.seafarers:
        return [
          CatanScenario.legendOfTheSeaRobbers,
          CatanScenario.treasuresDragonsAndAdventurers,
        ];
      case CatanExpansion.citiesAndKnights:
        return [
          CatanScenario.legendOfTheConquerers,
          CatanScenario.treasuresDragonsAndAdventurers,
        ];
      default:
        return [];
    }
  }
}

enum CatanScenario {
  legendOfTheConquerers,
  treasuresDragonsAndAdventurers,
  legendOfTheSeaRobbers,
  fishermenOfCatan,
  riversOfCatan,
  caravans,
  barbarianAttack,
  tradersAndBarbarians
}

extension CatanExpansions on CatanScenario {
  List<CatanExpansion> get expansions {
    switch (this) {
      case CatanScenario.treasuresDragonsAndAdventurers:
        return [
          CatanExpansion.seafarers,
          CatanExpansion.citiesAndKnights,
        ];
      case CatanScenario.legendOfTheConquerers:
        return [CatanExpansion.citiesAndKnights];
      case CatanScenario.legendOfTheSeaRobbers:
        return [CatanExpansion.seafarers];
      case CatanScenario.fishermenOfCatan:
      case CatanScenario.riversOfCatan:
      case CatanScenario.caravans:
      case CatanScenario.barbarianAttack:
      case CatanScenario.tradersAndBarbarians:
        return [CatanExpansion.tradersAndBarbarians];
    }
  }
}
