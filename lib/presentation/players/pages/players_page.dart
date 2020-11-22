import 'package:catan_master/application/players/players_bloc.dart';
import 'package:catan_master/presentation/players/widgets/players_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlayersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayersBloc, PlayerState>(
      builder: (BuildContext context, PlayerState state) {
        if (state is PlayersLoading || state is InitialPlayersState) {
          return Center(child: CircularProgressIndicator());
        } else if (state is PlayersLoaded) {
          return PlayersList(state.players);
        }
        return Text("Unimplemented state: $state");
      }
    );
  }
}
