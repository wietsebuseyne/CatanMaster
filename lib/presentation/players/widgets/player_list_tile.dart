import 'package:catan_master/domain/players/player.dart';
import 'package:catan_master/presentation/core/widgets/hexagon.dart';
import 'package:catan_master/presentation/players/widgets/win_lose_hex.dart';
import 'package:flutter/material.dart';

class PlayerListTile extends StatelessWidget {
  final PlayerStatistics statistics;
  Player get player => statistics.player;

  const PlayerListTile(this.statistics, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: TextHexagon(
        color: player.color,
        text: statistics.rankString,
      ),
      title: Text(
        player.name,
        style: Theme.of(context).textTheme.headline6,
      ),
      trailing: SizedBox(
        width: 24 * 5,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: statistics.getWinOrLose(5).map((w) => WinLoseHexagon(w, rotate: 0, width: 24)).toList(),
        ),
      ),
      onTap: () => Navigator.of(context).pushNamed("/players/detail", arguments: {"player": player}),
    );
  }
}
