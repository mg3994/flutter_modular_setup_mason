extension ToNullableInt on bool? {
  int? get toInt => this == null ? null : (this! ? 1 : 0);
}

extension ToInt on bool {
  int get toInt => this ? 1 : 0;
}
