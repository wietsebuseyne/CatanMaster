import 'package:meta/meta.dart';

@immutable
class Failure {
  final String message;

  const Failure(this.message);

  @override
  String toString() => message;
}

class MapFailure extends Failure {
  const MapFailure(String message) : super(message);
}

class DataValidationFailure extends Failure {
  final String? part;

  const DataValidationFailure({
    required String message,
    this.part,
  }) : super(message);
}
