import 'package:catan_master/domain/players/player.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meta/meta.dart';

class Game extends Equatable {

  final DateTime date;
  final List<Player> players;
  final Player _winner;
  final Map<Player, int> scores;
  final List<CatanExpansion> expansions;

  Player get winner {
    if (scores.isNotEmpty) return players.first;
    return _winner;
  }

  bool get hasScores => scores.isNotEmpty;

  bool get hasExpansion => expansions.isNotEmpty;

  Game.noScores({@required this.date, @required this.players, @required Player winner, this.expansions = const []})
      : assert(date != null),
        assert(winner != null),
        scores = {},
        _winner = winner;

  Game.withScores({
    @required this.date,
    Map<Player, int> scores,
    this.expansions = const []
  })  : this.scores = Map.unmodifiable(scores),
        this.players = List.unmodifiable(List.of(scores.keys)..sort((p1, p2) => scores[p2].compareTo(scores[p1]))),
        this._winner = null;

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

  ///TODO expand with scores
  /// * handle same score / nb of games won
  /// * more points for game with more points
  /// * more points for expansion games
  List<Player> getRanking() {
    Map<Player, int> gamesWon = {};
    games.expand((g) => g.players).forEach((p) => gamesWon[p] = 0);
    games.forEach((g) => gamesWon[g.winner] = gamesWon[g.winner] + 1);
    var entries = gamesWon.entries.toList();
    entries.sort((e1, e2) => e2.value.compareTo(e1.value));
    return entries.map((e) => e.key).toList();
  }

  Games add(Game newGame) => Games(List.from(games)..add(newGame));

  Games delete(Game game) => Games(List.of(games)..remove(game));

  bool get isEmpty => games.isEmpty;

  int get length => games.length;

  Game operator [](int index) {
    return games[index];
  }

  @override
  String toString() => "[${games.join(", ")}]";
}



enum CatanExpansion {

  cities_and_knights, seafarers, explorers_and_pirates, traders_and_barbarians, legend_of_the_conquerers

}