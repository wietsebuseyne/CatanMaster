import 'package:catan_master/application/players/players_bloc.dart';
import 'package:catan_master/domain/games/game.dart';
import 'package:catan_master/domain/players/player.dart';
import 'package:catan_master/presentation/core/catan_expansion_ui.dart';
import 'package:catan_master/presentation/core/catan_icons.dart';
import 'package:catan_master/presentation/core/widgets/hexagon.dart';
import 'package:catan_master/presentation/core/widgets/horizontal_info_tile.dart';
import 'package:catan_master/presentation/games/pages/games_page.dart';
import 'package:catan_master/presentation/players/widgets/win_lose_hex.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class PlayerStatsPage extends StatelessWidget {
  
  final Player player;

  const PlayerStatsPage(this.player);

  @override
  Widget build(BuildContext context) {
    return GamesPage(childBuilder: (context, state) {
      var statistics = state.getStatisticsForPlayer(player);
      return NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          Brightness brightness = ThemeData.estimateBrightnessForColor(player.color);
          var theme = ThemeData(brightness: brightness);
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                centerTitle: true,
                flexibleSpace: FlexibleSpaceBar(title: Text(player.name, style: theme.textTheme.headline6), centerTitle: true,),
                collapsedHeight: kToolbarHeight,
                toolbarHeight: kToolbarHeight,
                expandedHeight: 100.0,
                pinned: true,
                backgroundColor: player.color,
                iconTheme: brightness == Brightness.light ? IconTheme.of(context).copyWith(color: Colors.black) : null,
                actions: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pushNamed("/players/edit", arguments: {"player": player}),
                    icon: Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: () => BlocProvider.of<PlayersBloc>(context).add(DeletePlayerEvent(player)),
                    icon: Icon(Icons.delete),
                  )
                ],
              ),
            )
          ];
        },
        body: Builder(
          builder: (context) {
            return _stats(context, statistics);
          }
        ),
      );
    });
  }

  Widget _stats(BuildContext context, PlayerStatistics statistics) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverOverlapInjector(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        ),
        SliverToBoxAdapter(
          child: Column(
            children: [
              PlayerRank(player, statistics.rank),

              //Last Games
              Divider(indent: 32.0, endIndent: 32.0,),
              Center(child: WinLoseHexagonPath(
                wins: statistics.getWinOrLose(13),
                width: MediaQuery.of(context).size.width,
              )), //TODO calc nb based on width

              //Prizes
              if (statistics.prizes.isNotEmpty) Divider(indent: 32.0, endIndent: 32.0,),
              ...statistics.prizes.map((a) => AchievementLine(a)),

              //Achievements
//            Divider(indent: 32.0, endIndent: 32.0,),
//            Text("Achievements", style: Theme.of(context).textTheme.headline6),
//            Padding(
//              padding: const EdgeInsets.all(8.0),
//              child: Text("No Achievements \uD83D\uDE22", style: Theme.of(context).textTheme.caption),
//            ),

              //Stats
              Divider(indent: 32.0, endIndent: 32.0,),
              HorizontalInfoTile(
                leading: Icon(Icons.format_list_numbered),
                start: Text("Games played"),
                end: Text(statistics.games.length.toString()),
              ),
              HorizontalInfoTile(
                leading: Icon(Icons.tag),
                start: Text("Games won"),
                end: Text("${statistics.nbGamesWon} (${statistics.percentGamesWon}%)"),
              ),
              HorizontalInfoTile(
                leading: Icon(Icons.history),
                start: Text("Last Game"),
                end: Text(statistics.lastGame == null ? "TBD" : DateFormat.yMd().format(statistics.lastGame!.date)),
              ),
              HorizontalInfoTile(
                leading: statistics.mostPlayedExpansion.iconWidget,
                start: Text("Most Played"),
                end: Text(statistics.mostPlayedExpansion.name! ),
              ),
              HorizontalInfoTile(
                leading: statistics.mostWonExpansion.iconWidget,
                start: Text("Most Won"),
                end: Text(statistics.mostWonExpansion.name!),
              ),
              HorizontalInfoTile(
                leading: Icon(Icons.favorite_outline),
                start: Text("Best Catan Buddy"),
                end: Text(statistics.bestBuddy?.name ?? "TBD"),
              ),
            ],
          ),
        ),
      ],
    );
  }

}

class PlayerRank extends StatelessWidget {

  final Player player;
  final int rank;

  PlayerRank(this.player, this.rank);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: _rankIcon,
        ),
        Text(_rankTitle, style: Theme.of(context).textTheme.headline5),
        Text(_rankSubtitle, style: Theme.of(context).textTheme.caption),
      ],
    );
  }

  Widget get _rankIcon {
    if (rank == 1) return Icon(CatanIcons.trophy, size: 32, color: const Color.fromARGB(255, 218, 165, 32),);
    if (rank == 2) return Icon(CatanIcons.medal, size: 32, color: const Color.fromARGB(255, 150, 150, 150),);
    if (rank == 3) return Icon(CatanIcons.medal, size: 32, color: const Color.fromARGB(255, 176, 141, 87),);
    return Hexagon(color: player.color,);
  }

  String get _rankTitle {
    if (rank < 1) return "Unranked";
    if (rank == 1) return "Catan Master";
    if (rank == 2) return "Hand to the king"; //TODO queen
    if (rank == 3) return "3rd place";
    return "${rank}th place";
  }

  //TODO random messages
  String get _rankSubtitle {
    if (rank < 1) return "Start a game instead of looking at this app!";
    if (rank == 1) return "All hail the mighty $player!";
    if (rank == 2) return "One stab in the back away from first place.";
    if (rank == 3) return "On the way to the top.";
    return "Practice your negotation skills."; //"Needs some more practice";
  }

}

class AchievementLine extends StatelessWidget {

  final Prize achievement;

  AchievementLine(this.achievement);

  @override
  Widget build(BuildContext context) {
    return HorizontalInfoTile(
        leading: achievement.leadingWidget,
        start: Text(achievement.title),
        end: Text(achievement.valueString),
    );
  }
}

extension PrizeUi on Prize {

  IconData? get icon {
      switch (this.type) {
        case PrizeType.expansion_master:
          return (value as CatanExpansion).icon;
        case PrizeType.on_a_roll:
          return CatanIcons.dice;
        //TODO add more icons
        case PrizeType.catan_addict:
        case PrizeType.newbie:
        case PrizeType.loser:
      }
      return null;
  }

  Widget get leadingWidget => icon == null ? Hexagon() : Icon(icon);

  String get title {
    switch (this.type) {
      case PrizeType.expansion_master:
        return "$value Champion";
      case PrizeType.on_a_roll:
        return "On a roll";
      case PrizeType.catan_addict:
      case PrizeType.newbie:
      case PrizeType.loser:
    }
    return "?";
  }

  String get valueString {
    switch (this.type) {
      case PrizeType.expansion_master:
        return "Won $value games";
      case PrizeType.on_a_roll:
        return "Won $value out of 5 last games";
      case PrizeType.catan_addict:
      case PrizeType.newbie:
      case PrizeType.loser:
    }
    return "?";
}

}