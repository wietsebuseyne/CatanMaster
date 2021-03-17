
import 'dart:math';

import 'package:catan_master/presentation/core/widgets/hexagon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const hexSide = 16.0;
const hexWidth = hexSide*2;

class WinLoseHexagonPath extends StatefulWidget {

  final List<bool> top;
  final List<bool> bottom;
  final double width;

  const WinLoseHexagonPath._({
    @required this.top,
    @required this.bottom,
    @required this.width,
    Key key,
  })  : super(key: key);

  factory WinLoseHexagonPath({
    Key key,
    @required List<bool> wins,
    @required double width,
  }) {
    assert(wins != null);
    List<bool> top = <bool>[];
    List<bool> bottom = <bool>[];
    wins.asMap().forEach((i, value) {
      if (i % 2 == 1) {
        top.add(value);
      } else {
        bottom.add(value);
      }
    });
    return WinLoseHexagonPath._(key: key, top: top, bottom: bottom, width: width);
  }

  @override
  _WinLoseHexagonPathState createState() => _WinLoseHexagonPathState();

  int get nbHexagons => top.length + bottom.length;

}

class _WinLoseHexagonPathState extends State<WinLoseHexagonPath> with SingleTickerProviderStateMixin {

  AnimationController controller;
  List<Animation<double>> flyInAnimations = [];
  int total;
  int half;

  @override
  void initState() {
    super.initState();
    total = widget.top.length + widget.bottom.length;
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500 + total*75),
    );
    controller.addListener(() {
      setState(() {});
    });
    half = widget.top.length;

    var nb = this.total+3;

    double step = 1.0 / (nb+3);

    for (int i = 0; i < nb; i++) {
      flyInAnimations.add(
        Tween(begin: widget.width, end: 0.0).animate(CurvedAnimation(
          parent: controller,
          curve: Interval(step*i, step*(i+5), curve: Curves.easeInOutSine),
        )),
      );
    }
    controller.forward();
  }

  double _contentWidth(int nbHexagons) {
    if (nbHexagons % 2 == 0) {
      int half = (nbHexagons / 2).floor();
      return (3*half+1) * hexSide;
    }

    var halfCeil = (nbHexagons / 2).ceil();
    return (3*halfCeil-1) * hexSide;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var topNb = 1;
    var bottomNb = 0;
    return AnimatedBuilder(
      builder: (BuildContext context, Widget child) {
        var totalWidth = MediaQuery.of(context).size.width;
        var contentWidth = _contentWidth(widget.nbHexagons);
        var startInset = (totalWidth - contentWidth) / 2.0;
        return Container(
          height: 48,
          child: Stack(
              children: [
                Positioned(
                  left: 24+startInset,
                  child: Row(children: widget.top.expand((w) {
                    topNb+=2;
                    return _expandWin(w, topNb);
                  }).toList()),
                ),
                Positioned(
                  top: 14,
                  left: startInset,
                  child: Row(children: widget.bottom.expand((w) {
                    bottomNb += 2;
                    return _expandWin(w, bottomNb);
                  }).toList()),
                ),
              ]
          ),
        );
      },
      animation: controller,
    );
  }

  Iterable<Widget> _expandWin(bool win, int nb) => [
    Transform.translate(
        offset: Offset(flyInAnimations[nb].value, 0),
        child: WinLoseHexagon(win)
    ),
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