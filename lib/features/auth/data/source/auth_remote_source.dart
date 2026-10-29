import 'dart:convert';
import 'package:health_calculator/features/auth/data/models/auth_username_model.dart';
import 'package:http/http.dart' as http;
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
      name: 'Raihan',
      email: 'raihan@uad.ac.id',
      campus: 'Universitas Ahmad Dahlan',
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
      name: email.split('@').first.isEmpty ? 'Raihan' : email.split('@').first,
      email: email,
      campus: 'Universitas Ahmad Dahlan',
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
      name: name.isEmpty ? 'Raihan' : name,
      email: email,
      campus: campus.isEmpty ? 'Universitas Ahmad Dahlan' : campus,
    );
  }

  Future<String> signInWithUserName(AuthUsernameModel authUsernameModel) async {
    final client = http.Client();
    try {
      final response = await client.post(
        Uri.https("fakestoreapi.com", "/auth/login"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(authUsernameModel.toJson()),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final result = jsonDecode(response.body) as Map<String, dynamic>;
        final token = result['token'] as String?;
        if (token != null && token.isNotEmpty) {
          return token;
        }
        throw Exception('Token tidak ditemukan dalam respon.');
      } else {
        final bodyText = response.body.trim();
        throw Exception(
          bodyText.isNotEmpty
              ? bodyText
              : 'Login gagal (Kode: ${response.statusCode})',
        );
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    } finally {
      client.close();
    }
  }

  /// Mendaftarkan pengguna baru via endpoint FakeStore API (POST /users).
  Future<int> signUpWithUserName({
    required String username,
    required String password,
    String? email,
  }) async {
    final client = http.Client();
    try {
      final response = await client.post(
        Uri.https("fakestoreapi.com", "/users"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
          'email': email ?? '$username@fakestore.com',
        }),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final result = jsonDecode(response.body) as Map<String, dynamic>;
        final id = result['id'];
        if (id is int) {
          return id;
        } else if (id != null) {
          return int.tryParse(id.toString()) ?? 1;
        }
        return 1;
      } else {
        final bodyText = response.body.trim();
        throw Exception(
          bodyText.isNotEmpty
              ? bodyText
              : 'Pendaftaran gagal (Kode: ${response.statusCode})',
        );
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    } finally {
      client.close();
    }
  }
}
