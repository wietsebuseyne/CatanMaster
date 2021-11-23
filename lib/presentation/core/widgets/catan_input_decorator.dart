import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CatanInputDecorator extends StatelessWidget {
  final Widget child;
  final String? label;
  final String? errorText;

  const CatanInputDecorator({Key? key, this.label, required this.child, this.errorText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: catanInputDecoration(label: label, errorText: errorText),
      child: child,
    );
  }
}

InputDecoration catanInputDecoration({String? label, String? errorText, EdgeInsets? contentPadding}) {
  return InputDecoration(
    labelText: label,
    contentPadding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 16.0),
    border: const OctaOutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
    errorText: errorText,
  );
}

class OctaOutlineInputBorder extends InputBorder {
  const OctaOutlineInputBorder({
    BorderSide borderSide = const BorderSide(),
    this.borderRadius = const BorderRadius.all(Radius.circular(4.0)),
    this.gapPadding = 4.0,
  })  : assert(gapPadding >= 0.0),
        super(borderSide: borderSide);

  /// Horizontal padding on either side of the border's
  /// [InputDecoration.labelText] width gap.
  ///
  /// This value is used by the [paint] method to compute the actual gap width.
  final double gapPadding;

  /// The radii of the border's rectangle straight corners.
  final BorderRadius borderRadius;

  @override
  bool get isOutline => true;

  @override
  OctaOutlineInputBorder copyWith({
    BorderSide? borderSide,
    BorderRadius? borderRadius,
    double? gapPadding,
  }) {
    return OctaOutlineInputBorder(
      borderSide: borderSide ?? this.borderSide,
      borderRadius: borderRadius ?? this.borderRadius,
      gapPadding: gapPadding ?? this.gapPadding,
    );
  }

  @override
  EdgeInsetsGeometry get dimensions {
    return EdgeInsets.all(borderSide.width);
  }

  @override
  OctaOutlineInputBorder scale(double t) {
    return OctaOutlineInputBorder(
      borderSide: borderSide.scale(t),
      borderRadius: borderRadius * t,
      gapPadding: gapPadding * t,
    );
  }

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is OctaOutlineInputBorder) {
      final OctaOutlineInputBorder outline = a;
      return OctaOutlineInputBorder(
        borderRadius: BorderRadius.lerp(outline.borderRadius, borderRadius, t)!,
        borderSide: BorderSide.lerp(outline.borderSide, borderSide, t),
        gapPadding: outline.gapPadding,
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is OctaOutlineInputBorder) {
      final OctaOutlineInputBorder outline = b;
      return OctaOutlineInputBorder(
        borderRadius: BorderRadius.lerp(borderRadius, outline.borderRadius, t)!,
        borderSide: BorderSide.lerp(borderSide, outline.borderSide, t),
        gapPadding: outline.gapPadding,
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRRect(borderRadius.resolve(textDirection).toRRect(rect).deflate(borderSide.width));
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRRect(borderRadius.resolve(textDirection).toRRect(rect));
  }

  Path _gapBorderPath(Canvas canvas, RRect center, double start, double extent) {
    // When the corner radii on any side add up to be greater than the
    // given height, each radius has to be scaled to not exceed the
    // size of the width/height of the RRect.
    final RRect scaledRRect = center.scaleRadii();

    return Path()
      ..moveTo(scaledRRect.left, scaledRRect.top + borderRadius.topLeft.y)
      ..lineTo(scaledRRect.left + borderRadius.topLeft.x, scaledRRect.top)
      ..lineTo(start, scaledRRect.top)
      ..moveTo(start + extent, scaledRRect.top)
      ..lineTo(scaledRRect.right - borderRadius.topRight.x, scaledRRect.top)
      ..lineTo(scaledRRect.right, scaledRRect.top + borderRadius.topLeft.y)
      ..lineTo(scaledRRect.right, scaledRRect.bottom - borderRadius.bottomRight.y)
      ..lineTo(scaledRRect.right - borderRadius.bottomRight.x, scaledRRect.bottom)
      ..lineTo(scaledRRect.left + borderRadius.bottomLeft.x, scaledRRect.bottom)
      ..lineTo(scaledRRect.left, scaledRRect.bottom - borderRadius.bottomLeft.y)
      ..lineTo(scaledRRect.left, scaledRRect.top + borderRadius.topLeft.y);
  }

  /// Draw a rounded rectangle around [rect] using [borderRadius].
  ///
  /// The [borderSide] defines the line's color and weight.
  ///
  /// The top side of the rounded rectangle may be interrupted by a single gap
  /// if [gapExtent] is non-null. In that case the gap begins at
  /// `gapStart - gapPadding` (assuming that the [textDirection] is [TextDirection.ltr]).
  /// The gap's width is `(gapPadding + gapExtent + gapPadding) * gapPercentage`.
  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    double? gapStart,
    double gapExtent = 0.0,
    double gapPercentage = 0.0,
    TextDirection? textDirection,
  }) {
    assert(gapPercentage >= 0.0 && gapPercentage <= 1.0);

    final Paint paint = borderSide.toPaint();
    final RRect outer = borderRadius.toRRect(rect);
    final RRect center = outer.deflate(borderSide.width / 2.0);

    double extent = 0;
    double start;
    if (gapStart == null) {
      start = borderRadius.topLeft.x;
    } else {
      extent = lerpDouble(0.0, gapExtent + gapPadding * 2.0, gapPercentage)!;
      switch (textDirection!) {
        case TextDirection.rtl:
          start = math.max(0.0, gapStart - gapPadding);
          break;
        case TextDirection.ltr:
          start = math.max(0.0, gapStart - gapPadding);
          break;
      }
    }
    final Path path = _gapBorderPath(canvas, center, start, extent);
    canvas.drawPath(path, paint);
  }
}