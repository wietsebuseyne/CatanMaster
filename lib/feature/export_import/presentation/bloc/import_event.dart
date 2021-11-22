part of 'import_bloc.dart';

abstract class ImportEvent extends Equatable {
  const ImportEvent();
}

class StartImportEvent extends ImportEvent {
  final String data;

  const StartImportEvent(this.data);

  @override
  List<Object?> get props => [];
}
