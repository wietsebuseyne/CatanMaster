part of 'players_bloc.dart';

@immutable
abstract class PlayersEvent {}

class LoadPlayers extends PlayersEvent {}

class AddOrUpdatePlayer extends PlayersEvent {

  final Player toEdit;
  final String name;
  final Gender gender;
  final Color color;

  AddOrUpdatePlayer({this.toEdit, @required this.name, @required this.gender, @required this.color});

  AddOrUpdatePlayer.add({@required this.name, @required this.gender, @required this.color}) : toEdit = null;

  AddOrUpdatePlayer.edit({@required this.toEdit, @required this.name, @required this.gender, @required this.color});

  bool get isEdit => toEdit != null;
}