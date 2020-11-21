/*import 'package:catan_master/application/main/main_bloc.dart';
import 'package:catan_master/domain/players/player.dart';
import 'package:catan_master/presentation/core/catan_master_app.dart';
import 'package:catan_master/presentation/players/pages/add_edit_player_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

@immutable
class CatanRoutePath {

  final CatanScreen screen;
  final String detailId;

  CatanRoutePath.home() : this.screen = CatanScreen.home, detailId = null;
  CatanRoutePath.addPlayer() : this.screen = CatanScreen.add_edit_player, detailId = null;
  CatanRoutePath.editPlayer(String playerName) : this.screen = CatanScreen.add_edit_player, detailId = playerName;

}

enum CatanScreen {
  home, add_edit_player
}

class CatanRouterDelegate extends RouterDelegate<CatanRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<CatanRoutePath> {

  final GlobalKey<NavigatorState> navigatorKey;
  HomePageTab tab = HomePageTab.games;
  Player _editingPlayer;
  bool addingPlayer;

  CatanRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  CatanRoutePath get currentConfiguration {
    if (_editingPlayer != null) {
      return CatanRoutePath.editPlayer(_editingPlayer.name);
    }
    if (addingPlayer) {
      return CatanRoutePath.addPlayer();
    }
    return CatanRoutePath.home();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        MaterialPage(
          key: ValueKey('Home'),
          child: CatanMasterHomeScreen(tab: tab),
        ),
        if (addingPlayer)
          MaterialPage(
              key: ValueKey("Add Player"),
              child: AddPlayerPage()
          )
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        addingPlayer = false;
        _editingPlayer = null;
        notifyListeners();

        return true;
      }
    );
  }

  @override
  Future<void> setNewRoutePath(CatanRoutePath configuration) async {
    switch (configuration.screen) {
      case CatanScreen.home:
        _editingPlayer = null;
        addingPlayer = false;
        return;
      case CatanScreen.add_edit_player:
//        _editingPlayer = configuration.detailId;
        addingPlayer = false;
        break;
    }
  }
}
*/