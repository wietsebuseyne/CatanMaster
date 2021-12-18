import 'dart:async';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:catan_master/core/message.dart';
import 'package:catan_master/feature/feedback/presentation/bloc/feedback_cubit.dart';
import 'package:catan_master/feature/player/domain/player.dart';
import 'package:catan_master/feature/player/domain/player_repository.dart';
import 'package:catan_master/feature/player/presentation/usecase/delete_player.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'players_event.dart';
part 'players_state.dart';

class PlayersBloc extends Bloc<PlayerEvent, PlayerState> {
  final DeletePlayer deletePlayer;
  final PlayerRepository _repository;
  final FeedbackCubit feedbackCubit;
  StreamSubscription? _subscription;

  PlayersBloc(
    this._repository, {
    required this.feedbackCubit,
    required this.deletePlayer,
  }) : super(const PlayersLoading()) {
    on<_PlayersUpdated>(_playersUpdated);
    on<AddOrUpdatePlayer>(_addOrUpdatePlayer);
    on<DeletePlayerEvent>(_deletePlayer);
    _subscription = _repository.watchPlayers(seeded: true).listen((playersOr) {
      playersOr.fold(
        (failures) => feedbackCubit.toast(failures.message),
        (players) => add(_PlayersUpdated(players)),
      );
    });
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }

  Future<void> _playersUpdated(_PlayersUpdated event, Emitter<PlayerState> emit) async {
    emit(PlayersLoaded(event.players));
  }

  Future<void> _addOrUpdatePlayer(AddOrUpdatePlayer event, Emitter<PlayerState> emit) async {
    final PlayerState s = state;
    if (s is PlayersLoaded) {
      var player = Player(
        username: event.toEdit?.username ?? event.name,
        name: event.name,
        gender: event.gender,
        color: event.color,
      );

      if (event.isEdit) {
        (await _repository.editPlayer(player)).fold(
          (l) {
            feedbackCubit.snackbar(l.message);
          },
          (r) {
            feedbackCubit.snackbar("Player '$player' successfully edited");
            emit(PlayerEdited(List.from(s.players)..remove(event.toEdit), editedPlayer: player));
          },
        );
      } else {
        //TODO use return values
        (await _repository.addPlayer(player)).fold(
          (l) {
            feedbackCubit.snackbar(l.message);
          },
          (r) {
            feedbackCubit.snackbar("Player '$player' successfully added");
            emit(s.copyWith(newPlayer: player));
          },
        );
      }
    } else {
      feedbackCubit.snackbar("Cannot add player right now");
    }
  }

  Future<void> _deletePlayer(DeletePlayerEvent event, Emitter<PlayerState> emit) async {
    final PlayerState s = state;
    if (s is PlayersLoaded) {
      (await deletePlayer.call(event.player)).fold(
        (failure) {
          if (failure is PlayerHasGamesFailure) {
            feedbackCubit.dialog(failure.message, title: "Cannot delete player");
          } else {
            feedbackCubit.snackbar(failure.message);
          }
        },
        (_) {
          feedbackCubit.snackbar("Player '${event.player}' successfully deleted");
        },
      );
    } else {
      feedbackCubit.snackbar("Cannot delete player right now");
    }
  }
}
