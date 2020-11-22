import 'package:catan_master/application/players/players_bloc.dart';
import 'package:catan_master/domain/players/player.dart';
import 'package:catan_master/presentation/feedback/user_feedback.dart';
import 'package:catan_master/presentation/players/pages/add_edit_player_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class AddEditPlayerScreen extends StatelessWidget {

  final Player player;
  final GlobalKey<FormBuilderState> _formKey;

  AddEditPlayerScreen._({this.player}) : _formKey = GlobalKey<FormBuilderState>();

  factory AddEditPlayerScreen.add() => AddEditPlayerScreen._();
  factory AddEditPlayerScreen.edit(Player player) => AddEditPlayerScreen._(player: player);

  @override
  Widget build(BuildContext context) {
    return BlocListener<PlayersBloc, PlayerState>(
      listener: (context, state) {
        if (state is PlayerAdded || state is PlayerEdited) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text(player == null ? "Add Player" : "Edit Player"),
            backgroundColor: player?.color,
            actions: [
              FlatButton.icon(
                icon: Icon(Icons.save),
                label: Text("SAVE"),
                textColor: Theme.of(context).primaryIconTheme.color,
                shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
                onPressed: () {
                  if (_formKey.currentState.saveAndValidate()) {
                    BlocProvider.of<PlayersBloc>(context).add(AddOrUpdatePlayer(
                      toEdit: player,
                      name: _formKey.currentState.value["name"],
                      gender: _formKey.currentState.value["gender"],
                      color: _formKey.currentState.value["color"]
                    ));
                  }
                },
              )
            ],
          ),
          body: UserFeedback(child: AddEditPlayerPage(_formKey, player: player,))
      ),
    );
  }
}
