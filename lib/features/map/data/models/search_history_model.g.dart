// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchHistoryModel _$SearchHistoryModelFromJson(Map<String, dynamic> json) =>
    SearchHistoryModel(
      query: json['query'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      category: json['category'] as String?,
    );

Map<String, dynamic> _$SearchHistoryModelToJson(SearchHistoryModel instance) =>
    <String, dynamic>{
      'query': instance.query,
      'timestamp': instance.timestamp.toIso8601String(),
      'category': instance.category,
    };
