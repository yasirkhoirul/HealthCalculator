import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthLocalSource {
  final FlutterSecureStorage _storage;

  AuthLocalSource({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  static const String _keyToken = 'auth_token';
  static const String _keyUsername = 'auth_username';

  /// Menyimpan token autentikasi ke secure storage.
  Future<bool> saveToken(String token) async {
    try {
      await _storage.write(key: _keyToken, value: token);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Mengambil token autentikasi yang tersimpan.
  Future<String?> getToken() async {
    try {
      return await _storage.read(key: _keyToken);
    } catch (e) {
      return null;
    }
  }

  /// Menghapus token autentikasi dan data login dari secure storage.
  Future<bool> deleteToken() async {
    try {
      await _storage.delete(key: _keyToken);
      await _storage.delete(key: _keyUsername);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Mengecek apakah user sudah memiliki token tersimpan.
  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// Menyimpan username pengguna ke secure storage.
  Future<bool> saveUsername(String username) async {
    try {
      await _storage.write(key: _keyUsername, value: username);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Mengambil username pengguna dari secure storage.
  Future<String?> getUsername() async {
    try {
      return await _storage.read(key: _keyUsername);
    } catch (e) {
      return null;
    }
  }

  /// Menghapus semua data sesi pengguna.
  Future<bool> clearSession() => deleteToken();
}
