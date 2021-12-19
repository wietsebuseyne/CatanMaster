import 'package:catan_master/core/mapping.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

typedef OnMapFailure = void Function(MapFailure mapFailure);

//ignore_for_file: avoid_setters_without_getters
class MapperRegistry {
  final Map<_MapperRegistryItem, Mapper> _mappers = {};

  OnMapFailure? _onMapFailure;

  static MapperRegistry get instance => _instance;

  static final MapperRegistry _instance = MapperRegistry._();

  /// this clears the mappers, onMapFailure and MapFailureHandler
  @visibleForTesting
  void clear() {
    _mappers.clear();
    _onMapFailure = null;
  }

  MapperRegistry._();

  /// sets [_onMapFailure], returns true if this succeeds,
  /// returns false if this fails because [_mapFailureHandler] is already set.
  void setOnMapFailure(OnMapFailure value) {
    _onMapFailure = value;
  }

  void _handleFailure(MapFailure failure) {
    _onMapFailure?.call(failure);
  }

  //region registry

  void register(MapperRegistryEntry entry) {
    for (final mapper in entry.mappers) {
      _mappers[_MapperRegistryItem(mapper.from, mapper.to)] = mapper;
    }
    for (final e in entry.entries) {
      register(e);
    }
  }

  Mapper<FROM, TO> mapper<FROM extends Object, TO extends Object>() {
    final m = _mappers[_item<FROM, TO>()] as Mapper<FROM, TO>?;
    if (m == null) {
      //This is always an exception, also when mapping to Either
      throw MapperNotFoundException(from: FROM, to: TO);
    }
    return m;
  }

  Mapper<FROM, TO>? mapperOrNull<FROM extends Object, TO extends Object>() =>
      _mappers[_item<FROM, TO>()] as Mapper<FROM, TO>?;

  _MapperRegistryItem _item<FROM, TO>() => _MapperRegistryItem(FROM, TO);

  //endregion

  //region mapping

  Future<TO> mapOrThrow<FROM extends Object, TO extends Object>(FROM a) async {
    assert(TO != Object);
    assert(FROM != Object);
    return mapper<FROM, TO>().mapOrThrow(a, mappers: this);
  }

  Future<TO?> mapNullableOrThrow<FROM extends Object, TO extends Object>(FROM? a) async {
    return mapper<FROM, TO>().mapNullableOrThrow(a, mappers: this);
  }

  Future<Either<MapFailure, TO>> map<FROM extends Object, TO extends Object>(FROM a) async {
    return mapper<FROM, TO>().map(a, mappers: this);
  }

  Future<Either<MapFailure, TO?>> mapNullable<FROM extends Object, TO extends Object>(FROM? a) async {
    return mapper<FROM, TO>().mapNullable(a, mappers: this);
  }

  /// Maps an iterable to domain objects and returns a list of the [Domain] objects.
  /// If an error occurs during mapping, the execution is stopped and the first error is thrown.
  /// If [handleFailures] is true, the error is also sent to the [_onMapFailure] function or [_mapFailureHandler] (but will also be thrown)
  Future<List<TO>> mapIterableOrThrow<FROM extends Object, TO extends Object>(
    Iterable<FROM> iterable, {
    bool handleFailures = true,
  }) {
    final m = mapper<FROM, TO>();
    return Future.wait(iterable.map((a) {
      try {
        return m.mapOrThrow(a, mappers: this);
      } on Exception catch (e, s) {
        if (handleFailures) {
          final failure = e is MapException
              ? e.toFailure(object: a, stackTrace: s)
              : MapFailure(a, part: "?", message: e.toString(), stackTrace: s);

          _handleFailure(failure);
        }
        rethrow;
      }
    }));
  }

  /// Maps an iterable to domain objects and returns a list with either a [MapFailure] or a [Domain] object
  /// If [handleFailures] is true, the failures are sent to the [_onMapFailure] function or [_mapFailureHandler] (but are still present in the result as well)
  Future<Iterable<Either<MapFailure, TO>>> mapIterable<FROM extends Object, TO extends Object>(
    Iterable<FROM> iterable, {
    bool handleFailures = true,
  }) async {
    final m = mapper<FROM, TO>();
    final result = await Future.wait(iterable.map((a) => m.map(a, mappers: this)));

    if (handleFailures) {
      for (final either in result) {
        either.fold<void>(_handleFailure, (_) {});
      }
    }

    return result;
  }

  /// Maps to domain objects and discards the failure.
  /// If [handleFailures] is true, the failures are sent to the [_onMapFailure] function or [_mapFailureHandler]
  Future<List<TO>> mapIterableWithoutFailures<FROM extends Object, TO extends Object>(Iterable<FROM> iterable,
      {bool handleFailures = true}) async {
    final m = mapper<FROM, TO>();
    final result = await Future.wait(iterable.map((a) => m.map(a, mappers: this)));

    return result.fold<List<TO>>(
      <TO>[],
      (list, either) {
        either.fold<void>(
          handleFailures ? _handleFailure : (_) {},
          (b) => list.add(b),
        );
        return list;
      },
    );
  }

//endregion

}

mixin MapperRegistryEntry {
  Iterable<Mapper> get mappers;
  Iterable<MapperRegistryEntry> get entries;
}

@immutable
class _MapperRegistryItem extends Equatable {
  final Type from;
  final Type to;

  const _MapperRegistryItem(this.from, this.to);

  @override
  List<Object?> get props => [from, to];
}
