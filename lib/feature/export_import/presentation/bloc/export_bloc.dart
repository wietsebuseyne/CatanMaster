import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';

part 'export_event.dart';

part 'export_state.dart';

class ExportBloc extends Bloc<void, ExportState> {
  ExportBloc() : super(const ExportLoading()) {
    on<ExternalExportEvent>((event, emit) {});

    on<CopyToClipboardExportEvent>((event, emit) {
      final s = state;
      if (s is ExportDataLoaded) {
        Clipboard.setData(ClipboardData(text: s.data));
      }
    });
  }
}
