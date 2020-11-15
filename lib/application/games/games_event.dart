part of 'games_bloc.dart';

@immutable
abstract class GamesEvent extends Equatable {}

class LoadGames extends GamesEvent {
  @override
  List<Object> get props => [];
}

class AddGameEvent extends GamesEvent {

  final DateTime time;
  final List<Player> players;
  final Player winner;
  final List<CatanExpansion> expansions;

  AddGameEvent({this.time, this.players, this.winner, this.expansions});

  @override
  List<Object> get props => [time, players, winner, expansions];

}

class EditGameEvent extends GamesEvent {

  final Game oldGame;

  final DateTime time;
  final List<Player> players;
  final Player winner;
  final List<CatanExpansion> expansions;

  EditGameEvent(this.oldGame, {this.time, this.players, this.winner, this.expansions}) : assert(oldGame != null);

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