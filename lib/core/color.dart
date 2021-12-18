import 'package:flutter/material.dart';

bool useWhiteForeground(Color color) {
  if (colorToMaterialColor(color) != null) {
    return !isLight(color);
  }
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

MaterialColor? colorToMaterialColor(Color c) {
  if (c is MaterialColor) c = c.shade500;
  return CatanColors.colorToMaterial[c];
}

bool isLight(Color c) {
  if (c is MaterialColor) c = c.shade500;
  return CatanColors.lightColors.contains(c);
}

class CatanColors {
  static final allColors = <Color>[
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
    Colors.black,
    Colors.white,
  ];

  static final colorToMaterial = <Color, MaterialColor>{
    Colors.red: Colors.red,
    Colors.pink: Colors.pink,
    Colors.purple: Colors.purple,
    Colors.deepPurple: Colors.deepPurple,
    Colors.indigo: Colors.indigo,
    Colors.blue: Colors.blue,
    Colors.lightBlue: Colors.lightBlue,
    Colors.cyan: Colors.cyan,
    Colors.teal: Colors.teal,
    Colors.green: Colors.green,
    Colors.lightGreen: Colors.lightGreen,
    Colors.lime: Colors.lime,
    Colors.yellow: Colors.yellow,
    Colors.amber: Colors.amber,
    Colors.orange: Colors.orange,
    Colors.deepOrange: Colors.deepOrange,
    Colors.brown: Colors.brown,
    Colors.grey: Colors.grey,
    Colors.blueGrey: Colors.blueGrey,
    Colors.red.shade500: Colors.red,
    Colors.pink.shade500: Colors.pink,
    Colors.purple.shade500: Colors.purple,
    Colors.deepPurple.shade500: Colors.deepPurple,
    Colors.indigo.shade500: Colors.indigo,
    Colors.blue.shade500: Colors.blue,
    Colors.lightBlue.shade500: Colors.lightBlue,
    Colors.cyan.shade500: Colors.cyan,
    Colors.teal.shade500: Colors.teal,
    Colors.green.shade500: Colors.green,
    Colors.lightGreen.shade500: Colors.lightGreen,
    Colors.lime.shade500: Colors.lime,
    Colors.yellow.shade500: Colors.yellow,
    Colors.amber.shade500: Colors.amber,
    Colors.orange.shade500: Colors.orange,
    Colors.deepOrange.shade500: Colors.deepOrange,
    Colors.brown.shade500: Colors.brown,
    Colors.grey.shade500: Colors.grey,
    Colors.blueGrey.shade500: Colors.blueGrey,
  };

  static final lightColors = <Color>{
    Colors.white,
    Colors.yellow.shade500,
    Colors.lime.shade500,
  };
}
