import 'package:catan_master/feature/player/presentation/bloc/players_bloc.dart';
import 'package:catan_master/feature/player/domain/player.dart';
import 'package:catan_master/presentation/feedback/user_feedback.dart';
import 'package:catan_master/presentation/players/pages/player_stats_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlayerDetailScreen extends StatelessWidget {
  //We use username here and listen to player changes
  final String username;

  const PlayerDetailScreen(this.username);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlayersBloc, PlayerState>(
      listenWhen: (s1, s2) => s2 is PlayersLoaded && !s2.players.any((p) => p.username == username),
      listener: (s1, s2) => Navigator.of(context).pop(),
      builder: (context, state) {
        if (state is PlayersLoaded) {
          var player = state.getPlayer(username);
          if (player != null) {
            return _PlayerDetailScreen(player);
          }
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class _PlayerDetailScreen extends StatelessWidget {
  const _PlayerDetailScreen(
    this.player, {
    Key? key,
  }) : super(key: key);

  final Player player;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: UserFeedback(child: PlayerStatsPage(player)));
  }
}
