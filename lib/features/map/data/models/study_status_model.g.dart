// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'study_status_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudyStatusModel _$StudyStatusModelFromJson(Map<String, dynamic> json) =>
    StudyStatusModel(
      emoji: json['emoji'] as String,
      label: json['label'] as String,
      customMessage: json['customMessage'] as String?,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$StudyStatusModelToJson(StudyStatusModel instance) =>
    <String, dynamic>{
      'emoji': instance.emoji,
      'label': instance.label,
      'customMessage': instance.customMessage,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
