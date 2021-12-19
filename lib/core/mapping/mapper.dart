import 'package:catan_master/core/mapping.dart';
import 'package:dartz/dartz.dart';

mixin Mapper<A extends Object, B extends Object> {
  Future<B> mapOrThrow(A a, {required MapperRegistry mappers});

  Future<B?> mapNullableOrThrow(A? a, {required MapperRegistry mappers}) async {
    if (a == null) {
      return null;
    }
    return mapOrThrow(a, mappers: mappers);
  }

  Future<Either<MapFailure, B>> map(A a, {required MapperRegistry mappers}) async {
    try {
      final B result = await mapOrThrow(a, mappers: mappers);
      return Right(result);
    } on MapException catch (e, s) {
      return Left(e.toFailure(object: a, stackTrace: s));
    } on Exception catch (e, s) {
      return Left(MapFailure(a, part: '?', message: e.toString(), stackTrace: s));
    }
  }

  Future<Either<MapFailure, B?>> mapNullable(A? a, {required MapperRegistry mappers}) async {
    if (a == null) {
      return Right<MapFailure, B?>(null);
    }
    return map(a, mappers: mappers);
  }

  Type get from => A;
  Type get to => B;
}
