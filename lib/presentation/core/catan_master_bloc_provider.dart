import 'package:catan_master/application/feedback/feedback_bloc.dart';
import 'package:catan_master/application/games/games_bloc.dart';
import 'package:catan_master/application/main/main_bloc.dart';
import 'package:catan_master/application/players/players_bloc.dart';
import 'package:catan_master/application/players/usecases/delete_player.dart';
import 'package:catan_master/domain/games/game_repository.dart';
import 'package:catan_master/domain/players/player_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CatanMasterBlocProvider extends StatelessWidget {

  final Widget child;

  CatanMasterBlocProvider({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FeedbackBloc>(
      create: (BuildContext context) => FeedbackBloc(),
      child: Builder(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider<PlayersBloc>(
              create: (BuildContext context) => PlayersBloc(
                RepositoryProvider.of<PlayerRepository>(context),
                feedbackBloc: BlocProvider.of<FeedbackBloc>(context),
                deletePlayer: DeletePlayer(
                    gameRepository: RepositoryProvider.of<GameRepository>(context),
                    playerRepository: RepositoryProvider.of<PlayerRepository>(context)
                ),
              )..add(LoadPlayers()),
            ),
            BlocProvider<GamesBloc>(
              create: (BuildContext context) => GamesBloc(
                RepositoryProvider.of<GameRepository>(context),
                feedbackBloc: BlocProvider.of<FeedbackBloc>(context),
                playersBloc: BlocProvider.of<PlayersBloc>(context),
              )..add(LoadGames()),
            ),
            BlocProvider<MainBloc>(
              create: (BuildContext context) => MainBloc(),
            )
          ],
          child: child
        ),
      ),
    );
  }
}
