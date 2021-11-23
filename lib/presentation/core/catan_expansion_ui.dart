import 'package:catan_master/domain/games/game.dart';
import 'package:catan_master/presentation/core/catan_icons.dart';
import 'package:catan_master/presentation/core/widgets/hexagon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
      case CatanExpansion.legendOfTheConquerers:
        return Colors.green;
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
      case CatanExpansion.legendOfTheConquerers:
        return CatanIcons.crossedSwords;
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
      case CatanExpansion.legendOfTheConquerers:
        return CatanIcons.crossedSwords;
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
      case CatanExpansion.legendOfTheConquerers:
        return "Legend of the conquerers";
    }
  }
}
