import 'package:json_annotation/json_annotation.dart';

part 'spot_model.g.dart';

/// Model data untuk Spot Belajar Kampus (Campus Study Spot)
/// Memuat informasi jarak, kuota meja, status keramaian, fasilitas, dan rating.
@JsonSerializable(explicitToJson: true)
class SpotModel {
  final String id;
  final String name;
  final String category;
  final String subtitle;
  final int distanceInMeters;
  final String crowdStatus;
  final String crowdLevel;
  final String friendsSummary;
  final int friendsCount;
  final int openDesks;
  final int totalDesks;
  final double rating;
  final String? imageUrl;
  final double latitude;
  final double longitude;
  final bool isOpen;
  final String vibe;
  final String? powerOutletStatus;
  final double? virtualX;
  final double? virtualY;

  const SpotModel({
    required this.id,
    required this.name,
    required this.category,
    required this.subtitle,
    required this.distanceInMeters,
    required this.crowdStatus,
    required this.crowdLevel,
    required this.friendsSummary,
    this.friendsCount = 0,
    this.openDesks = 0,
    this.totalDesks = 0,
    this.rating = 4.8,
    this.imageUrl,
    required this.latitude,
    required this.longitude,
    this.isOpen = true,
    this.vibe = 'All Vibe',
    this.powerOutletStatus,
    this.virtualX,
    this.virtualY,
  });

  /// Format teks jarak yang mudah dibaca (misal: "120m", "350m", "1.2km")
  String get formattedDistance {
    if (distanceInMeters >= 1000) {
      final km = (distanceInMeters / 1000).toStringAsFixed(1);
      return '${km}km';
    }
    return '${distanceInMeters}m';
  }

  /// Rasio keterisian meja (0.0 - 1.0)
  double get occupancyRatio {
    if (totalDesks <= 0) return 0.5;
    return (1.0 - (openDesks / totalDesks)).clamp(0.0, 1.0);
  }

  factory SpotModel.fromJson(Map<String, dynamic> json) =>
      _$SpotModelFromJson(json);

  Map<String, dynamic> toJson() => _$SpotModelToJson(this);

