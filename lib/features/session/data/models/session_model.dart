import 'package:json_annotation/json_annotation.dart';

part 'session_model.g.dart';

/// Model data untuk sesi belajar fokus (Focus Session)
@JsonSerializable()
class SessionModel {
  final String id;
  final String title;
  final String spotName;
  final int durationMinutes;
  final int remainingSeconds;
  final bool isRunning;
  final DateTime? startedAt;

  const SessionModel({
    required this.id,
    required this.title,
    required this.spotName,
    required this.durationMinutes,
    required this.remainingSeconds,
    this.isRunning = false,
    this.startedAt,
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) =>
      _$SessionModelFromJson(json);

  Map<String, dynamic> toJson() => _$SessionModelToJson(this);

  SessionModel copyWith({
    String? id,
    String? title,
    String? spotName,
    int? durationMinutes,
    int? remainingSeconds,
    bool? isRunning,
    DateTime? startedAt,
  }) {
    return SessionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      spotName: spotName ?? this.spotName,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isRunning: isRunning ?? this.isRunning,
      startedAt: startedAt ?? this.startedAt,
    );
  }
}
