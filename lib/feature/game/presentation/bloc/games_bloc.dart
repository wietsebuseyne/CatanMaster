import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:catan_master/core/core.dart';
import 'package:catan_master/core/failures.dart';
import 'package:catan_master/feature/feedback/domain/feedback_message.dart';
import 'package:catan_master/feature/feedback/presentation/bloc/feedback_cubit.dart';
import 'package:catan_master/feature/game/domain/game.dart';
import 'package:catan_master/feature/game/domain/game_repository.dart';
import 'package:catan_master/feature/player/domain/player.dart';
import 'package:catan_master/feature/player/presentation/bloc/players_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

part 'games_event.dart';
part 'games_state.dart';

class GamesBloc extends Bloc<GamesEvent, GamesState> {
  final FeedbackCubit feedbackCubit;
  final GameRepository gameRepository;
  final PlayersBloc playersBloc;
  late StreamSubscription _subscription;

  GamesBloc(this.gameRepository, {required this.playersBloc, required this.feedbackCubit})
      : super(InitialGamesState()) {
    on<_GamesUpdated>(_gamesUpdated);
    on<DeleteGameEvent>(_removeGame);
    on<UndoDeleteGameEvent>(_undoRemoveGame);
    _subscription = gameRepository.watchGames(seeded: true).listen((gamesOr) {
      gamesOr.fold(
        (failure) => feedbackCubit.toast(failure.message),
        (games) => add(_GamesUpdated(games)),
      );
    });
  }

  @override
  Future<void> close() async {
    await _subscription.cancel();
    return super.close();
  }

  Future<void> _gamesUpdated(_GamesUpdated event, Emitter<GamesState> emit) async {
    emit(GamesLoaded(Games(event.games)));
  }

  Future<void> _removeGame(DeleteGameEvent event, Emitter<GamesState> emit) async {
    final GamesState s = state;
    if (s is GamesLoaded) {
      Game game = event.game;
      (await gameRepository.deleteGame(game)).fold(
        (f) => _toast(f, message: "Error while deleting game: ${f.toString()}"),
        (r) {
          feedbackCubit.showFeedback(
            FeedbackMessage.snackbar(
              "Game on '${DateFormat.MMMEd().format(game.date)}' deleted",
              severity: Severity.warning,
              action: FeedbackAction(text: "UNDO", action: (pop) async => add(UndoDeleteGameEvent(game))),
            ),
          );
        },
      );
    }
  }

  Future<void> _undoRemoveGame(UndoDeleteGameEvent event, Emitter<GamesState> emit) async {
    final GamesState s = state;
    if (s is GamesLoaded) {
      Game game = event.game;
      (await gameRepository.undoDelete(game: game)).fold(
        (f) => _toast(f, message: "Error while undoing remove: ${f.toString()}"),
        (r) => GamesLoaded(s.games.add(game)),
      );
    }
  }

  void _toast(Failure failure, {String? message}) {
    feedbackCubit.toast(message ?? failure.message, severity: Severity.error);
  }
}
