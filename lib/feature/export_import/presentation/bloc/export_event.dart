part of 'export_bloc.dart';

abstract class ExportEvent extends Equatable {
  const ExportEvent();
}

class _Init extends ExportEvent {
  const _Init();

  @override
  List<Object?> get props => [];
}

class CopyToClipboardExportEvent extends ExportEvent {
  const CopyToClipboardExportEvent();

  @override
  List<Object?> get props => [];
}
