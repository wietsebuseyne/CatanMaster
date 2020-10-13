part of 'players_bloc.dart';

@immutable
abstract class PlayersEvent {}

class LoadPlayers extends PlayersEvent {}

class AddPlayer extends PlayersEvent {

  final String name;
  final Color color;

  AddPlayer({@required this.name, @required this.color});
}