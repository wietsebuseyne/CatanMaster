import 'package:catan_master/application/players/players_bloc.dart';
import 'package:catan_master/domain/games/game.dart';
import 'package:catan_master/domain/players/player.dart';
import 'package:catan_master/presentation/core/catan_expansion_ui.dart';
import 'package:catan_master/presentation/core/catan_icons.dart';
import 'package:catan_master/presentation/core/widgets/hexagon.dart';
import 'package:catan_master/presentation/core/widgets/horizontal_info_tile.dart';
import 'package:catan_master/presentation/feedback/user_feedback.dart';
import 'package:catan_master/presentation/players/pages/add_player_page.dart';
import 'package:catan_master/presentation/players/pages/player_stats_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class PlayerDetailScreen extends StatelessWidget {

  final String username;

  PlayerDetailScreen(this.username) : assert(username != null);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayersBloc, PlayersState>(
      builder: (context, state) {
        if (state is PlayersLoaded) {
          var player = state.getPlayer(username);
          if (player == null) {
            return Text("Player not found");
          }
          return _PlayerDetailScreen(player);
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

class _PlayerDetailScreen extends StatelessWidget {

  const _PlayerDetailScreen(this.player, {
    Key key,
  }) : assert(player != null), super(key: key);

  final Player player;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: player.color,
          title: Text(player.name),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.delete),
            )
          ],
        ),
        body: PlayerStatsPage(player)
    );
  }
}