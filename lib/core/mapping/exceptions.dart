import 'package:catan_master/core/core.dart';
import 'package:catan_master/core/mapping.dart';

/// Indicates an exception while mapping an object to another object, typically to the domain layer.
/// Can also be when data validation fails when mapping from one layer to another
class MapException implements Exception {
  final String part;
  final String message;

  const MapException({required this.part, required this.message});

  MapFailure toFailure({required Object object, StackTrace? stackTrace}) {
    return MapFailure(object, part: part, message: message, stackTrace: stackTrace);
  }

  @override
  String toString() => "Could not map [$part]: $message";
}

class MapperNotFoundException with ToFailure implements Exception {
  final Type from;
  final Type to;

  const MapperNotFoundException({
    required this.from,
    required this.to,
  });

  @override
  Failure toFailure({StackTrace? stackTrace}) {
    return MapperNotFoundFailure(
      message: this.toString(),
      from: from,
      to: to,
      stackTrace: stackTrace,
    );
  }

  @override
  String toString() => 'MapperNotFoundException: no Mapper<$from, $to> found';
}
