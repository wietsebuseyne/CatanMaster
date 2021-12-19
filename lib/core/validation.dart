import 'package:catan_master/core/core.dart';

T validateNotNull<T>(String part, T? value) {
  if (value == null) throw DomainValidationException(part, 'cannot be null');
  return value;
}

String validateNotEmpty(String part, String? value) {
  if (value == null) throw DomainValidationException(part, 'cannot be null');
  if (value.isEmpty) throw DomainValidationException(part, 'cannot be empty');
  return value;
}

T validateIterableNotEmpty<T extends Iterable<dynamic>>(String part, T? value) {
  if (value == null) throw DomainValidationException(part, 'cannot be null');
  if (value.isEmpty) throw DomainValidationException(part, 'cannot be empty');
  return value;
}

T validateLength<T extends Iterable<dynamic>>(String part, T? value, {int min = 0, int max = -1}) {
  if (value == null) throw DomainValidationException(part, 'cannot be null');
  if (max >= 0 && value.length > max) throw DomainValidationException(part, 'size should be <= $max');
  if (value.length < min) throw DomainValidationException(part, 'size should be >= $min');
  return value;
}
