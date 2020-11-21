part of 'players_bloc.dart';

@immutable
abstract class PlayersState {

  final Message message;

  PlayersState({this.message});

  PlayersState copyWith({Message message});

}

class InitialPlayersState extends PlayersState {

  InitialPlayersState({Message message}) : super(message: message);

  InitialPlayersState copyWith({Message message}) {
    return InitialPlayersState(message: message ?? message);
  }
}

class PlayersLoading extends PlayersState {

  PlayersLoading({Message message}) : super(message: message);

  PlayersLoading copyWith({Message message}) {
    return PlayersLoading(message: message ?? message);
  }

}

class PlayersLoaded extends PlayersState {

  final List<Player> players;
  //Map<String, Game> gameMap;

  PlayersLoaded(List<Player> players, {Message message}) :
        this.players = List.unmodifiable(players),
        super(message: message);

  PlayersLoaded copyWith({Player newPlayer, Message message}) {
    return PlayerAdded(players, newPlayer: newPlayer, message: message ?? message);
  }

  Player getPlayer(String username) => players.firstWhere((p) => p.username == username, orElse: null);

}

class PlayerAdded extends PlayersLoaded {

  final Player newPlayer;

  PlayerAdded(List<Player> players, {this.newPlayer, Message message}) : super(
      List.from(players)..add(newPlayer),
      message: message
  );
}

class PlayerEdited extends PlayersLoaded {

  //TODO move to Players object
  final Player editedPlayer;

  PlayerEdited(List<Player> players, {this.editedPlayer}) : super(List.from(players)..add(editedPlayer));

}