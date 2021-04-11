import 'dart:ui';

import 'package:catan_master/core/core.dart';
import 'package:catan_master/domain/games/game.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class Player extends Equatable {

  final String username;
  final String name;
  final Gender gender;
  final Color color;

  Player({
    required String username,
    required this.name,
    required this.gender,
    required Color color
  }) :
        assert(username.isNotEmpty),
        this.username = username.toLowerCase(),
        assert(name.isNotEmpty),
        assert(color.alpha == 255),
        this.color = Color(color.value);

  @override
  String toString() => name;

  @override
  List<Object> get props => [username, name, gender, color.value];
}

enum Gender { male, female, x }

@immutable
class PlayerStatistics extends Equatable {

  final Player player;
  final List<Game> games;
  final int nbGamesWon;
  final int percentGamesWon;
  final Player? bestBuddy;
  //TODO include 'Base' as an option here
  final CatanExpansion? mostPlayedExpansion;
  final CatanExpansion? mostWonExpansion;
  final int rank;
  final List<Prize> prizes;

  PlayerStatistics._({
    required this.player,
    required this.games,
    required this.nbGamesWon,
    required this.percentGamesWon,
    required this.bestBuddy,
    required this.mostPlayedExpansion,
    required this.mostWonExpansion,
    required this.rank,
    required this.prizes,
  });

  factory PlayerStatistics.fromGames(Player player, Games allGames) {
    var games = allGames.getGamesForPlayer(player);

    Map<Player, int> gamesPlayed = {};
    Map<Player, int> gamesWon = {};

    Map<CatanExpansion, int> expansionsPlayed = {};
    Map<CatanExpansion?, int> expansionsWon = {};

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
    int nbGamesWon = gamesWon[player] ?? 0;
    int nbGamesPlayed = gamesPlayed[player] ?? 0;
    int percentGamesWon = nbGamesPlayed == 0 ? 0 : ((nbGamesWon / nbGamesPlayed) * 100.0).round();
    //Cannot be own best buddy
    gamesPlayed.remove(player);
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
      nbGamesWon: nbGamesWon,
      percentGamesWon: percentGamesWon
    );
  }

  int getNbWinsOutOfLast(int nb) => games.take(nb).where((g) => g.winner == player).length;

  Game? get lastGame => games.firstOrNull;

  List<bool> getWinOrLose(int nb) => games.take(nb).toList().map((g) => g.winner == player).toList();

  @override
  List<Object> get props => [player, games];

}

extension HighestValue<K> on Map<K, int> {

  K? get highestValue {
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