import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import '../../../../core/constant/app_base_state.dart';
import '../../../../core/mock/mock_data.dart';
import '../../../chat/data/source/chat_remote_source.dart';

typedef UserDetailState = AppBaseState<UserProfileModel>;

/// ViewModel untuk Halaman Detail Profil Pengguna Lain (`UserDetailPage`)
/// Mengimplementasikan arsitektur MVVM Feature-First murni dengan AppBaseState generic.
class UserDetailViewModel extends ChangeNotifier {
  final ChatRemoteSource _remoteSource;

  UserDetailState _userState = const AppStateInitial();
  UserDetailState get userState => _userState;

  String _friendshipStatus = 'none'; // 'none', 'pending', 'friends'
  String get friendshipStatus => _friendshipStatus;

  bool _isDisposed = false;

  UserDetailViewModel({ChatRemoteSource? remoteSource})
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

  /// Memuat informasi detail profil mahasiswa dan status relasi pertemanan
  Future<void> loadUserDetail(String userId) async {
    _userState = const AppStateLoading(message: 'Memuat profil pengguna...');
    notifyListeners();

    try {
      // Ambil status pertemanan
      _friendshipStatus = await _remoteSource.getFriendshipStatus(userId);

      // Cari atau bentuk UserProfileModel untuk userId terkait
      final profile = _resolveUserProfile(userId);
      _userState = AppStateSuccess(data: profile);
    } catch (e) {
      _userState = AppStateError(
        message: 'Gagal memuat profil: ${e.toString()}',
        error: e,
      );
    } finally {
      notifyListeners();
    }
  }

  /// Menangani penambahan, pembatalan, atau perubahan status pertemanan
  Future<void> toggleFriendship(String userId) async {
    final prevStatus = _friendshipStatus;
    try {
      // Optimistic update
      if (_friendshipStatus == 'none') {
        _friendshipStatus = 'pending';
      } else if (_friendshipStatus == 'pending') {
        _friendshipStatus = 'friends';
      } else {
        _friendshipStatus = 'none';
      }
      notifyListeners();

      final updatedStatus = await _remoteSource.toggleFriendship(userId);
      _friendshipStatus = updatedStatus;
    } catch (e) {
      _friendshipStatus = prevStatus;
      debugPrint('Error toggling friendship: $e');
    } finally {
      notifyListeners();
    }
  }

  static const Map<String, StudyBuddy> _mockSpotBuddies = {
    'b-1': StudyBuddy(
      id: 'b-1',
      name: 'Rian M.',
      avatarInitials: 'RM',
      campus: 'UAD',
      major: 'CS UI • Mobile Dev',
      semester: 'Semester 6',
      currentStudyTopic: 'Flutter & Android Development',
      isOnline: true,
      currentSpotName: 'Spot Belajar Kampus',
      mutualFriends: 7,
    ),
    'b-2': StudyBuddy(
      id: 'b-2',
      name: 'Sarah K.',
      avatarInitials: 'SK',
      campus: 'UAD',
      major: 'Sistem Informasi • Semester 5',
      semester: 'Semester 5',
      currentStudyTopic: 'Figma UI/UX & Deep Focus',
      isOnline: true,
      currentSpotName: 'Spot Belajar Kampus',
      mutualFriends: 12,
    ),
    'b-3': StudyBuddy(
      id: 'b-3',
      name: 'Dimas P.',
      avatarInitials: 'DP',
      campus: 'UAD',
      major: 'Teknik Komputer',
      semester: 'Semester 7',
      currentStudyTopic: 'Jaringan Komputer & Belajar Santai',
      isOnline: true,
      currentSpotName: 'Spot Belajar Kampus',
      mutualFriends: 5,
    ),
    'b-4': StudyBuddy(
      id: 'b-4',
      name: 'Nadia S.',
      avatarInitials: 'NS',
      campus: 'UAD',
      major: 'Manajemen Bisnis • Semester 3',
      semester: 'Semester 3',
      currentStudyTopic: 'Analisis Kasus Pemasaran',
      isOnline: true,
      currentSpotName: 'Spot Belajar Kampus',
      mutualFriends: 9,
    ),
    'b-5': StudyBuddy(
      id: 'b-5',
      name: 'Alif Fathur',
      avatarInitials: 'AF',
      campus: 'UAD',
      major: 'Informatika • Semester 7',
      semester: 'Semester 7',
      currentStudyTopic: 'Algoritma & Struktur Data',
      isOnline: true,
      currentSpotName: 'Spot Belajar Kampus',
      mutualFriends: 14,
    ),
    'b-6': StudyBuddy(
      id: 'b-6',
      name: 'Clara Devina',
      avatarInitials: 'CD',
      campus: 'UAD',
      major: 'Statistika • Semester 5',
      semester: 'Semester 5',
      currentStudyTopic: 'Data Science & Python',
      isOnline: true,
      currentSpotName: 'Spot Belajar Kampus',
      mutualFriends: 8,
    ),
    'b-7': StudyBuddy(
      id: 'b-7',
      name: 'Kevin Sanjaya',
      avatarInitials: 'KS',
      campus: 'UAD',
      major: 'Ilmu Komunikasi',
      semester: 'Semester 5',
      currentStudyTopic: 'Media Digital & Produksi Konten',
      isOnline: true,
      currentSpotName: 'Spot Belajar Kampus',
      mutualFriends: 6,
    ),
    'b-8': StudyBuddy(
      id: 'b-8',
      name: 'Alya Putri',
      avatarInitials: 'AP',
      campus: 'UAD',
      major: 'Psikologi 2022',
      semester: 'Semester 5',
      currentStudyTopic: 'Review Jurnal Kognitif',
      isOnline: true,
      currentSpotName: 'Spot Belajar Kampus',
      mutualFriends: 11,
    ),
  };

