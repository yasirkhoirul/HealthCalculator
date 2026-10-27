import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constant/app_colors.dart';
import '../../../../core/mock/mock_data.dart';

/// Sub-route: /location-details/:id
/// Menampilkan informasi detail spot belajar atau profil rekan di lokasi
class LocationDetailsPage extends StatelessWidget {
  final String id;

  const LocationDetailsPage({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    final spot = MockData.spots.firstWhere(
      (s) => s.id == id,
      orElse: () => MockData.spots.first,
    );

    final surfaceColor = AppColors.surfaceOf(context);
    final borderColor = AppColors.borderOf(context);
    final borderSubtleColor = AppColors.borderSubtleOf(context);
    final textPrimaryColor = AppColors.textPrimaryOf(context);
    final textSecondaryColor = AppColors.textSecondaryOf(context);
    final textBodyColor = AppColors.textBodyOf(context);
    final primaryColor = AppColors.primaryOf(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      appBar: AppBar(
        backgroundColor: surfaceColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: textPrimaryColor),
          onPressed: () => context.pop(),
        ),
        title: Text(
          spot.name,
          style: TextStyle(
            color: textPrimaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.bookmark_border_rounded, color: primaryColor),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Disimpan ke spot favorit'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. Spot Header Banner
          Container(
            height: 180,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryColor, AppColors.studentAvatarPurple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withValues(alpha: 0.25),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -20,
                  bottom: -20,
                  child: Icon(
                    Icons.school_rounded,
                    size: 160,
                    color: Colors.white.withValues(alpha: 0.12),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          spot.category,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        spot.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color: Colors.white70,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '${spot.address} • ${spot.distanceMeters}m',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // 2. Capacity & Realtime Occupancy
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: borderSubtleColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Kapasitas Kursi Real-Time',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: textPrimaryColor,
                      ),
                    ),
                    Text(
                      '${spot.currentCapacity} / ${spot.maxCapacity} Terisi',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: spot.occupancyRatio,
                    minHeight: 10,
                    backgroundColor: borderColor,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      spot.occupancyRatio > 0.85
                          ? AppColors.error
                          : primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tersedia ${spot.availableSeats} kursi kosong untuk belajar saat ini.',
                  style: TextStyle(
                    fontSize: 12,
                    color: textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // 3. Operating Hours & Campus
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: borderSubtleColor),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      color: primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Jam Operasional Kampus',
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: textPrimaryColor,
                            ),
                          ),
                          Text(
                            spot.openingHours,
                            style: TextStyle(
                              fontSize: 12,
                              color: textSecondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(height: 20, color: borderSubtleColor),
                Row(
                  children: [
                    Icon(
                      Icons.domain_rounded,
                      color: primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Afiliasi Kampus',
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: textPrimaryColor,
                            ),
                          ),
                          Text(
                            spot.campus,
                            style: TextStyle(
                              fontSize: 12,
                              color: textSecondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // 4. Facilities List
          Text(
            'Fasilitas Spot Belajar',
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
              color: textPrimaryColor,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: spot.facilities.map((facility) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle_outline_rounded,
                      size: 16,
                      color: AppColors.successGreen,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      facility,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: textBodyColor,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 28),

          // 5. Booking / Join Action Button
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Memulai sesi belajar di ${spot.name}'),
                  duration: const Duration(seconds: 1),
                ),
              );
              context.pop();
            },
            icon: const Icon(Icons.flash_on_rounded, color: Colors.white),
            label: const Text(
              'Mulai Sesi Belajar di Sini',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.5,
                fontWeight: FontWeight.w700,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              elevation: 0,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
