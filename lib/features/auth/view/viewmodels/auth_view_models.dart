import 'package:flutter/foundation.dart';
import 'package:health_calculator/core/constant/app_auth_state.dart';
import 'package:health_calculator/features/auth/data/models/auth_username_model.dart';
import 'package:health_calculator/features/auth/data/source/auth_local_source.dart';
import '../../data/models/auth_user_model.dart';
import '../../data/source/auth_remote_source.dart';

/// ViewModel untuk manajemen state autentikasi (pola BLoC / sealed state).
///
/// Seluruh hasil operasi auth dipancarkan lewat [stateLogin] berupa
/// [AppAuthState], sehingga UI cukup melakukan pattern matching tanpa perlu
/// getter `isLoading` / `errorMessage` terpisah.
class AuthViewModel extends ChangeNotifier {
  final AuthRemoteSource _authRemoteSource;
  final AuthLocalSource _authLocalSource;

  AuthViewModel(
    this._authRemoteSource, [
    AuthLocalSource? authLocalSource,
  ]) : _authLocalSource = authLocalSource ?? AuthLocalSource();

  AppAuthState _stateLogin = const AppAuthStateInitial();
  AppAuthState get stateLogin => _stateLogin;

  /// Pengguna yang sedang login, null bila belum terautentikasi.
  AuthUserModel? get currentUser => _stateLogin.dataOrNull;

  bool get isAuthenticated => _stateLogin is AppAuthStateSuccess;

  void _emit(AppAuthState state) {
    _stateLogin = state;
    notifyListeners();
  }

  /// Cek sesi login lokal dari Secure Storage saat inisialisasi aplikasi.
  Future<void> checkAuthStatus() async {
    try {
      final token = await _authLocalSource.getToken();
      final username = await _authLocalSource.getUsername();
      if (token != null && token.isNotEmpty) {
        _emit(AppAuthStateSuccess(
          data: AuthUserModel(
            id: token,
            name: username ?? 'Mahasiswa',
            email: '${username ?? "mahasiswa"}@fakestore.com',
            campus: 'Universitas Ahmad Dahlan',
          ),
        ));
      }
    } catch (_) {}
  }

  Future<void> signInWithUserName(String username, String password) async {
    _emit(const AppAuthStateLoading());
    try {
      final token = await _authRemoteSource.signInWithUserName(
        AuthUsernameModel(username: username, password: password),
      );
      final resultToken = await _authLocalSource.saveToken(token);
      if (resultToken == true) {
        await _authLocalSource.saveUsername(username);
        _emit(AppAuthStateSuccess(
          data: AuthUserModel(
            id: token,
            name: username,
            email: '$username@fakestore.com',
            campus: 'Universitas Ahmad Dahlan',
          ),
        ));
      } else {
        _emit(const AppAuthStateError(message: 'Gagal menyimpan sesi login.'));
      }
    } on Exception catch (e) {
      _emit(AppAuthStateError(
        message: e.toString().replaceAll('Exception: ', ''),
        error: e,
      ));
    } catch (e) {
      _emit(AppAuthStateError(message: e.toString()));
    }
  }

  /// Pendaftaran user baru menggunakan FakeStore API (POST /users).
  Future<void> signUpWithUserName({
    required String username,
    required String password,
    String? email,
  }) async {
    _emit(const AppAuthStateLoading());
    try {
      final newUserId = await _authRemoteSource.signUpWithUserName(
        username: username,
        password: password,
        email: email,
      );
      final token = 'fakestore-jwt-$newUserId-$username';
      final resultToken = await _authLocalSource.saveToken(token);
      if (resultToken == true) {
        await _authLocalSource.saveUsername(username);
        _emit(AppAuthStateSuccess(
          data: AuthUserModel(
            id: newUserId.toString(),
            name: username,
            email: email ?? '$username@fakestore.com',
            campus: 'StudyMap User',
          ),
        ));
      } else {
        _emit(const AppAuthStateError(message: 'Gagal menyimpan sesi akun baru.'));
      }
    } on Exception catch (e) {
      _emit(AppAuthStateError(
        message: e.toString().replaceAll('Exception: ', ''),
        error: e,
      ));
    } catch (e) {
      _emit(AppAuthStateError(message: e.toString()));
    }
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
    await _authLocalSource.deleteToken();
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
