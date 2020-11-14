import 'dart:async';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:catan_master/core/message.dart';
import 'package:catan_master/domain/players/player.dart';
import 'package:catan_master/domain/players/player_repository.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'players_event.dart';
part 'players_state.dart';

class PlayersBloc extends Bloc<PlayersEvent, PlayersState> {

  final PlayerRepository _repository;

  PlayersBloc(this._repository) : super(InitialPlayersState());

  @override
  Stream<PlayersState> mapEventToState(PlayersEvent event) async* {
    if (event is LoadPlayers) {
      yield PlayersLoading();
      yield (await _repository.getPlayers()).fold(
          (failure) => state.copyWith(message: Message.error("Error while loading players", extraInfo: failure.toString())), //TODO yield error state
          (players) => PlayersLoaded(players)
      );
    }
    if (event is AddPlayer) {
      final s = state;
      if (s is PlayersLoaded) {
        var newPlayer = Player(username: event.name, name: event.name, color: event.color);
        yield (await _repository.addPlayer(newPlayer)).fold(
                (l) => s.copyWith(message: Message.error("Error while adding player: ${l.message}")),
                (r) => s.copyWith(newPlayer: newPlayer, message: Message.success("Player successfully added"))
        );
      } else {
        print("Trying to add player while state is $s");
        s.copyWith(message: Message.error("Cannot add player right now"));
      }
    }
  }
}
