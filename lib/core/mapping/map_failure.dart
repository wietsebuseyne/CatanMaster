import 'package:catan_master/core/core.dart';

class MapFailure extends Failure {
  final Object object;

  /// The part of the object for which mapping failed.
  /// No validation is done on this string.
  final String part;

  const MapFailure(this.object, {required this.part, required String message, StackTrace? stackTrace})
      : super(message, stackTrace);

  @override
  String toString() => "Could not map [$part] of <$object>: $message";
}

class MapperNotFoundFailure extends Failure {
  final Type from;
  final Type to;

  const MapperNotFoundFailure({required this.from, required this.to, required String message, StackTrace? stackTrace})
      : super(message, stackTrace);
}
