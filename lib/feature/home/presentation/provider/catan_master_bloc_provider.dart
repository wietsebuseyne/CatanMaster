import 'package:catan_master/feature/feedback/presentation/bloc/feedback_cubit.dart';
import 'package:catan_master/feature/game/domain/game_repository.dart';
import 'package:catan_master/feature/game/presentation/bloc/games_bloc.dart';
import 'package:catan_master/feature/player/domain/player_repository.dart';
import 'package:catan_master/feature/player/presentation/bloc/players_bloc.dart';
import 'package:catan_master/feature/player/presentation/usecase/delete_player.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CatanMasterBlocProvider extends StatelessWidget {
  final Widget child;

  const CatanMasterBlocProvider({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FeedbackCubit>(
      create: (BuildContext context) => FeedbackCubit(),
      child: Builder(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider<PlayersBloc>(
              create: (BuildContext context) => PlayersBloc(
                RepositoryProvider.of<PlayerRepository>(context),
                feedbackCubit: BlocProvider.of<FeedbackCubit>(context),
                deletePlayer: DeletePlayer(
                  gameRepository: RepositoryProvider.of<GameRepository>(context),
                  playerRepository: RepositoryProvider.of<PlayerRepository>(context),
                ),
              ),
            ),
            BlocProvider<GamesBloc>(
              create: (BuildContext context) => GamesBloc(
                RepositoryProvider.of<GameRepository>(context),
                feedbackCubit: BlocProvider.of<FeedbackCubit>(context),
                playersBloc: BlocProvider.of<PlayersBloc>(context),
              ),
            ),
          ],
          child: child,
        ),
      ),
    );
  }
}
