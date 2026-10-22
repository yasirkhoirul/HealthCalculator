library;

/// Model dan data tiruan (Mock Data) untuk StudyMap / HangoutMap.
/// Berfungsi sebagai data realistis sebelum integrasi backend API/Firebase.

class StudySpot {
  final String id;
  final String name;
  final String category;
  final String campus;
  final String address;
  final double rating;
  final int distanceMeters;
  final int currentCapacity;
  final int maxCapacity;
  final List<String> facilities;
  final bool isPopular;
  final String openingHours;
  final double latitude;
  final double longitude;

  const StudySpot({
    required this.id,
    required this.name,
    required this.category,
    required this.campus,
    required this.address,
    required this.rating,
    required this.distanceMeters,
    required this.currentCapacity,
    required this.maxCapacity,
    required this.facilities,
    this.isPopular = false,
    required this.openingHours,
    required this.latitude,
    required this.longitude,
  });

  double get occupancyRatio =>
      maxCapacity > 0 ? (currentCapacity / maxCapacity).clamp(0.0, 1.0) : 0.0;

  int get availableSeats => (maxCapacity - currentCapacity).clamp(0, maxCapacity);
}

class StudyBuddy {
  final String id;
  final String name;
  final String avatarInitials;
  final String campus;
  final String major;
  final String semester;
  final String currentStudyTopic;
  final bool isOnline;
  final String currentSpotName;
  final bool isGhostMode;
  final int mutualFriends;

  const StudyBuddy({
    required this.id,
    required this.name,
    required this.avatarInitials,
    required this.campus,
    required this.major,
    required this.semester,
    required this.currentStudyTopic,
    required this.isOnline,
    required this.currentSpotName,
    this.isGhostMode = false,
    this.mutualFriends = 0,
  });
}

class StudyRequest {
  final String id;
  final StudyBuddy sender;
  final String note;
  final DateTime? timestamp;
  final String targetSubject;

  const StudyRequest({
    required this.id,
    required this.sender,
    required this.note,
    this.timestamp,
    required this.targetSubject,
  });
}

class StudySchedule {
  final String id;
  final String title;
  final String subject;
  final DateTime? date;
  final String timeRange;
  final String locationName;
  final int buddyCount;
  final String note;

  const StudySchedule({
    required this.id,
    required this.title,
    required this.subject,
    this.date,
    required this.timeRange,
    required this.locationName,
    required this.buddyCount,
    this.note = '',
  });
}

class UserProfile {
  final String id;
  final String name;
  final String nim;
  final String campus;
  final String major;
  final String email;
  final double totalFocusHours;
  final int completedSessions;
  final int connectedBuddies;
  final bool isGhostMode;
  final String focusPreference;

  const UserProfile({
    required this.id,
    required this.name,
    required this.nim,
    required this.campus,
    required this.major,
    required this.email,
    required this.totalFocusHours,
    required this.completedSessions,
    required this.connectedBuddies,
    this.isGhostMode = false,
    required this.focusPreference,
  });

  UserProfile copyWith({
    String? name,
    String? nim,
    String? campus,
    String? major,
    String? email,
    double? totalFocusHours,
    int? completedSessions,
    int? connectedBuddies,
    bool? isGhostMode,
    String? focusPreference,
  }) {
    return UserProfile(
      id: id,
      name: name ?? this.name,
      nim: nim ?? this.nim,
      campus: campus ?? this.campus,
      major: major ?? this.major,
      email: email ?? this.email,
      totalFocusHours: totalFocusHours ?? this.totalFocusHours,
      completedSessions: completedSessions ?? this.completedSessions,
      connectedBuddies: connectedBuddies ?? this.connectedBuddies,
      isGhostMode: isGhostMode ?? this.isGhostMode,
      focusPreference: focusPreference ?? this.focusPreference,
    );
  }
}

/// Kumpulan Data Tiruan (Mock Repository)
abstract class MockData {
  static const List<StudySpot> spots = [
    StudySpot(
      id: 'spot-1',
      name: 'Main Campus Library',
      category: 'Perpustakaan',
      campus: 'Universitas Indonesia',
      address: 'Gedung Crystal of Knowledge, Lt. 2-4',
      rating: 4.9,
      distanceMeters: 120,
      currentCapacity: 42,
      maxCapacity: 50,
      facilities: ['WiFi 100 Mbps', 'AC Dingin', 'Stopkontak', 'Ruang Hening', 'Kafe'],
      isPopular: true,
      openingHours: '08:00 - 21:00 WIB',
      latitude: -6.3653,
      longitude: 106.8286,
    ),
    StudySpot(
      id: 'spot-2',
      name: 'Student Hub & Co-Study',
      category: 'Coworking',
      campus: 'Universitas Indonesia',
      address: 'Pusat Kegiatan Mahasiswa Lt. 1',
      rating: 4.8,
      distanceMeters: 280,
      currentCapacity: 19,
      maxCapacity: 30,
      facilities: ['WiFi Cepat', 'Papan Tulis', 'Bisa Diskusi', 'Bean Bag', 'Dispenser'],
      isPopular: true,
      openingHours: '08:00 - 22:00 WIB',
      latitude: -6.3670,
      longitude: 106.8300,
    ),
    StudySpot(
      id: 'spot-3',
      name: 'Kantin Kopi & Belajar',
      category: 'Cafe Belajar',
      campus: 'Universitas Indonesia',
      address: 'Fakultas Teknik UI, Area Boulevard',
      rating: 4.7,
      distanceMeters: 390,
      currentCapacity: 24,
      maxCapacity: 35,
      facilities: ['Kopi & Snack', 'Semi-Outdoor', 'Stopkontak', 'Musik Santai'],
      isPopular: false,
      openingHours: '09:00 - 20:00 WIB',
      latitude: -6.3685,
      longitude: 106.8265,
    ),
    StudySpot(
      id: 'spot-4',
      name: 'Gazebo Danau Kenanga',
      category: 'Ruang Terbuka',
      campus: 'Universitas Indonesia',
      address: 'Area Hijau Tepi Danau Rektorat',
      rating: 4.6,
      distanceMeters: 450,
      currentCapacity: 8,
      maxCapacity: 16,
      facilities: ['Udara Segar', 'Meja Kayu', 'Pemandangan Danau', 'Suasana Tenang'],
      isPopular: false,
      openingHours: '24 Jam',
      latitude: -6.3640,
      longitude: 106.8315,
    ),
  ];

