import 'package:core/core.dart' show CacheManager;

abstract interface class TokenService {
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<void> setAccessToken(String? accessToken);
  Future<void> setRefreshToken(String? refreshToken);

  /// Clears all stored tokens (access and refresh).
  Future<void> clearTokens();
}

class TokenServiceImpl implements TokenService {
  static const _accessTokenKey = 'accessToken';
  static const _refreshTokenKey = 'refreshToken';

  final CacheManager _cacheManager;

  TokenServiceImpl(this._cacheManager);

  @override
  Future<void> clearTokens() async {
    await _cacheManager.delete(_accessTokenKey);
    await _cacheManager.delete(_refreshTokenKey);
  }

  @override
  Future<String?> getAccessToken() async {
    return await _cacheManager.read<String?>(_accessTokenKey);
  }

  @override
  Future<String?> getRefreshToken() async {
    return await _cacheManager.read<String?>(_refreshTokenKey);
  }

  @override
  Future<void> setAccessToken(String? accessToken) async {
    await _cacheManager.write(_accessTokenKey, accessToken);
  }

  @override
  Future<void> setRefreshToken(String? refreshToken) async {
    await _cacheManager.write(_refreshTokenKey, refreshToken);
  }
}
