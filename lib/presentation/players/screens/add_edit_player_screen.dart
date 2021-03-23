import 'package:catan_master/application/players/players_bloc.dart';
import 'package:catan_master/domain/players/player.dart';
import 'package:catan_master/presentation/feedback/user_feedback.dart';
import 'package:catan_master/presentation/players/pages/add_edit_player_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddEditPlayerScreen extends StatelessWidget {

  final Player? player;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final PlayerFormData formData = PlayerFormData();

  AddEditPlayerScreen._({this.player}) {
    formData.name = player?.name;
    formData.gender = player?.gender;
    formData.color = player?.color;
  }

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
              TextButton.icon(
                icon: Icon(Icons.save),
                label: Text("Save"),
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  textStyle: TextStyle(fontSize: 16),
                  shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                ),
                onPressed: () {
                  FormState? state = _formKey.currentState;
                  if (state != null && state.validate()) {
                    state.save();
                    BlocProvider.of<PlayersBloc>(context).add(AddOrUpdatePlayer(
                      toEdit: player,
                      name: formData.name!,
                      gender: formData.gender!,
                      color: formData.color!
                    ));
                  }
                },
              )
            ],
          ),
          body: UserFeedback(child: AddEditPlayerPage(_formKey, formData: formData,))
      ),
    );
  }
}