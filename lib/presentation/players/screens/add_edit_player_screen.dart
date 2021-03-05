import 'package:catan_master/application/players/players_bloc.dart';
import 'package:catan_master/domain/players/player.dart';
import 'package:catan_master/presentation/feedback/user_feedback.dart';
import 'package:catan_master/presentation/players/pages/add_edit_player_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddEditPlayerScreen extends StatelessWidget {

  final Player player;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AddEditPlayerFormData formData = AddEditPlayerFormData();

  AddEditPlayerScreen._({this.player});

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
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    BlocProvider.of<PlayersBloc>(context).add(AddOrUpdatePlayer(
                      toEdit: player,
                      name: formData.name,
                      gender: formData.gender,
                      color: formData.color
                    ));
                  }
                },
              )
            ],
          ),
          body: UserFeedback(child: AddEditPlayerPage(_formKey, formData: formData, player: player,))
      ),
    );
  }
}

class AddEditPlayerFormData {

  Player toEdit;
  String name;
  Gender gender;
  Color color;

}