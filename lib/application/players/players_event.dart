part of 'players_bloc.dart';

@immutable
abstract class PlayerEvent {
  const PlayerEvent();
}

class LoadPlayers extends PlayerEvent {
  const LoadPlayers();
}

class AddOrUpdatePlayer extends PlayerEvent {
  final Player? toEdit;
  final String name;
  final Gender gender;
  final Color color;

  const AddOrUpdatePlayer({
    this.toEdit,
    required this.name,
    required this.gender,
    required this.color,
  });

  const AddOrUpdatePlayer.add({
    required this.name,
    required this.gender,
    required this.color,
  }) : toEdit = null;

  const AddOrUpdatePlayer.edit({
    required this.toEdit,
    required this.name,
    required this.gender,
    required this.color,
  });

  bool get isEdit => toEdit != null;
}

class DeletePlayerEvent extends PlayerEvent {
  final Player player;

  const DeletePlayerEvent(this.player);
}
