import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class ImportResult extends Equatable {
  final String logs;
  final int nbErrors;
  final int nbPlayersImported;
  final int nbGamesImported;

  const ImportResult({
    required this.logs,
    required this.nbErrors,
    required this.nbPlayersImported,
    required this.nbGamesImported,
  });

  @override
  List<Object> get props => [logs, nbErrors, nbGamesImported, nbPlayersImported];
}
