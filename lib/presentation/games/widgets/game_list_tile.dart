import 'package:catan_master/domain/games/game.dart';
import 'package:catan_master/domain/players/player.dart';
import 'package:catan_master/presentation/core/catan_icons.dart';
import 'package:catan_master/presentation/players/player_extensions.dart';
import 'package:catan_master/presentation/core/catan_expansion.dart';
import 'package:catan_master/presentation/core/widgets/hexagon.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//TODO vertical line on the left, switching between color of current and color of next
class GameListTile extends StatelessWidget {

  final Game game;
  final DateFormat _dateFormat = DateFormat("EE dd MMM yyyy, HH:mm");
  final Function onTap;

  GameListTile(this.game, {this.onTap, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Hexagon(
        color: game.winner.color,
        child: _leadingChild(),
      ),
      title: Text(_dateFormat.format(game.date),),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: _playersToWidget().toList(),
          ),
        ]
      ),
      onTap: onTap,
    );
  }

  Widget _leadingChild() {
    if (game.expansions.length == 1) {
      return Icon(game.expansions.first.icon, size: 16, color: game.winner.onColor,);
    } else if (game.expansions.length > 1) {
      return Center(
          child: Text(game.expansions.length.toString(),
            style: TextStyle(color: game.winner.onColor, fontWeight: FontWeight.bold, fontSize: 18),
          ));
    }
    return null;
  }

  Iterable<Widget> _playersToWidget() sync* {
    for (var i = 0; i < game.players.length; i++) {
      var player = game.players[i];
      yield GameListTilePlayer(player, winner: player == game.winner);
      if (i != game.players.length-1) {
        yield SizedBox(width: 12.0,);
      }
    }
  }
}

class GameListTilePlayer extends StatelessWidget {

  final Player player;
  final bool winner;

  GameListTilePlayer(this.player, {this.winner = false});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        if (winner)
          Container(
            child: Icon(
              CatanIcons.trophy_solid,
              color: player.foregroundColor,
              size: 12,
            ),
          )
        else
          Hexagon(
            color: player.color,
            size: 8,
          ),
        SizedBox(
          width: 4.0,
        ),
        Text(player.name)
      ],
    );
  }
}

