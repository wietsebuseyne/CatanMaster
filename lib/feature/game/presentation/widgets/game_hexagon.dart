import 'package:catan_master/feature/game/domain/game.dart';
import 'package:catan_master/feature/game/presentation/catan_expansion_ui.dart';
import 'package:catan_master/core/widgets/hexagon.dart';
import 'package:catan_master/feature/player/presentation/player_presentation.dart';
import 'package:flutter/material.dart';

class GameHexagon extends StatelessWidget {
  final Game game;

  const GameHexagon(this.game);

  @override
  Widget build(BuildContext context) {
    return Hexagon(
      color: game.winner.color,
      child: _leadingChild(),
    );
  }

  Widget? _leadingChild() {
    if (game.expansions.length == 1) {
      return Icon(
        game.expansions.first.icon,
        size: 16,
        color: game.winner.onColor,
      );
    } else if (game.expansions.length > 1) {
      return Center(
          child: Text(
        game.expansions.length.toString(),
        style: TextStyle(color: game.winner.onColor, fontWeight: FontWeight.bold, fontSize: 18),
      ));
    }
    return null;
  }
}
