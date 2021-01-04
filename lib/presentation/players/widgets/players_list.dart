import 'package:catan_master/domain/players/player.dart';
import 'package:catan_master/presentation/core/widgets/empty_list_message.dart';
import 'package:catan_master/presentation/players/widgets/player_list_tile.dart';
import 'package:flutter/material.dart';

class PlayersList extends StatelessWidget {

  final List<PlayerStatistics> statistics;

  PlayersList(this.statistics);

  @override
  Widget build(BuildContext context) {
    if (statistics.isEmpty) return EmptyListMessage(
      title: Text("No players"),
      subtitle: Text("To get started, add a player by pressing the \u2795 button below"),
    );
    return ListView.builder(
        itemBuilder: (BuildContext context, int index) => PlayerListTile(
          statistics[index],
        ),
        itemCount: statistics.length,
        padding: const EdgeInsets.only(bottom: 48.0),
    );
  }
}
