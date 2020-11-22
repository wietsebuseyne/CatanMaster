import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmptyListMessage extends StatelessWidget {

  final Widget title;
  final Widget subtitle;

  EmptyListMessage({@required this.title, this.subtitle}) : assert(title != null);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DefaultTextStyle(style: Theme.of(context).textTheme.headline5, textAlign: TextAlign.center, child: title),
          if (subtitle != null) SizedBox(height: 8.0,),
          if (subtitle != null) DefaultTextStyle(
              style: Theme.of(context).textTheme.bodyText2,
              textAlign: TextAlign.center,
              child: subtitle
          ),
        ],
      ),
    );
  }

}