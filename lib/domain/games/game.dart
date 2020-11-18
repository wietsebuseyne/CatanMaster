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

}

enum CatanExpansion {

  cities_and_knights, seafarers, explorers_and_pirates, traders_and_barbarians, legend_of_the_conquerers

}