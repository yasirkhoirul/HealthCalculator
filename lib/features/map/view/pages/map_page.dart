import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constant/app_colors.dart';
import '../../../../core/mock/mock_data.dart';
import '../../../../router/app_router.dart';
import '../viewmodels/study_map_provider.dart';

/// Tab 1: Map / Beranda StudyMap
/// Menampilkan peta visual kampus, filter spot belajar, pin avatar rekan,
/// serta bottom sheet spot rekomendasi.
class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mapProvider = context.watch<StudyMapProvider>();
    final selectedSpot = mapProvider.selectedSpot;
    final spots = mapProvider.filteredSpots;

    return Scaffold(
      backgroundColor: const Color(0xFFE5ECF6), // Map background tone
      body: Stack(
        children: [
          // 1. Interactive Mock Campus Map Canvas
          _buildMapCanvas(spots, selectedSpot, mapProvider),

          // 2. Top Header (Search Bar & Campus Filter)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSearchBar(mapProvider),
                  const SizedBox(height: 10),
                  _buildFilterChips(mapProvider),
                ],
              ),
            ),
          ),

          // 3. Floating Action Buttons (My Location & Create Room)
          Positioned(
            right: 16,
            bottom: mapProvider.isBottomSheetOpen ? 240 : 20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildFloatingButton(
                  icon: Icons.my_location_rounded,
                  tooltip: 'Lokasi Saya',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Memusatkan ke lokasi Anda di kampus UI'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                _buildFloatingButton(
                  icon: Icons.add_rounded,
                  tooltip: 'Buat Ruang Belajar',
                  isPrimary: true,
                  onPressed: () => context.pushNamed(AppRouter.createRoom),
                ),
              ],
            ),
          ),

          // 4. Recommendation / Selected Spot Bottom Sheet
          if (mapProvider.isBottomSheetOpen && selectedSpot != null)
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: _buildSpotCard(context, selectedSpot, mapProvider),
            ),
        ],
      ),
    );
  }

  Widget _buildMapCanvas(
    List<StudySpot> spots,
    StudySpot? selectedSpot,
    StudyMapProvider mapProvider,
  ) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () {
          // Tap background
        },
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFE8EFF8), Color(0xFFDFE9F5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              // Stylized Campus Roads & Buildings
              CustomPaint(
                size: Size.infinite,
                painter: _CampusMapPainter(),
              ),

              // Interactive Study Spot Markers
              ...spots.asMap().entries.map((entry) {
                final index = entry.key;
                final spot = entry.value;
                final isSelected = selectedSpot?.id == spot.id;

                // Fixed realistic relative coordinates on campus canvas
                final positions = [
                  const Offset(0.32, 0.46),
                  const Offset(0.68, 0.38),
                  const Offset(0.48, 0.65),
                  const Offset(0.22, 0.68),
                ];
                final pos = positions[index % positions.length];

                return LayoutBuilder(
                  builder: (context, constraints) {
                    return Positioned(
                      left: constraints.maxWidth * pos.dx - 28,
                      top: constraints.maxHeight * pos.dy - 32,
                      child: GestureDetector(
                        onTap: () => mapProvider.selectSpot(spot),
                        child: _SpotMarkerPin(
                          spot: spot,
                          isSelected: isSelected,
                        ),
                      ),
                    );
                  },
                );
              }),

              // Student Presence Avatars (Zenly style)
              LayoutBuilder(
                builder: (context, constraints) {
                  return Positioned(
                    left: constraints.maxWidth * 0.42,
                    top: constraints.maxHeight * 0.42,
                    child: _StudentAvatarPin(
                      initials: 'AF',
                      label: 'Alif F.',
                      statusColor: AppColors.activeGreen,
                    ),
                  );
                },
              ),
              LayoutBuilder(
                builder: (context, constraints) {
                  return Positioned(
                    left: constraints.maxWidth * 0.62,
                    top: constraints.maxHeight * 0.52,
                    child: _StudentAvatarPin(
                      initials: 'SJ',
                      label: 'Sarah J.',
                      statusColor: AppColors.primary,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(StudyMapProvider mapProvider) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: mapProvider.updateSearchQuery,
        decoration: InputDecoration(
          hintText: 'Cari perpustakaan, kafe, atau ruang belajar...',
          hintStyle: const TextStyle(
            fontSize: 13.5,
            color: AppColors.textMuted,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.primary,
            size: 22,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded, size: 18),
                  onPressed: () {
                    _searchController.clear();
                    mapProvider.updateSearchQuery('');
                  },
                )
              : const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Icon(
                    Icons.tune_rounded,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips(StudyMapProvider mapProvider) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: mapProvider.categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = mapProvider.categories[index];
          final isSelected = mapProvider.selectedCategory == cat;

          return FilterChip(
            label: Text(cat),
            selected: isSelected,
            onSelected: (_) => mapProvider.selectCategory(cat),
            backgroundColor: AppColors.surface,
            selectedColor: AppColors.primary,
            checkmarkColor: Colors.white,
            labelStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : AppColors.textBody,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(19),
              side: BorderSide(
                color: isSelected ? AppColors.primary : AppColors.border,
                width: 1,
              ),
            ),
            elevation: isSelected ? 4 : 1,
            shadowColor: AppColors.primary.withValues(alpha: 0.25),
          );
        },
      ),
    );
  }

  Widget _buildFloatingButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
    bool isPrimary = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isPrimary ? AppColors.primary : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (isPrimary ? AppColors.primary : Colors.black)
                .withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: isPrimary ? Colors.white : AppColors.textPrimary,
          size: 22,
        ),
        tooltip: tooltip,
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildSpotCard(
    BuildContext context,
    StudySpot spot,
    StudyMapProvider mapProvider,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row Header: Name, Distance, Close Button
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.local_library_rounded,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            spot.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.successLight,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                color: AppColors.successGreen,
                                size: 14,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                '${spot.rating}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.successGreen,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${spot.category} • ${spot.distanceMeters}m dari lokasimu',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.close_rounded,
                  size: 20,
                  color: AppColors.textMuted,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: mapProvider.closeBottomSheet,
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Occupancy & Capacity Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Kapasitas: ${spot.currentCapacity}/${spot.maxCapacity} Kursi',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textBody,
                ),
              ),
              Text(
                'Sisa ${spot.availableSeats} kursi',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: spot.availableSeats > 10
                      ? AppColors.successGreen
                      : AppColors.error,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: spot.occupancyRatio,
              minHeight: 8,
              backgroundColor: AppColors.border,
              valueColor: AlwaysStoppedAnimation<Color>(
                spot.occupancyRatio > 0.85
                    ? AppColors.error
                    : AppColors.primary,
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Buddies studying here
          Row(
            children: [
              _buildAvatarStack(),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Alif, Sarah & 3 rekan belajar di sini',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Action Buttons: View Details & Knock/Join
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    context.pushNamed(
                      AppRouter.locationDetails,
                      pathParameters: {'id': spot.id},
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    side: const BorderSide(color: AppColors.primary),
                  ),
                  child: const Text(
                    'Lihat Detail',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Mengetuk (Knock) di ${spot.name}...'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.waving_hand_rounded,
                    size: 16,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Knock / Join',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarStack() {
    final initials = ['AF', 'SJ', 'DP'];
    return SizedBox(
      width: 58,
      height: 26,
      child: Stack(
        children: [
          for (int i = 0; i < initials.length; i++)
            Positioned(
              left: i * 16.0,
              child: Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: i == 0
                      ? AppColors.studentAvatarPurple
                      : i == 1
                          ? AppColors.studentAvatarOlive
                          : AppColors.studentAvatarSlate,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Center(
                  child: Text(
                    initials[i],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SpotMarkerPin extends StatelessWidget {
  final StudySpot spot;
  final bool isSelected;

  const _SpotMarkerPin({
    required this.spot,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: (isSelected ? AppColors.primary : Colors.black)
                    .withValues(alpha: 0.25),
                blurRadius: isSelected ? 14 : 8,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: isSelected ? Colors.white : AppColors.primary,
              width: 2,
            ),
          ),
          child: Icon(
            Icons.school_rounded,
            size: isSelected ? 22 : 18,
            color: isSelected ? Colors.white : AppColors.primary,
          ),
        ),
        const SizedBox(height: 2),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 4,
              ),
            ],
          ),
          child: Text(
            spot.name,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

class _StudentAvatarPin extends StatelessWidget {
  final String initials;
  final String label;
  final Color statusColor;

  const _StudentAvatarPin({
    required this.initials,
    required this.label,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.studentAvatarPurple],
                ),
                border: Border.all(color: Colors.white, width: 2.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

/// Custom Painter yang menggambar denah jalan dan taman kampus bergaya modern Zenly
class _CampusMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 26
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final roadBorderPaint = Paint()
      ..color = const Color(0xFFCAD7E8)
      ..strokeWidth = 30
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final parkPaint = Paint()
      ..color = const Color(0xFFD4E8DC)
      ..style = PaintingStyle.fill;

    // Parks / Green zones
    final parkPath1 = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(size.width * 0.1, size.height * 0.2, 140, 110),
          const Radius.circular(24),
        ),
      );
    canvas.drawPath(parkPath1, parkPaint);

    final parkPath2 = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(size.width * 0.55, size.height * 0.55, 160, 120),
          const Radius.circular(28),
        ),
      );
    canvas.drawPath(parkPath2, parkPaint);

    // Lake / Water zone (Danau UI)
    final lakePaint = Paint()
      ..color = const Color(0xFFC7DEFA)
      ..style = PaintingStyle.fill;
    final lakePath = Path()
      ..addOval(
        Rect.fromLTWH(size.width * 0.15, size.height * 0.58, 120, 80),
      );
    canvas.drawPath(lakePath, lakePaint);

    // Main Boulevard Road
    final roadPath = Path()
      ..moveTo(-20, size.height * 0.45)
      ..cubicTo(
        size.width * 0.35,
        size.height * 0.40,
        size.width * 0.65,
        size.height * 0.55,
        size.width + 20,
        size.height * 0.48,
      );

    // Diagonal Campus Avenue
    final crossRoad = Path()
      ..moveTo(size.width * 0.45, -20)
      ..lineTo(size.width * 0.55, size.height + 20);

    canvas.drawPath(roadPath, roadBorderPaint);
    canvas.drawPath(roadPath, roadPaint);

    canvas.drawPath(crossRoad, roadBorderPaint);
    canvas.drawPath(crossRoad, roadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
