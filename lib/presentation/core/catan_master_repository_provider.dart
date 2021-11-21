import 'package:catan_master/data/games/game_datasource.dart';
import 'package:catan_master/data/games/game_dtos.dart';
import 'package:catan_master/data/games/game_repository.dart';
import 'package:catan_master/data/games/hive_game_datasource.dart';
import 'package:catan_master/data/players/hive_player_datasource.dart';
import 'package:catan_master/data/players/player_datasource.dart';
import 'package:catan_master/data/players/player_dtos.dart';
import 'package:catan_master/data/players/player_repository.dart';
import 'package:catan_master/domain/games/game_repository.dart';
import 'package:catan_master/domain/players/player_repository.dart';
import 'package:catan_master/presentation/core/catan_master_bloc_provider.dart';
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
              Provider<PlayerDatasource>(
                create: (context) => HivePlayerDatasource(playerBox),
              ),
              Provider<GameDatasource>(
                create: (context) => HiveGameDatasource(gameBox),
              ),
              Provider<PlayerRepository>(
                create: (BuildContext context) {
                  return CachedPlayerRepository(context.read<PlayerDatasource>());
                },
              ),
              ProxyProvider<PlayerRepository, GameRepository>(
                update: (context, playerRepo, gameRepo) {
                  return CachedGameRepository(
                    gameDatasource: context.read<GameDatasource>(),
                    playerRepository: playerRepo,
                  );
                },
              ),
            ],
            child: CatanMasterBlocProvider(child: child),
          );
        });
  }
}

/*class CatanMasterFirebaseRepositoryProvider extends StatelessWidget {

  final Widget child;
  final FirebaseDatabase database;

  CatanMasterFirebaseRepositoryProvider({Key key, @required this.database, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<PlayerRepository>(
          create: (BuildContext context) => CachedPlayerRepository(
              FirebasePlayerDatasource(database)
          ),
        ),
        ProxyProvider<PlayerRepository, GameRepository>(
            update: (context, playerRepo, gameRepo) => CachedGameRepository(
                gameDatasource: FirebaseGameDatasource(database),
                playerRepository: playerRepo
            )
        ),
      ],
      child: CatanMasterBlocProvider(child: child)
    );
  }
}*/
