// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionModel _$SessionModelFromJson(Map<String, dynamic> json) => SessionModel(
  id: json['id'] as String,
  title: json['title'] as String,
  spotName: json['spotName'] as String,
  durationMinutes: (json['durationMinutes'] as num).toInt(),
  remainingSeconds: (json['remainingSeconds'] as num).toInt(),
  isRunning: json['isRunning'] as bool? ?? false,
  startedAt: json['startedAt'] == null
      ? null
      : DateTime.parse(json['startedAt'] as String),
);

Map<String, dynamic> _$SessionModelToJson(SessionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'spotName': instance.spotName,
      'durationMinutes': instance.durationMinutes,
      'remainingSeconds': instance.remainingSeconds,
      'isRunning': instance.isRunning,
      'startedAt': instance.startedAt?.toIso8601String(),
    };
