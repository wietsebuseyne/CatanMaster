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