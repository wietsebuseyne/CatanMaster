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
    _subscription = playersBloc.stream.listen((state) {
      if (state is PlayersLoaded) {
        add(const LoadGames());
      }
    });
    on<LoadGames>(_loadGames);
    on<AddEditGameEvent>(_addEditGame);
    on<DeleteGameEvent>(_removeGame);
    on<UndoDeleteGameEvent>(_undoRemoveGame);
  }

  @override
  Future<void> close() async {
    await _subscription.cancel();
    return super.close();
  }

  Future<void> _loadGames(LoadGames event, Emitter<GamesState> emit) async {
    emit(GamesLoading());
    (await gameRepository.getGames()).fold(
      (l) => _toast(l),
      (r) => emit(GamesLoaded(Games(r))),
    );
  }

  Future<void> _addEditGame(AddEditGameEvent event, Emitter<GamesState> emit) async {
    final GamesState s = state;
    if (s is GamesLoaded) {
      //TODO validate input
      //TODO handle map failure extension of AddGameEvent

      try {
        Game game;
        if (event.withScores) {
          game = Game.withScores(
            date: event.time,
            scores: event.scores!,
            expansions: event.expansions,
            scenarios: event.scenarios,
          );
        } else {
          game = Game.noScores(
            players: event.players,
            date: event.time,
            winner: event.winner,
            expansions: event.expansions,
            scenarios: event.scenarios,
          );
        }
        //TODO use returned value to ensure equality (to prevent issues like difference in Color and MaterialColor)
        Game? oldGame = event.oldGame;
        if (oldGame != null) {
          (await gameRepository.editGame(oldGame.date.millisecondsSinceEpoch, game)).fold(
            (f) => _toast(f, message: "Error while editing game: $f"),
            (r) => emit(GameEdited(s.games.delete(event.oldGame), editedGame: game)),
          );
        } else {
          (await gameRepository.addGame(game)).fold(
            (f) => _toast(f, message: "Error while adding game: $f"),
            (r) => emit(GameAdded(s.games, newGame: game)),
          );
        }
      } on DomainException catch (e) {
        _toast(DataValidationFailure(message: e.message!, part: e.part));
      }
    }
  }

  Future<void> _removeGame(DeleteGameEvent event, Emitter<GamesState> emit) async {
    final GamesState s = state;
    if (s is GamesLoaded) {
      Game game = event.game;
      (await gameRepository.deleteGame(game)).fold(
        (f) => _toast(f, message: "Error while deleting game: ${f.toString()}"),
        (r) {
          feedbackCubit.feedback(
            FeedbackMessage.snackbar("Game on '${DateFormat.MMMEd().format(game.date)}' deleted",
                severity: Severity.warning,
                action: FeedbackAction(text: "UNDO", action: () => add(UndoDeleteGameEvent(game)))),
          );
          emit(GamesLoaded(s.games.delete(event.game)));
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
          (r) => GamesLoaded(s.games.add(game)));
    }
  }

  void _toast(Failure failure, {String? message}) {
    feedbackCubit.toast(message ?? failure.message, severity: Severity.error);
  }
}
