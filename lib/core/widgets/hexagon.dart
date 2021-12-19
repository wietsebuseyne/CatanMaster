import 'package:catan_master/core/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polygon/flutter_polygon.dart';

const kLongToSmallRatio = 0.8660254;
const kSmallToLongRatio = 1 / 0.8660254;

/// TODO fix width / height / rotation to tightly match
class Hexagon extends StatelessWidget {
  final Color? color;
  final double width;
  final double height;
  final double rotate;
  final Widget? child;
  final List<BoxShadow> shadows;
  final BorderSide side;

  const Hexagon({
    this.color,
    this.width = 32 * kLongToSmallRatio,
    this.height = 32,
    this.rotate = 0,
    this.side = BorderSide.none,
    this.shadows = const [],
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: ShapeDecoration(
        shape: PolygonBorder(sides: 6, side: side, rotate: rotate),
        shadows: shadows,
        color: color ?? IconTheme.of(context).color,
      ),
      child: child,
    );
  }
}

class TextHexagon extends StatelessWidget {
  final Color color;
  final String text;

  const TextHexagon({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    var white = useWhiteForeground(color);
    return Hexagon(
      color: color,
      child: Center(
          child: Text(
        text,
        style: Theme.of(context).textTheme.subtitle1!.copyWith(
              color: white ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
      )),
    );
  }
}
