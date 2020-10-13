part of 'games_bloc.dart';

@immutable
abstract class GamesState {}

class InitialGamesState extends GamesState {}

class GamesLoading extends GamesState {}

class GamesLoaded extends GamesState {

  final List<Game> games;

  GamesLoaded(List<Game> games) : games = List.unmodifiable(games);

  List<Game> getGamesForPlayer(String player) {
    return games.where((g) => g.players.map((p) => p.name).contains(player));
  }

  GamesLoaded copyWith({Game newGame}) {
    return GameAdded(games, newGame: newGame);
  }

}

class GameAdded extends GamesLoaded {

  final Game newGame;

  GameAdded(List<Game> games, {this.newGame}) : super(List.from(games)..add(newGame));

}