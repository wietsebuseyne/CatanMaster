import 'package:catan_master/application/main/main_bloc.dart';
import 'package:catan_master/domain/players/player.dart';
import 'package:catan_master/presentation/core/catan_icons.dart';
import 'package:catan_master/presentation/core/catan_page_route_builder.dart';
import 'package:catan_master/presentation/feedback/user_feedback.dart';
import 'package:catan_master/presentation/games/pages/games_page.dart';
import 'package:catan_master/presentation/games/screens/add_edit_game_screen.dart';
import 'package:catan_master/presentation/games/widgets/games_list.dart';
import 'package:catan_master/presentation/players/pages/players_page.dart';
import 'package:catan_master/presentation/players/screens/add_player_screen.dart';
import 'package:catan_master/presentation/players/screens/player_detail_screen.dart';
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
              return CatanPageRouteBuilder(page: AddEditGameScreen.add());
            } else if (settings.name == '/games/edit') {
              return MaterialPageRoute(
                  builder: (context) {
                    var game = (settings.arguments as Map)["game"];
                    if (game == null) {
                      return Text("Error: no game provided");
                    }
                    return AddEditGameScreen.edit(game);
                  },
                  fullscreenDialog: true
              );
            } else if (settings.name == '/players/detail') {
              return MaterialPageRoute(
                builder: (context) {
                  var player = (settings.arguments as Map)["player"] as Player;
                  if (player == null) {
                    return Text("Error: no player provided");
                  }
                  return PlayerDetailScreen(player.username);
                }
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
        actions: [
          IconButton(icon: Icon(Icons.settings), onPressed: () {}),
        ],
      ),
      body: _createPage(tab),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: pageToIndex(tab),
        items: [
          BottomNavigationBarItem(
            icon: new Icon(tab == HomePageTab.games ? CatanIcons.dice_solid : CatanIcons.dice),
            label: 'Games',
          ),
          BottomNavigationBarItem(
              icon: Icon(tab == HomePageTab.players ? Icons.people : Icons.people_outline),
              label: 'Players'
          ),
        ],
        onTap: (newIndex) => BlocProvider.of<MainBloc>(context).add(SwitchPageEvent(indexToPage(newIndex))),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: CatanFloatingActionButton(
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

class CatanFloatingActionButton extends StatelessWidget {

  const CatanFloatingActionButton({
    Key key,
    @required this.onPressed,
  }) : super(key: key);

  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "catan_fab",
      flightShuttleBuilder: (flightContext, animation, flightDirection, fromHeroContext, toHeroContext) {
        final Hero toHero = toHeroContext.widget;
        return RotationTransition(
          turns: Tween<double>(begin: 0.0, end: 1.0)
              .animate(CurvedAnimation(parent: animation, curve: Curves.easeInOutSine)),
          child: toHero.child,
        );
      },
      child: FloatingActionButton(
        heroTag: null,
        child: Icon(Icons.add),
        shape: PolygonBorder(
          sides: 6,
          borderRadius: 5.0, // Default 0.0 degrees
          rotate: 30
        ),
        onPressed: () => onPressed(),
      ),
    );
  }
}

Widget _createPage(HomePageTab page) {
  Widget p;
  switch (page) {
    case HomePageTab.players:
      p = PlayersPage();
      break;
    case HomePageTab.games:
    default:
      p = GamesPage(
        childBuilder: (context, state) => GamesList(state.games)
      );
  }

  return UserFeedback(child: p);
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