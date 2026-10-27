import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import '../../../../core/constant/app_base_state.dart';
import '../../../../core/mock/mock_data.dart';
import '../../data/models/chat_message_model.dart';
import '../../data/models/knock_payload_model.dart';
import '../../data/source/chat_remote_source.dart';

typedef ChatState = AppBaseState<List<ChatMessageModel>>;

/// ViewModel untuk Chat Room / Obrolan Langsung (StudyMap) dengan gaya TikTok DM.
/// Mengimplementasikan MVVM Feature-First murni dengan AppBaseState generic.
class ChatViewModel extends ChangeNotifier {
  final ChatRemoteSource _remoteSource;

  ChatState _messageState = const AppStateInitial();
  ChatState get messageState => _messageState;

  bool _isFriend = false;
  bool get isFriend => _isFriend;

  bool _isPendingFriend = false;
  bool get isPendingFriend => _isPendingFriend;

  String? _targetUserId;
  String? get targetUserId => _targetUserId;

  StudyBuddy? _targetBuddy;
  StudyBuddy? get targetBuddy => _targetBuddy;

  bool _isDisposed = false;

  ChatViewModel({ChatRemoteSource? remoteSource})
      : _remoteSource = remoteSource ?? ChatRemoteSource();

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (_isDisposed) return;

    final binding = WidgetsBinding.instance;
    final phase = SchedulerBinding.instance.schedulerPhase;
    final isBuilding = phase == SchedulerPhase.persistentCallbacks ||
        (binding.buildOwner?.debugBuilding ?? false);

