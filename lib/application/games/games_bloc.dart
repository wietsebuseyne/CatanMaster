import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:catan_master/application/feedback/feedback_bloc.dart';
import 'package:catan_master/core/failures.dart';
import 'package:catan_master/domain/feedback/feedback_message.dart';
import 'package:catan_master/domain/games/game.dart';
import 'package:catan_master/domain/games/game_repository.dart';
import 'package:catan_master/domain/players/player.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

part 'games_event.dart';
part 'games_state.dart';

class GamesBloc extends Bloc<GamesEvent, GamesState> {

  final FeedbackBloc feedbackBloc;
  final GameRepository gameRepository;

  GamesBloc(this.gameRepository, {@required this.feedbackBloc}) :
        assert(gameRepository != null),
        super(InitialGamesState());

  @override
  Stream<GamesState> mapEventToState(GamesEvent event) async* {
    if (event is LoadGames) {
      yield* _loadGames(event);
    } else if (event is AddGameEvent) {
      yield* _addGame(event);
    } else if (event is EditGameEvent) {
      yield* _editGame(event);
    } else if (event is RemoveGameEvent) {
      yield* _removeGame(event);
    } else if (event is UndoRemoveGameEvent) {
      yield* _undoRemoveGame(event);
    }
  }

  Stream<GamesState> _loadGames(LoadGames event) async* {
    yield GamesLoading();
    yield (await gameRepository.getGames()).fold(
        (l) => _feedbackAndReturn(l),
        (r) => GamesLoaded(r)
    );
  }

  Stream<GamesState> _addGame(AddGameEvent event) async* {
    final s = state;
    if (s is GamesLoaded) {
      //TODO validate input
      //TODO handle map failure extension of AddGameEvent
      var game = Game(
          players: event.players,
          date: event.time,
          winner: event.winner,
          expansions: event.expansions
      );
      yield (await gameRepository.addGame(game)).fold(
        (l) => _feedbackAndReturn(l),
        (r) => GameAdded(s.games, newGame: game)
      );
    }
  }

  Stream<GamesState> _editGame(EditGameEvent event) async* {
    final s = state;
    if (s is GamesLoaded) {
      var game = Game(
          players: event.players,
          date: event.time,
          winner: event.winner,
          expansions: event.expansions
      );
      yield (await gameRepository.editGame(event.oldGame.date.millisecondsSinceEpoch, game)).fold(
          (f) => _feedbackAndReturn(f, message: "Error while editing game: ${f.toString()}"),
          (r) => GameEdited(List.of(s.games)..remove(event.oldGame), editedGame: game)
      );
    }
  }

  Stream<GamesState> _removeGame(RemoveGameEvent event) async* {
    final s = state;
    if (s is GamesLoaded) {
      Game game = event.game;
      yield (await gameRepository.deleteGame(game)).fold(
          (f) => _feedbackAndReturn(f, message: "Error while deleting game: ${f.toString()}"),
          (r) {
            feedbackBloc.add(FeedbackEvent(
                FeedbackMessage.snackbar(
                  "Game on '${DateFormat.MMMEd().format(game.date)}' deleted",
                  severity: Severity.warning,
                  action: FeedbackAction(text: "UNDO", action: () => add(UndoRemoveGameEvent(game)))
                ),
            ));
            return GamesLoaded(List.from(s.games)..remove(event.game));
          }
      );
    }
  }

  Stream<GamesState> _undoRemoveGame(UndoRemoveGameEvent event) async* {
    final s = state;
    if (s is GamesLoaded) {
      Game game = event.game;
      yield (await gameRepository.undoDelete(game: game)).fold(
          (f) => _feedbackAndReturn(f, message: "Error while undoing remove: ${f.toString()}"),
          (r) => GamesLoaded(s.games..add(game))
      );
    }
  }

  GamesState _feedbackAndReturn(Failure failure, {String message}) {
    feedbackBloc.add(FeedbackEvent(FeedbackMessage.toast(message ?? failure.message)));
    return state;
  }

}