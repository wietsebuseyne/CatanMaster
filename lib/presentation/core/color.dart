import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

bool useWhiteForeground(Color color) {
  return ThemeData.estimateBrightnessForColor(color) == Brightness.dark;
  // Oldest:
  // return 1.05 / (color.computeLuminance() + 0.05) > 4.5;

  // Old:
  // int v = sqrt(pow(color.red, 2) * 0.299 +
  //     pow(color.green, 2) * 0.587 +
  //     pow(color.blue, 2) * 0.114)
  //     .round();
  // return v < 130 * bias ? true : false;
}