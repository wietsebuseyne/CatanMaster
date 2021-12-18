part of 'players_bloc.dart';

@immutable
abstract class PlayerEvent extends Equatable {
  const PlayerEvent();
}

class _PlayersUpdated extends PlayerEvent {
  final List<Player> players;
  const _PlayersUpdated(this.players);

  @override
  List<Object?> get props => [players];
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

  @override
  List<Object?> get props => [toEdit, gender, name, color];
}

class DeletePlayerEvent extends PlayerEvent {
  final Player player;

  const DeletePlayerEvent(this.player);

  @override
  List<Object?> get props => [player];
}
