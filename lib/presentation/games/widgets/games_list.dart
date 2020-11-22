import 'package:catan_master/application/games/games_bloc.dart';
import 'package:catan_master/domain/games/game.dart';
import 'package:catan_master/presentation/core/catan_icons.dart';
import 'package:catan_master/presentation/core/widgets/empty_list_message.dart';
import 'package:catan_master/presentation/games/widgets/game_actions.dart';
import 'package:catan_master/presentation/games/widgets/game_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polygon_clipper/polygon_border.dart';

class GamesList extends StatelessWidget {

  final Games games;

  GamesList(this.games);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 8.0,),
            ExpansionFilter(CatanIcons.helmet_solid),
            SizedBox(width: 8.0,),
            ExpansionFilter(CatanIcons.compass_solid),
            SizedBox(width: 8.0,),
            ExpansionFilter(CatanIcons.axe_solid),
            SizedBox(width: 8.0,),
            ExpansionFilter(CatanIcons.anchor),
            SizedBox(width: 8.0,),
            ExpansionFilter(CatanIcons.crossed_swords),
            SizedBox(width: 8.0,),
          ],
        ),
        if (games.isEmpty)
          Expanded(
            child: EmptyListMessage(
              title: Text("No games"),
              subtitle: Text("Add your first game by pressing the \u2795 button below"),
            ),
          )
        else
          Expanded(
            child:
            ListView.builder(
              itemBuilder: (BuildContext context, int index) => GameListTile(
                games[index],
                onTap: () => _showActionsSheet(context, games[index]),
              ),
              itemCount: games.length,
              padding: const EdgeInsets.only(bottom: 48.0),

            ),
          )
      ],
    );
  }

  _showActionsSheet(BuildContext context, Game game) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
        ),
        builder: (BuildContext bc) {
          return GameActions(
            game: game,
            onEdit: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed("/games/edit", arguments: {"game": game});
            },
            onDelete: () {
              BlocProvider.of<GamesBloc>(context).add(RemoveGameEvent(game));
              Navigator.of(context).pop();
            },
          );
        }
    );
  }

}

class ExpansionFilter extends StatelessWidget {

  final IconData icon;

  ExpansionFilter(this.icon);

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 12,),
      labelPadding: const EdgeInsets.only(),
      label: SizedBox(),
      shape: PolygonBorder(
          sides: 6,
          rotate: 30
      ),
      visualDensity: VisualDensity.compact,
    );
  }

}
