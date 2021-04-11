import 'package:catan_master/application/games/games_bloc.dart';
import 'package:catan_master/domain/games/game.dart';
import 'package:catan_master/domain/players/player.dart';
import 'package:catan_master/presentation/core/color.dart';
import 'package:catan_master/presentation/feedback/user_feedback.dart';
import 'package:catan_master/presentation/games/pages/add_edit_game_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddEditGameScreen extends StatefulWidget {

  final Game? game;
  final bool edit;

  AddEditGameScreen.add() : edit = false, game = null;

  AddEditGameScreen.edit(Game this.game) :
        edit = true;

  @override
  _AddEditGameScreenState createState() => _AddEditGameScreenState(
      edit ? GameFormData.fromGame(game!) : GameFormData()
  );
}

class _AddEditGameScreenState extends State<AddEditGameScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GameFormData formData;

  _AddEditGameScreenState(this.formData);

  @override
  Widget build(BuildContext context) {
    var color = formData.winner?.color ?? Colors.blue;
    print(color);
    var light = isLight(color);
    var brightness = light ? Brightness.light : Brightness.dark;
    return BlocListener<GamesBloc, GamesState>(
      listener: (context, state) {
        if ((!widget.edit && state is GameAdded) || (widget.edit && state is GameEdited)) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: color,
            title: Text(
              widget.edit ? "Edit Game" : "Add Game",
              style: ThemeData(brightness: brightness).textTheme.headline6,
            ),
            brightness: brightness,
            iconTheme: ThemeData(brightness: brightness).iconTheme,
            actions: [
              TextButton.icon(
                icon: Icon(Icons.save),
                label: Text("Save"),
                style: TextButton.styleFrom(
                  primary: light ? Colors.black : Colors.white,
                  textStyle: TextStyle(fontSize: 16),
                  shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                ),
                onPressed: () {
                  FormState? formState = _formKey.currentState;
                  if (formState != null && formState.validate()) {
                    formState.save();

                    bool withScores = formData.withScores;
                    List<CatanExpansion> expansions = formData.expansions;
                    Map<Player, int>? scores = formData.scores;
                    DateTime? date = formData.date;
                    List<Player> players = formData.players;
                    Player? winner = formData.winner;

                    if (withScores) {
                      BlocProvider.of<GamesBloc>(context).add(AddEditGameEvent.withScores(
                        oldGame: widget.game,
                        time: date!,
                        scores: scores!,
                        expansions: expansions,
                      ));
                    } else {
                      BlocProvider.of<GamesBloc>(context).add(AddEditGameEvent.noScores(
                        oldGame: widget.game,
                        time: date!,
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
          body: UserFeedback(child: AddEditGamePage(
            _formKey,
            formData: formData,
            onFormChanged: () {
              _formKey.currentState?.save();
              setState(() {});
            },
          ))
      ),
    );
  }
}