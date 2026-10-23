// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => UserProfile(
  id: json['id'] as String,
  name: json['name'] as String,
  nim: json['nim'] as String,
  campus: json['campus'] as String,
  major: json['major'] as String,
  email: json['email'] as String,
  totalFocusHours: (json['totalFocusHours'] as num).toDouble(),
  completedSessions: (json['completedSessions'] as num).toInt(),
  connectedBuddies: (json['connectedBuddies'] as num).toInt(),
  isGhostMode: json['isGhostMode'] as bool? ?? false,
  focusPreference: json['focusPreference'] as String,
);

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'nim': instance.nim,
      'campus': instance.campus,
      'major': instance.major,
      'email': instance.email,
      'totalFocusHours': instance.totalFocusHours,
      'completedSessions': instance.completedSessions,
      'connectedBuddies': instance.connectedBuddies,
      'isGhostMode': instance.isGhostMode,
      'focusPreference': instance.focusPreference,
    };
