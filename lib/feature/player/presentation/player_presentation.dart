import 'dart:ui';

import 'package:catan_master/core/color.dart';
import 'package:catan_master/feature/player/domain/player.dart';
import 'package:flutter/material.dart';

extension PlayerPresentation on Player {
  Color get foregroundColor {
    return color == Colors.white ? Colors.black : color;
  }

  Color get onColor => useWhiteForeground(color) ? Colors.white : Colors.black;
}
