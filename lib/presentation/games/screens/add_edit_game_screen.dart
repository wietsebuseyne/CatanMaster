import 'package:catan_master/application/games/games_bloc.dart';
import 'package:catan_master/domain/games/game.dart';
import 'package:catan_master/domain/players/player.dart';
import 'package:catan_master/presentation/feedback/user_feedback.dart';
import 'package:catan_master/presentation/games/pages/add_edit_game_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddEditGameScreen extends StatelessWidget {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Game game;
  final GameFormData formData;
  final bool edit;

  AddEditGameScreen.add() : formData = GameFormData(), edit = false, game = null;

  AddEditGameScreen.edit(this.game) :
        formData = GameFormData.fromGame(game),
        edit = true;

  @override
  Widget build(BuildContext context) {
    return BlocListener<GamesBloc, GamesState>(
      listener: (context, state) {
        if ((!edit && state is GameAdded) || (edit && state is GameEdited)) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text(edit ? "Edit Game" : "Add Game"),
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
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();

                    bool withScores = formData.withScores;
                    List<CatanExpansion> expansions = formData.expansions;
                    Map<Player, int> scores = formData.scores;
                    DateTime date = formData.date;
                    List<Player> players = formData.players;
                    Player winner = formData.winner;

                    if (withScores) {
                      BlocProvider.of<GamesBloc>(context).add(AddEditGameEvent.withScores(
                        oldGame: game,
                        time: date,
                        scores: scores,
                        expansions: expansions,
                      ));
                    } else {
                      BlocProvider.of<GamesBloc>(context).add(AddEditGameEvent.noScores(
                        oldGame: game,
                        time: date,
                        players: players,
                        winner: winner,
                        expansions: expansions,
                      ));
                    }
                  }
                },
              )
            ],
          ),
          body: UserFeedback(child: AddEditGamePage(_formKey, formData: formData))
      ),
    );
  }
}