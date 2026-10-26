import 'package:json_annotation/json_annotation.dart';
import 'study_status_model.dart';

part 'user_presence_model.g.dart';

@JsonSerializable(explicitToJson: true)
class UserPresenceModel {
  final String id;
  final String name;
  final String? avatarUrl;
  final String campus;
  final String major;
  final String currentSpotName;
  final String currentTopic;
  final double latitude;
  final double longitude;
  final bool isOnline;
  final StudyStatusModel? status;
  final bool isCurrentUser;
  final bool isFriend;
  final bool isGroup;
  final int buddiesCount;
  final String? statusEmote;
  final String? groupBadge;
  final String? distanceLabel;
  final List<String> memberAvatars;
  final double? virtualX;
  final double? virtualY;

  UserPresenceModel({
    required this.id,
    required this.name,
    this.avatarUrl,
    required this.campus,
    required this.major,
    required this.currentSpotName,
    required this.currentTopic,
    required this.latitude,
    required this.longitude,
    this.isOnline = true,
    this.status,
    this.isCurrentUser = false,
    this.isFriend = false,
    this.isGroup = false,
    this.buddiesCount = 0,
    this.statusEmote,
    this.groupBadge,
    this.distanceLabel,
    this.memberAvatars = const [],
    this.virtualX,
    this.virtualY,
  });

  String get avatarInitials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return 'SM';
    if (parts.length == 1) return parts[0].substring(0, 1).toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  UserPresenceModel copyWith({
    String? id,
    String? name,
    String? avatarUrl,
    String? campus,
    String? major,
    String? currentSpotName,
    String? currentTopic,
    double? latitude,
    double? longitude,
    bool? isOnline,
    StudyStatusModel? status,
    bool? isCurrentUser,
    bool? isFriend,
    bool? isGroup,
    int? buddiesCount,
    String? statusEmote,
    String? groupBadge,
    String? distanceLabel,
    List<String>? memberAvatars,
    double? virtualX,
    double? virtualY,
  }) {
    return UserPresenceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      campus: campus ?? this.campus,
      major: major ?? this.major,
      currentSpotName: currentSpotName ?? this.currentSpotName,
      currentTopic: currentTopic ?? this.currentTopic,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isOnline: isOnline ?? this.isOnline,
      status: status ?? this.status,
      isCurrentUser: isCurrentUser ?? this.isCurrentUser,
      isFriend: isFriend ?? this.isFriend,
      isGroup: isGroup ?? this.isGroup,
      buddiesCount: buddiesCount ?? this.buddiesCount,
      statusEmote: statusEmote ?? this.statusEmote,
      groupBadge: groupBadge ?? this.groupBadge,
      distanceLabel: distanceLabel ?? this.distanceLabel,
      memberAvatars: memberAvatars ?? this.memberAvatars,
      virtualX: virtualX ?? this.virtualX,
      virtualY: virtualY ?? this.virtualY,
    );
  }

  factory UserPresenceModel.fromJson(Map<String, dynamic> json) =>
      _$UserPresenceModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserPresenceModelToJson(this);
}
