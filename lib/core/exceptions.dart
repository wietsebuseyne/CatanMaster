import 'dart:core';

import 'package:catan_master/core/core.dart';
import 'package:catan_master/core/mapping.dart';

class CacheException implements Exception {
  String? message;

  CacheException([this.message]);

  @override
  String toString() => message ?? super.toString();
}

class AlreadyExistsException implements Exception {}

class NotFoundException implements Exception {}

///Thrown when something does not comply with the domain logic or constraints,
///e.g. constructing a domain obect with invalid data
class DomainValidationException extends MapException {
  const DomainValidationException(String part, String message) : super(part: part, message: message);

  @override
  String toString() => "DomainException: Could not map [$part]: $message";
}

mixin ToFailure {
  Failure toFailure({StackTrace? stackTrace});
}
