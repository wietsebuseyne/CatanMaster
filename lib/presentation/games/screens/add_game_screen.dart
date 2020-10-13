import 'package:catan_master/application/games/games_bloc.dart';
import 'package:catan_master/domain/games/game.dart';
import 'package:catan_master/domain/players/player.dart';
import 'package:catan_master/presentation/games/pages/add_game_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class AddGameScreen extends StatelessWidget {

  final GlobalKey<FormBuilderState> _formKey;

  AddGameScreen() : _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<GamesBloc, GamesState>(
      listener: (context, state) {
        if (state is GameAdded) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text("Add Game"),
            actions: [
              IconButton(
                onPressed: () {
                  if (_formKey.currentState.saveAndValidate()) {
                    BlocProvider.of<GamesBloc>(context).add(AddGameEvent(
                      time: _formKey.currentState.value["time"],
                      players: List<Player>.from(_formKey.currentState.value["players"]),
                      winner: _formKey.currentState.value["winner"],
                      expansions: List<CatanExpansion>.from(_formKey.currentState.value["expansions"])
                    ));
                  }
                },
                icon: Icon(Icons.check),
                tooltip: "Add game",
              )
            ],
          ),
          body: AddGamePage(_formKey)
      ),
    );
  }
}
