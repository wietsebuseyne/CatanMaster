import 'package:catan_master/core/core.dart';
import 'package:catan_master/domain/players/player.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meta/meta.dart';

class Game extends Equatable {

  final DateTime date;
  final List<Player> players;
  final Player winner;
  final Map<Player, int> scores;
  final List<CatanExpansion> expansions;

  bool get hasScores => scores.isNotEmpty;

  bool get hasExpansion => expansions.isNotEmpty;

  Game._({
    required this.date,
    required this.winner,
    required List<Player> players,
    Map<Player, int> scores = const {},
    List<CatanExpansion> expansions = const [],
  })
      : assert(scores.isNotEmpty || players.isNotEmpty),
        assert(scores.isEmpty || players.isEmpty),
        this.players = List.unmodifiable(players..sort((p1, p2) => p1.name.compareTo(p2.name))),
        this.expansions = List.unmodifiable(expansions),
        this.scores = Map.unmodifiable(scores);

  factory Game.noScores({
    required DateTime? date,
    required List<Player>? players,
    required Player? winner,
    List<CatanExpansion> expansions = const [],
  }) {
    if (date == null) throw DomainException("Date must not be null", "date");
    if (winner == null) throw DomainException("Winner must not be empty", "winner");
    if (players == null) throw DomainException("Players cannot be null", "players");
    if (players.isEmpty) throw DomainException("Players cannot be empty", "players");
    if (!players.any((p) => p == winner)) {
      throw DomainException("Winner must be one of the players", "winner");
    }

    return Game._(
      date: date,
      winner: winner,
      players: players,
      expansions: expansions,
    );
  }

  factory Game.withScores({
    required DateTime? date,
    required Map<Player, int> scores,
    List<CatanExpansion>? expansions = const []
  }) {
    if (date == null) throw DomainException("Date must not be null", "date");
    if (expansions == null) throw DomainException("expansions cannot be null", "expansions");

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
      throw DomainException("Only one player can have the highest score", "scores");
    }

    return Game._(
      date: date,
      scores: Map.unmodifiable(scores),
      players: players,
      winner: winner!,
      expansions: expansions,
    );
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

  List<Game> getGamesForPlayer(Player player) {
    return games.where((g) => g.players.contains(player)).toList();
  }

  Games filterExpansion(Set<CatanExpansion?> expansions) {
    if (expansions.isEmpty) return this;
    return Games(games.where((g) {
      // Base game or any expansion in provided set
      return (g.expansions.isEmpty && expansions.contains(null))
          || g.expansions.any((e) => expansions.contains(e));
    }).toList());
  }

  ///TODO expand with scores
  /// * handle same score / nb of games won
  /// * more points for game with more points
  /// * more points for expansion games
  List<Player> getRanking() {
    Map<Player, int> gamesWon = {};
    games.expand((g) => g.players).forEach((p) => gamesWon[p] = 0);
    games.forEach((g) => gamesWon[g.winner] = gamesWon[g.winner]! + 1);
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

  cities_and_knights, seafarers, explorers_and_pirates, traders_and_barbarians, legend_of_the_conquerers

}