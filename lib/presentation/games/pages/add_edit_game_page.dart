import 'dart:math';

import 'package:catan_master/application/players/players_bloc.dart';
import 'package:catan_master/domain/games/game.dart';
import 'package:catan_master/domain/players/player.dart';
import 'package:catan_master/presentation/core/catan_expansion_ui.dart';
import 'package:catan_master/presentation/core/catan_icons.dart';
import 'package:catan_master/presentation/core/widgets/catan_input_decorator.dart';
import 'package:catan_master/presentation/games/pages/players_with_scores_input.dart';
import 'package:catan_master/presentation/games/pages/players_with_winner_input.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

const notEnoughPlayersMsgs = ["Moooore players needed", "Players needed", "Not enough players, mi lord"];

notEnoughPlayersMsg() => notEnoughPlayersMsgs[Random().nextInt(3)];

class AddEditGamePage extends StatelessWidget {

  final GlobalKey<FormState> _formKey;
  final GameFormData formData;

  /*Map<Player, int> get scores {
    if (game == null) return {};
    if (game.hasScores) return Map.from(game.scores);
    return Map.fromIterable(game.players, key: (p) => p, value: (p) => 5);
  }*/

  AddEditGamePage(this._formKey, {this.formData});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayersBloc, PlayerState>(
        builder: (context, state) {
          if (state is PlayersLoaded) {
            return _createForm(context, state.players);
          } else if (state is PlayersLoading) {
            return Center(child: CircularProgressIndicator(),);
          }
          return Center(child: Text("Error while loading players"),); //TODO retry;
        }
    );
  }

  Widget _createForm(BuildContext context, List<Player> players) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 48.0, top: 16.0, right: 16.0, left: 16.0),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.always,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DateTimeField(
              format: DateFormat("dd/MM/yyyy HH:mm"), //TODO customize based on device locale
              decoration: catanInputDecoration(label: "Date & Time"),
              initialValue: formData.date ?? DateTime.now(),
              validator: (date) {
                if (date == null) return "Please pick a time, mi lord";
                if (date.millisecondsSinceEpoch > DateTime.now().millisecondsSinceEpoch) return "Can't timetravel, mi lord";
                return null;
              },
              onShowPicker: (context, currentValue) async {
                final date = await showDatePicker(
                    context: context,
                    firstDate: DateTime.fromMillisecondsSinceEpoch(0),
                    initialDate: currentValue ?? DateTime.now(),
                    lastDate: DateTime.now());
                if (date != null) {
                  final time = await showTimePicker(
                    context: context,
                    initialTime:
                    TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                  );
                  return DateTimeField.combine(date, time);
                } else {
                  return currentValue;
                }
              },
              onSaved: (DateTime date) {
                formData.date = date;
              },
            ),
            SizedBox(height: 16.0,),
            FormField<Set<CatanExpansion>>(
              initialValue: {},
              builder: (state) {
                return CatanInputDecorator(
                  label: "Expansions",
                  errorText: state.errorText,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      children: CatanExpansion.values.map((expansion) {
                        return GestureDetector(
                          onTap: () {
                            if (!state.value.contains(expansion)) {
                              state.didChange(state.value..add(expansion));
                            } else {
                              state.didChange(state.value..remove(expansion));
                            }
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Checkbox(
                                value: state.value.contains(expansion),
                                onChanged: (selected) {
                                  if (selected) {
                                    state.didChange(state.value..add(expansion));
                                  } else {
                                    state.didChange(state.value..remove(expansion));
                                  }
                                }
                              ),
                              Icon(expansion.icon),
                              SizedBox(width: 8.0),
                              Text(expansion.name),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
              onSaved: (Set<CatanExpansion> expansions) {
                formData.expansions = expansions.toList();
              },
            ),
            SizedBox(height: 16.0,),
            FormField<PlayersFormState>(
              initialValue: PlayersFormState(),
              builder: (FormFieldState<PlayersFormState> state) {
                Map<Player, int> scores = state.value.scores ?? {};
                return Column(
                  children: [
                    Center(
                      child: ToggleButtons(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("No scores"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Scores"),
                          )
                        ],
                        constraints: BoxConstraints(minHeight: 32),
                        borderColor: Colors.blue.withOpacity(0.3),
                        selectedBorderColor: Colors.blue,
                        isSelected: [!state.value.withScores, state.value.withScores],
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        onPressed: (i) {
                          state.value.withScores = i == 1;
                          state.didChange(state.value);
                          _formKey.currentState.validate();
                        },
                      ),
                    ),
                    SizedBox(height: 8.0,),
                    if (state.value.withScores) CatanInputDecorator(
                      child: PlayersWithScoresInput(
                        scores: scores,
                        players: players,
                        onChanged: (scores) {
                          state.value.scores = scores;
                          state.didChange(state.value);
                        }
                      ),
                      errorText: state.errorText,
                    ),
                    if (!state.value.withScores) CatanInputDecorator(
                      child: PlayersWithWinnerInput(
                        players: players,
                        selected: state.value.players,
                        winner: state.value.winner,
                        onSelectionChanged: (Set<Player> players) {
                          state.value.players = players;
                          state.didChange(state.value);
                        },
                        onWinnerChanged: (Player winner) {
                          state.value.winner = winner;
                          state.didChange(state.value);
                        },
                      ),
                      errorText: state.errorText,
                    ),
                  ],
                );
              },
              validator: (PlayersFormState state) {
                var scores = state.scores;
                if ((state.withScores ? scores.length : state.players.length) < 2) {
                  return notEnoughPlayersMsg();
                }
                if (state.withScores) {
                  var scoreList = scores.values;
                  var maxScore = scores.values.reduce(max);
                  if (scoreList
                      .where((s) => s == maxScore)
                      .length > 1) {
                    return "Can't have two winners, my lord";
                  }
                } else {
                  if (state.winner == null) {
                    return "Winner needed!";
                  }
                  if (!state.players.contains(state.winner)) {
                    return "Winner must one the players";
                  }
                }
                return null;
              },
              onSaved: (playersData) {
                formData.withScores = playersData.withScores;
                formData.scores = playersData.scores;
                formData.winner = playersData.winner;
                formData.players = playersData.players.toList();
              },
            ),
          ],
        ),
      ),
    );
  }

}

class PlayerWithScore {
  final Player player;
  final int score;

  PlayerWithScore.selected(this.player, this.score);

  PlayerWithScore.unselected(this.player) : score = null;

  bool get selected => score != null;
}

class PlayersFormState {

  bool withScores = true;
  Set<Player> players = {};
  Map<Player, int> scores = {};
  Player winner;

}

class GameFormData {

  bool withScores = true;
  DateTime date;
  List<Player> players;
  Map<Player, int> scores;
  Player winner;
  List<CatanExpansion> expansions;

  GameFormData();

  GameFormData.fromGame(Game game) {
    this.date = game.date;
    this.players = game.players;
    this.scores = game.scores;
    this.winner = game.winner;
    this.expansions = game.expansions;
    this.withScores = game.hasScores;
  }

}