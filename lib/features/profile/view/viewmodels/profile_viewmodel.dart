import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import '../../../../core/constant/app_base_state.dart';
import '../../../../core/mock/mock_data.dart';

typedef ProfileState = AppBaseState<UserProfileModel>;

/// ViewModel utama untuk fitur Profil & Pengaturan (StudyMap)
/// Mengimplementasikan MVVM murni dengan AppBaseState generic.
class ProfileViewModel extends ChangeNotifier {
  ProfileState _state = const AppStateInitial();
  ProfileState get state => _state;

  UserProfileModel _user = MockData.currentUser;
  UserProfileModel get user => _user;
  UserProfileModel? get currentProfile => _state.dataOrNull ?? _user;

  // Preferensi Pengaturan Sistem
  bool _allowNearbyKnock = true;
  bool _soundEffectsEnabled = true;
  bool _isDisposed = false;

  bool get isGhostMode => _user.isGhostMode;
  bool get allowNearbyKnock => _allowNearbyKnock;
  bool get soundEffectsEnabled => _soundEffectsEnabled;
  bool get isLoading => _state.isLoading;

  ProfileViewModel() {
    loadUserProfile();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  /// Menghindari error "setState() or markNeedsBuild() called during build"
  /// dan mencegah pemanggilan setelah ChangeNotifier di-dispose.
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

  /// Memuat profil pengguna saat inisialisasi
  Future<void> loadUserProfile() async {
    _state = const AppStateLoading(message: 'Memuat profil...');
    notifyListeners();

    try {
      await Future<void>.delayed(const Duration(milliseconds: 250));
      if (_isDisposed) return;
      _state = AppStateSuccess(
        data: _user,
        message: 'Data profil berhasil dimuat',
      );
      notifyListeners();
    } catch (e) {
      if (_isDisposed) return;
      _state = AppStateError(
        message: 'Gagal memuat profil: $e',
        error: e,
      );
      notifyListeners();
    }
  }

  /// Memperbarui data profil secara lengkap (dari Halaman Edit Profil)
  Future<bool> updateProfile(UserProfileModel updatedData) async {
    _state = const AppStateLoading(message: 'Menyimpan perubahan...');
    notifyListeners();

    try {
      await Future<void>.delayed(const Duration(milliseconds: 500));
      if (_isDisposed) return false;
      _user = updatedData;
      _state = AppStateSuccess(
        data: _user,
        message: 'Perubahan profil berhasil disimpan!',
      );
      notifyListeners();
      return true;
    } catch (e) {
      if (_isDisposed) return false;
      _state = AppStateError(
        message: 'Gagal menyimpan perubahan: $e',
        error: e,
      );
      notifyListeners();
      return false;
    }
  }

  /// Mengubah visibilitas di peta kampus
  void toggleMapVisibility(bool value) {
    _user = _user.copyWith(isMapVisible: value, isGhostMode: !value);
    _state = AppStateSuccess(data: _user);
    notifyListeners();
  }

  /// Toggle Mode Hantu (Ghost Mode)
  void toggleGhostMode() {
    final newGhostMode = !_user.isGhostMode;
    _user = _user.copyWith(
      isGhostMode: newGhostMode,
      isMapVisible: !newGhostMode,
    );
    _state = AppStateSuccess(data: _user);
    notifyListeners();
  }

  /// Toggle izin ketukan dari teman sekitar
  void toggleAllowNearbyKnock() {
    _allowNearbyKnock = !_allowNearbyKnock;
    notifyListeners();
  }

  /// Toggle efek suara aplikasi
  void toggleSoundEffects() {
    _soundEffectsEnabled = !_soundEffectsEnabled;
    notifyListeners();
  }

  /// Mengatur preferensi suasana fokus
  void setFocusPreference(String pref) {
    _user = _user.copyWith(focusPreference: pref);
    _state = AppStateSuccess(data: _user);
    notifyListeners();
  }

  /// Menambah minat belajar
  void addInterest(String interest) {
    final clean = interest.trim();
    if (clean.isEmpty) return;
    if (_user.interests.contains(clean)) return;

    final updatedInterests = List<String>.from(_user.interests)..add(clean);
    _user = _user.copyWith(interests: updatedInterests);
    _state = AppStateSuccess(data: _user);
    notifyListeners();
  }

  /// Menghapus minat belajar
  void removeInterest(String interest) {
    final updatedInterests = _user.interests.where((i) => i != interest).toList();
    _user = _user.copyWith(interests: updatedInterests);
    _state = AppStateSuccess(data: _user);
    notifyListeners();
  }
}

/// Typedef alias untuk backward compatibility
typedef ProfileProvider = ProfileViewModel;
typedef EditProfileViewModel = ProfileViewModel;
