import 'package:catan_master/core/color.dart';
import 'package:catan_master/feature/player/domain/player.dart';
import 'package:flutter/material.dart';

extension PlayerPresentation on Player {
  Color foregroundColor(BuildContext context) {
    switch (Theme.of(context).brightness) {
      case Brightness.dark:
        return color == Colors.black ? Colors.white : color;
      case Brightness.light:
        return color == Colors.white ? Colors.black : color;
    }
  }

  Color get onColor => useWhiteForeground(color) ? Colors.white : Colors.black;
}
