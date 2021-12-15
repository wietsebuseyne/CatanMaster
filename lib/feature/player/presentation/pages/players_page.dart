import 'package:catan_master/feature/game/presentation/bloc/games_bloc.dart';
import 'package:catan_master/feature/player/presentation/bloc/players_bloc.dart';
import 'package:catan_master/feature/player/domain/player.dart';
import 'package:catan_master/feature/player/presentation/widgets/players_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlayersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayersBloc, PlayerState>(builder: (BuildContext context, PlayerState playersState) {
      if (playersState is PlayersLoading || playersState is InitialPlayersState) {
        return const Center(child: CircularProgressIndicator());
      } else if (playersState is PlayersLoaded) {
        return BlocBuilder<GamesBloc, GamesState>(builder: (BuildContext context, GamesState gamesState) {
          if (gamesState is GamesLoaded) {
            List<PlayerStatistics> statistics =
                playersState.players.map((p) => PlayerStatistics.fromGames(p, gamesState.games)).toList();
            statistics.sort((s1, s2) {
              var r1 = s1.rank == 0 ? double.maxFinite.toInt() : s1.rank;
              var r2 = s2.rank == 0 ? double.maxFinite.toInt() : s2.rank;
              return r1.compareTo(r2);
            });
            return Center(child: PlayersList(statistics));
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
      }
      return Text("Unimplemented state: $playersState");
    });
  }
}
