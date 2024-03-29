import 'dart:math';

import 'package:catan_master/core/widgets/catan_input_decorator.dart';
import 'package:catan_master/feature/game/domain/game.dart';
import 'package:catan_master/feature/game/presentation/pages/players_with_scores_input.dart';
import 'package:catan_master/feature/game/presentation/pages/players_with_winner_input.dart';
import 'package:catan_master/feature/game/presentation/widgets/expansion_picker.dart';
import 'package:catan_master/feature/player/domain/player.dart';
import 'package:catan_master/feature/player/presentation/bloc/players_bloc.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

const notEnoughPlayersMsgs = [
  "Moooore players needed",
  "Players needed",
  "Not enough players, mi lord",
];

String notEnoughPlayersMsg() => notEnoughPlayersMsgs[Random().nextInt(3)];

class AddEditGamePage extends StatelessWidget {
  final GlobalKey<FormState> _formKey;
  final GameFormData formData;
  final VoidCallback? onFormChanged;

  const AddEditGamePage(
    this._formKey, {
    required this.formData,
    this.onFormChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayersBloc, PlayerState>(builder: (context, state) {
      if (state is PlayersLoaded) {
        return _createForm(context, state.players);
      } else if (state is PlayersLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      return const Center(
        child: Text("Error while loading players"),
      ); //TODO retry;
    });
  }

  Widget _createForm(BuildContext context, List<Player> players) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 48.0, top: 16.0, right: 16.0, left: 16.0),
      child: Form(
        key: _formKey,
        onChanged: onFormChanged,
        autovalidateMode: AutovalidateMode.always,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DateTimeField(
              format: DateFormat.yMd().add_Hm(),
              //TODO customize based on device locale
              decoration: catanInputDecoration(label: "Date & Time"),
              initialValue: formData.date ?? DateTime.now(),
              validator: (date) {
                if (date == null) return "Please pick a time, mi lord";
                if (date.millisecondsSinceEpoch > DateTime.now().millisecondsSinceEpoch) {
                  return "Can't timetravel, mi lord";
                }
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
                    initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                  );
                  return DateTimeField.combine(date, time);
                } else {
                  return currentValue;
                }
              },
              onSaved: (DateTime? date) {
                formData.date = date;
              },
            ),
            const SizedBox(
              height: 16.0,
            ),
            FormField<ExpansionSelection>(
              initialValue: ExpansionSelection(
                scenarios: formData.scenarios,
                expansions: formData.expansions,
              ),
              builder: (state) {
                final selections = state.value ?? ExpansionSelection();
                return CatanInputDecorator(
                  label: "Expansions",
                  errorText: state.errorText,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ExpansionPicker(
                      selection: ExpansionSelection(
                        expansions: selections.expansions,
                        scenarios: selections.scenarios,
                      ),
                      onChanged: (selection) {
                        state.didChange(selection);
                      },
                    ),
                  ),
                );
              },
              onSaved: (ExpansionSelection? selection) {
                formData.expansions = List.of(selection?.expansions ?? {});
                formData.scenarios = List.of(selection?.scenarios ?? {});
              },
            ),
            const SizedBox(
              height: 16.0,
            ),
            FormField<PlayersFormState>(
              initialValue: PlayersFormState(
                players: formData.players.toSet(),
                winner: formData.winner,
                withScores: formData.withScores,
                scores: formData.scores ?? {},
              ),
              builder: (FormFieldState<PlayersFormState> state) {
                PlayersFormState formState = state.value ?? PlayersFormState();

                Map<Player, int> scores = formState.scores;
                return Column(
                  children: [
                    Center(
                      child: ToggleButtons(
                        children: const [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("No scores"),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Scores"),
                          )
                        ],
                        constraints: const BoxConstraints(minHeight: 32),
                        isSelected: [!formState.withScores, formState.withScores],
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        onPressed: (i) {
                          formState.withScores = i == 1;
                          if (formState.withScores) {
                            if (formState.scores.entries.isEmpty) {
                              formState.winner = null;
                            } else {
                              formState.winner =
                                  formState.scores.entries.reduce((max, e) => e.value > max.value ? e : max).key;
                            }
                          }
                          state.didChange(formState);
                          _formKey.currentState?.validate();
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    if (formState.withScores)
                      CatanInputDecorator(
                        child: PlayersWithScoresInput(
                            scores: scores,
                            players: players,
                            onChanged: (scores) {
                              formState.scores = scores;
                              if (scores.entries.isEmpty) {
                                formState.winner = null;
                              } else {
                                formState.winner = scores.entries.reduce((max, e) => e.value > max.value ? e : max).key;
                              }
                              state.didChange(formState);
                            }),
                        errorText: state.errorText,
                      ),
                    if (!formState.withScores)
                      CatanInputDecorator(
                        child: PlayersWithWinnerInput(
                          players: players,
                          selected: formState.players,
                          winner: formState.winner,
                          onSelectionChanged: (Set<Player> players) {
                            formState.players = players;
                            state.didChange(formState);
                          },
                          onWinnerChanged: (Player? winner) {
                            formState.winner = winner;
                            state.didChange(formState);
                          },
                        ),
                        errorText: state.errorText,
                      ),
                  ],
                );
              },
              validator: (PlayersFormState? state) {
                if (state == null) return "Invalid state: <null>";
                var scores = state.scores;
                if ((state.withScores ? scores.length : state.players.length) < 2) {
                  return notEnoughPlayersMsg();
                }
                if (state.withScores) {
                  var scoreList = scores.values;
                  var maxScore = scores.values.reduce(max);
                  if (scoreList.where((s) => s == maxScore).length > 1) {
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
              onSaved: (PlayersFormState? playersData) {
                playersData ??= PlayersFormState();
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
  final int? score;

  PlayerWithScore.selected(this.player, this.score);

  PlayerWithScore.unselected(this.player) : score = null;

  bool get selected => score != null;
}

class PlayersFormState {
  bool withScores = true;
  Set<Player> players = {};
  Map<Player, int> scores = {};
  Player? winner;

  PlayersFormState({
    this.withScores = true,
    this.players = const {},
    this.scores = const {},
    this.winner,
  });
}

class GameFormData {
  bool withScores = true;
  DateTime? date;
  List<Player> players = [];
  Map<Player, int>? scores;
  Player? winner;
  List<CatanExpansion> expansions = [];
  List<CatanScenario> scenarios = [];

  GameFormData();

  GameFormData.fromGame(Game game) {
    this.date = game.date;
    this.players = game.players;
    this.scores = game.scores;
    this.winner = game.winner;
    this.expansions = game.expansions;
    this.scenarios = game.scenarios;
    this.withScores = game.hasScores;
  }
}
