import 'package:catan_master/domain/games/game.dart';
import 'package:catan_master/presentation/core/catan_icons.dart';
import 'package:catan_master/presentation/games/widgets/game_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:polygon_clipper/polygon_border.dart';

class GamesList extends StatelessWidget {

  final List<Game> games;

  GamesList(this.games);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("No games", style: Theme.of(context).textTheme.headline5, textAlign: TextAlign.center,),
                  SizedBox(height: 8.0,),
                  Text("Get started and add your first game by pressing the (+) button below", style: Theme.of(context).textTheme.bodyText2, textAlign: TextAlign.center),
                ],
              ),
            ),
          )
        else
          Expanded(
            child:
            ListView.builder(
                itemBuilder: (BuildContext context, int index) => GameListTile(games[index]),
                itemCount: games.length
            ),
          )
      ],
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
