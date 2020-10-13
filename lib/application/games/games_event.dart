part of 'games_bloc.dart';

@immutable
abstract class GamesEvent {}

class LoadGames extends GamesEvent {}

class AddGameEvent extends GamesEvent {

  final DateTime time;
  final List<Player> players;
  final Player winner;
  final List<CatanExpansion> expansions;

  AddGameEvent({this.time, this.players, this.winner, this.expansions});

}