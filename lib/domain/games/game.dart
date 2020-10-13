import 'package:catan_master/domain/players/player.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meta/meta.dart';

class Game extends Equatable {

  final DateTime date;
  final List<Player> players;
  final Player winner;
  final List<CatanExpansion> expansions;

  Game({@required this.date, @required this.players, @required this.winner, this.expansions = const []});

  @override
  List<Object> get props => [date, players, winner, expansions];

}

enum CatanExpansion {

  cities_and_knights, seafarers, explorers_and_pirates, traders_and_barbarians, legend_of_the_conquerers

}