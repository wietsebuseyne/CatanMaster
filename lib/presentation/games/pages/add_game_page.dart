import 'package:catan_master/application/players/players_bloc.dart';
import 'package:catan_master/presentation/core/catan_expansion.dart';
import 'package:catan_master/domain/games/game.dart';
import 'package:catan_master/domain/players/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

class AddGamePage extends StatelessWidget {

  final GlobalKey<FormBuilderState> _formKey;

  AddGamePage(this._formKey);

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
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
          key: _formKey,
          initialValue: { },
          autovalidateMode: AutovalidateMode.always,
          child: Column(
            children: [
              FormBuilderDateTimePicker(
                attribute: "time",
                inputType: InputType.both,
                format: DateFormat.yMd().add_Hm(),
                initialValue: DateTime.now(),
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
                ],
              ),
              SizedBox(height: 16.0,),
              FormBuilderCheckboxGroup(
                attribute: "players",
                initialValue: [], //TODO same players as last game
                orientation: GroupedCheckboxOrientation.vertical,
                options: players.map((p) {
                  return FormBuilderFieldOption(
                    child: Text(p.name),
                    value: p,
                  );
                }).toList(),
                decoration: InputDecoration(
                    labelText: "Players",
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0))
                    ),
                ),
                onChanged: (_) => _formKey.currentState.fields["winner"].currentState.validate(),
                validators: [
                  FormBuilderValidators.minLength(2, errorText: "Please pick at least two players"),
                ],
              ),
              SizedBox(height: 16.0,),
              FormBuilderRadioGroup(
                attribute: "winner",
                initialValue: [],
                orientation: GroupedRadioOrientation.vertical,
                options: players.map((p) {
                  return FormBuilderFieldOption(
                    child: Text(p.name),
                    value: p,
                  );
                }).toList(),
//                options: ((_formKey.currentState?.value ?? {})["players"] ?? <Player>[])
//                    .map<FormBuilderFieldOption>((p) => FormBuilderFieldOption(child: Text(p.name), value: p,)).toList(),
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
              SizedBox(height: 16.0,),
              FormBuilderCheckboxGroup(
                attribute: "expansions",
                initialValue: [], //TODO same players as last game
                orientation: GroupedCheckboxOrientation.vertical,
                options: CatanExpansion.values.map((e) {
                  return FormBuilderFieldOption(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(e.icon),
                        SizedBox(width: 8.0,),
                        Text(e.name),
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
            ],
          ),
        ),
      ),
    );
  }

  List<Player> _pickedPlayers() => List.from(_formKey.currentState.fields['players'].currentState.value ?? <Player>[]);

}