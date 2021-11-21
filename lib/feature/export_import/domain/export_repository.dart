import 'dart:async';

import 'package:catan_master/core/failures.dart';
import 'package:dartz/dartz.dart';

abstract class ExportRepository {
  Future<Either<Failure, String>> exportData();
}
