import 'package:flutter/foundation.dart';
import '../../../../core/mock/mock_data.dart';

/// ViewModel / Provider untuk Pengaturan & Profil Mahasiswa
class ProfileProvider extends ChangeNotifier {
  UserProfile _user = MockData.currentUser;
  bool _allowNearbyKnock = true;
  bool _soundEffectsEnabled = true;

  UserProfile get user => _user;
  bool get isGhostMode => _user.isGhostMode;
  bool get allowNearbyKnock => _allowNearbyKnock;
  bool get soundEffectsEnabled => _soundEffectsEnabled;

  void toggleGhostMode() {
    _user = _user.copyWith(isGhostMode: !_user.isGhostMode);
    notifyListeners();
  }

  void toggleAllowNearbyKnock() {
    _allowNearbyKnock = !_allowNearbyKnock;
    notifyListeners();
  }

  void toggleSoundEffects() {
    _soundEffectsEnabled = !_soundEffectsEnabled;
    notifyListeners();
  }

  void setFocusPreference(String pref) {
    _user = _user.copyWith(focusPreference: pref);
    notifyListeners();
  }
}
