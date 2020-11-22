import 'package:catan_master/application/games/games_bloc.dart';
import 'package:catan_master/application/players/players_bloc.dart';
import 'package:catan_master/domain/players/player.dart';
import 'package:catan_master/presentation/players/widgets/players_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlayersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayersBloc, PlayerState>(
      builder: (BuildContext context, PlayerState playersState) {
        if (playersState is PlayersLoading || playersState is InitialPlayersState) {
          return Center(child: CircularProgressIndicator());
        } else if (playersState is PlayersLoaded) {
          return BlocBuilder<GamesBloc, GamesState>(
            builder: (BuildContext context, GamesState gamesState) {
              if (gamesState is GamesLoaded) {
                List<PlayerStatistics> statistics = playersState.players.map(
                        (p) => PlayerStatistics.fromGames(p, gamesState.games)
                ).toList();
                statistics.sort((s1, s2) => s1.rank.compareTo(s2.rank));
                return PlayersList(statistics);
              }
              return Center(child: CircularProgressIndicator(),);
            }
          );
        }
        return Text("Unimplemented state: $playersState");
      }
    );
  }
}
