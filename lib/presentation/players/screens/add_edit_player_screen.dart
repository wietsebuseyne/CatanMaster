import 'package:catan_master/application/players/players_bloc.dart';
import 'package:catan_master/domain/players/player.dart';
import 'package:catan_master/presentation/core/color.dart';
import 'package:catan_master/presentation/feedback/user_feedback.dart';
import 'package:catan_master/presentation/players/pages/add_edit_player_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddEditPlayerScreen extends StatefulWidget {

  final Player? player;

  AddEditPlayerScreen._({this.player});

  factory AddEditPlayerScreen.add() => AddEditPlayerScreen._();
  factory AddEditPlayerScreen.edit(Player player) => AddEditPlayerScreen._(player: player);

  @override
  _AddEditPlayerScreenState createState() => _AddEditPlayerScreenState(
    PlayerFormData(name: player?.name, color: player?.color, gender: player?.gender)
  );
}

class _AddEditPlayerScreenState extends State<AddEditPlayerScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final PlayerFormData formData;

  _AddEditPlayerScreenState(this.formData);

  @override
  Widget build(BuildContext context) {
    var color = formData.color ?? Theme.of(context).primaryColor;
    var light = isLight(color);
    var brightness = light ? Brightness.light : Brightness.dark;
    return BlocListener<PlayersBloc, PlayerState>(
      listener: (context, state) {
        if (state is PlayerAdded || state is PlayerEdited) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              widget.player == null ? "Add Player" : "Edit Player",
              style: ThemeData(brightness: brightness).textTheme.headline6,
            ),
            backgroundColor: color,
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
                  FormState? state = _formKey.currentState;
                  if (state != null && state.validate()) {
                    state.save();
                    BlocProvider.of<PlayersBloc>(context).add(AddOrUpdatePlayer(
                      toEdit: widget.player,
                      name: formData.name!,
                      gender: formData.gender!,
                      color: formData.color!
                    ));
                  }
                },
              )
            ],
          ),
          body: UserFeedback(child: AddEditPlayerPage(
            _formKey,
            formData: formData,
            onFormChanged: () {
              _formKey.currentState?.save();
              // Formdata has changed
              setState(() { });
            },
          ))
      ),
    );
  }
}