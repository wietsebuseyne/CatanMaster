import 'package:catan_master/domain/games/game.dart';
import 'package:catan_master/domain/players/player.dart';
import 'package:catan_master/presentation/core/catan_icons.dart';
import 'package:catan_master/presentation/core/widgets/hexagon.dart';
import 'package:catan_master/presentation/games/widgets/game_hexagon.dart';
import 'package:catan_master/presentation/players/player_presentation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//TODO vertical line on the left, switching between color of current and color of next
class GameListTile extends StatelessWidget {
  final Game game;
  final DateFormat _dateFormat = DateFormat("EE dd MMM yyyy, HH:mm");
  final Function? onTap;

  GameListTile(this.game, {this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: GameHexagon(game),
      title: Text(
        _dateFormat.format(game.date),
      ),
      subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: _playersToWidget().toList(),
        ),
      ]),
      onTap: onTap as void Function()?,
    );
  }

  Iterable<Widget> _playersToWidget() sync* {
    for (var i = 0; i < game.players.length; i++) {
      var player = game.players[i];
      yield GameListTilePlayer(player,
          winner: player == game.winner, score: game.scores[player]);
      if (i != game.players.length - 1) {
        yield const SizedBox(
          width: 12.0,
        );
      }
    }
  }
}

class GameListTilePlayer extends StatelessWidget {
  final Player player;
  final bool winner;
  final int? score;

  const GameListTilePlayer(this.player, {this.winner = false, this.score});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        if (winner)
          Icon(CatanIcons.trophySolid, color: player.foregroundColor, size: 12)
        else
          Hexagon(color: player.color, width: 8),
        const SizedBox(width: 4.0),
        Text(score == null ? player.name : "${player.name} ($score)")
      ],
    );
  }
}