    if (isBuilding) {
      binding.addPostFrameCallback((_) {
        if (!_isDisposed) {
          super.notifyListeners();
        }
      });
    } else {
      super.notifyListeners();
    }
  }

  /// Memuat riwayat pesan dan status pertemanan dengan lawan bicara
  Future<void> loadMessages(String targetUserId) async {
    _targetUserId = targetUserId;
    _resolveTargetBuddy(targetUserId);

    _messageState = const AppStateLoading(message: 'Memuat obrolan...');
    notifyListeners();

    try {
      // Ambil status pertemanan
      _isFriend = await _remoteSource.isFriend(targetUserId);
      _isPendingFriend = await _remoteSource.isPendingFriend(targetUserId);

      // Ambil daftar pesan
      final messages = await _remoteSource.getMessages(targetUserId);
      _messageState = AppStateSuccess(data: messages);
    } catch (e) {
      _messageState = AppStateError(
        message: 'Gagal memuat pesan: ${e.toString()}',
        error: e,
      );
    } finally {
      notifyListeners();
    }
  }

  /// Mengirim pesan teks baru ke lawan bicara secara reaktif
  Future<void> sendMessage(String text, String targetUserId) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final currentMessages = _messageState.dataOrNull != null
        ? List<ChatMessageModel>.from(_messageState.dataOrNull!)
        : <ChatMessageModel>[];

    // Optimistic UI update
    final optimisticMessage = ChatMessageModel(
      id: 'local-${DateTime.now().millisecondsSinceEpoch}',
      senderId: 'user-farhan',
      receiverId: targetUserId,
      message: trimmed,
      timestamp: DateTime.now(),
      isRead: false,
    );

    currentMessages.add(optimisticMessage);
    _messageState = AppStateSuccess(data: currentMessages);
    notifyListeners();

    try {
      final sentMessage = await _remoteSource.sendMessage(
        senderId: 'user-farhan',
        receiverId: targetUserId,
        message: trimmed,
      );

      final index = currentMessages.indexOf(optimisticMessage);
      if (index != -1) {
        currentMessages[index] = sentMessage;
        _messageState = AppStateSuccess(data: currentMessages);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error sending message: $e');
    }
  }

  /// Mengirimkan kartu interaktif "Knock / Ajak Belajar" langsung ke dalam chat
  Future<void> sendKnockInvitation({
    required String targetUserId,
    required String spotName,
    required int durationMinutes,
  }) async {
    final currentMessages = _messageState.dataOrNull != null
        ? List<ChatMessageModel>.from(_messageState.dataOrNull!)
        : <ChatMessageModel>[];

    final knockId = 'knock-${DateTime.now().millisecondsSinceEpoch}';
    final payload = KnockPayloadModel(
      knockId: knockId,
      spotName: spotName,
      durationMinutes: durationMinutes,
      status: 'pending',
    );

    final knockMessage = ChatMessageModel(
      id: 'msg-knock-${DateTime.now().millisecondsSinceEpoch}',
      senderId: 'user-farhan',
      receiverId: targetUserId,
      message: '👋 Mengajak belajar bareng di $spotName selama $durationMinutes menit.',
      timestamp: DateTime.now(),
      isRead: false,
      knockPayload: payload,
    );

    currentMessages.add(knockMessage);
    _messageState = AppStateSuccess(data: currentMessages);
    notifyListeners();

    try {
      await _remoteSource.sendMessage(
        senderId: 'user-farhan',
        receiverId: targetUserId,
        message: knockMessage.message,
        knockPayload: payload,
      );
    } catch (e) {
      debugPrint('Error sending knock invitation: $e');
    }
  }

  /// Menanggapi ajakan belajar bareng (Menerima atau Menolak Knock)
  Future<void> respondToKnock(String knockId, bool isAccepted) async {
    final currentMessages = _messageState.dataOrNull;
    if (currentMessages == null) return;

    final updatedMessages = List<ChatMessageModel>.from(currentMessages);
    for (int i = 0; i < updatedMessages.length; i++) {
      final msg = updatedMessages[i];
      if (msg.knockPayload?.knockId == knockId) {
        updatedMessages[i] = msg.copyWith(
          knockPayload: msg.knockPayload!.copyWith(
            status: isAccepted ? 'accepted' : 'declined',
          ),
        );
      }
    }

    _messageState = AppStateSuccess(data: updatedMessages);
    notifyListeners();

    try {
      await _remoteSource.respondToKnock(
        knockId: knockId,
        isAccepted: isAccepted,
      );
    } catch (e) {
      debugPrint('Error responding to knock: $e');
    }
  }

  /// Menambahkan teman langsung (seperti Follow / Add Friend pada TikTok DM)
  Future<void> addFriend(String targetUserId) async {
    try {
      _isFriend = true;
      _isPendingFriend = false;
      notifyListeners();

      await _remoteSource.addFriend(targetUserId);
    } catch (e) {
      _isFriend = false;
      debugPrint('Error adding friend: $e');
    } finally {
      notifyListeners();
    }
  }

  /// Mengirim permintaan pertemanan ke lawan bicara
  Future<void> sendFriendRequest(String targetUserId) async {
    try {
      _isPendingFriend = true;
      notifyListeners();

      await _remoteSource.sendFriendRequest(targetUserId);
      _isPendingFriend = true;
      _isFriend = false;
    } catch (e) {
      _isPendingFriend = false;
      debugPrint('Error sending friend request: $e');
    } finally {
      notifyListeners();
    }
  }

  /// Helper untuk mencocokkan target user dari MockData
  void _resolveTargetBuddy(String targetUserId) {
    try {
      _targetBuddy = MockData.buddies.firstWhere(
        (b) => b.id == targetUserId,
        orElse: () {
          final req = MockData.requests.where((r) => r.sender.id == targetUserId);
          if (req.isNotEmpty) return req.first.sender;

          return StudyBuddy(
            id: targetUserId,
            name: targetUserId == 'buddy-5' ? 'Rian Pratama' : 'Rian M.',
            avatarInitials: 'RM',
            campus: 'Universitas Ahmad Dahlan',
            major: 'Teknik Informatika 2022',
            semester: 'Semester 5',
            currentStudyTopic: 'Sedang belajar di Perpustakaan Pusat',
            isOnline: true,
            currentSpotName: 'Main Campus Library',
            mutualFriends: 6,
          );
        },
      );
    } catch (_) {
      _targetBuddy = null;
    }
  }

  String get targetUserName => _targetBuddy?.name ?? 'Rekan Belajar';

  String get targetUserUsername =>
      '@${targetUserName.toLowerCase().replaceAll(' ', '_').replaceAll('.', '')}';

  String get targetUserStatus {
    if (_targetBuddy == null) return 'Aktif sekarang';
    if (_targetBuddy!.currentSpotName.isNotEmpty) {
      return 'Belajar di ${_targetBuddy!.currentSpotName}';
    }
    return _targetBuddy!.isOnline ? 'Aktif sekarang' : 'Offline';
  }

  String get targetUserInitials => _targetBuddy?.avatarInitials ?? 'SM';

  bool get isTargetOnline => _targetBuddy?.isOnline ?? true;
}
