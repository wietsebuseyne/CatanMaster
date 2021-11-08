import 'package:catan_master/application/games/games_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef GamesWidgetBuilder = Widget Function(BuildContext, GamesLoaded);

class GamesPage extends StatelessWidget {
  final GamesWidgetBuilder childBuilder;

  const GamesPage({required this.childBuilder});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GamesBloc, GamesState>(
        builder: (BuildContext context, GamesState state) {
      if (state is GamesLoading || state is InitialGamesState) {
        return const Center(child: CircularProgressIndicator());
      } else if (state is GamesLoaded) {
        return childBuilder(context, state);
      }
      assert(false);
      return Text("Unimplemented state: $state");
    });
  }
}
