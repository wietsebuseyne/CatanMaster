import 'package:catan_master/domain/players/player.dart';
import 'package:catan_master/presentation/core/catan_icons.dart';
import 'package:catan_master/presentation/core/widgets/hexagon.dart';
import 'package:catan_master/presentation/players/player_presentation.dart';
import 'package:flutter/material.dart';

class PlayerListTile extends StatelessWidget {

  final Player player;

  PlayerListTile(this.player, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Hexagon(
        color: player.color,
        child: Icon(CatanIcons.medal_solid, size: 16, color: player.onColor),
      ),
      title: Text(player.name, style: Theme.of(context).textTheme.headline6,),
    );
  }
}