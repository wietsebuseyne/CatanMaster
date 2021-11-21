import 'package:bloc/bloc.dart';
import 'package:catan_master/core/core.dart';
import 'package:catan_master/feature/export_import/domain/export_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';

part 'export_event.dart';
part 'export_state.dart';

class ExportBloc extends Bloc<ExportEvent, ExportState> {
  final ExportRepository repository;

  ExportBloc({required this.repository}) : super(const ExportLoading()) {
    on<_Init>((event, emit) async {
      (await repository.exportData()).fold(
        (failure) => emit(ExportError(failure: failure)),
        (r) => emit(ExportDataLoaded(data: r)),
      );
    });

    on<CopyToClipboardExportEvent>((event, emit) {
      final s = state;
      if (s is ExportDataLoaded) {
        Clipboard.setData(ClipboardData(text: s.data));
      }
    });

    add(const _Init());
  }
}
