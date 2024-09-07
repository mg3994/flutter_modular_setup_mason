import 'package:packages/packages.dart' show Equatable;

@Equatable(stringify: true) // stringify for above use case
final class ServerException implements Exception {}

@Equatable(stringify: true) // stringify for above use case
final class CacheException implements Exception {}

@Equatable(stringify: true) // stringify for above use case
final class AuthException implements Exception {}

@Equatable(stringify: true) // stringify for above use case
final class EmptyException implements Exception {}

@Equatable(stringify: true) // stringify for above use case
final class DuplicateEmailException implements Exception {}
