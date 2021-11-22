import 'dart:async';

import 'package:catan_master/core/failures.dart';
import 'package:catan_master/feature/export_import/domain/import_result.dart';
import 'package:dartz/dartz.dart';

abstract class ExportRepository {
  Future<Either<Failure, String>> exportData();

  Future<Either<Failure, ImportResult>> importData(String data);
}