import 'package:bloc/bloc.dart';
import 'package:catan_master/core/bloc/catan_bloc.dart';
import 'package:catan_master/core/core.dart';
import 'package:catan_master/feature/feedback/presentation/bloc/feedback_cubit.dart';
import 'package:catan_master/feature/game/domain/game.dart';
import 'package:catan_master/feature/game/domain/game_repository.dart';
import 'package:catan_master/feature/player/domain/player.dart';
import 'package:equatable/equatable.dart';

part 'add_edit_game_event.dart';
part 'add_edit_game_state.dart';

class AddEditGameBloc extends CatanBloc<AddEditGameEvent, AddEditGameState> {
  final GameRepository gameRepository;
  final Game? toEdit;

  AddEditGameBloc({
    required this.gameRepository,
    this.toEdit,
    required FeedbackCubit feedbackCubit,
  }) : super(AddEditGameInProgress(), f: feedbackCubit) {
    on<AddEditGameEvent>(_addEditGame);
  }

  Future<void> _addEditGame(AddEditGameEvent event, Emitter<AddEditGameState> emit) async {
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
      if (toEdit != null) {
        (await gameRepository.editGame(toEdit!.date.millisecondsSinceEpoch, game)).fold(
          (f) => failureFeedback(f, message: "Error while editing game: $f"),
          (r) => emit(AddEditGameSuccess()),
        );
      } else {
        (await gameRepository.addGame(game)).fold(
          (f) => failureFeedback(f, message: "Error while adding game: $f"),
          (r) => emit(AddEditGameSuccess()),
        );
      }
    } on DomainException catch (e) {
      failureFeedback(DataValidationFailure(message: e.message ?? '?', part: e.part));
    }
  }
}
