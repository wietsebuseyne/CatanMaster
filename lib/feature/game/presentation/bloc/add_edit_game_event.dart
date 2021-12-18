part of 'add_edit_game_bloc.dart';

class AddEditGameEvent extends Equatable {
  final DateTime time;
  final List<Player>? players;
  final Player? winner;
  final List<CatanExpansion> expansions;
  final List<CatanScenario> scenarios;
  final Map<Player, int>? scores;

  const AddEditGameEvent.noScores({
    required this.time,
    required this.players,
    required this.winner,
    required this.expansions,
    required this.scenarios,
  }) : scores = null;

  AddEditGameEvent.withScores({
    required this.time,
    required Map<Player, int> this.scores,
    required this.expansions,
    required this.scenarios,
  })  : assert(scores.isNotEmpty),
        players = null,
        winner = null;

  bool get withScores => scores != null;

  @override
  List<Object?> get props => [time, players, winner, expansions];
}
