import 'package:flutter/foundation.dart';
import 'package:health_calculator/core/constant/app_auth_state.dart';
import '../../data/models/auth_user_model.dart';
import '../../data/source/auth_remote_source.dart';

/// ViewModel untuk manajemen state autentikasi (pola BLoC / sealed state).
///
/// Seluruh hasil operasi auth dipancarkan lewat [stateLogin] berupa
/// [AppAuthState], sehingga UI cukup melakukan pattern matching tanpa perlu
/// getter `isLoading` / `errorMessage` terpisah.
class AuthViewModel extends ChangeNotifier {
  final AuthRemoteSource _authRemoteSource;

  AuthViewModel(this._authRemoteSource);

  AppAuthState _stateLogin = const AppAuthStateInitial();
  AppAuthState get stateLogin => _stateLogin;

  /// Pengguna yang sedang login, null bila belum terautentikasi.
  AuthUserModel? get currentUser => _stateLogin.dataOrNull;

  bool get isAuthenticated => _stateLogin is AppAuthStateSuccess;

  void _emit(AppAuthState state) {
    _stateLogin = state;
    notifyListeners();
  }

  Future<void> signInWithGoogle() =>
      _run(() => _authRemoteSource.signInWithGoogle());

  Future<void> signInWithEmail(String email) =>
      _run(() => _authRemoteSource.signInWithEmail(email));

  Future<void> signUpWithEmail({
    required String name,
    required String email,
    required String password,
    required String campus,
  }) {
    return _run(
      () => _authRemoteSource.signUpWithEmail(
        name: name,
        email: email,
        password: password,
        campus: campus,
      ),
    );
  }

  Future<void> signOut() async {
    _emit(const AppAuthStateInitial());
  }

  /// Alur seragam: Loading → Success(user | null) → Error.
  Future<void> _run(Future<AuthUserModel?> Function() action) async {
    _emit(const AppAuthStateLoading());
    try {
      final user = await action();
      _emit(AppAuthStateSuccess(data: user));
    } catch (e) {
      _emit(AppAuthStateError(message: e.toString(), error: e));
    }
  }
}
