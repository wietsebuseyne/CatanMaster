import 'package:catan_master/application/games/games_bloc.dart';
import 'package:catan_master/domain/games/game.dart';
import 'package:catan_master/domain/players/player.dart';
import 'package:catan_master/presentation/core/color.dart';
import 'package:catan_master/presentation/feedback/user_feedback.dart';
import 'package:catan_master/presentation/games/pages/add_edit_game_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddEditGameScreen extends StatefulWidget {
  final Game? game;
  final bool edit;

  const AddEditGameScreen.add()
      : edit = false,
        game = null;

  const AddEditGameScreen.edit(Game this.game) : edit = true;

  @override
  _AddEditGameScreenState createState() => _AddEditGameScreenState();
}

class _AddEditGameScreenState extends State<AddEditGameScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late GameFormData formData;

  _AddEditGameScreenState() {
    this.formData =
        widget.edit ? GameFormData.fromGame(widget.game!) : GameFormData();
  }

  @override
  Widget build(BuildContext context) {
    final color = formData.winner?.color ?? Colors.blue;
    final light = isLight(color);
    final brightness = light ? Brightness.light : Brightness.dark;
    var overlayStyle =
        light ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light;
    return BlocListener<GamesBloc, GamesState>(
      listener: (context, state) {
        if ((!widget.edit && state is GameAdded) ||
            (widget.edit && state is GameEdited)) {
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
          systemOverlayStyle: overlayStyle,
          iconTheme: ThemeData(brightness: brightness).iconTheme,
          actions: [
            TextButton.icon(
              icon: const Icon(Icons.save),
              label: const Text("Save"),
              style: TextButton.styleFrom(
                primary: light ? Colors.black : Colors.white,
                textStyle: const TextStyle(fontSize: 16),
                shape: const CircleBorder(
                    side: BorderSide(color: Colors.transparent)),
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
                    BlocProvider.of<GamesBloc>(context)
                        .add(AddEditGameEvent.withScores(
                      oldGame: widget.game,
                      time: date!,
                      scores: scores!,
                      expansions: expansions,
                    ));
                  } else {
                    BlocProvider.of<GamesBloc>(context)
                        .add(AddEditGameEvent.noScores(
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
        body: UserFeedback(
          child: AddEditGamePage(
            _formKey,
            formData: formData,
            onFormChanged: () {
              _formKey.currentState?.save();
              setState(() {});
            },
          ),
        ),
      ),
    );
  }
}
