part of 'import_bloc.dart';

abstract class ImportState extends Equatable {
  const ImportState();
}

class ImportInitial extends ImportState {
  const ImportInitial();

  @override
  List<Object> get props => [];
}

class ImportFinished extends ImportState {
  final ImportResult result;

  const ImportFinished({required this.result});

  @override
  List<Object> get props => [result];
}

class ImportError extends ImportState {
  final Failure failure;

  const ImportError({required this.failure});

  @override
  List<Object> get props => [failure];
}
