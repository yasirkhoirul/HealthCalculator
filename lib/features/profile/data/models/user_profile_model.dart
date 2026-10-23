import 'package:json_annotation/json_annotation.dart';

part 'user_profile_model.g.dart';

/// Model profil mahasiswa beserta statistik fokus dan preferensi.
@JsonSerializable()
class UserProfile {
  final String id;
  final String name;
  final String nim;
  final String campus;
  final String major;
  final String email;
  final double totalFocusHours;
  final int completedSessions;
  final int connectedBuddies;
  final bool isGhostMode;
  final String focusPreference;

  const UserProfile({
    required this.id,
    required this.name,
    required this.nim,
    required this.campus,
    required this.major,
    required this.email,
    required this.totalFocusHours,
    required this.completedSessions,
    required this.connectedBuddies,
    this.isGhostMode = false,
    required this.focusPreference,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileToJson(this);

  UserProfile copyWith({
    String? id,
    String? name,
    String? nim,
    String? campus,
    String? major,
    String? email,
    double? totalFocusHours,
    int? completedSessions,
    int? connectedBuddies,
    bool? isGhostMode,
    String? focusPreference,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      nim: nim ?? this.nim,
      campus: campus ?? this.campus,
      major: major ?? this.major,
      email: email ?? this.email,
      totalFocusHours: totalFocusHours ?? this.totalFocusHours,
      completedSessions: completedSessions ?? this.completedSessions,
      connectedBuddies: connectedBuddies ?? this.connectedBuddies,
      isGhostMode: isGhostMode ?? this.isGhostMode,
      focusPreference: focusPreference ?? this.focusPreference,
    );
  }
}