  /// Memetakan StudyBuddy ke dalam UserProfileModel lengkap
  UserProfileModel _resolveUserProfile(String userId) {
    StudyBuddy? buddy;
    try {
      buddy = MockData.buddies.firstWhere((b) => b.id == userId);
    } catch (_) {
      try {
        final req = MockData.requests.where((r) => r.sender.id == userId);
        if (req.isNotEmpty) buddy = req.first.sender;
      } catch (_) {}
    }

    buddy ??= _mockSpotBuddies[userId];

    if (buddy != null) {
      final safeHandle = buddy.name.toLowerCase().replaceAll(' ', '_').replaceAll('.', '');
      return UserProfileModel(
        id: buddy.id,
        name: buddy.name,
        username: '@$safeHandle',
        nim: '210608${buddy.id.hashCode.abs() % 10000}',
        campus: buddy.campus == 'UAD' ? 'Universitas Ahmad Dahlan' : buddy.campus,
        campusBranch: 'Kampus 4 UAD - Yogyakarta',
        major: buddy.major,
        academicYear: '2022',
        email: '${safeHandle.split('_').first}@webmail.uad.ac.id',
        bio: 'Mahasiswa aktif ${buddy.major}. Fokus topik: ${buddy.currentStudyTopic}. Sedang belajar di ${buddy.currentSpotName}.',
        interests: const [
          'Algoritma & Struktur Data',
          'Flutter Mobile Dev',
          'UI/UX Design',
          'Machine Learning',
        ],
        isMapVisible: true,
        photoUrl: null,
        totalFocusHours: 38.5,
        completedSessions: 26,
        connectedBuddies: buddy.mutualFriends > 0 ? buddy.mutualFriends : 8,
        isGhostMode: buddy.isGhostMode,
        focusPreference: 'Kolaborasi & Diskusi Santai',
      );
    }

    // Default fallback profile
    return UserProfileModel(
      id: userId,
      name: 'Rian Pratama',
      username: '@rian_study',
      nim: '2106081290',
      campus: 'Universitas Ahmad Dahlan',
      campusBranch: 'Kampus 4 UAD - Yogyakarta',
      major: 'Teknik Komputer 2022',
      academicYear: '2022',
      email: 'rian.pratama@webmail.uad.ac.id',
      bio: 'Senang belajar pemrograman mobile dan jaringan komputer. Selalu terbuka untuk diskusi di perpus!',
      interests: const ['Flutter', 'Computer Networks', 'System Design'],
      isMapVisible: true,
      photoUrl: null,
      totalFocusHours: 42.0,
      completedSessions: 29,
      connectedBuddies: 11,
      isGhostMode: false,
      focusPreference: 'Suasana Tenang (Deep Focus)',
    );
  }
}
