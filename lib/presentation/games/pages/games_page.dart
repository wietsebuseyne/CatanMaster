import 'package:catan_master/application/games/games_bloc.dart';
import 'package:catan_master/presentation/games/widgets/games_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GamesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GamesBloc, GamesState>(
        builder: (BuildContext context, GamesState state) {
          if (state is GamesLoading || state is InitialGamesState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is GamesLoaded) {
            return GamesList(state.games);
          }
          return Text("Unimplemented state: $state");
        }
    );
  }
}
