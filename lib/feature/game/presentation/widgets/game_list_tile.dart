import 'package:catan_master/core/catan_icons.dart';
import 'package:catan_master/core/widgets/hexagon.dart';
import 'package:catan_master/feature/game/domain/game.dart';
import 'package:catan_master/feature/game/presentation/widgets/game_hexagon.dart';
import 'package:catan_master/feature/player/domain/player.dart';
import 'package:catan_master/feature/player/presentation/player_presentation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//TODO vertical line on the left, switching between color of current and color of next
class GameListTile extends StatelessWidget {
  final Game game;
  final DateFormat _dateFormat = DateFormat("EE dd MMM yyyy, HH:mm");
  final VoidCallback? onTap;

  GameListTile(this.game, {this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: GameHexagon(game),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(4, 16, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_dateFormat.format(game.date), style: Theme.of(context).textTheme.subtitle1),
                    const SizedBox(height: 4),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      runSpacing: 4,
                      children: _playersToWidget().toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Iterable<Widget> _playersToWidget() sync* {
    for (var i = 0; i < game.players.length; i++) {
      var player = game.players[i];
      yield GameListTilePlayer(player, winner: player == game.winner, score: game.scores[player]);
      if (i != game.players.length - 1) {
        yield const SizedBox(width: 12.0);
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
    final theme = Theme.of(context).textTheme;
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        if (winner)
          Icon(CatanIcons.trophySolid, color: player.foregroundColor, size: 12)
        else
          Hexagon(color: player.color, width: 8, height: 12),
        const SizedBox(width: 4.0),
        Text(
          score == null ? player.name : "${player.name} ($score)",
          style: theme.bodyText2!.copyWith(color: theme.caption!.color),
        )
      ],
    );
  }
}
