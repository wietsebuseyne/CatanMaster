import 'package:flutter/material.dart';
import 'package:flutter_polygon/flutter_polygon.dart';

class CatanFloatingActionButton extends StatelessWidget {
  const CatanFloatingActionButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "catan_fab",
      flightShuttleBuilder: (flightContext, animation, flightDirection, fromHeroContext, toHeroContext) {
        final Hero toHero = toHeroContext.widget as Hero;
        return RotationTransition(
          turns: Tween<double>(begin: 0.0, end: 1.0)
              .animate(CurvedAnimation(parent: animation, curve: Curves.easeInOutSine)),
          child: toHero.child,
        );
      },
      child: FloatingActionButton(
        heroTag: null,
        child: const Icon(Icons.add),
        shape: const PolygonBorder(
          sides: 6,
          borderRadius: 5.0, // Default 0.0 degrees
          rotate: 30,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
