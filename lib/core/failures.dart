import 'package:meta/meta.dart';

@immutable
class Failure {
  final String message;
  final StackTrace? stackTrace;

  const Failure(this.message, [this.stackTrace]);

  @override
  String toString() => message;
}

class DataValidationFailure extends Failure {
  final String? part;

  const DataValidationFailure({
    required String message,
    StackTrace? stackTrace,
    this.part,
  }) : super(message, stackTrace);
}
