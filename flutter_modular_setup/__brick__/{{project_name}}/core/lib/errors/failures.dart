// import 'package:equatable/equatable.dart';

// sealed class Failure extends Equatable {
//   @override
//   List<Object> get props => [];
// }

// class ServerFailure extends Failure {}

// class CacheFailure extends Failure {}

// class EmptyFailure extends Failure {}

// class CredentialFailure extends Failure {}

// class DuplicateEmailFailure extends Failure {}

// class PasswordNotMatchFailure extends Failure {}

// class InvalidEmailFailure extends Failure {}

// class InvalidPasswordFailure extends Failure {}

// import 'package:equatable/equatable.dart';

// abstract class Failure extends Equatable {
//   Failure([List properties = const <dynamic>[]]) : super(properties);
// }

// class ServerFailure extends Failure {}

// class CacheFailure extends Failure {}

// class NoConnectionFailure extends Failure {}

// abstract class Failure {
//   const Failure() : super();
// }

// class ServerFailure extends Failure {}

// class CacheFailure extends Failure {}

// class NoConnectionFailure extends Failure {}

import 'package:packages/packages.dart' show Equatable;

@pragma('antinna:keep-to-string-in-subtypes by remind')
// TODO: // stringify for above use case //comment this here but apply this in all subtypes
abstract interface class Failure {
  factory Failure([var message]) => PFailure(message);
  String? get message;
}

/// Default implementation of [Failure] which carries a message.
@Equatable(stringify: true) // stringify for above use case
final class PFailure implements Failure {
  final dynamic _message;

  const PFailure([this._message]);
  @override
  String? get message => _message.toString();
}

@Equatable(stringify: true) // stringify for above use case
final class ServerFailure implements Failure {
  /// A message describing the format error.
  final String _message;
  const ServerFailure([this._message = ""]);
  @override
  String? get message => _message;
}

@Equatable(stringify: true) // stringify for above use case
final class CacheFailure implements Failure {
  /// A message describing the format error.
  final String _message;
  const CacheFailure([this._message = ""]);
  @override
  String? get message => _message;
}

@Equatable(stringify: true) // stringify for above use case
final class NetworkFailure implements Failure {
  /// A message describing the format error.
  final String _message;
  const NetworkFailure([this._message = ""]);
  @override
  String? get message => _message;
}
