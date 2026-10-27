// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spot_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpotModel _$SpotModelFromJson(Map<String, dynamic> json) => SpotModel(
  id: json['id'] as String,
  name: json['name'] as String,
  category: json['category'] as String,
  subtitle: json['subtitle'] as String,
  distanceInMeters: (json['distanceInMeters'] as num).toInt(),
  crowdStatus: json['crowdStatus'] as String,
  crowdLevel: json['crowdLevel'] as String,
  friendsSummary: json['friendsSummary'] as String,
  friendsCount: (json['friendsCount'] as num?)?.toInt() ?? 0,
  openDesks: (json['openDesks'] as num?)?.toInt() ?? 0,
  totalDesks: (json['totalDesks'] as num?)?.toInt() ?? 0,
  rating: (json['rating'] as num?)?.toDouble() ?? 4.8,
  imageUrl: json['imageUrl'] as String?,
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  isOpen: json['isOpen'] as bool? ?? true,
  vibe: json['vibe'] as String? ?? 'All Vibe',
  powerOutletStatus: json['powerOutletStatus'] as String?,
  virtualX: (json['virtualX'] as num?)?.toDouble(),
  virtualY: (json['virtualY'] as num?)?.toDouble(),
);

Map<String, dynamic> _$SpotModelToJson(SpotModel instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'category': instance.category,
  'subtitle': instance.subtitle,
  'distanceInMeters': instance.distanceInMeters,
  'crowdStatus': instance.crowdStatus,
  'crowdLevel': instance.crowdLevel,
  'friendsSummary': instance.friendsSummary,
  'friendsCount': instance.friendsCount,
  'openDesks': instance.openDesks,
  'totalDesks': instance.totalDesks,
  'rating': instance.rating,
  'imageUrl': instance.imageUrl,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'isOpen': instance.isOpen,
  'vibe': instance.vibe,
  'powerOutletStatus': instance.powerOutletStatus,
  'virtualX': instance.virtualX,
  'virtualY': instance.virtualY,
};
