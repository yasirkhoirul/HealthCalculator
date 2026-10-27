import 'package:json_annotation/json_annotation.dart';

part 'user_profile_model.g.dart';

/// Model profil mahasiswa beserta statistik fokus, preferensi, dan data edit profil.
@JsonSerializable()
class UserProfileModel {
  final String id;
  final String name;
  final String username;
  final String nim;
  final String campus;
  final String campusBranch;
  final String major;
  final String academicYear;
  final String email;
  final String bio;
  final List<String> interests;
  final bool isMapVisible;
  final String? photoUrl;
  final double totalFocusHours;
  final int completedSessions;
  final int connectedBuddies;
  final bool isGhostMode;
  final String focusPreference;

  const UserProfileModel({
    required this.id,
    required this.name,
    this.username = '@farhan_study',
    required this.nim,
    required this.campus,
    this.campusBranch = 'ITB Kampus Ganesha',
    required this.major,
    this.academicYear = '2023',
    required this.email,
    this.bio = 'Fokus persiapan UAS & mobile dev. Selalu cari teman ngoding di perpus!',
    this.interests = const ['Flutter', 'System Design', 'Calculus'],
    this.isMapVisible = true,
    this.photoUrl,
    required this.totalFocusHours,
    required this.completedSessions,
    required this.connectedBuddies,
    this.isGhostMode = false,
    required this.focusPreference,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileModelToJson(this);

  UserProfileModel copyWith({
    String? id,
    String? name,
    String? username,
    String? nim,
    String? campus,
    String? campusBranch,
    String? major,
    String? academicYear,
    String? email,
    String? bio,
    List<String>? interests,
    bool? isMapVisible,
    String? photoUrl,
    double? totalFocusHours,
    int? completedSessions,
    int? connectedBuddies,
    bool? isGhostMode,
    String? focusPreference,
  }) {
    return UserProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      nim: nim ?? this.nim,
      campus: campus ?? this.campus,
      campusBranch: campusBranch ?? this.campusBranch,
      major: major ?? this.major,
      academicYear: academicYear ?? this.academicYear,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      interests: interests ?? this.interests,
      isMapVisible: isMapVisible ?? this.isMapVisible,
      photoUrl: photoUrl ?? this.photoUrl,
      totalFocusHours: totalFocusHours ?? this.totalFocusHours,
      completedSessions: completedSessions ?? this.completedSessions,
      connectedBuddies: connectedBuddies ?? this.connectedBuddies,
      isGhostMode: isGhostMode ?? this.isGhostMode,
      focusPreference: focusPreference ?? this.focusPreference,
    );
  }
}

typedef UserProfile = UserProfileModel;
