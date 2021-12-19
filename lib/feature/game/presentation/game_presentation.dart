import 'package:catan_master/feature/game/domain/game.dart';
import 'package:catan_master/feature/game/presentation/catan_expansion_ui.dart';
import 'package:flutter/material.dart';

extension GamePresentation on Game {
  IconData? get icon {
    if (expansions.isEmpty) return null;
    if (expansions.length == 1) return expansions.first.icon;
  }
}
