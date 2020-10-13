import 'package:catan_master/data/games/game_dtos.dart';
import 'package:catan_master/data/games/game_local_datasource.dart';
import 'package:catan_master/data/games/game_repository.dart';
import 'package:catan_master/data/players/player_dtos.dart';
import 'package:catan_master/data/players/player_local_datasource.dart';
import 'package:catan_master/data/players/player_repository.dart';
import 'package:catan_master/domain/games/game_repository.dart';
import 'package:catan_master/domain/players/player_repository.dart';
import 'package:catan_master/presentation/core/catan_master_bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

class CatanMasterRepositoryProvider extends StatelessWidget {

  final Widget child;

  CatanMasterRepositoryProvider({Key key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([Hive.openBox<PlayerDto>("players"), Hive.openBox<GameDto>("games")]),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          var playerBox = snapshot.data[0];
          var gameBox = snapshot.data[1];
          return MultiRepositoryProvider(
              providers: [
                RepositoryProvider<PlayerRepository>(
                  create: (BuildContext context) => CachedPlayerRepository(
                    HivePlayerLocalDatasource(playerBox)
                  ),
                ),
                RepositoryProvider<GameRepository>(
                  create: (BuildContext context) => CachedGameRepository(
                      localDatasource: HiveGameLocalDatasource(gameBox),
                      playerRepository: CachedPlayerRepository(HivePlayerLocalDatasource(playerBox)) //TODO reuse the above repository with ProxyProvider here
                  ),
                ),
              ],
              child: CatanMasterBlocProvider(child: child)
          );
        }
    );
  }
}
