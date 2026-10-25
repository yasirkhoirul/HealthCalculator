// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfileModel _$UserProfileModelFromJson(
  Map<String, dynamic> json,
) => UserProfileModel(
  id: json['id'] as String,
  name: json['name'] as String,
  username: json['username'] as String? ?? '@farhan_study',
  nim: json['nim'] as String,
  campus: json['campus'] as String,
  campusBranch: json['campusBranch'] as String? ?? 'ITB Kampus Ganesha',
  major: json['major'] as String,
  academicYear: json['academicYear'] as String? ?? '2023',
  email: json['email'] as String,
  bio:
      json['bio'] as String? ??
      'Fokus persiapan UAS & mobile dev. Selalu cari teman ngoding di perpus!',
  interests:
      (json['interests'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const ['Flutter', 'System Design', 'Calculus'],
  isMapVisible: json['isMapVisible'] as bool? ?? true,
  photoUrl: json['photoUrl'] as String?,
  totalFocusHours: (json['totalFocusHours'] as num).toDouble(),
  completedSessions: (json['completedSessions'] as num).toInt(),
  connectedBuddies: (json['connectedBuddies'] as num).toInt(),
  isGhostMode: json['isGhostMode'] as bool? ?? false,
  focusPreference: json['focusPreference'] as String,
);

Map<String, dynamic> _$UserProfileModelToJson(UserProfileModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'username': instance.username,
      'nim': instance.nim,
      'campus': instance.campus,
      'campusBranch': instance.campusBranch,
      'major': instance.major,
      'academicYear': instance.academicYear,
      'email': instance.email,
      'bio': instance.bio,
      'interests': instance.interests,
      'isMapVisible': instance.isMapVisible,
      'photoUrl': instance.photoUrl,
      'totalFocusHours': instance.totalFocusHours,
      'completedSessions': instance.completedSessions,
      'connectedBuddies': instance.connectedBuddies,
      'isGhostMode': instance.isGhostMode,
      'focusPreference': instance.focusPreference,
    };
