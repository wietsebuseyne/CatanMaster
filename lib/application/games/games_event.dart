part of 'games_bloc.dart';

@immutable
abstract class GamesEvent extends Equatable {}

class LoadGames extends GamesEvent {
  @override
  List<Object> get props => [];
}

class AddEditGameEvent extends GamesEvent {

  final Game oldGame;
  final DateTime time;
  final List<Player> players;
  final Player winner;
  final List<CatanExpansion> expansions;
  final Map<Player, int> scores;

  AddEditGameEvent.noScores({
    this.oldGame,
    @required this.time,
    @required this.players,
    @required this.winner,
    @required this.expansions
  }) : scores = null;

  AddEditGameEvent.withScores({
    this.oldGame,
    @required this.time,
    @required this.scores,
    @required this.expansions
  }) : assert(scores != null), assert(scores?.isNotEmpty), players = null, winner = null;

  bool get withScores => scores != null;
  bool get isEdit => oldGame != null;

  @override
  List<Object> get props => [oldGame, time, players, winner, expansions];

}

class RemoveGameEvent extends GamesEvent {

  final Game game;

  RemoveGameEvent(this.game) : assert(game != null);

  @override
  List<Object> get props => [game];

}

class UndoRemoveGameEvent extends GamesEvent {

  final Game game;

  UndoRemoveGameEvent(this.game) : assert(game != null);

  @override
  List<Object> get props => [game];

}