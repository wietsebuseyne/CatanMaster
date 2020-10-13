import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:catan_master/domain/games/game.dart';
import 'package:catan_master/domain/games/game_repository.dart';
import 'package:catan_master/domain/players/player.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'games_event.dart';
part 'games_state.dart';

class GamesBloc extends Bloc<GamesEvent, GamesState> {

  final GameRepository gameRepository;

  GamesBloc(this.gameRepository) :
        assert(gameRepository != null),
        super(InitialGamesState());

  @override
  Stream<GamesState> mapEventToState(GamesEvent event) async* {
    if (event is LoadGames) {
      yield GamesLoading();
      yield (await gameRepository.getGames()).fold(
              (l) => state, //TODO withError message
              (r) => GamesLoaded(r)
      );
    } else if (event is AddGameEvent) {
      final s = state;
      if (s is GamesLoaded) {
        //TODO handle map failure extansion of AddGameEvent
        var game = Game(
          players: event.players,
          date: event.time,
          winner: event.winner,
          expansions: event.expansions
        );
        yield (await gameRepository.addGame(game)).fold(
                (l) => state, //TODO withError message
                (r) => s.copyWith(newGame: game)
        );
      }
    }
  }
}


/*

[
          Game(
            date: DateTime.now(),
            players: [
              Player(name: "Nillie", color: Colors.orange),
              Player(name: "Wittie", color: Colors.blue),
              Player(name: "Roelie", color: Colors.red),
              Player(name: "Evelie", color: Colors.black),
            ],
            winner: Player(name: "Wittie", color: Colors.blue),
            expansions: [CatanExpansion.cities_and_knights]
          ),
          Game(
              date: DateTime.now().add(Duration(days: -1)),
              players: [
                Player(name: "Nillie", color: Colors.orange),
                Player(name: "Wittie", color: Colors.blue),
                Player(name: "Roelie", color: Colors.red),
                Player(name: "Evelie", color: Colors.black),
              ],
              winner: Player(name: "Roelie", color: Colors.red),
              expansions: []
          ),
          Game(
              date: DateTime.now().add(Duration(days: -8)),
              players: [
                Player(name: "Nillie", color: Colors.orange),
                Player(name: "Roelie", color: Colors.red),
                Player(name: "Evelie", color: Colors.black),
              ],
              winner: Player(name: "Roelie", color: Colors.red),
              expansions: [CatanExpansion.traders_and_barbarians]
          ),
          Game(
              date: DateTime.now().add(Duration(days: -16)),
              players: [
                Player(name: "Wittie", color: Colors.blue),
                Player(name: "Roelie", color: Colors.red),
                Player(name: "Evelie", color: Colors.black),
              ],
              winner: Player(name: "Evelie", color: Colors.black),
              expansions: [CatanExpansion.seafarers]
          ),
          Game(
              date: DateTime.now().add(Duration(days: -23)),
              players: [
                Player(name: "Wittie", color: Colors.blue),
                Player(name: "Nillie", color: Colors.orange),
                Player(name: "Roelie", color: Colors.red),
              ],
              winner: Player(name: "Nillie", color: Colors.orange),
              expansions: [CatanExpansion.explorers_and_pirates, CatanExpansion.seafarers]
          ),
        ]
 */