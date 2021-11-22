part of 'games_bloc.dart';

@immutable
abstract class GamesEvent extends Equatable {
  const GamesEvent();
}

class LoadGames extends GamesEvent {
  const LoadGames();

  @override
  List<Object> get props => [];
}

class AddEditGameEvent extends GamesEvent {
  final Game? oldGame;
  final DateTime time;
  final List<Player>? players;
  final Player? winner;
  final List<CatanExpansion> expansions;
  final Map<Player, int>? scores;

  const AddEditGameEvent.noScores({
    this.oldGame,
    required this.time,
    required this.players,
    required this.winner,
    required this.expansions,
  }) : scores = null;

  AddEditGameEvent.withScores({
    this.oldGame,
    required this.time,
    required Map<Player, int> this.scores,
    required this.expansions,
  })  : assert(scores.isNotEmpty),
        players = null,
        winner = null;

  bool get withScores => scores != null;
  bool get isEdit => oldGame != null;

  @override
  List<Object?> get props => [oldGame, time, players, winner, expansions];
}

class DeleteGameEvent extends GamesEvent {
  final Game game;

  const DeleteGameEvent(this.game);

  @override
  List<Object> get props => [game];
}

class UndoDeleteGameEvent extends GamesEvent {
  final Game game;

  const UndoDeleteGameEvent(this.game);

  @override
  List<Object> get props => [game];
}
