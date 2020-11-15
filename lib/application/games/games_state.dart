part of 'games_bloc.dart';

@immutable
abstract class GamesState {}

class InitialGamesState extends GamesState {}

class GamesLoading extends GamesState {}

class GamesLoaded extends GamesState {

  final List<Game> games;

  GamesLoaded(List<Game> games) : games = List.unmodifiable(games..sort((g1, g2) => g2.date.compareTo(g1.date)));

  List<Game> getGamesForPlayer(String player) {
    return games.where((g) => g.players.map((p) => p.name).contains(player));
  }

}

class GameAdded extends GamesLoaded {

  final Game newGame;

  GameAdded(List<Game> games, {this.newGame}) : super(List.from(games)..add(newGame));

}

class GameEdited extends GamesLoaded {

  final Game editedGame;

  GameEdited(List<Game> games, {this.editedGame}) : super(List.from(games)..add(editedGame));

}