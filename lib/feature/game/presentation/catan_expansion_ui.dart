import 'package:catan_master/core/catan_icons.dart';
import 'package:catan_master/core/widgets/hexagon.dart';
import 'package:catan_master/feature/game/domain/game.dart';
import 'package:flutter/material.dart';

extension CatanExpansionUi on CatanExpansion? {
  Widget get iconWidget {
    if (this == null) {
      return const Padding(
        padding: EdgeInsets.all(2.0),
        child: Hexagon(),
      );
    }
    return Icon(icon);
  }

  Color get color {
    switch (this) {
      case null:
        return Colors.red;
      case CatanExpansion.citiesAndKnights:
        return Colors.orange;
      case CatanExpansion.seafarers:
        return Colors.blue;
      case CatanExpansion.explorersAndPirates:
        return Colors.blue[900]!;
      case CatanExpansion.tradersAndBarbarians:
        return Colors.purple;
    }
  }

  IconData? get icon {
    switch (this) {
      case null:
        return null;
      case CatanExpansion.citiesAndKnights:
        return CatanIcons.shield;
      case CatanExpansion.seafarers:
        return CatanIcons.anchor;
      case CatanExpansion.explorersAndPirates:
        return CatanIcons.compassSolid;
      case CatanExpansion.tradersAndBarbarians:
        return CatanIcons.axeSolid;
    }
  }

  IconData? get iconOutline {
    switch (this) {
      case null:
        return null;
      case CatanExpansion.citiesAndKnights:
        return CatanIcons.shield;
      case CatanExpansion.seafarers:
        return CatanIcons.anchor;
      case CatanExpansion.explorersAndPirates:
        return CatanIcons.compass;
      case CatanExpansion.tradersAndBarbarians:
        return CatanIcons.axe;
    }
  }

  String? get name {
    if (this == null) return "Regular";
    switch (this) {
      case null:
        return null;
      case CatanExpansion.citiesAndKnights:
        return "Cities & Knights";
      case CatanExpansion.seafarers:
        return "Seafarers";
      case CatanExpansion.explorersAndPirates:
        return "Explorers & Pirates";
      case CatanExpansion.tradersAndBarbarians:
        return "Traders & Barbarians";
    }
  }
}

extension CatanScenarioUi on CatanScenario {
  Color get color {
    switch (this) {
      case CatanScenario.legendOfTheConquerers:
        return Colors.green;
      default:
        return this.expansions.first.color;
    }
  }

  IconData? get icon {
    switch (this) {
      case CatanScenario.legendOfTheConquerers:
        return CatanIcons.crossedSwords;
      default:
        return null;
    }
  }

  String get name {
    switch (this) {
      case CatanScenario.legendOfTheConquerers:
        return "Legend of the Conquerers";
      case CatanScenario.fishermenOfCatan:
        return "Fishermen of Catan";
      case CatanScenario.riversOfCatan:
        return "The Rivers of Catan";
      case CatanScenario.caravans:
        return "Caravans";
      case CatanScenario.barbarianAttack:
        return "Barbarian Attack";
      case CatanScenario.tradersAndBarbarians:
        return "Traders and Barbarians";
      case CatanScenario.treasuresDragonsAndAdventurers:
        return "Treasures, Dragons & Adventurers";
      case CatanScenario.legendOfTheSeaRobbers:
        return "Legend of the Sea Robbers";
    }
  }
}
