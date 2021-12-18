import 'package:catan_master/feature/feedback/presentation/user_feedback.dart';
import 'package:catan_master/feature/game/domain/game.dart';
import 'package:catan_master/feature/game/presentation/bloc/games_bloc.dart';
import 'package:catan_master/feature/game/presentation/pages/game_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameDetailScreen extends StatelessWidget {
  final DateTime date;

  const GameDetailScreen(this.date);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GamesBloc, GamesState>(
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
