import 'dart:ui';

import 'package:catan_master/domain/players/player.dart';
import 'package:flutter/material.dart';

extension ForegroundPlayerColor on Player {

  Color get foregroundColor {
    return color == Colors.white ? Colors.black : color;
  }

  Color get onColor => color == Colors.white ? Colors.black : Colors.white;

}