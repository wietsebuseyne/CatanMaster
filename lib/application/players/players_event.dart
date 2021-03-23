part of 'players_bloc.dart';

@immutable
abstract class PlayerEvent {}

class LoadPlayers extends PlayerEvent {}

class AddOrUpdatePlayer extends PlayerEvent {

  final Player? toEdit;
  final String name;
  final Gender gender;
  final Color color;

  AddOrUpdatePlayer({this.toEdit, required this.name, required this.gender, required this.color});

  AddOrUpdatePlayer.add({required this.name, required this.gender, required this.color}) : toEdit = null;

  AddOrUpdatePlayer.edit({required this.toEdit, required this.name, required this.gender, required this.color});

  bool get isEdit => toEdit != null;
}

class DeletePlayerEvent extends PlayerEvent {

  final Player player;

  DeletePlayerEvent(this.player);
}