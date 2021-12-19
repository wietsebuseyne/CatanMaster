import 'package:catan_master/core/color.dart';
import 'package:catan_master/feature/feedback/presentation/user_feedback.dart';
import 'package:catan_master/feature/game/domain/game.dart';
import 'package:catan_master/feature/game/presentation/bloc/add_edit_game_bloc.dart';
import 'package:catan_master/feature/game/presentation/pages/add_edit_game_page.dart';
import 'package:catan_master/feature/player/domain/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddEditGameScreen extends StatelessWidget {
  final Game? game;

  const AddEditGameScreen.add() : game = null;

  const AddEditGameScreen.edit(Game this.game);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddEditGameBloc>(
      create: (context) => AddEditGameBloc(toEdit: game, gameRepository: context.read(), feedbackCubit: context.read()),
      child: _AddEditGameScreen(game: game),
    );
  }
}

class _AddEditGameScreen extends StatefulWidget {
  final Game? game;

  bool get edit => game != null;

  const _AddEditGameScreen({this.game});

  @override
  _AddEditGameScreenState createState() => _AddEditGameScreenState();
}

class _AddEditGameScreenState extends State<_AddEditGameScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late GameFormData formData;

  _AddEditGameScreenState();

  @override
  void initState() {
    this.formData = widget.edit ? GameFormData.fromGame(widget.game!) : GameFormData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final color = formData.winner?.color ?? Colors.blue;
    final light = isLight(color);
    final brightness = light ? Brightness.light : Brightness.dark;
    final theme = Theme.of(context);
    final sameBrightness = theme.brightness == brightness;
    var overlayStyle = light ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light;
    return Theme(
      data: Theme.of(context).copyWith(
          primaryColor: color,
          toggleButtonsTheme: ToggleButtonsThemeData(
            // color: sameBrightness ? (light ? Colors.black : Colors.white) : color,
            selectedColor: sameBrightness ? theme.colorScheme.onSurface : theme.colorScheme.surface,
            selectedBorderColor: sameBrightness ? theme.colorScheme.onSurface : color,
            // borderColor: color,
            fillColor: color,
          )),
      child: BlocListener<AddEditGameBloc, AddEditGameState>(
        listener: (context, state) {
          Navigator.of(context).pop();
          //TODO refactor: for now we pop twice to also exit the detail screen (which does not work if the date was edited)
          if (widget.edit) Navigator.of(context).pop();
        },
        listenWhen: (s1, s2) => s2 is AddEditGameSuccess,
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
                  shape: const CircleBorder(side: BorderSide(color: Colors.transparent)),
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                ),
                onPressed: () {
                  FormState? formState = _formKey.currentState;
                  if (formState != null && formState.validate()) {
                    formState.save();

                    bool withScores = formData.withScores;
                    List<CatanExpansion> expansions = formData.expansions;
                    List<CatanScenario> scenarios = formData.scenarios;
                    Map<Player, int>? scores = formData.scores;
                    DateTime? date = formData.date;
                    List<Player> players = formData.players;
                    Player? winner = formData.winner;

                    if (withScores) {
                      BlocProvider.of<AddEditGameBloc>(context).add(AddEditGameEvent.withScores(
                        time: date!,
                        scores: scores!,
                        expansions: expansions,
                        scenarios: scenarios,
                      ));
                    } else {
                      BlocProvider.of<AddEditGameBloc>(context).add(AddEditGameEvent.noScores(
                        time: date!,
                        players: players,
                        winner: winner,
                        expansions: expansions,
                        scenarios: scenarios,
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
      ),
    );
  }
}
