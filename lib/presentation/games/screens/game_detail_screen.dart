import 'package:catan_master/application/games/games_bloc.dart';
import 'package:catan_master/domain/games/game.dart';
import 'package:catan_master/presentation/feedback/user_feedback.dart';
import 'package:catan_master/presentation/games/pages/game_detail_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameDetailScreen extends StatelessWidget {
  //We use username here and listen to player changes
  final DateTime date;

  const GameDetailScreen(this.date);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GamesBloc, GamesState>(
      listenWhen: (s1, s2) => s2 is GamesLoaded && s2.games.getGame(date) == null,
      listener: (s1, s2) => Navigator.of(context).pop(),
      builder: (context, state) {
        if (state is GamesLoaded) {
          var game = state.games.getGame(date);
          if (game != null) {
            return _GameDetailScreen(game);
          }
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class _GameDetailScreen extends StatelessWidget {
  final Game game;

  const _GameDetailScreen(
    this.game, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: UserFeedback(child: GameDetailPage(game)));
  }
}
