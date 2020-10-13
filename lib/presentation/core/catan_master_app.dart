import 'package:catan_master/application/main/main_bloc.dart';
import 'package:catan_master/presentation/core/catan_icons.dart';
import 'package:catan_master/presentation/games/pages/games_page.dart';
import 'package:catan_master/presentation/games/screens/add_game_screen.dart';
import 'package:catan_master/presentation/players/pages/players_page.dart';
import 'package:catan_master/presentation/players/screens/add_player_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polygon_clipper/polygon_border.dart';

class CatanMasterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        return MaterialApp(
          title: 'Catan Master',
          theme: ThemeData(
            primarySwatch: Colors.blue, //TODO color of last win
          ),
          home: CatanMasterHomeScreen(tab: state.page),
          initialRoute: '/',
          onGenerateRoute: (RouteSettings settings) {
            if (settings.name == '/players/add') {
              return MaterialPageRoute(
                builder: (context) => AddPlayerScreen(),
                fullscreenDialog: true
              );
            } else if (settings.name == '/games/add') {
              return MaterialPageRoute(
                  builder: (context) => AddGameScreen(),
                  fullscreenDialog: true
              );
            }
            return MaterialPageRoute(
                builder: (context) => Text("unknown route"),
            );
          },
        );
      },
    );
  }
}

class CatanMasterHomeScreen extends StatelessWidget {

  final HomePageTab tab;
  final Function onAddTapped;

  CatanMasterHomeScreen({this.tab = HomePageTab.games, this.onAddTapped});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Catan Master"),
      ),
      body: _createPage(tab),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: pageToIndex(tab),
        items: [
          BottomNavigationBarItem(
            icon: new Icon(tab == HomePageTab.games ? CatanIcons.dice_solid : CatanIcons.dice),
            label: 'Spellekes',
          ),
          BottomNavigationBarItem(
              icon: Icon(tab == HomePageTab.players ? Icons.people : Icons.people_outline),
              label: 'Spelers'
          )
        ],
        onTap: (newIndex) => BlocProvider.of<MainBloc>(context).add(SwitchPageEvent(indexToPage(newIndex))),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        shape: PolygonBorder(
          sides: 6,
          borderRadius: 5.0, // Default 0.0 degrees
          rotate: 30, //TODO rotate when clicked
        ),
        onPressed: () {
          switch(tab) {
            case HomePageTab.games:
              Navigator.of(context).pushNamed("/games/add");
              break;
            case HomePageTab.players:
              Navigator.of(context).pushNamed("/players/add");
              break;
          }
        },
      ),
    );
  }

}

Widget _createPage(HomePageTab page) {
  switch (page) {
    case HomePageTab.players:
      return PlayersPage();
    case HomePageTab.games:
    default:
      return GamesPage();
  }
}

HomePageTab indexToPage(int index) {
  switch (index) {
    case 1:
      return HomePageTab.players;
    case 0:
    default:
      return HomePageTab.games;
  }
}

int pageToIndex(HomePageTab page) {
  switch (page) {
    case HomePageTab.players:
      return 1;
    case HomePageTab.games:
    default:
      return 0;
  }
}