  SpotModel copyWith({
    String? id,
    String? name,
    String? category,
    String? subtitle,
    int? distanceInMeters,
    String? crowdStatus,
    String? crowdLevel,
    String? friendsSummary,
    int? friendsCount,
    int? openDesks,
    int? totalDesks,
    double? rating,
    String? imageUrl,
    double? latitude,
    double? longitude,
    bool? isOpen,
    String? vibe,
    String? powerOutletStatus,
    double? virtualX,
    double? virtualY,
  }) {
    return SpotModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      subtitle: subtitle ?? this.subtitle,
      distanceInMeters: distanceInMeters ?? this.distanceInMeters,
      crowdStatus: crowdStatus ?? this.crowdStatus,
      crowdLevel: crowdLevel ?? this.crowdLevel,
      friendsSummary: friendsSummary ?? this.friendsSummary,
      friendsCount: friendsCount ?? this.friendsCount,
      openDesks: openDesks ?? this.openDesks,
      totalDesks: totalDesks ?? this.totalDesks,
      rating: rating ?? this.rating,
      imageUrl: imageUrl ?? this.imageUrl,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isOpen: isOpen ?? this.isOpen,
      vibe: vibe ?? this.vibe,
      powerOutletStatus: powerOutletStatus ?? this.powerOutletStatus,
      virtualX: virtualX ?? this.virtualX,
      virtualY: virtualY ?? this.virtualY,
    );
  }

  /// Preset mock data spot kampus sesuai referensi desain UI (image_3.png)
  static List<SpotModel> get defaultSpots => const [
        SpotModel(
          id: 'spot-1',
          name: 'Main Library (Floor 2)',
          category: 'Library',
          subtitle: 'Silent Zone • Power outlets at 90%',
          distanceInMeters: 350,
          crowdStatus: '14 Desks Open',
          crowdLevel: 'Silent Zone',
          friendsSummary: '28 friends nearby',
          friendsCount: 28,
          openDesks: 14,
          totalDesks: 60,
          rating: 4.9,
          imageUrl: 'https://images.unsplash.com/photo-1521587760476-6c12a4b040da?w=500&q=80',
          latitude: -6.3625,
          longitude: 106.8285,
          isOpen: true,
          vibe: 'All Vibe',
          powerOutletStatus: 'Power outlets at 90%',
        ),
        SpotModel(
          id: 'spot-2',
          name: 'Green House Roastery',
          category: 'Cafe/Roastery',
          subtitle: 'Buzzing • Lo-Fi Beats & Espresso',
          distanceInMeters: 720,
          crowdStatus: 'Moderate Crowd',
          crowdLevel: 'Moderate Crowd',
          friendsSummary: 'Maya & 5 others',
          friendsCount: 6,
          openDesks: 8,
          totalDesks: 24,
          rating: 4.7,
          imageUrl: 'https://images.unsplash.com/photo-1554118811-1e0d58224f24?w=500&q=80',
          latitude: -6.3655,
          longitude: 106.8310,
          isOpen: true,
          vibe: 'Coding',
        ),
        SpotModel(
          id: 'spot-3',
          name: 'Engineering Student Hub',
          category: 'Coworking',
          subtitle: 'Coding & Collaboration Lab',
          distanceInMeters: 120,
          crowdStatus: '6 Desks Open',
          crowdLevel: 'Moderate Crowd',
          friendsSummary: '12 friends nearby',
          friendsCount: 12,
          openDesks: 6,
          totalDesks: 30,
          rating: 4.8,
          imageUrl: 'https://images.unsplash.com/photo-1497366216548-37526070297c?w=500&q=80',
          latitude: -6.3610,
          longitude: 106.8260,
          isOpen: true,
          vibe: 'Coding',
        ),
        SpotModel(
          id: 'spot-4',
          name: 'Creative Studio Lab',
          category: 'Studio',
          subtitle: 'UI/UX Design Studio • Dual Monitors',
          distanceInMeters: 480,
          crowdStatus: 'Moderate Crowd',
          crowdLevel: 'Moderate Crowd',
          friendsSummary: '8 friends nearby',
          friendsCount: 8,
          openDesks: 10,
          totalDesks: 25,
          rating: 4.9,
          imageUrl: 'https://images.unsplash.com/photo-1522071820081-009f0129c71c?w=500&q=80',
          latitude: -6.3640,
          longitude: 106.8320,
          isOpen: true,
          vibe: 'UI/UX',
        ),
        SpotModel(
          id: 'spot-5',
          name: 'Vokasi Creative Coworking',
          category: 'Coworking',
          subtitle: 'Exam Prep & Group Study',
          distanceInMeters: 550,
          crowdStatus: '18 Desks Open',
          crowdLevel: 'Moderate Crowd',
          friendsSummary: '9 friends nearby',
          friendsCount: 9,
          openDesks: 18,
          totalDesks: 40,
          rating: 4.6,
          imageUrl: 'https://images.unsplash.com/photo-1527192491265-7e15c55b1ed2?w=500&q=80',
          latitude: -6.3670,
          longitude: 106.8250,
          isOpen: true,
          vibe: 'Exam Prep',
        ),
        SpotModel(
          id: 'spot-6',
          name: 'Perpustakaan Pusat Lt. 1',
          category: 'Library',
          subtitle: 'Academics & Deep Focus',
          distanceInMeters: 280,
          crowdStatus: 'Quiet',
          crowdLevel: 'Silent Zone',
          friendsSummary: '15 friends nearby',
          friendsCount: 15,
          openDesks: 22,
          totalDesks: 50,
          rating: 4.8,
          imageUrl: 'https://images.unsplash.com/photo-1568667256549-094345857637?w=500&q=80',
          latitude: -6.3620,
          longitude: 106.8280,
          isOpen: true,
          vibe: 'All Vibe',
        ),
        SpotModel(
          id: 'spot-7',
          name: 'Kantin Kopi & Diskusi',
          category: 'Cafe/Roastery',
          subtitle: 'Casual Study & Snack Break',
          distanceInMeters: 890,
          crowdStatus: 'Buzzing',
          crowdLevel: 'Buzzing',
          friendsSummary: '10 friends nearby',
          friendsCount: 10,
          openDesks: 4,
          totalDesks: 20,
          rating: 4.5,
          imageUrl: 'https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?w=500&q=80',
          latitude: -6.3690,
          longitude: 106.8330,
          isOpen: true,
          vibe: 'All Vibe',
        ),
        SpotModel(
          id: 'spot-8',
          name: 'Science Park Study Pods',
          category: 'Study Pod',
          subtitle: 'Ultra Silent Focus Pods',
          distanceInMeters: 1050,
          crowdStatus: '4 Desks Open',
          crowdLevel: 'Silent Zone',
          friendsSummary: '3 friends nearby',
          friendsCount: 3,
          openDesks: 4,
          totalDesks: 12,
          rating: 4.9,
          imageUrl: 'https://images.unsplash.com/photo-1517502884422-41eaead166d4?w=500&q=80',
          latitude: -6.3710,
          longitude: 106.8240,
          isOpen: true,
          vibe: 'Coding',
        ),
      ];
}
