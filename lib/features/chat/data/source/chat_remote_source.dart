import '../models/chat_message_model.dart';
import '../models/knock_payload_model.dart';

/// Remote data source untuk simulasi fitur Chat Room / Obrolan Langsung & Pertemanan.
class ChatRemoteSource {
  final Map<String, List<ChatMessageModel>> _messageCache = {};
  final Set<String> _pendingFriends = {};
  final Set<String> _acceptedFriends = {'buddy-1', 'buddy-2'}; // Default friends in MockData

  ChatRemoteSource() {
    _initMockMessages();
  }

  void _initMockMessages() {
    final now = DateTime.now();

    // Mock Chat dengan buddy-1 (Alif Fathur R.) - ada kartu Knock sebelumnya
    _messageCache['buddy-1'] = [
      ChatMessageModel(
        id: 'msg-1',
        senderId: 'buddy-1',
        receiverId: 'user-farhan',
        message: 'Halo Farhan! Kamu lagi fokus belajar di perpustakaan lantai 2 ya?',
        timestamp: now.subtract(const Duration(minutes: 30)),
        isRead: true,
      ),
      ChatMessageModel(
        id: 'msg-2',
        senderId: 'user-farhan',
        receiverId: 'buddy-1',
        message: 'Halo Alif! Iya nih, lagi selesaikan modul arsitektur MVVM Flutter.',
        timestamp: now.subtract(const Duration(minutes: 27)),
        isRead: true,
      ),
      ChatMessageModel(
        id: 'msg-3',
        senderId: 'buddy-1',
        receiverId: 'user-farhan',
        message: 'Keren! Aku kirimkan ajakan belajar bareng ya.',
        timestamp: now.subtract(const Duration(minutes: 20)),
        isRead: true,
        knockPayload: const KnockPayloadModel(
          knockId: 'knock-101',
          spotName: 'Main Campus Library Floor 2',
          durationMinutes: 90,
          status: 'accepted',
        ),
      ),
      ChatMessageModel(
        id: 'msg-4',
        senderId: 'user-farhan',
        receiverId: 'buddy-1',
        message: 'Mantap, aku terima! Aku ada di area meja tengah dekat jendela nomor 14.',
        timestamp: now.subtract(const Duration(minutes: 15)),
        isRead: true,
      ),
    ];

    // Mock Chat dengan buddy-5 (Rian Pratama - calon teman / request masuk)
    _messageCache['buddy-5'] = [
      ChatMessageModel(
        id: 'msg-501',
        senderId: 'buddy-5',
        receiverId: 'user-farhan',
        message: 'Halo Farhan, salam kenal! Aku lihat di radar kampus kamu lagi di perpus.',
        timestamp: now.subtract(const Duration(hours: 3)),
        isRead: true,
      ),
      ChatMessageModel(
        id: 'msg-502',
        senderId: 'buddy-5',
        receiverId: 'user-farhan',
        message: 'Yuk belajar bareng praktikum Pemrograman Web!',
        timestamp: now.subtract(const Duration(hours: 2, minutes: 50)),
        isRead: true,
        knockPayload: const KnockPayloadModel(
          knockId: 'knock-501',
          spotName: 'Main Campus Library Floor 2',
          durationMinutes: 60,
          status: 'pending',
        ),
      ),
    ];
  }

  /// Mengambil riwayat pesan untuk lawan bicara tertentu
  Future<List<ChatMessageModel>> getMessages(String targetUserId) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    if (!_messageCache.containsKey(targetUserId)) {
      _messageCache[targetUserId] = [
        ChatMessageModel(
          id: 'msg-intro-$targetUserId',
          senderId: targetUserId,
          receiverId: 'user-farhan',
          message: 'Halo! Salam kenal di StudyMap. Yuk jadwalkan belajar bareng!',
          timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
          isRead: true,
        ),
      ];
    }
    return List<ChatMessageModel>.from(_messageCache[targetUserId]!);
  }

  /// Mengirim pesan baru
  Future<ChatMessageModel> sendMessage({
    required String senderId,
    required String receiverId,
    required String message,
    KnockPayloadModel? knockPayload,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    final newMsg = ChatMessageModel(
      id: 'msg-${DateTime.now().millisecondsSinceEpoch}',
      senderId: senderId,
      receiverId: receiverId,
      message: message,
      timestamp: DateTime.now(),
      isRead: false,
      knockPayload: knockPayload,
    );
    _messageCache.putIfAbsent(receiverId, () => []).add(newMsg);
    return newMsg;
  }

  /// Menanggapi kartu ajakan Knock
  Future<void> respondToKnock({
    required String knockId,
    required bool isAccepted,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    for (final messages in _messageCache.values) {
      for (int i = 0; i < messages.length; i++) {
        final msg = messages[i];
        if (msg.knockPayload?.knockId == knockId) {
          messages[i] = msg.copyWith(
            knockPayload: msg.knockPayload!.copyWith(
              status: isAccepted ? 'accepted' : 'declined',
            ),
          );
        }
      }
    }
  }

  /// Cek apakah pengguna saat ini berteman dengan [userId]
  Future<bool> isFriend(String userId) async {
    await Future<void>.delayed(const Duration(milliseconds: 80));
    return _acceptedFriends.contains(userId);
  }

  /// Cek apakah permohonan pertemanan sedang berstatus pending
  Future<bool> isPendingFriend(String userId) async {
    await Future<void>.delayed(const Duration(milliseconds: 80));
    return _pendingFriends.contains(userId);
  }

  /// Mengirim permintaan pertemanan
  Future<void> sendFriendRequest(String userId) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    _pendingFriends.add(userId);
  }

  /// Menambahkan teman langsung (seperti Follow di TikTok DM)
  Future<void> addFriend(String userId) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    _pendingFriends.remove(userId);
    _acceptedFriends.add(userId);
  }

  /// Toggle status pertemanan (none -> pending -> friends -> none)
  Future<String> toggleFriendship(String userId) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    if (_acceptedFriends.contains(userId)) {
      _acceptedFriends.remove(userId);
      _pendingFriends.remove(userId);
      return 'none';
    } else if (_pendingFriends.contains(userId)) {
      _pendingFriends.remove(userId);
      _acceptedFriends.add(userId);
      return 'friends';
    } else {
      _pendingFriends.add(userId);
      return 'pending';
    }
  }

  /// Mendapatkan string status relasi ('none', 'pending', 'friends')
  Future<String> getFriendshipStatus(String userId) async {
    await Future<void>.delayed(const Duration(milliseconds: 80));
    if (_acceptedFriends.contains(userId)) {
      return 'friends';
    } else if (_pendingFriends.contains(userId)) {
      return 'pending';
    }
    return 'none';
  }
}
