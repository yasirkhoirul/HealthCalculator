import 'package:json_annotation/json_annotation.dart';

part 'knock_payload_model.g.dart';

/// Model payload untuk kartu ajakan interaktif "Knock / Ajak Belajar" di dalam obrolan chat.
@JsonSerializable()
class KnockPayloadModel {
  final String knockId;
  final String spotName;
  final int durationMinutes;
  final String status; // 'pending', 'accepted', 'declined'

  const KnockPayloadModel({
    required this.knockId,
    required this.spotName,
    required this.durationMinutes,
    this.status = 'pending',
  });

  factory KnockPayloadModel.fromJson(Map<String, dynamic> json) =>
      _$KnockPayloadModelFromJson(json);

  Map<String, dynamic> toJson() => _$KnockPayloadModelToJson(this);

  KnockPayloadModel copyWith({
    String? knockId,
    String? spotName,
    int? durationMinutes,
    String? status,
  }) {
    return KnockPayloadModel(
      knockId: knockId ?? this.knockId,
      spotName: spotName ?? this.spotName,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      status: status ?? this.status,
    );
  }
}
