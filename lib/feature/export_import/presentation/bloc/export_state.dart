part of 'export_bloc.dart';

abstract class ExportState extends Equatable {
  const ExportState();
}

class ExportLoading extends ExportState {
  const ExportLoading();

  @override
  List<Object> get props => [];
}

class ExportDataLoaded extends ExportState {
  final String data;

  const ExportDataLoaded({required this.data});

  @override
  List<Object> get props => [data];
}
