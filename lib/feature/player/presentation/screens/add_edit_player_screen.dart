import 'package:catan_master/core/color.dart';
import 'package:catan_master/feature/feedback/presentation/user_feedback.dart';
import 'package:catan_master/feature/player/domain/player.dart';
import 'package:catan_master/feature/player/presentation/bloc/players_bloc.dart';
import 'package:catan_master/feature/player/presentation/pages/add_edit_player_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddEditPlayerScreen extends StatefulWidget {
  final Player? player;

  const AddEditPlayerScreen._({this.player});

  factory AddEditPlayerScreen.add() => const AddEditPlayerScreen._();

  factory AddEditPlayerScreen.edit(Player player) => AddEditPlayerScreen._(player: player);

  @override
  _AddEditPlayerScreenState createState() => _AddEditPlayerScreenState();
}

class _AddEditPlayerScreenState extends State<AddEditPlayerScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late PlayerFormData formData;

  _AddEditPlayerScreenState();

  @override
  void initState() {
    this.formData = PlayerFormData(
      name: widget.player?.name,
      color: widget.player?.color,
      gender: widget.player?.gender,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final color = formData.color ?? Theme.of(context).primaryColor;
    final light = isLight(color);
    final brightness = light ? Brightness.light : Brightness.dark;
    final overlayStyle = light ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light;
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
                FormState? state = _formKey.currentState;
                if (state != null && state.validate()) {
                  state.save();
                  BlocProvider.of<PlayersBloc>(context).add(AddOrUpdatePlayer(
                    toEdit: widget.player,
                    name: formData.name!,
                    gender: formData.gender!,
                    color: formData.color!,
                  ));
                }
              },
            )
          ],
        ),
        body: UserFeedback(
          child: AddEditPlayerPage(
            _formKey,
            formData: formData,
            onFormChanged: () {
              _formKey.currentState?.save();
              // Formdata has changed
              setState(() {});
            },
          ),
        ),
      ),
    );
  }
}
