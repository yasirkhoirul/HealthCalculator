// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_presence_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserPresenceModel _$UserPresenceModelFromJson(Map<String, dynamic> json) =>
    UserPresenceModel(
      id: json['id'] as String,
      name: json['name'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      campus: json['campus'] as String,
      major: json['major'] as String,
      currentSpotName: json['currentSpotName'] as String,
      currentTopic: json['currentTopic'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      isOnline: json['isOnline'] as bool? ?? true,
      status: json['status'] == null
          ? null
          : StudyStatusModel.fromJson(json['status'] as Map<String, dynamic>),
      isCurrentUser: json['isCurrentUser'] as bool? ?? false,
      isFriend: json['isFriend'] as bool? ?? false,
      isGroup: json['isGroup'] as bool? ?? false,
      buddiesCount: (json['buddiesCount'] as num?)?.toInt() ?? 0,
      statusEmote: json['statusEmote'] as String?,
      groupBadge: json['groupBadge'] as String?,
      distanceLabel: json['distanceLabel'] as String?,
      memberAvatars:
          (json['memberAvatars'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      virtualX: (json['virtualX'] as num?)?.toDouble(),
      virtualY: (json['virtualY'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$UserPresenceModelToJson(UserPresenceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'avatarUrl': instance.avatarUrl,
      'campus': instance.campus,
      'major': instance.major,
      'currentSpotName': instance.currentSpotName,
      'currentTopic': instance.currentTopic,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'isOnline': instance.isOnline,
      'status': instance.status?.toJson(),
      'isCurrentUser': instance.isCurrentUser,
      'isFriend': instance.isFriend,
      'isGroup': instance.isGroup,
      'buddiesCount': instance.buddiesCount,
      'statusEmote': instance.statusEmote,
      'groupBadge': instance.groupBadge,
      'distanceLabel': instance.distanceLabel,
      'memberAvatars': instance.memberAvatars,
      'virtualX': instance.virtualX,
      'virtualY': instance.virtualY,
    };
