import '../../../../core/mock/mock_data.dart';

/// Remote Data Source untuk fitur Profil Pengguna
class ProfileRemoteSource {
  Future<UserProfileModel> fetchProfile() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return MockData.currentUser;
  }

  Future<bool> updateProfile(UserProfileModel profile) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return true;
  }
}
