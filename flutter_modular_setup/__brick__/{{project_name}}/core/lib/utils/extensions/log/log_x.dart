import 'dart:developer' as devtools show log;

extension Log on Object {
  /// ```dart
  /// "anything".log();
  ///
  /// ```
  void log() => devtools.log(toString());
}
