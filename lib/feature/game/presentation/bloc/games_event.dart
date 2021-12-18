part of 'games_bloc.dart';

@immutable
abstract class GamesEvent extends Equatable {
  const GamesEvent();
}

class _GamesUpdated extends GamesEvent {
  final List<Game> games;
  const _GamesUpdated(this.games);

  @override
  List<Object> get props => [games];
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
