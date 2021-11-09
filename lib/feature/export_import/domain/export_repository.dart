import 'package:catan_master/core/failures.dart';
import 'package:dartz/dartz.dart';
import 'dart:async';

abstract class ExportRepository {

  Future<Either<Failure, String>> exportData();

}