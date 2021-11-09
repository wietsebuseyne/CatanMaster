import 'dart:ui';

import 'package:catan_master/feature/export_import/presentation/bloc/export_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExportDataDialog extends StatelessWidget {
  const ExportDataDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Export data'),
      contentPadding: const EdgeInsets.only(top: 16.0),
      contentTextStyle: Theme.of(context).textTheme.bodyText2?.copyWith(
        fontFeatures: const [FontFeature.tabularFigures()],
        fontSize: 12.0,
        letterSpacing: 2,
      ),
      content: Material(
        color: Theme.of(context).dividerColor.withOpacity(0.05),
        child: Scrollbar(
          isAlwaysShown: true,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0.0),
              child: Text('TODO'),
            ),
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () {}, child: Text('Export')),
        TextButton(onPressed: () {}, child: Text('Copy to clipboard')),
        TextButton(onPressed: () {}, child: Text('OK')),
      ],
    );
  }
}

class ExportDataProviders extends StatelessWidget {
  const ExportDataProviders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ExportBloc>(
      create: (BuildContext context) => ExportBloc(),
    );
  }
}
