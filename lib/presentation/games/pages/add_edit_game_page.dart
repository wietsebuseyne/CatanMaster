import 'dart:math';

import 'package:catan_master/application/players/players_bloc.dart';
import 'package:catan_master/domain/games/game.dart';
import 'package:catan_master/domain/players/player.dart';
import 'package:catan_master/presentation/core/catan_expansion_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

class AddEditGamePage extends StatefulWidget {

  final GlobalKey<FormBuilderState> _formKey;
  final Game game;

  Map<Player, int> get scores {
    if (game == null) return {};
    if (game.hasScores) return Map.from(game.scores);
    return Map.fromIterable(game.players, key: (p) => p, value: (p) => 5);
  }

  AddEditGamePage(this._formKey, {this.game});

  @override
  _AddEditGamePageState createState() => _AddEditGamePageState();
}

class _AddEditGamePageState extends State<AddEditGamePage> {

  bool withScores = true;
  List<Player> selectedPlayers = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayersBloc, PlayersState>(
        builder: (context, state) {
          if (state is PlayersLoaded) {
            return _createForm(state.players);
          } else if (state is PlayersLoading) {
            return Center(child: CircularProgressIndicator(),);
          }
          return Center(child: Text("Error while loading players"),); //TODO retry;
        }
    );
  }

  Widget _createForm(List<Player> players) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 48.0),
      child: FormBuilder(
        key: widget._formKey,
        initialValue: {},
        autovalidateMode: AutovalidateMode.always,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: FormBuilderDateTimePicker(
                attribute: "time",
                inputType: InputType.both,
                format: DateFormat.yMd().add_Hm(),
                initialValue: widget.game?.date ?? DateTime.now(),
                lastDate: DateTime.fromMillisecondsSinceEpoch(
                    max(DateTime.now().millisecondsSinceEpoch, widget.game?.date?.millisecondsSinceEpoch ?? 0)
                ),
                initialTime: null,
                decoration: InputDecoration(
                    labelText: "Time",
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0))
                    )
                ),
                validators: [
                  FormBuilderValidators.required(errorText: "Please pick a time"),
                  (dateTime) {
                      if ((dateTime?.millisecondsSinceEpoch ?? 0) > DateTime.now().millisecondsSinceEpoch) {
                        return "Sadly, no timetravelling allowed. Please pick a valid time";
                      }
                      return null;
                  },
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: FormBuilderCheckboxGroup(
                attribute: "expansions",
                initialValue: widget.game?.expansions ?? [], //TODO same players as last game
                orientation: GroupedCheckboxOrientation.vertical,
                options: CatanExpansion.values.map((e) {
                  return FormBuilderFieldOption(
                    child: Row(
                      children: [
                        Icon(e.icon),
                        SizedBox(width: 8.0,),
                        Text(e.name, textAlign: TextAlign.center,)
                      ],
                    ),
                    value: e,
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: "Expansions",
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0))
                  ),
                ),
                validators: [],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FormBuilderCustomField(
                attribute: "with-scores",
                  formField: FormField<bool>(
                    initialValue: true,
                    builder: (FormFieldState<bool> field) {
                      return Center(
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
                          isSelected: [!field.value, field.value],
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          onPressed: (i) {
                            var scores = i == 1;
                            field.didChange(scores);
                            setState(() {
                              withScores = scores;
                            });
                          },
                        ),
                      );
                    },
                  )
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Visibility(
                visible: withScores,
                child: FormBuilderCustomField<Map<Player, int>>(
                  attribute: "scores",
                  initialValue: widget.scores,
                  formField: FormField<Map<Player, int>>(
                    builder: (FormFieldState<Map<Player, int>> field) {
                      Map<Player, int> scores = field.value ?? {};
                      return InputDecorator(
                        decoration: InputDecoration(
                          errorText: field.errorText,
                          border: OutlineInputBorder(),
                          contentPadding: const EdgeInsets.only(),
                        ),
                        child: Column(
                          children: players.map((p) => CheckboxListTile(
                              activeColor: p.color,
                              value: scores[p] != null,
                              controlAffinity: ListTileControlAffinity.leading,
                              contentPadding: const EdgeInsets.only(),
                              dense: true,
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(child: Text(p.name)),
                                  Row(
                                    children: [
                                      if (scores[p] != null) SizedBox(width: 16.0,),
                                      if (scores[p] != null) Chip(label: Text(scores[p].toString()),),
                                      Slider(
                                          label: scores[p]?.toString(),
                                          activeColor: p.color,
                                          min: 0,
                                          max: 20,
                                          divisions: 20,
                                          value: (scores[p] ?? 0).toDouble(),
                                          onChanged: (v) {
                                            Map<Player, int> newScores = Map.from(scores);
                                            int score = v.toInt();
                                            if (score == 0) score = null;
                                            newScores[p] = score;
                                            field.didChange(newScores);
                                          }),
                                    ],
                                  ),
                                ]
                              ),
                              onChanged: (selected) {
                                Map<Player, int> newScores = Map.from(scores);
                                if (selected) {
                                  newScores[p] = 5;
                                } else {
                                  newScores[p] = null;
                                }
                                field.didChange(newScores);
                              }
                          )).toList(),
                        ),
                      );
                    },
                  ),
                  validators: [
                    FormBuilderValidators.minLength(2, errorText: "Please pick at least two players"),
                    (s) {
                      if (s == null) return null;
                      var scores = (s as Map<Player, int>).values.where((s) => s != null);
                      if (scores.length < 2) return "Please pick at least two players";
                      var maxScore = scores.reduce(max);
                      if (scores.where((s) => s == maxScore).length > 1) {
                        return "Only one player can have the most points";
                      }
                      return null;
                    }
                  ],
                ),
              ),
            ),
            Visibility(
              visible: !withScores,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: FormBuilderCheckboxGroup<Player>(
                  attribute: "players",
                  initialValue: List.from(widget.game?.players ?? []),
                  orientation: GroupedCheckboxOrientation.vertical,
                  options: players.map((p) {
                    return FormBuilderFieldOption(
                      child: Text(p.name),
                      value: p,
                    );
                  }).toList(),
                  decoration: InputDecoration(
                      labelText: "Players",
                      contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0))
                      ),
                  ),
                  onChanged: (values) {
                    setState(() {
                      selectedPlayers = values;
                    });
                  },
                  validators: [
                    FormBuilderValidators.minLength(2, errorText: "Please pick at least two players"),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: !withScores,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: FormBuilderRadioGroup(
                  attribute: "winner",
                  initialValue: widget.game?.winner ?? [],
                  orientation: GroupedRadioOrientation.vertical,
                  options: selectedPlayers.map((p) {
                    return FormBuilderFieldOption(
                      child: Text(p.name),
                      value: p,
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: "Winner",
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0))
                    ),
                  ),
                  validators: [
                    FormBuilderValidators.required(errorText: "Please pick a winner"),
                    (val)  {
                      if (!_pickedPlayers().contains(val)) return "Winner must be one of the players";
                      return null;
                    }
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Player> _pickedPlayers() => List.from(widget._formKey.currentState.fields['players'].currentState.value ?? <Player>[]);
}

class PlayerWithScore {
  final Player player;
  final int score;

  PlayerWithScore.selected(this.player, this.score);

  PlayerWithScore.unselected(this.player) : score = null;

  bool get selected => score != null;
}