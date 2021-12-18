import 'package:flutter/material.dart';

class EmptyListMessage extends StatelessWidget {
  final Widget title;
  final Widget? subtitle;
  final Widget? action;

  const EmptyListMessage({required this.title, this.subtitle, this.action});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DefaultTextStyle(
            style: Theme.of(context).textTheme.headline5!,
            textAlign: TextAlign.center,
            child: title,
          ),
          if (subtitle != null)
            const SizedBox(
              height: 8.0,
            ),
          if (subtitle != null)
            DefaultTextStyle(
              style: Theme.of(context).textTheme.bodyText2!,
              textAlign: TextAlign.center,
              child: subtitle!,
            ),
          if (action != null)
            const SizedBox(
              height: 8.0,
            ),
          if (action != null) action!,
        ],
      ),
    );
  }
}
