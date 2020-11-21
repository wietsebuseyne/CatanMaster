import 'dart:async';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:catan_master/application/feedback/feedback_bloc.dart';
import 'package:catan_master/core/message.dart';
import 'package:catan_master/domain/feedback/feedback_message.dart';
import 'package:catan_master/domain/players/player.dart';
import 'package:catan_master/domain/players/player_repository.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'players_event.dart';
part 'players_state.dart';

class PlayersBloc extends Bloc<PlayersEvent, PlayersState> {

  final PlayerRepository _repository;
  final FeedbackBloc feedbackBloc;

  PlayersBloc(this._repository, {@required this.feedbackBloc}) : super(InitialPlayersState());

  @override
  Stream<PlayersState> mapEventToState(PlayersEvent event) async* {
    if (event is LoadPlayers) {
      yield* _loadPlayers();
    } else if (event is AddOrUpdatePlayer) {
      yield* _addOrUpdatePlayer(event);
    }
  }

  Stream<PlayersState> _loadPlayers() async* {
    yield PlayersLoading();
    yield (await _repository.getPlayers()).fold(
            (failure) {
              //TODO PlayersError
              return state;
            },
            (players) => PlayersLoaded(players)
    );
  }

  Stream<PlayersState> _addOrUpdatePlayer(AddOrUpdatePlayer event) async* {
    final s = state;
    if (s is PlayersLoaded) {
      var player = Player(
          username: event.toEdit?.username ?? event.name,
          name: event.name,
          gender: event.gender,
          color: event.color
      );

      if (event.isEdit) {
        yield (await _repository.editPlayer(player)).fold(
            (l) {
              feedbackBloc.snackbar("${l.message}");
              return s;
            },
            (r) {
              feedbackBloc.snackbar("Player '$player' successfully edited");
              return PlayerEdited(List.from(s.players)..remove(event.toEdit), editedPlayer: player);
            }
        );
      } else {
        yield (await _repository.addPlayer(player)).fold(
            (l) {
              feedbackBloc.snackbar("${l.message}");
              return s;
            },
            (r) {
              feedbackBloc.snackbar("Player '$player' successfully added");
              return s.copyWith(newPlayer: player);
            }
        );
      }
    } else {
      feedbackBloc.snackbar("Cannot add player right now");
    }
  }



}
