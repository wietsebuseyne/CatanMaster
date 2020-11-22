
import 'dart:math';

import 'package:catan_master/presentation/core/widgets/hexagon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WinLoseHexagonPath extends StatelessWidget {

  final List<bool> wins;

  const WinLoseHexagonPath({
    Key key,
    @required this.wins,
  }) : assert(wins != null), super(key: key);

  @override
  Widget build(BuildContext context) {
    var half = (wins.length/2).floor();
    var top = <bool>[];
    var bottom = <bool>[];
    wins.asMap().forEach((i, value) {
      if (i % 2 == 1) {
        top.add(value);
      } else {
        bottom.add(value);
      }
    });
    return Container(
      height: 48,
      width: 32.0*(half+1) + 16.0*half,
      child: Stack(
          children: [
            Positioned(
              left: 24,
              child: Row(children: top.expand(_expandWin).toList()),
            ),
            Positioned(
              top: 14,
              child: Row(children: bottom.expand(_expandWin).toList()),
            ),
          ]
      ),
    );
  }

  Iterable<Widget> _expandWin(bool win) => [
    WinLoseHexagon(win),
    SizedBox(width: 16,),
  ];
}

class WinLoseHexagon extends StatelessWidget {

  final bool win;
  final double width;
  final double height;
  final double rotate;

  WinLoseHexagon(this.win, {this.rotate = 30, this.width = 32, this.height = 32});

  @override
  Widget build(BuildContext context) {
    return Hexagon(
        color: win ? Colors.green : Colors.red,
        shadows: [],
        child: Icon(win ? Icons.check : Icons.cancel_outlined, color: Colors.white, size: min(width, height) / 2 + 2,),
        rotate: rotate,
        width: width,
        height: height
    );
  }

}