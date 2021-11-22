import 'package:bloc/bloc.dart';
import 'package:catan_master/core/core.dart';
import 'package:catan_master/feature/export_import/domain/export_repository.dart';
import 'package:catan_master/feature/export_import/domain/import_result.dart';
import 'package:equatable/equatable.dart';

part 'import_event.dart';
part 'import_state.dart';

class ImportBloc extends Bloc<ImportEvent, ImportState> {
  final ExportRepository repository;

  ImportBloc({required this.repository}) : super(const ImportInitial()) {
    on<StartImportEvent>((event, emit) async {
      if (state is ImportInitial) {
        (await repository.importData(event.data)).fold(
          (l) => emit(ImportError(failure: l)),
          (r) => emit(ImportFinished(result: r)),
        );
      }
    });
  }
}
