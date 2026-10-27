// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'knock_payload_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KnockPayloadModel _$KnockPayloadModelFromJson(Map<String, dynamic> json) =>
    KnockPayloadModel(
      knockId: json['knockId'] as String,
      spotName: json['spotName'] as String,
      durationMinutes: (json['durationMinutes'] as num).toInt(),
      status: json['status'] as String? ?? 'pending',
    );

Map<String, dynamic> _$KnockPayloadModelToJson(KnockPayloadModel instance) =>
    <String, dynamic>{
      'knockId': instance.knockId,
      'spotName': instance.spotName,
      'durationMinutes': instance.durationMinutes,
      'status': instance.status,
    };
