import 'package:catan_master/domain/players/player.dart';
import 'package:catan_master/presentation/players/widgets/player_list_tile.dart';
import 'package:flutter/material.dart';

class PlayersList extends StatelessWidget {

  final List<Player> players;

  PlayersList(this.players);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (BuildContext context, int index) => PlayerListTile(players[index]),
        separatorBuilder: (c, i) => Divider(height: 1,),
        itemCount: players.length
    );
  }
}
