extension EnumByNameOr<T extends Enum> on Iterable<T> {
  T byNameOr(String? name, {required T Function() orElse}) {
    try {
      return name == null ? orElse() : byName(name);
    } on ArgumentError {
      return orElse();
    }
  }
}
