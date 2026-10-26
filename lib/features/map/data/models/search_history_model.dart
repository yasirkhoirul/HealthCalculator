import 'package:json_annotation/json_annotation.dart';

part 'search_history_model.g.dart';

/// Model data untuk item riwayat pencarian (Search History)
@JsonSerializable()
class SearchHistoryModel {
  final String query;
  final DateTime timestamp;
  final String? category;

  const SearchHistoryModel({
    required this.query,
    required this.timestamp,
    this.category,
  });

  factory SearchHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$SearchHistoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$SearchHistoryModelToJson(this);

  SearchHistoryModel copyWith({
    String? query,
    DateTime? timestamp,
    String? category,
  }) {
    return SearchHistoryModel(
      query: query ?? this.query,
      timestamp: timestamp ?? this.timestamp,
      category: category ?? this.category,
    );
  }
}
