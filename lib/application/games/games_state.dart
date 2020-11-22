part of 'games_bloc.dart';

@immutable
abstract class GamesState {}

class InitialGamesState extends GamesState {}

class GamesLoading extends GamesState {}

class GamesLoaded extends GamesState {

  final Games games;

  GamesLoaded(this.games);

  PlayerStatistics getStatisticsForPlayer(Player player) {
    return PlayerStatistics.fromGames(player, games);
  }

}

class GameAdded extends GamesLoaded {

  final Game newGame;

  GameAdded(Games games, {this.newGame}) : super(Games(List.from(games.games)..add(newGame)));

}

class GameEdited extends GamesLoaded {

  //TODO move to games
  final Game editedGame;

  GameEdited(Games games, {this.editedGame}) : super(Games(List.from(games.games)..add(editedGame)));

}