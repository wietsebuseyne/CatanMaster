import 'dart:async';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:catan_master/core/message.dart';
import 'package:catan_master/feature/feedback/presentation/bloc/feedback_cubit.dart';
import 'package:catan_master/feature/player/domain/player.dart';
import 'package:catan_master/feature/player/domain/player_repository.dart';
import 'package:catan_master/feature/player/presentation/usecase/delete_player.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'players_event.dart';
part 'players_state.dart';

class PlayersBloc extends Bloc<PlayerEvent, PlayerState> {
  final DeletePlayer deletePlayer;
  final PlayerRepository _repository;
  final FeedbackCubit feedbackCubit;

  PlayersBloc(
    this._repository, {
    required this.feedbackCubit,
    required this.deletePlayer,
  }) : super(const InitialPlayersState());

  @override
  Stream<PlayerState> mapEventToState(PlayerEvent event) async* {
    if (event is LoadPlayers) {
      yield* _loadPlayers();
    } else if (event is AddOrUpdatePlayer) {
      yield* _addOrUpdatePlayer(event);
    } else if (event is DeletePlayerEvent) {
      yield* _deletePlayer(event);
    }
  }

  Stream<PlayerState> _loadPlayers() async* {
    yield const PlayersLoading();
    yield (await _repository.getPlayers()).fold((failure) {
      //TODO PlayersError
      return state;
    }, (players) => PlayersLoaded(players));
  }

  Stream<PlayerState> _addOrUpdatePlayer(AddOrUpdatePlayer event) async* {
    final PlayerState s = state;
    if (s is PlayersLoaded) {
      var player = Player(
        username: event.toEdit?.username ?? event.name,
        name: event.name,
        gender: event.gender,
        color: event.color,
      );

      if (event.isEdit) {
        yield (await _repository.editPlayer(player)).fold(
          (l) {
            feedbackCubit.snackbar(l.message);
            return s;
          },
          (r) {
            feedbackCubit.snackbar("Player '$player' successfully edited");
            return PlayerEdited(List.from(s.players)..remove(event.toEdit), editedPlayer: player);
          },
        );
      } else {
        //TODO use return values
        yield (await _repository.addPlayer(player)).fold(
          (l) {
            feedbackCubit.snackbar(l.message);
            return s;
          },
          (r) {
            feedbackCubit.snackbar("Player '$player' successfully added");
            return s.copyWith(newPlayer: player);
          },
        );
      }
    } else {
      feedbackCubit.snackbar("Cannot add player right now");
    }
  }

  Stream<PlayerState> _deletePlayer(DeletePlayerEvent event) async* {
    final PlayerState s = state;
    if (s is PlayersLoaded) {
      yield (await deletePlayer.call(event.player)).fold(
        (failure) {
          if (failure is PlayerHasGamesFailure) {
            feedbackCubit.dialog(failure.message, title: "Cannot delete player");
          } else {
            feedbackCubit.snackbar(failure.message);
          }
          return s;
        },
        (_) {
          feedbackCubit.snackbar("Player '${event.player}' successfully deleted");
          return PlayersLoaded(List.from(s.players)..remove(event.player));
        },
      );
    } else {
      feedbackCubit.snackbar("Cannot delete player right now");
    }
  }
}
