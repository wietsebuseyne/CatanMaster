import 'package:catan_master/feature/game/data/dto/game_dtos.dart';
import 'package:catan_master/feature/game/data/game_datasource.dart';
import 'package:catan_master/feature/game/data/local_game_repository.dart';
import 'package:catan_master/feature/game/domain/game_repository.dart';
import 'package:catan_master/feature/player/data/dto/player_dtos.dart';
import 'package:catan_master/feature/player/data/local_player_repository.dart';
import 'package:catan_master/feature/player/data/player_datasource.dart';
import 'package:catan_master/feature/player/domain/player_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class CatanMasterLocalRepositoryProvider extends StatelessWidget {
  final Widget child;

  const CatanMasterLocalRepositoryProvider({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Box>>(
      future: Future.wait<Box>([
        Hive.openBox<PlayerDto>("players"),
        Hive.openBox<GameDto>("games"),
      ]),
      builder: (BuildContext context, AsyncSnapshot<List<Box>> snapshot) {
        if (snapshot.hasError) {
          return const MaterialApp(
            home: Scaffold(body: Center(child: Text("Fatal error occured"))),
          );
        }
        var data = snapshot.data;
        if (data == null) {
          return const Center(child: CircularProgressIndicator());
        }
        Box<PlayerDto> playerBox = data[0] as Box<PlayerDto>;
        Box<GameDto> gameBox = data[1] as Box<GameDto>;
        return MultiProvider(
          providers: [
            Provider<PlayerDatasource>(create: (context) => HivePlayerDatasource(playerBox)),
            Provider<GameDatasource>(create: (context) => HiveGameDatasource(gameBox)),
            Provider<PlayerRepository>(
              create: (BuildContext context) {
                return LocalPlayerRepository(context.read<PlayerDatasource>());
              },
            ),
            ProxyProvider<PlayerRepository, GameRepository>(
              update: (context, playerRepo, gameRepo) {
                return LocalGameRepository(
                  gameDatasource: context.read<GameDatasource>(),
                  playerRepository: playerRepo,
                );
              },
            ),
          ],
          child: child,
        );
      },
    );
  }
}
