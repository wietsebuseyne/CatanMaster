import 'package:catan_master/feature/game/domain/game.dart';
import 'package:catan_master/feature/game/presentation/screens/add_edit_game_screen.dart';
import 'package:catan_master/feature/game/presentation/screens/game_detail_screen.dart';
import 'package:catan_master/feature/home/presentation/route/catan_page_route_builder.dart';
import 'package:catan_master/feature/player/domain/player.dart';
import 'package:catan_master/feature/player/presentation/screens/add_edit_player_screen.dart';
import 'package:catan_master/feature/player/presentation/screens/player_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CatanRouteGenerator {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    if (settings.name == '/players/add') {
      return CatanPageRouteBuilder(page: AddEditPlayerScreen.add(), fullscreenDialog: true);
    } else if (settings.name == '/players/edit') {
      return MaterialPageRoute(
        builder: (context) {
          var player = (settings.arguments as Map)["player"];
          if (player == null) {
            return const Text("Error: no player provided");
          }
          return AddEditPlayerScreen.edit(player);
        },
        fullscreenDialog: true,
      );
    } else if (settings.name == '/players/detail') {
      return MaterialPageRoute(builder: (context) {
        var player = (settings.arguments as Map)["player"] as Player?;
        if (player == null) {
          return const Text("Error: no player provided");
        }
        return PlayerDetailScreen(player.username);
      });
    } else if (settings.name == '/games/add') {
      return CatanPageRouteBuilder(page: const AddEditGameScreen.add(), fullscreenDialog: true);
    } else if (settings.name == '/games/edit') {
      return MaterialPageRoute(
          builder: (context) {
            var game = (settings.arguments as Map)["game"];
            if (game == null) {
              return const Text("Error: no game provided");
            }
            return AddEditGameScreen.edit(game);
          },
          fullscreenDialog: true);
    } else if (settings.name == '/games/detail') {
      return MaterialPageRoute(builder: (context) {
        var game = (settings.arguments as Map)["game"] as Game?;
        if (game == null) {
          return const Text("Error: no game provided");
        }
        return GameDetailScreen(game.date);
      });
    }
    return MaterialPageRoute(
      builder: (context) => const Text("unknown route"),
    );
  }
}
