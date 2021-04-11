import 'package:catan_master/application/games/games_bloc.dart';
import 'package:catan_master/domain/games/game.dart';
import 'package:catan_master/domain/players/player.dart';
import 'package:catan_master/presentation/core/catan_expansion_ui.dart';
import 'package:catan_master/presentation/core/catan_icons.dart';
import 'package:catan_master/presentation/core/color.dart';
import 'package:catan_master/presentation/core/widgets/hexagon.dart';
import 'package:catan_master/presentation/core/widgets/horizontal_info_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

final DateFormat _df = DateFormat("EE dd MMM yy, HH:mm");

class GameDetailPage extends StatelessWidget {
  
  final Game game;

  const GameDetailPage(this.game);

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        bool light = isLight(game.winner.color);
        var brightness = light ? Brightness.light : Brightness.dark;
        var theme = ThemeData(brightness: brightness);
        return <Widget>[
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: SliverAppBar(
              centerTitle: true,
              flexibleSpace: FlexibleSpaceBar(title: Text(_df.format(game.date), style: theme.textTheme.headline6), centerTitle: true,),
              collapsedHeight: kToolbarHeight,
              toolbarHeight: kToolbarHeight,
              expandedHeight: 100.0,
              pinned: true,
              backgroundColor: game.winner.color,
              iconTheme: light
                  ? IconTheme.of(context).copyWith(color: Colors.black)
                  : IconTheme.of(context).copyWith(color: Colors.white),
              brightness: brightness,
              actions: [
                IconButton(
                  onPressed: () => Navigator.of(context).pushNamed("/games/edit", arguments: {"game": game}),
                  icon: Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () => BlocProvider.of<GamesBloc>(context).add(DeleteGameEvent(game)),
                  icon: Icon(Icons.delete),
                )
              ],
            ),
          )
        ];
      },
      body: Builder(
        builder: (context) {
          return _body(context);
        }
      ),
    );
  }

  Widget _body(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverOverlapInjector(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        ),
        SliverToBoxAdapter(
          child: Column(
            children: [
              GameWinner(game.winner),

              //Last Games
              if (game.hasExpansion) ..._expansions(),

              //Stats
              Divider(indent: 32.0, endIndent: 32.0,),
              SizedBox(height: 8.0,),
              Text("Players", style: Theme.of(context).textTheme.headline6),
              SizedBox(height: 8.0,),
              ...game.getPlayersByScoreOrName().map((p) {
                return ListTile(
                  leading: TextHexagon(
                      text: "${game.scores[p] ?? ""}",
                      color: p.color
                  ),
                  title: Text(p.name),
                  onTap: () => Navigator.of(context).pushNamed("/players/detail", arguments: {"player": p}),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Iterable<Widget> _expansions() sync* {
    yield Divider(indent: 32.0, endIndent: 32.0,);
    yield Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: game.expansions.map((e) {
        return Tooltip(
          message: e.name ?? "",
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: e.iconWidget,
            ),
        );
      }).toList(),
    );
  }

}

class GameWinner extends StatelessWidget {

  final Player player;

  GameWinner(this.player);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(CatanIcons.trophy, size: 32, color: const Color.fromARGB(255, 218, 165, 32),),
        ),
        Text(player.name, style: Theme.of(context).textTheme.headline5),
      ],
    );
  }

}