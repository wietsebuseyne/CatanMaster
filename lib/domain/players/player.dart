import 'dart:ui';

import 'package:catan_master/core/core.dart';
import 'package:catan_master/domain/games/game.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@immutable
class Player extends Equatable {

  final String username;
  final String name;
  final Gender gender;
  final Color color;

  Player({
    @required this.username,
    @required this.name,
    @required this.gender,
    @required this.color
  }) :
        assert(username != null && username.isNotEmpty),
        assert(name != null),
        assert(name.isNotEmpty),
        assert(gender != null),
        assert(color != null),
        assert(color.alpha == 255);

  @override
  String toString() => name;

  @override
  List<Object> get props => [username, name, color];
}

enum Gender { male, female, x }

@immutable
class PlayerStatistics extends Equatable {

  final Player player;
  final List<Game> games;
  final Player bestBuddy;
  //TODO include 'Base' as an option here
  final CatanExpansion mostPlayedExpansion;
  final CatanExpansion mostWonExpansion;
  final int rank;
  final List<Prize> prizes;

  PlayerStatistics._({
    @required this.player,
    @required this.games,
    @required this.bestBuddy,
    @required this.mostPlayedExpansion,
    @required this.mostWonExpansion,
    @required this.rank,
    @required this.prizes,
  });

  factory PlayerStatistics.fromGames(Player player, Games allGames) {
    var games = allGames.getGamesForPlayer(player);

    Map<Player, int> gamesPlayed = {};
    Map<Player, int> gamesWon = {};

    Map<CatanExpansion, int> expansionsPlayed = {};
    Map<CatanExpansion, int> expansionsWon = {};

    games.forEach((game) {
      game.players.forEach((p) => gamesPlayed[p] = (gamesPlayed[p] ?? 0)+1);
      gamesWon[game.winner] = (gamesWon[game.winner] ?? 0) + 1;
      game.expansions.forEach((e) => expansionsPlayed[e] = (expansionsPlayed[e] ?? 0)+1);
      if (game.winner == player) {
        if (game.expansions.isEmpty) {
          expansionsWon[null] = (expansionsWon[null] ?? 0) + 1;
        } else {
          game.expansions.forEach((e) => expansionsWon[e] = (expansionsWon[e] ?? 0)+1);
        }
      }
    });
    List<Prize> achievements = [];

    int nbWinsFive = games.take(5).where((g) => g.winner == player).length;
    if (nbWinsFive >= 3) {
      achievements.add(Prize(PrizeType.on_a_roll, nbWinsFive));
    }
    return PlayerStatistics._(
        player: player,
        games: games,
        rank: allGames.getRanking().indexOf(player)+1,
        bestBuddy: gamesPlayed.highestValue,
        mostPlayedExpansion: expansionsPlayed.highestValue,
        mostWonExpansion: expansionsWon.highestValue, //TODO procentueel
        prizes: achievements,
    );
  }

  int getNbWinsOutOfLast(int nb) => games.take(nb).where((g) => g.winner == player).length;

  Game get lastGame => games.firstOrNull;

  List<bool> getWins(int nb) => games.take(nb).toList().reversed.map((g) => g.winner == player).toList();

  @override
  List<Object> get props => [player, games];

}

extension HighestValue<K> on Map<K, int> {

  K get highestValue {
    if (isEmpty) return null;
    return entries.toList().reduce((v1, v2) => v1.value >= v2.value ? v1 : v2).key;
  }

}

///TODO add Achievement: once you get it you keep it
///1. Seafarers Beginner / moderate / expert / addict

class Prize {

  final PrizeType type;
  final dynamic value;

  Prize(this.type, this.value);
}

/// ranked from highest to lowest ranked achievement type
enum PrizeType {

  expansion_master, // Best win/lose rate for one expansion
  on_a_roll,          // Best win/lose rate for last five games
  catan_addict,       // Most games
  newbie,             // Played less than five game
  loser,              // Worst win/lose rate

}