import 'package:catan_master/core/widgets/catan_input_decorator.dart';
import 'package:catan_master/feature/export_import/data/export_repository.dart';
import 'package:catan_master/feature/export_import/domain/export_repository.dart';
import 'package:catan_master/feature/export_import/presentation/bloc/import_bloc.dart';
import 'package:catan_master/feature/game/data/game_datasource.dart';
import 'package:catan_master/feature/player/data/player_datasource.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ImportDataDialog extends StatefulWidget {
  const ImportDataDialog({Key? key}) : super(key: key);

  @override
  State<ImportDataDialog> createState() => _ImportDataDialogState();
}

class _ImportDataDialogState extends State<ImportDataDialog> {
  late TextEditingController inputController;

  @override
  void initState() {
    super.initState();
    inputController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    inputController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ImportProviders(
      child: BlocConsumer<ImportBloc, ImportState>(
        listener: (context, state) {
          if (state is ImportError) {
            Fluttertoast.showToast(msg: 'Error: ${state.failure}');
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          if (state is ImportFinished) {
            return AlertDialog(
              title: const Text('Import finished'),
              contentPadding: const EdgeInsets.only(top: 20.0),
              content: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (state.result.nbErrors > 0)
                        Text(
                          '${state.result.nbErrors} errors encountered while importing',
                          style: TextStyle(color: Theme.of(context).colorScheme.error),
                        ),
                      Text('${state.result.nbPlayersImported} players successfully imported'),
                      Text('${state.result.nbGamesImported} games successfully imported'),
                      const SizedBox(height: 8.0),
                      const Text('Logs', style: TextStyle(fontWeight: FontWeight.bold)),
                      RichText(
                        text: TextSpan(
                          children: state.result.logs.split('\n').map((log) {
                            Color color = Theme.of(context).textTheme.bodyText1?.color ?? Colors.black;
                            if (log.isNotEmpty) {
                              switch (log.substring(0, 2)) {
                                case 'W/':
                                  color = Colors.orange;
                                  break;
                                case 'E/':
                                  color = Theme.of(context).colorScheme.error;
                                  break;
                              }
                            }
                            return TextSpan(
                              text: '$log\n',
                              style: TextStyle(color: color, fontSize: 14.0, letterSpacing: 0.5),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            );
          }

          return AlertDialog(
            title: const Text('Import data'),
            contentPadding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
            content: TextField(
              decoration: catanInputDecoration(label: 'Import data', contentPadding: const EdgeInsets.all(16.0)),
              minLines: 5,
              maxLines: 5,
              controller: inputController,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  final data = await Clipboard.getData('text/plain');
                  if (data == null) {
                    Fluttertoast.showToast(msg: 'Error retrieving text from clipboard');
                  } else {
                    inputController.text = data.text ?? '';
                  }
                },
                child: const Text('Copy from clipboard'),
              ),
              TextButton(
                onPressed: () => context.read<ImportBloc>().add(StartImportEvent(inputController.text)),
                child: const Text('Import'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class ImportProviders extends StatelessWidget {
  final Widget child;

  const ImportProviders({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<ExportRepository>(
      create: (context) => DefaultExportRepository(
        playerDatasource: context.read<PlayerDatasource>(),
        gameDatasource: context.read<GameDatasource>(),
      ),
      child: Builder(
        builder: (context) => BlocProvider<ImportBloc>(
          create: (BuildContext context) => ImportBloc(repository: context.read<ExportRepository>()),
          child: child,
        ),
      ),
    );
  }
}
