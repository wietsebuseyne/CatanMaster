import 'package:catan_master/application/games/games_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef GamesWidgetBuilder = Widget Function(BuildContext, GamesLoaded);

class GamesPage extends StatelessWidget {

  final GamesWidgetBuilder childBuilder;

  GamesPage({@required this.childBuilder}) : assert(childBuilder != null);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GamesBloc, GamesState>(
        builder: (BuildContext context, GamesState state) {
          if (state is GamesLoading || state is InitialGamesState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is GamesLoaded) {
            return childBuilder(context, state);
          }
          return Text("Unimplemented state: $state");
        }
    );
  }
}
