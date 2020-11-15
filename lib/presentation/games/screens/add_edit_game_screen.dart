import 'package:catan_master/application/games/games_bloc.dart';
import 'package:catan_master/domain/games/game.dart';
import 'package:catan_master/domain/players/player.dart';
import 'package:catan_master/presentation/feedback/user_feedback.dart';
import 'package:catan_master/presentation/games/pages/add_edit_game_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class AddEditGameScreen extends StatelessWidget {

  final GlobalKey<FormBuilderState> _formKey;
  final Game game;

  AddEditGameScreen.add() : _formKey = GlobalKey<FormBuilderState>(), game = null;

  AddEditGameScreen.edit(this.game) : _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<GamesBloc, GamesState>(
      listener: (context, state) {
        if ((game == null && state is GameAdded) || (game != null && state is GameEdited)) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text(game == null ? "Add Game" : "Edit Game"),
            actions: [
              FlatButton(
                onPressed: () {
                  if (_formKey.currentState.saveAndValidate()) {
                    if (game == null) {
                      BlocProvider.of<GamesBloc>(context).add(AddGameEvent(
                        time: _formKey.currentState.value["time"],
                        players: List<Player>.from(_formKey.currentState.value["players"]),
                        winner: _formKey.currentState.value["winner"],
                        expansions: List<CatanExpansion>.from(_formKey.currentState.value["expansions"])
                      ));
                    } else {
                      BlocProvider.of<GamesBloc>(context).add(EditGameEvent(
                        game,
                        time: _formKey.currentState.value["time"],
                        players: List<Player>.from(_formKey.currentState.value["players"]),
                        winner: _formKey.currentState.value["winner"],
                        expansions: List<CatanExpansion>.from(_formKey.currentState.value["expansions"])
                      ));
                    }
                  }
                },
                child: Text("SAVE"),
                textColor: Theme.of(context).primaryIconTheme.color,
                shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
              )
            ],
          ),
          body: UserFeedback(child: AddEditGamePage(_formKey, game: game))
      ),
    );
  }
}
