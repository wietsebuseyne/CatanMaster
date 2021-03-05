import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CatanDecorator extends StatelessWidget {

  final Widget child;
  final String label;
  final String errorText;

  CatanDecorator({Key key, @required this.label, @required this.child, this.errorText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0))
        ),
        errorText: errorText,
      ),
      child: child);
  }
}
