import 'package:catan_master/domain/games/game.dart';
import 'package:catan_master/presentation/games/widgets/game_list_tile.dart';
import 'package:flutter/material.dart';

class GameActions extends StatelessWidget {

  final Game game;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  GameActions({@required this.game, @required this.onEdit, @required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: GameListTile(game),
        ),
        Divider(thickness: 1),
        ListTile(
          leading: Icon(Icons.edit),
          title: Text("Edit game"),
          visualDensity: VisualDensity.compact,
          onTap: onEdit,
        ),
        ListTile(
          leading: Icon(Icons.delete),
          title: Text("Delete game"),
          visualDensity: VisualDensity.compact,
          onTap: onDelete,
        )
      ],
    );
  }
}
