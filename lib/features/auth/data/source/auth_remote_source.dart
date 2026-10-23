import '../models/auth_user_model.dart';

/// Remote data source untuk fitur autentikasi (Firebase / REST API).
///
/// Method mengembalikan [AuthUserModel] agar ViewModel dapat menyimpannya
/// langsung ke dalam state tanpa mapping tambahan.
class AuthRemoteSource {
  /// Simulasi login dengan akun Google.
  Future<AuthUserModel> signInWithGoogle() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return const AuthUserModel(
      id: 'user-me',
      name: 'Raihan Ridho Mubarok',
      email: 'raihan.ridho@ui.ac.id',
      campus: 'Universitas Indonesia',
      nim: '2106081234',
      major: 'Teknik Informatika (S1)',
      isEmailVerified: true,
    );
  }

  /// Simulasi login dengan email kampus.
  Future<AuthUserModel> signInWithEmail(String email) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return AuthUserModel(
      id: 'user-${email.hashCode}',
      name: email.split('@').first,
      email: email,
      campus: 'Universitas Indonesia',
      isEmailVerified: true,
    );
  }

  /// Simulasi registrasi pengguna baru.
  Future<AuthUserModel> signUpWithEmail({
    required String name,
    required String email,
    required String password,
    required String campus,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return AuthUserModel(
      id: 'user-${email.hashCode}',
      name: name.isEmpty ? email.split('@').first : name,
      email: email,
      campus: campus.isEmpty ? 'Universitas Indonesia' : campus,
    );
  }
}
