import 'dart:math';

import 'package:catan_master/core/color.dart';
import 'package:flutter_polygon/flutter_polygon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const List<Color> _defaultColors = [
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

class GridColorPicker extends StatelessWidget {
  final Color? selected;
  final ValueChanged<Color>? onSelected;
  final List<Color> availableColors;
  final double maxCircleRadius;
  final double spacing;

  const GridColorPicker(
      {this.selected,
      this.onSelected,
      this.availableColors = _defaultColors,
      this.maxCircleRadius = 50.0,
      this.spacing = 8.0});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final int itemsPerRow = (constraints.maxWidth / (maxCircleRadius + spacing * 2)).ceil();
      return Column(
        children: _colorRows(itemsPerRow, (constraints.maxWidth / itemsPerRow).floorToDouble() - 2 * spacing).toList(),
      );
    });
  }

  Iterable<Widget> _colorRows(int itemsPerRow, double radius) sync* {
    for (int i = 0; i < availableColors.length; i += itemsPerRow) {
      yield Row(
        children: availableColors.getRange(i, min(i + itemsPerRow, availableColors.length)).map((c) {
          return _ColorPickerItem(
            color: c,
            selected: selected?.value == c.value,
            onSelected: () => onSelected!(c),
            radius: radius,
            spacing: spacing,
          );
        }).toList(),
      );
    }
  }
}

class _ColorPickerItem extends StatelessWidget {
  final Color color;
  final bool selected;
  final double radius;
  final double spacing;
  final Function onSelected;

  const _ColorPickerItem({
    required this.color,
    required this.selected,
    required this.onSelected,
    this.radius = 100.0,
    this.spacing = 5.0,
  });

  @override
  Widget build(BuildContext context) {
    Color shadowColor = color.withOpacity(0.8);

    final bool isLight = Theme.of(context).brightness == Brightness.light;
    if (isLight && color == Colors.white) {
      shadowColor = Colors.black.withOpacity(0.4);
    } else if (!isLight && color == Colors.black) {
      shadowColor = Colors.white.withOpacity(0.4);
    }

    return Container(
      margin: EdgeInsets.all(spacing),
      width: radius,
      height: radius,
      decoration: ShapeDecoration(
        shape: const PolygonBorder(
          sides: 6,
          rotate: 30,
        ),
        color: color,
        shadows: [
          BoxShadow(
            color: shadowColor,
            offset: const Offset(1.0, 2.0),
            blurRadius: 3.0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onSelected as void Function()?,
          customBorder: const PolygonBorder(sides: 6, rotate: 30),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 210),
            opacity: selected ? 1.0 : 0.0,
            child: Icon(
              Icons.done,
              color: useWhiteForeground(color) ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
