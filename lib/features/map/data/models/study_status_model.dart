import 'package:json_annotation/json_annotation.dart';

part 'study_status_model.g.dart';

@JsonSerializable()
class StudyStatusModel {
  final String emoji;
  final String label;
  final String? customMessage;
  final DateTime updatedAt;

  const StudyStatusModel({
    required this.emoji,
    required this.label,
    this.customMessage,
    required this.updatedAt,
  });

  /// Preset mood belajar yang sering dipakai mahasiswa
  static List<StudyStatusModel> get presets => [
        StudyStatusModel(
          emoji: '🔥',
          label: 'Semangat',
          customMessage: 'Lagi produktif / ngebut materi',
          updatedAt: DateTime.now(),
        ),
        StudyStatusModel(
          emoji: '🤯',
          label: 'Pusing',
          customMessage: 'Butuh tutor sebaya / buntu',
          updatedAt: DateTime.now(),
        ),
        StudyStatusModel(
          emoji: '🎯',
          label: 'Deep Focus',
          customMessage: 'Mode hening, jangan diganggu',
          updatedAt: DateTime.now(),
        ),
        StudyStatusModel(
          emoji: '☕',
          label: 'Santai',
          customMessage: 'Belajar santai sambil ngopi',
          updatedAt: DateTime.now(),
        ),
        StudyStatusModel(
          emoji: '😴',
          label: 'Butuh Kafein',
          customMessage: 'Ngantuk berat, butuh teman jajan',
          updatedAt: DateTime.now(),
        ),
      ];

  /// Default status awal pengguna
  static StudyStatusModel get defaultStatus => presets.first;

  String get displayText =>
      (customMessage != null && customMessage!.trim().isNotEmpty)
          ? customMessage!.trim()
          : label;

  StudyStatusModel copyWith({
    String? emoji,
    String? label,
    String? customMessage,
    DateTime? updatedAt,
  }) {
    return StudyStatusModel(
      emoji: emoji ?? this.emoji,
      label: label ?? this.label,
      customMessage: customMessage ?? this.customMessage,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory StudyStatusModel.fromJson(Map<String, dynamic> json) =>
      _$StudyStatusModelFromJson(json);

  Map<String, dynamic> toJson() => _$StudyStatusModelToJson(this);
}
