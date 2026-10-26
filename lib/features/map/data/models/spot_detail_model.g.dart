// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spot_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpotDetailModel _$SpotDetailModelFromJson(
  Map<String, dynamic> json,
) => SpotDetailModel(
  spot: SpotModel.fromJson(json['spot'] as Map<String, dynamic>),
  photos:
      (json['photos'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  amenities:
      (json['amenities'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  activeBuddiesCount: (json['activeBuddiesCount'] as num?)?.toInt() ?? 0,
  operatingHours: json['operatingHours'] as String? ?? '08:00 - 21:00',
);

Map<String, dynamic> _$SpotDetailModelToJson(SpotDetailModel instance) =>
    <String, dynamic>{
      'spot': instance.spot.toJson(),
      'photos': instance.photos,
      'amenities': instance.amenities,
      'activeBuddiesCount': instance.activeBuddiesCount,
      'operatingHours': instance.operatingHours,
    };
