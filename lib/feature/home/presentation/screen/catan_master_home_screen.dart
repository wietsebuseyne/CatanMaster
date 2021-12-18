import 'package:catan_master/core/catan_icons.dart';
import 'package:catan_master/core/widgets.dart';
import 'package:catan_master/feature/export_import/presentation/export_data_dialog.dart';
import 'package:catan_master/feature/export_import/presentation/import_data_dialog.dart';
import 'package:catan_master/feature/feedback/presentation/bloc/feedback_cubit.dart';
import 'package:catan_master/feature/feedback/presentation/user_feedback.dart';
import 'package:catan_master/feature/game/presentation/bloc/games_bloc.dart';
import 'package:catan_master/feature/game/presentation/pages/games_page.dart';
import 'package:catan_master/feature/game/presentation/widgets/games_list.dart';
import 'package:catan_master/feature/player/presentation/bloc/players_bloc.dart';
import 'package:catan_master/feature/player/presentation/pages/players_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum HomeScreenTab { games, players }

class CatanMasterHomeScreen extends StatefulWidget {
  final Function? onAddTapped;

  const CatanMasterHomeScreen({this.onAddTapped});

  @override
  State<CatanMasterHomeScreen> createState() => _CatanMasterHomeScreenState();
}

class _CatanMasterHomeScreenState extends State<CatanMasterHomeScreen> {
  HomeScreenTab tab = HomeScreenTab.games;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Catan Master"),
        actions: [
          PopupMenuButton<String>(
            onSelected: (selection) {
              switch (selection) {
                case 'export':
                  showExportDialog(context);
                  break;
                case 'import':
                  showImportDialog(context);
                  break;
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem<String>(child: Text('Export data'), value: 'export'),
                const PopupMenuItem<String>(child: Text('Import data'), value: 'import'),
              ];
            },
          ),
        ],
      ),
      body: _HomeBody(tab: tab),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: pageToIndex(tab),
        items: [
          BottomNavigationBarItem(
            icon: Icon(tab == HomeScreenTab.games ? CatanIcons.diceSolid : CatanIcons.dice),
            label: 'Games',
          ),
          BottomNavigationBarItem(
            icon: Icon(tab == HomeScreenTab.players ? Icons.people : Icons.people_outline),
            label: 'Players',
          ),
        ],
        onTap: (newIndex) => setState(() => this.tab = indexToPage(newIndex)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: CatanFloatingActionButton(
        onPressed: () {
          switch (tab) {
            case HomeScreenTab.games:
              _addGame(context);
              break;
            case HomeScreenTab.players:
              Navigator.of(context).pushNamed("/players/add");
              break;
          }
        },
      ),
    );
  }

  void switchIndexTab(int index) {
    setState(() => this.tab = indexToPage(index));
  }

  void switchTab(HomeScreenTab tab) {
    setState(() => this.tab = tab);
  }

  void _addGame(BuildContext context) {
    PlayerState playersState = BlocProvider.of<PlayersBloc>(context).state;
    if (playersState is PlayersLoaded) {
      if (playersState.players.length > 1) {
        Navigator.of(context).pushNamed("/games/add");
      } else {
        showDialog<void>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Not enough players, my lord"),
            content: const Text("You must add at least 2 players before adding a game."),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Cancel")),
              ElevatedButton(
                  onPressed: () {
                    switchTab(HomeScreenTab.players);
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed("/players/add");
                  },
                  child: const Text("Add Player")),
            ],
          ),
        );
      }
    } else {
      BlocProvider.of<FeedbackCubit>(context).snackbar("Still loading data, please be patient");
    }
  }

  Future<void> showExportDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (context) => const ExportDataDialog(),
    );
  }

  Future<void> showImportDialog(BuildContext context) async {
    final gamesBloc = context.read<GamesBloc>();
    final playersBloc = context.read<PlayersBloc>();
    await showDialog<void>(
      context: context,
      builder: (context) => const ImportDataDialog(),
    );
    playersBloc.add(const LoadPlayers());
    gamesBloc.add(const LoadGames());
  }

  HomeScreenTab indexToPage(int index) {
    switch (index) {
      case 1:
        return HomeScreenTab.players;
      case 0:
      default:
        return HomeScreenTab.games;
    }
  }

  int pageToIndex(HomeScreenTab page) {
    switch (page) {
      case HomeScreenTab.players:
        return 1;
      case HomeScreenTab.games:
      default:
        return 0;
    }
  }
}

class _HomeBody extends StatelessWidget {
  final HomeScreenTab tab;

  const _HomeBody({required this.tab, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UserFeedback(
      child: Builder(builder: (context) {
        switch (tab) {
          case HomeScreenTab.players:
            return PlayersPage();
          case HomeScreenTab.games:
          default:
            return GamesPage(childBuilder: (context, state) => GamesList(state.games));
        }
      }),
    );
  }
}
