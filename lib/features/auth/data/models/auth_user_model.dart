import 'package:json_annotation/json_annotation.dart';

part 'auth_user_model.g.dart';

/// Model pengguna hasil autentikasi.
///
/// Dibuat dengan `json_serializable` agar siap dipakai langsung saat
/// integrasi Firebase / REST API tanpa perlu mapping manual.
@JsonSerializable()
class AuthUserModel {
  final String id;
  final String name;
  final String email;
  final String campus;
  final String? nim;
  final String? major;
  final String? photoUrl;
  final bool isEmailVerified;

  const AuthUserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.campus,
    this.nim,
    this.major,
    this.photoUrl,
    this.isEmailVerified = false,
  });

  factory AuthUserModel.fromJson(Map<String, dynamic> json) =>
      _$AuthUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthUserModelToJson(this);

  AuthUserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? campus,
    String? nim,
    String? major,
    String? photoUrl,
    bool? isEmailVerified,
  }) {
    return AuthUserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      campus: campus ?? this.campus,
      nim: nim ?? this.nim,
      major: major ?? this.major,
      photoUrl: photoUrl ?? this.photoUrl,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
    );
  }
}
