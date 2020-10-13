import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:polygon_clipper/polygon_border.dart';

class Hexagon extends StatelessWidget {

  final Color color;
  final double size;
  final Widget child;

  Hexagon({this.color, this.size = 32, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: ShapeDecoration(
        shape: PolygonBorder(sides: 6,),
        color: color,
      ),
      child: child,
    );
  }

}