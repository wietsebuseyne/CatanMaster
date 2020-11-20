part of 'players_bloc.dart';

@immutable
abstract class PlayersEvent {}

class LoadPlayers extends PlayersEvent {}

class AddPlayer extends PlayersEvent {

  final String name;
  final Gender gender;
  final Color color;

  AddPlayer({@required this.name, @required this.gender, @required this.color});
}