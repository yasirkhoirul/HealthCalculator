// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthUserModel _$AuthUserModelFromJson(Map<String, dynamic> json) =>
    AuthUserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      campus: json['campus'] as String,
      nim: json['nim'] as String?,
      major: json['major'] as String?,
      photoUrl: json['photoUrl'] as String?,
      isEmailVerified: json['isEmailVerified'] as bool? ?? false,
    );

Map<String, dynamic> _$AuthUserModelToJson(AuthUserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'campus': instance.campus,
      'nim': instance.nim,
      'major': instance.major,
      'photoUrl': instance.photoUrl,
      'isEmailVerified': instance.isEmailVerified,
    };
