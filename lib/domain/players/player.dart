import 'dart:ui';

import 'package:catan_master/core/core.dart';
import 'package:catan_master/domain/games/game.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class Player extends Equatable {

  final String username;
  final String name;
  final Color color;

  Player({@required this.username, @required this.name, @required this.color}) :
        assert(username != null && username.isNotEmpty),
        assert(name != null),
        assert(name.isNotEmpty),
        assert(color != null),
        assert(color.alpha == 255)
  ;

  @override
  List<Object> get props => [username, name, color];
}

@immutable
class PlayerStatistics extends Equatable {

  final Player player;
  final List<Game> games;
  final Player mostLovedCoPlayer;
  final CatanExpansion mostPlayedExpansion;
  final CatanExpansion mostSuccessfulExpansion;
  final int rank;

  PlayerStatistics._({
    @required this.player,
    @required this.games,
    @required this.mostLovedCoPlayer,
    @required this.mostPlayedExpansion,
    @required this.mostSuccessfulExpansion,
    @required this.rank,
  });

  factory PlayerStatistics.fromGames(Player player, List<Game> games) {
    return PlayerStatistics._(
        player: player,
        games: games.where((g) => g.players.contains(player)).toList(),
        mostLovedCoPlayer: null,
        mostPlayedExpansion: null,
        mostSuccessfulExpansion: null,
        rank: null
    );
  }

  Game get lastGame => games.firstOrNull;

  List<bool> get winOrLose => games.map((g) => g.winner == player).toList();

  @override
  List<Object> get props => [player, games];

}

/*
class Achievement {

  final AchievementType type;
  final int rank;
  final CatanExpansion expansion;

}*/

/// ranked from highest to lowest ranked achievement type
enum AchievementType {

  catan_master,       // Best win/lose rates
  expansion_champion, // Best win/lose rate for one expansion
  on_a_roll,          // Best win/lose rate for last five games
  catan_addict,       // Most games
  newbie,             // Played less than five game - one cannot qualify for achievements
  loser,              // Worst win/lose rate

}