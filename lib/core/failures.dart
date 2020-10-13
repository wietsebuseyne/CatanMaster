import 'package:meta/meta.dart';

@immutable
class Failure {

  final String message;

  const Failure(this.message);

}

class MapFailure extends Failure {

  MapFailure(String message) : super(message);

}