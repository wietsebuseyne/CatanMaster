import 'package:catan_master/data/games/game_dtos.dart';
import 'package:catan_master/data/games/game_repository.dart';
import 'package:catan_master/data/games/hive_game_datasource.dart';
import 'package:catan_master/data/players/hive_player_datasource.dart';
import 'package:catan_master/data/players/player_dtos.dart';
import 'package:catan_master/data/players/player_repository.dart';
import 'package:catan_master/domain/games/game_repository.dart';
import 'package:catan_master/domain/players/player_repository.dart';
import 'package:catan_master/presentation/core/catan_master_bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:provider/provider.dart';

class CatanMasterLocalRepositoryProvider extends StatelessWidget {

  final Widget child;

  CatanMasterLocalRepositoryProvider({Key key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([Hive.openBox<PlayerDto>("players"), Hive.openBox<GameDto>("games")]),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          //TODO show error for reporting
          if (snapshot.hasError) return MaterialApp(home: Scaffold(body: Center(child: Text("Fatal error occured"))));
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          var playerBox = snapshot.data[0];
          var gameBox = snapshot.data[1];
          return MultiProvider(
              providers: [
                Provider<PlayerRepository>(
                  create: (BuildContext context) => CachedPlayerRepository(
                      HivePlayerDatasource(playerBox),
                  ),
                ),
                ProxyProvider<PlayerRepository, GameRepository>(
                  update: (context, playerRepo, gameRepo) => CachedGameRepository(
                      gameDatasource: HiveGameDatasource(gameBox),
                      playerRepository: playerRepo
                  )
                ),
              ],
              child: CatanMasterBlocProvider(child: child)
          );
        }
    );
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
