import 'package:catan_master/presentation/core/widgets/hexagon.dart';
import 'package:flutter/material.dart';

class GameActions extends StatelessWidget {

  final Widget title;
  final Function onEdit;
  final Function onDelete;

  GameActions({@required this.title, @required this.onEdit, @required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: ListTile(
            leading: Hexagon(size: 24, color: Colors.grey),
            title: title,
            visualDensity: VisualDensity.comfortable,
          ),
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
