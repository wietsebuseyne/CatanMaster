import 'dart:ui';

import 'package:catan_master/feature/export_import/data/export_repository.dart';
import 'package:catan_master/feature/export_import/domain/export_repository.dart';
import 'package:catan_master/feature/export_import/presentation/bloc/export_bloc.dart';
import 'package:catan_master/feature/game/data/game_datasource.dart';
import 'package:catan_master/feature/player/data/player_datasource.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus/share_plus.dart';

class ExportDataDialog extends StatelessWidget {
  const ExportDataDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExportDataProviders(
      child: Builder(builder: (context) {
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
                  padding: const EdgeInsets.all(24.0),
                  child: BlocBuilder<ExportBloc, ExportState>(
                    builder: (context, state) {
                      if (state is ExportLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is ExportError) {
                        return Text('Failure: ${state.failure.toString()}');
                      } else if (state is ExportDataLoaded) {
                        return Text(state.data);
                      }
                      throw StateError('unknown state $state');
                    },
                  ),
                ),
              ),
            ),
          ),
          actions: [
            BlocBuilder<ExportBloc, ExportState>(
              builder: (context, state) {
                return TextButton(
                  onPressed: state is! ExportDataLoaded ? null : () => Share.share(state.data),
                  child: const Text('Export'),
                );
              },
            ),
            TextButton(
              onPressed: () {
                context.read<ExportBloc>().add(const CopyToClipboardExportEvent());
                Fluttertoast.showToast(msg: 'Content copied to clipboard');
              },
              child: const Text('Copy to clipboard'),
            ),
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('OK')),
          ],
        );
      }),
    );
  }
}

class ExportDataProviders extends StatelessWidget {
  final Widget child;

  const ExportDataProviders({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<ExportRepository>(
      create: (context) => DefaultExportRepository(
        playerDatasource: context.read<PlayerDatasource>(),
        gameDatasource: context.read<GameDatasource>(),
      ),
      child: Builder(
        builder: (context) => BlocProvider<ExportBloc>(
          create: (BuildContext context) => ExportBloc(repository: context.read<ExportRepository>()),
          child: child,
        ),
      ),
    );
  }
}
