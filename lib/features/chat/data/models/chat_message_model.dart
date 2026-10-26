import 'package:json_annotation/json_annotation.dart';
import 'knock_payload_model.dart';

part 'chat_message_model.g.dart';

/// Model pesan obrolan langsung (Chat Room) antar mahasiswa StudyMap.
/// Mendukung pesan teks biasa dan kartu interaktif ajakan "Knock / Ajak Belajar".
@JsonSerializable(explicitToJson: true)
class ChatMessageModel {
  final String id;
  final String senderId;
  final String receiverId;
  final String message;
  final DateTime timestamp;
  final bool isRead;
  final KnockPayloadModel? knockPayload;

  ChatMessageModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
    this.isRead = false,
    this.knockPayload,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMessageModelToJson(this);

  ChatMessageModel copyWith({
    String? id,
    String? senderId,
    String? receiverId,
    String? message,
    DateTime? timestamp,
    bool? isRead,
    KnockPayloadModel? knockPayload,
  }) {
    return ChatMessageModel(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      knockPayload: knockPayload ?? this.knockPayload,
    );
  }
}
