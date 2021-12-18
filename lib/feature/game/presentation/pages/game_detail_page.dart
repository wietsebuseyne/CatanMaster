import 'package:catan_master/core/catan_icons.dart';
import 'package:catan_master/core/color.dart';
import 'package:catan_master/core/widgets/hexagon.dart';
import 'package:catan_master/feature/game/domain/game.dart';
import 'package:catan_master/feature/game/presentation/bloc/games_bloc.dart';
import 'package:catan_master/feature/game/presentation/catan_expansion_ui.dart';
import 'package:catan_master/feature/player/domain/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        var overlayStyle = light ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light;
        return <Widget>[
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: SliverAppBar(
              centerTitle: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(_df.format(game.date), style: theme.textTheme.headline6),
                centerTitle: true,
              ),
              collapsedHeight: kToolbarHeight,
              toolbarHeight: kToolbarHeight,
              expandedHeight: 100.0,
              pinned: true,
              backgroundColor: game.winner.color,
              iconTheme: light
                  ? IconTheme.of(context).copyWith(color: Colors.black)
                  : IconTheme.of(context).copyWith(color: Colors.white),
              systemOverlayStyle: overlayStyle,
              actions: [
                IconButton(
                  onPressed: () => Navigator.of(context).pushNamed("/games/edit", arguments: {"game": game}),
                  icon: const Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () => BlocProvider.of<GamesBloc>(context).add(DeleteGameEvent(game)),
                  icon: const Icon(Icons.delete),
                )
              ],
            ),
          )
        ];
      },
      body: Builder(builder: (context) {
        return _body(context);
      }),
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
              if (game.hasExpansion) ..._expansions(),
              if (game.hasScenario) ..._scenarios(),
              //Stats
              const Divider(),
              const SizedBox(
                height: 8.0,
              ),
              Text("Players", style: Theme.of(context).textTheme.headline6),
              const SizedBox(
                height: 8.0,
              ),
              ...game.getPlayersByScoreOrName().map((p) {
                return ListTile(
                  leading: TextHexagon(text: "${game.scores[p] ?? ""}", color: p.color),
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
    yield const Divider();
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

  Iterable<Widget> _scenarios() sync* {
    for (final scenario in game.scenarios) {
      yield Padding(
        padding: const EdgeInsets.all(2.0),
        child: Text(scenario.name),
      );
    }
  }
}

class GameWinner extends StatelessWidget {
  final Player player;

  const GameWinner(this.player);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(
            CatanIcons.trophy,
            size: 32,
            color: Color.fromARGB(255, 218, 165, 32),
          ),
        ),
        Text(player.name, style: Theme.of(context).textTheme.headline5),
      ],
    );
  }
}
