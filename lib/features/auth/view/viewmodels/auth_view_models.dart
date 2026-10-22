import 'package:flutter/foundation.dart';
import '../../data/source/auth_remote_source.dart';

/// ViewModel untuk manajemen state fitur autentikasi menggunakan Provider / ChangeNotifier
class AuthViewModel extends ChangeNotifier {
  final AuthRemoteSource _authRemoteSource;

  AuthViewModel(this._authRemoteSource);

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Login menggunakan Google
  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authRemoteSource.signInWithGoogle();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Login menggunakan Email Kampus
  Future<bool> signInWithEmail(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authRemoteSource.signInWithEmail(email);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Pendaftaran / Registrasi akun baru
  Future<bool> signUpWithEmail({
    required String name,
    required String email,
    required String password,
    required String campus,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authRemoteSource.signUpWithEmail(
        name: name,
        email: email,
        password: password,
        campus: campus,
      );
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Bersihkan pesan error jika diperlukan
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
