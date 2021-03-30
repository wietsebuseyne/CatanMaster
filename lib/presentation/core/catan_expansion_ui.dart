import 'package:catan_master/domain/games/game.dart';
import 'package:catan_master/presentation/core/catan_icons.dart';
import 'package:catan_master/presentation/core/widgets/hexagon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

extension CatanExpansionUi on CatanExpansion? {

  Widget get iconWidget {
    if (this == null) return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Hexagon(color: Colors.black,),
    );
    return Icon(icon);
  }

  Color get color {
    switch (this) {
      case null:
        return Colors.red;
      case CatanExpansion.cities_and_knights:
        return Colors.orange;
      case CatanExpansion.seafarers:
        return Colors.blue;
      case CatanExpansion.explorers_and_pirates:
        return Colors.blue[900]!;
      case CatanExpansion.traders_and_barbarians:
        return Colors.purple;
      case CatanExpansion.legend_of_the_conquerers:
        return Colors.green;
    }
  }

  IconData? get icon {
    switch (this) {
      case null:
        return null;
      case CatanExpansion.cities_and_knights:
        return CatanIcons.shield;
      case CatanExpansion.seafarers:
        return CatanIcons.anchor;
      case CatanExpansion.explorers_and_pirates:
        return CatanIcons.compass_solid;
      case CatanExpansion.traders_and_barbarians:
        return CatanIcons.axe_solid;
      case CatanExpansion.legend_of_the_conquerers:
        return CatanIcons.crossed_swords;
    }
  }

  IconData? get iconOutline {
    switch (this) {
      case null:
        return null;
      case CatanExpansion.cities_and_knights:
        return CatanIcons.shield;
      case CatanExpansion.seafarers:
        return CatanIcons.anchor;
      case CatanExpansion.explorers_and_pirates:
        return CatanIcons.compass;
      case CatanExpansion.traders_and_barbarians:
        return CatanIcons.axe;
      case CatanExpansion.legend_of_the_conquerers:
        return CatanIcons.crossed_swords;
    }
  }

  String? get name {
    if (this == null) return "Regular";
    switch(this) {
      case null:
        return null;
      case CatanExpansion.cities_and_knights:
        return "Cities & Knights";
      case CatanExpansion.seafarers:
        return "Seafarers";
      case CatanExpansion.explorers_and_pirates:
        return "Explorers & Pirates";
      case CatanExpansion.traders_and_barbarians:
        return "Traders & Barbarians";
      case CatanExpansion.legend_of_the_conquerers:
        return "Legend of the conquerers";
    }
  }

}