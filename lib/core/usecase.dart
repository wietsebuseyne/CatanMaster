import 'package:catan_master/core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

@immutable
class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
