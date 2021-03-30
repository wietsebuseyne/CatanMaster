import 'dart:ui';

import 'package:catan_master/presentation/core/polygon/polygon_border.dart';
import 'package:flutter/material.dart';

/// TODO fix width / height / rotation to tightly match
class Hexagon extends StatelessWidget {

  final Color? color;
  final double width;
  final double height;
  final double rotate;
  final Widget? child;
  final List<BoxShadow> shadows;

  Hexagon({
    this.color,
    this.width = 32,
    this.height = 32,
    this.rotate = 0,
    this.shadows = const [],
    this.child
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: ShapeDecoration(
        shape: PolygonBorder(sides: 6, rotate: rotate),
        shadows: shadows,
        color: color ?? IconTheme.of(context).color,
      ),
      child: child,
    );
  }

}