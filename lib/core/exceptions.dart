import 'dart:core';

class CacheException implements Exception {

  String message;

  CacheException([this.message]);

  @override
  String toString() => message ?? super.toString();

}

class AlreadyExistsException implements Exception {

}

class NotFoundException implements Exception {}

///Thrown when something does not comply with the domain logic or constraints,
///e.g. constructing a domain obect with invalid data
class DomainException implements Exception {

  final String part;
  final String message;

  const DomainException([this.message, this.part]);

  @override
  String toString() => "${part == null ? "" : "$part: "}$message";
}