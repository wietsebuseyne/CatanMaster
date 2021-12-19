import 'package:catan_master/core/widgets.dart';
import 'package:catan_master/feature/game/domain/game.dart';
import 'package:catan_master/feature/game/presentation/bloc/games_bloc.dart';
import 'package:catan_master/feature/game/presentation/game_presentation.dart';
import 'package:catan_master/feature/player/presentation/player_presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//TODO invert (incomplete top row instead of bottom)
class StatsBody extends StatelessWidget {
  const StatsBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GamesBloc, GamesState>(
      builder: (context, state) {
        if (state is! GamesLoaded) return const Center(child: CircularProgressIndicator());
        List<List<Game>> gameLists = [];
        for (int i = 0; i < state.games.length; i += 10) {
          gameLists.add(state.games.games.skip(i).take(10).toList());
        }
        int row = -1;
        return Stack(
          children: gameLists.expand((gs) {
            row++;
            return [
              GameHexagonRow.odd(games: gs, row: row),
              GameHexagonRow.even(games: gs, row: row),
            ];
          }).toList(),
        );
      },
    );
  }
}

class GameHexagonRow extends StatelessWidget {
  final List<Game> games;
  final bool even;
  final int row;
  final double hexWidth;

  const GameHexagonRow._({
    required this.games,
    required this.even,
    required this.row,
    this.hexWidth = 48,
    Key? key,
  }) : super(key: key);

  factory GameHexagonRow.even({required List<Game> games, required int row, Key? key}) {
    final even = <Game>[];
    if (row % 2 == 1) {
      games = games.reversed.toList();
    }
    for (var i = 0; i < games.length; i += 2) {
      even.add(games[i]);
    }
    return GameHexagonRow._(games: even, even: true, row: row, key: key);
  }

  factory GameHexagonRow.odd({required List<Game> games, required int row, Key? key}) {
    final odd = <Game>[];
    if (row % 2 == 1) {
      games = games.reversed.toList();
    }
    for (var i = 1; i < games.length; i += 2) {
      odd.add(games[i]);
    }
    return GameHexagonRow._(games: odd, even: false, row: row, key: key);
  }

  @override
  Widget build(BuildContext context) {
    final height = hexWidth * kLongToSmallRatio;
    return Positioned(
      top: (row * height) + (even ? (height / 2) : 0),
      left: even ? 0 : hexWidth * 3 / 4,
      child: Row(
        children: games.expand((w) {
          return [
            GameHexagon(
              w,
              width: hexWidth,
              height: height,
            ),
            SizedBox(width: hexWidth / 2)
          ];
        }).toList(),
      ),
    );
  }
}

class GameHexagon extends StatelessWidget {
  final Game game;
  final double width;
  final double height;
  final double rotate;

  const GameHexagon(this.game, {this.rotate = 30, this.width = 32, this.height = 32});

  @override
  Widget build(BuildContext context) {
    return Hexagon(
      color: game.winner.color,
      child: _GameHexExpansion(game),
      side: const BorderSide(color: Colors.white, width: 0),
      rotate: rotate,
      width: width,
      height: height,
    );
  }
}

class _GameHexExpansion extends StatelessWidget {
  final Game game;

  const _GameHexExpansion(this.game, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final icon = game.icon;
    if (icon != null) return Icon(icon, size: 18, color: game.winner.onColor);
    if (game.expansions.isEmpty) return const SizedBox();
    return Center(
      child: Text(
        game.expansions.length.toString(),
        style: TextStyle(color: game.winner.onColor, fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }
}
