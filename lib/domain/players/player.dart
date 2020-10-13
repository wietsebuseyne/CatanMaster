import 'dart:ui';

import 'package:catan_master/domain/games/game.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:catan_master/core/core.dart';

@immutable
class Player extends Equatable {

  final String name;
  final Color color;

  Player({@required this.name, @required this.color}) :
        assert(name != null),
        assert(name.isNotEmpty),
        assert(color != null),
        assert(color.alpha == 255)
  ;

  @override
  List<Object> get props => [name, color];
}

@immutable
class PlayerStatistics extends Equatable {

  final Player player;
  final List<Game> games;

  PlayerStatistics(this.player, this.games); //TODO asserts, unmod

  Game get lastGame => games.firstOrNull;

  List<bool> getWinOrLose() => games.map((g) => g.winner == player).toList();

  CatanExpansion get mostPlayedExpansion {
    return null;
  }

  CatanExpansion get mostSuccesfullExpansion {
    return null;
  }

  Player get mostLovedCoPlayer {
    return null;
  }

  int get rank {
    return null;
  }

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


@immutable
class PlayerWithGames extends Player {

  final List<Game> games;

  PlayerWithGames({@required String name, @required Color color, @required List<Game> games}) :
      this.games = List.unmodifiable(games),
      super(name: name, color: color);

}