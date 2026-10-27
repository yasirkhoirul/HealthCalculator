import '../models/study_status_model.dart';
import '../models/user_presence_model.dart';

/// Remote data source untuk data presensi pengguna aktif di peta kampus.
class MapRemoteSource {
  Future<UserPresenceModel> getMyLocation() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return UserPresenceModel(
      id: 'me',
      name: 'Saya',
      campus: 'Universitas Indonesia',
      major: 'Ilmu Komputer',
      currentSpotName: 'Main Campus Library Floor 2',
      currentTopic: 'Sistem Operasi & Jaringan',
      latitude: -6.3635,
      longitude: 106.8275,
      isOnline: true,
      isCurrentUser: true,
      status: StudyStatusModel.defaultStatus,
    );
  }

  Future<List<UserPresenceModel>> getNearbyUserPresences() async {
    // Simulasi latency jaringan
    await Future.delayed(const Duration(milliseconds: 100));

    return [
      UserPresenceModel(
        id: 'u-rian',
        name: 'Rian M.',
        campus: 'Universitas Indonesia',
        major: 'Mobile App Dev (Android)',
        currentSpotName: 'Perpustakaan Pusat',
        currentTopic: 'Python Dev',
        latitude: -6.3625,
        longitude: 106.8285,
        isOnline: true,
        status: StudyStatusModel(
          emoji: '🔥',
          label: 'Semangat',
          customMessage: 'Ngebut deadline praktikum',
          updatedAt: DateTime.now(),
        ),
      ),
      UserPresenceModel(
        id: 'b-1',
        name: 'Ahmad Farhan',
        campus: 'Fasilkom UI',
        major: 'Ilmu Komputer',
        currentSpotName: 'Perpustakaan Pusat Floor 2',
        currentTopic: 'Algoritma & Struktur Data',
        latitude: -6.3630,
        longitude: 106.8240,
        isOnline: true,
        status: StudyStatusModel(
          emoji: '🎯',
          label: 'Deep Focus',
          customMessage: 'Mode hening, no chat',
          updatedAt: DateTime.now(),
        ),
      ),
      UserPresenceModel(
        id: 'b-2',
        name: 'Sarah Jessica',
        campus: 'Fasilkom UI',
        major: 'Sistem Informasi',
        currentSpotName: 'Student Hub & Co-Study',
        currentTopic: 'Figma UI/UX Design',
        latitude: -6.3645,
        longitude: 106.8290,
        isOnline: true,
        status: StudyStatusModel(
          emoji: '☕',
          label: 'Santai',
          customMessage: 'Sambil ngopi latte',
          updatedAt: DateTime.now(),
        ),
      ),
      UserPresenceModel(
        id: 'b-3',
        name: 'Dimas Arya',
        campus: 'FT UI',
        major: 'Teknik Elektro',
        currentSpotName: 'Vokasi Creative Coworking',
        currentTopic: 'Embedded Systems & IoT',
        latitude: -6.3680,
        longitude: 106.8270,
        isOnline: false,
        status: StudyStatusModel(
          emoji: '😴',
          label: 'Butuh Kafein',
          customMessage: 'Ngantuk banget',
          updatedAt: DateTime.now(),
        ),
      ),
      UserPresenceModel(
        id: 'b-4',
        name: 'Dinda Kirana',
        campus: 'FPsi UI',
        major: 'Psikologi Klinis',
        currentSpotName: 'Kantin Kopi & Belajar',
        currentTopic: 'Persiapan Skripsi',
        latitude: -6.3650,
        longitude: 106.8310,
        isOnline: true,
        status: StudyStatusModel(
          emoji: '🤯',
          label: 'Pusing',
          customMessage: 'Revisi bab 4 mumet',
          updatedAt: DateTime.now(),
        ),
      ),
    ];
  }
}