  static const List<StudyBuddy> buddies = [
    StudyBuddy(
      id: 'buddy-1',
      name: 'Alif Fathur R.',
      avatarInitials: 'AF',
      campus: 'UI',
      major: 'Ilmu Komputer 2021',
      semester: 'Semester 7',
      currentStudyTopic: 'Belajar Algoritma & Struktur Data',
      isOnline: true,
      currentSpotName: 'Main Campus Library',
      mutualFriends: 8,
    ),
    StudyBuddy(
      id: 'buddy-2',
      name: 'Sarah Jenkins',
      avatarInitials: 'SJ',
      campus: 'UI',
      major: 'Sistem Informasi 2022',
      semester: 'Semester 5',
      currentStudyTopic: 'UI/UX Design di Figma',
      isOnline: true,
      currentSpotName: 'Student Hub & Co-Study',
      mutualFriends: 12,
    ),
    StudyBuddy(
      id: 'buddy-3',
      name: 'Dimas Prasetyo',
      avatarInitials: 'DP',
      campus: 'UI',
      major: 'Teknik Elektro 2020',
      semester: 'Semester 7',
      currentStudyTopic: 'Persiapan Ujian Kalkulus II',
      isOnline: false,
      currentSpotName: 'Main Campus Library',
      mutualFriends: 4,
    ),
    StudyBuddy(
      id: 'buddy-4',
      name: 'Nadia Safitri',
      avatarInitials: 'NS',
      campus: 'UI',
      major: 'Manajemen Bisnis 2023',
      semester: 'Semester 3',
      currentStudyTopic: 'Analisis Studi Kasus Pemasaran',
      isOnline: true,
      currentSpotName: 'Kantin Kopi & Belajar',
      mutualFriends: 6,
    ),
  ];

  static const List<StudyRequest> requests = [
    StudyRequest(
      id: 'req-1',
      sender: StudyBuddy(
        id: 'buddy-5',
        name: 'Rian Pratama',
        avatarInitials: 'RP',
        campus: 'UI',
        major: 'Teknik Komputer 2022',
        semester: 'Semester 5',
        currentStudyTopic: 'Pemrograman Web Lanjut',
        isOnline: true,
        currentSpotName: 'Main Campus Library',
        mutualFriends: 5,
      ),
      note: 'Halo! Boleh gabung sesi belajar bareng di Perpus Pusat hari ini?',
      timestamp: null, // dihandle runtime
      targetSubject: 'Pemrograman Web (Flutter / React)',
    ),
    StudyRequest(
      id: 'req-2',
      sender: StudyBuddy(
        id: 'buddy-6',
        name: 'Clara Devina',
        avatarInitials: 'CD',
        campus: 'UI',
        major: 'Statistika 2022',
        semester: 'Semester 5',
        currentStudyTopic: 'Analisis Regresi Data',
        isOnline: true,
        currentSpotName: 'Student Hub & Co-Study',
        mutualFriends: 3,
      ),
      note: 'Yuk belajar bareng untuk persiapan kuis besok pagi.',
      timestamp: null,
      targetSubject: 'Statistika Inferensial',
    ),
  ];

  static const List<StudySchedule> schedules = [
    StudySchedule(
      id: 'sch-1',
      title: 'Sprint Tugas Akhir & Pemrograman',
      subject: 'Mobile Application Engineering',
      date: null,
      timeRange: '15:30 - 17:30 WIB',
      locationName: 'Main Campus Library - Lt. 3',
      buddyCount: 4,
      note: 'Bawa charger dan kabel ekstensi jika diperlukan.',
    ),
    StudySchedule(
      id: 'sch-2',
      title: 'Diskusi Kelompok UI/UX Design System',
      subject: 'Human Computer Interaction',
      date: null,
      timeRange: '19:00 - 21:00 WIB',
      locationName: 'Student Hub & Co-Study',
      buddyCount: 3,
      note: 'Review wireframe dan user persona.',
    ),
  ];

  static const UserProfile currentUser = UserProfile(
    id: 'user-me',
    name: 'Raihan Ridho Mubarok',
    nim: '2106081234',
    campus: 'Universitas Indonesia',
    major: 'Teknik Informatika (S1)',
    email: 'raihan.ridho@ui.ac.id',
    totalFocusHours: 48.5,
    completedSessions: 32,
    connectedBuddies: 18,
    isGhostMode: false,
    focusPreference: 'Suasana Tenang (Deep Focus)',
  );
}
