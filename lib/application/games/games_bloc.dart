import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:catan_master/application/feedback/feedback_bloc.dart';
import 'package:catan_master/application/players/players_bloc.dart';
import 'package:catan_master/core/core.dart';
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
  final PlayersBloc playersBloc;
  late StreamSubscription _subscription;

  GamesBloc(this.gameRepository, {required this.playersBloc, required this.feedbackBloc}) :
        super(InitialGamesState()) {
    _subscription = playersBloc.stream.listen((state) {
      if (state is PlayersLoaded) {
        add(LoadGames());
      }
    });
  }

  @override
  Future<void> close() async{
    await _subscription.cancel();
    return super.close();
  }

  @override
  Stream<GamesState> mapEventToState(GamesEvent event) async* {
    if (event is LoadGames) {
      yield* _loadGames(event);
    } else if (event is AddEditGameEvent) {
      yield* _addEditGame(event);
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
        (r) => GamesLoaded(Games(r))
    );
  }

  Stream<GamesState> _addEditGame(AddEditGameEvent event) async* {
    final GamesState s = state;
    if (s is GamesLoaded) {
      //TODO validate input
      //TODO handle map failure extension of AddGameEvent

      var game;
      try {
        if (event.withScores) {
          game = Game.withScores(
            date: event.time,
            scores: event.scores!,
            expansions: event.expansions,
          );
        } else {
          if(event.players != null) {
            game = Game.noScores(
                players: event.players,
                date: event.time,
                winner: event.winner,
                expansions: event.expansions
            );
          }
        }
        //TODO use returned value to ensure equality (to prevent issues like difference in Color and MaterialColor)
        if (event.isEdit) {
          yield (await gameRepository.editGame(event.oldGame!.date.millisecondsSinceEpoch, game)).fold(
                  (f) => _feedbackAndReturn(f, message: "Error while editing game: $f"),
                  (r) => GameEdited(s.games.delete(event.oldGame), editedGame: game)
          );
        } else {
          yield (await gameRepository.addGame(game)).fold(
                  (f) => _feedbackAndReturn(f, message: "Error while adding game: $f"),
                  (r) => GameAdded(s.games, newGame: game)
          );
        }
      } on DomainException catch(e) {
        yield _feedbackAndReturn(DataValidationFailure(message: e.message!, part: e.part));
      }
    }
  }

  Stream<GamesState> _removeGame(RemoveGameEvent event) async* {
    final GamesState s = state;
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
            return GamesLoaded(s.games.delete(event.game));
          }
      );
    }
  }

  Stream<GamesState> _undoRemoveGame(UndoRemoveGameEvent event) async* {
    final GamesState s = state;
    if (s is GamesLoaded) {
      Game game = event.game;
      yield (await gameRepository.undoDelete(game: game)).fold(
          (f) => _feedbackAndReturn(f, message: "Error while undoing remove: ${f.toString()}"),
          (r) => GamesLoaded(s.games.add(game))
      );
    }
  }

  GamesState _feedbackAndReturn(Failure failure, {String? message}) {
    feedbackBloc.add(FeedbackEvent(FeedbackMessage.toast(message ?? failure.message)));
    return state;
  }

}