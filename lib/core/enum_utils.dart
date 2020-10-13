class EnumUtils {

  static bool _isEnumItem(enumItem) {
    final splittedEnum = enumItem.toString().split('.');
    return splittedEnum.length > 1 &&
        splittedEnum[0] == enumItem.runtimeType.toString();
  }

  /// Convert an enum to a string
  ///
  /// Pass in the enum value, so TestEnum.valueOne into [enumItem]
  /// It will return the striped off value so "valueOne".
  ///
  /// If you pass in the option [camelCase]=true it will convert it to words
  /// So TestEnum.valueOne will become Value One
  static String convertToString(enumItem) {
    if (enumItem == null) return null;

    if (!_isEnumItem(enumItem)) {
      throw NotAnEnumException(enumItem);
    }
    return enumItem.toString().split('.')[1];
  }

  /// Given a string, find and return its matching enum value
  ///
  /// You need to pass in the values of the enum object. So TestEnum.values
  /// in the first argument. The matching value is the second argument.
  ///
  /// Example final result = EnumToString.fromString(TestEnum.values, "valueOne")
  /// result == TestEnum.valueOne //true
  ///
  static T fromString<T>(List<T> enumValues, String value, {T orElse()}) {
    if (value == null || enumValues == null) return null;

    return enumValues.singleWhere(
            (enumItem) => EnumUtils.convertToString(enumItem)?.toLowerCase() == value?.toLowerCase(),
        orElse: orElse ?? () => null);
  }

}

class NotAnEnumException implements Exception {
  dynamic value;

  NotAnEnumException(this.value);

  @override
  String toString() =>
      '${value.toString()} of type ${value.runtimeType.toString()} is not an enum item.';
}