import 'package:catan_master/application/players/players_bloc.dart';
import 'package:catan_master/presentation/players/pages/add_player_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class AddPlayerScreen extends StatelessWidget {

  final GlobalKey<FormBuilderState> _formKey;

  AddPlayerScreen() : _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<PlayersBloc, PlayersState>(
      listener: (context, state) {
        if (state is PlayerAdded) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text("Add Player"),
            actions: [
              IconButton(
                onPressed: () {
                  if (_formKey.currentState.saveAndValidate()) {
                    BlocProvider.of<PlayersBloc>(context).add(AddPlayer(
                        name: _formKey.currentState.value["name"],
                        color: _formKey.currentState.value["color"]
                    ));
                  }
                },
                icon: Icon(Icons.check),
                tooltip: "Add player",
              )
            ],
          ),
          body: AddPlayerPage(_formKey)
      ),
    );
  }
}
