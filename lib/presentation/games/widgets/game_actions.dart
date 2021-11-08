import 'package:catan_master/domain/games/game.dart';
import 'package:catan_master/presentation/games/widgets/game_list_tile.dart';
import 'package:flutter/material.dart';

class GameActions extends StatelessWidget {
  final Game game;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const GameActions(
      {required this.game, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: GameListTile(game),
        ),
        const Divider(thickness: 1),
        ListTile(
          leading: const Icon(Icons.edit),
          title: const Text("Edit game"),
          visualDensity: VisualDensity.compact,
          onTap: onEdit,
        ),
        ListTile(
          leading: const Icon(Icons.delete),
          title: const Text("Delete game"),
          visualDensity: VisualDensity.compact,
          onTap: onDelete,
        )
      ],
    );
  }
}
