import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HorizontalInfoTile extends StatelessWidget {

  final Widget start;
  final Widget end;
  final Widget leading;
  final Widget trailing;

  final EdgeInsets padding;
  final double internalSpace;

  final Function onTap;
  final Function onLongPress;
  final Function onDoubleTap;
  final Function onTapDown;
  final Function onTapCancel;

  HorizontalInfoTile({
    this.start,
    this.end,
    this.leading,
    this.trailing,
    this.padding = const EdgeInsets.all(6.0),
    this.internalSpace = 12.0,
    this.onTap,
    this.onLongPress,
    this.onDoubleTap,
    this.onTapDown,
    this.onTapCancel});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      onDoubleTap: onDoubleTap,
      onTapDown: onTapDown,
      onTapCancel: onTapCancel,
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 0),
          child: Row(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Padding(
                      child: SizedBox(width: 24, height: 24, child: leading),
                      padding: EdgeInsets.only(left: padding.horizontal, right: internalSpace)
                  ),
                ],
              ),
              Expanded(child: Padding(
                  padding: const EdgeInsets.only(right: 18),
                  child: Row(
                    children: <Widget>[
                      if (start != null) _start(Theme.of(context)),
                      if (end != null) _end(context)
                    ],
                  )),),
              if (trailing != null) trailing
            ],
          )),
    );
  }

  Widget _start(ThemeData theme) {
    return Expanded(
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: padding.vertical),
            child: DefaultTextStyle(
              style: theme.textTheme.subtitle2,
              child: start,
            )
        )
    );
  }

  Widget _end(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.25,
        child: DefaultTextStyle(
          style: Theme.of(context).textTheme.bodyText2.apply(fontSizeDelta: -1),
          textAlign: TextAlign.end,
          child: end,
        )
    );
  }

}