/// Remote data source untuk fitur autentikasi (Firebase / REST API)
class AuthRemoteSource {
  /// Simulasi login dengan akun Google
  Future<void> signInWithGoogle() async {
    await Future.delayed(const Duration(milliseconds: 600));
  }

  /// Simulasi login dengan email kampus
  Future<void> signInWithEmail(String email) async {
    await Future.delayed(const Duration(milliseconds: 600));
  }

  /// Simulasi registrasi pengguna baru
  Future<void> signUpWithEmail({
    required String name,
    required String email,
    required String password,
    required String campus,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
  }
}
