import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constant/app_colors.dart';
import '../../../../core/mock/mock_data.dart';
import '../../../../router/app_router.dart';
import '../viewmodels/study_map_provider.dart';

/// Halaman MapScreen lengkap dengan floating search bar, horizontal filter chips,
/// viewport peta kampus interaktif dengan marker pins, dan draggable/sliding bottom sheet.
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late final TextEditingController _searchController;
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _sheetController.dispose();
    super.dispose();
  }

  void _animateSheetTo(double size) {
    if (_sheetController.isAttached) {
      _sheetController.animateTo(
        size,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final mapProvider = context.watch<StudyMapProvider>();
    final selectedSpot = mapProvider.selectedSpot;
    final spots = mapProvider.filteredSpots;

    return Scaffold(
      backgroundColor: const Color(0xFFE5ECF6),
      body: Stack(
        children: [
          // ─── 1. Map Viewport (Interactive Campus Canvas with Mock Pins) ───
          _buildMapViewport(spots, selectedSpot, mapProvider),

          // ─── 2. Top Floating Section: Search Bar & Horizontal Filter Chips ───
          _buildTopFloatingSection(mapProvider),

          // ─── 3. Floating Action Buttons (My Location & Create Room) ───
          _buildFloatingActionButtons(context),

          // ─── 4. Interactive Draggable / Sliding Bottom Sheet ───
          if (selectedSpot != null && mapProvider.isBottomSheetOpen)
            _buildDraggableBottomSheet(context, selectedSpot, mapProvider),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // TOP SECTION: Floating Search Bar & Horizontal Filter Chips
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildTopFloatingSection(StudyMapProvider mapProvider) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Floating Search Bar
            Container(
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
                  hintText: 'Cari spot belajar...',
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
            ),

            const SizedBox(height: 10),

            // Horizontal Filter Chips: "All Spot", "Coworking", "Library", "Event/Meet"
            SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: mapProvider.categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final category = mapProvider.categories[index];
                  final isSelected = mapProvider.selectedCategory == category;

                  return FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (_) => mapProvider.selectCategory(category),
                    backgroundColor: AppColors.surface,
                    selectedColor: AppColors.primary,
                    checkmarkColor: Colors.white,
                    labelStyle: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : AppColors.textBody,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
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
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // MAP VIEWPORT: Interactive Campus Canvas with Mock Pins
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildMapViewport(
    List<StudySpot> spots,
    StudySpot? selectedSpot,
    StudyMapProvider mapProvider,
  ) {
    return Positioned.fill(
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
            // Canvas Denah Kampus Zenly-Style
            CustomPaint(
              size: Size.infinite,
              painter: _CampusMapPainter(),
            ),

            // Marker Pin Spot Belajar Kampus
            ...spots.asMap().entries.map((entry) {
              final index = entry.key;
              final spot = entry.value;
              final isSelected = selectedSpot?.id == spot.id;

              final positions = [
                const Offset(0.32, 0.44), // Main Campus Library Floor 2
                const Offset(0.68, 0.38), // Student Hub & Coworking
                const Offset(0.48, 0.65), // Engineering Event Hall
                const Offset(0.22, 0.68), // Vokasi Creative Coworking
              ];
              final pos = positions[index % positions.length];

              return LayoutBuilder(
                builder: (context, constraints) {
                  return Positioned(
                    left: constraints.maxWidth * pos.dx - 32,
                    top: constraints.maxHeight * pos.dy - 34,
                    child: GestureDetector(
                      onTap: () {
                        mapProvider.selectSpot(spot);
                        _animateSheetTo(0.32);
                      },
                      child: _SpotMarkerPin(
                        spot: spot,
                        isSelected: isSelected,
                      ),
                    ),
                  );
                },
              );
            }),

            // Mock Student Presence Pins (Zenly-style)
            LayoutBuilder(
              builder: (context, constraints) {
                return Positioned(
                  left: constraints.maxWidth * 0.42,
                  top: constraints.maxHeight * 0.40,
                  child: const _StudentAvatarPin(
                    initials: 'AF',
                    name: 'Alif F.',
                    statusTopic: 'Algoritma & Struktur Data',
                    statusColor: AppColors.activeGreen,
                  ),
                );
              },
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                return Positioned(
                  left: constraints.maxWidth * 0.62,
                  top: constraints.maxHeight * 0.50,
                  child: const _StudentAvatarPin(
                    initials: 'SJ',
                    name: 'Sarah J.',
                    statusTopic: 'Figma UI/UX Design',
                    statusColor: AppColors.primary,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // FLOATING BUTTONS: My Location & Create Room
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildFloatingActionButtons(BuildContext context) {
    return Positioned(
      right: 16,
      top: 150,
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
            icon: Icons.add_home_work_rounded,
            tooltip: 'Buat Ruang Belajar Baru',
            isPrimary: true,
            onPressed: () => context.pushNamed(AppRouter.createRoom),
          ),
        ],
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

  // ─────────────────────────────────────────────────────────────────────────
  // INTERACTIVE DRAGGABLE / SLIDING BOTTOM SHEET
  // Collapsed: Ringkasan Top Campus Spots
  // Expanded: Detail Fasilitas & Buddies in this Spot + Aksi
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildDraggableBottomSheet(
    BuildContext context,
    StudySpot spot,
    StudyMapProvider mapProvider,
  ) {
    final buddies = mapProvider.selectedSpotBuddies;

    return DraggableScrollableSheet(
      controller: _sheetController,
      initialChildSize: 0.30,
      minChildSize: 0.16,
      maxChildSize: 0.88,
      snap: true,
      snapSizes: const [0.16, 0.30, 0.88],
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 28,
                offset: const Offset(0, -6),
              ),
            ],
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            children: [
              // 1. Drag Handle Pill
              Center(
                child: Container(
                  width: 44,
                  height: 4.5,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // 2. Section Header: "Top Campus Spots" & Close Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          spot.category.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Top Campus Spot',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
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

              const SizedBox(height: 10),

              // 3. Spot Summary Card (State Default / Collapsed Focus)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.studentAvatarPurple],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      _getSpotIcon(spot.category),
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 14),
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
                                  fontSize: 16.5,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                  letterSpacing: -0.2,
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
                                    size: 13,
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
                          '${spot.address} • ${spot.distanceMeters}m dari Anda',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // 4. Capacity & Occupancy Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Kapasitas Kursi: ${spot.currentCapacity}/${spot.maxCapacity}',
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textBody,
                    ),
                  ),
                  Text(
                    'Tersisa ${spot.availableSeats} kursi',
                    style: TextStyle(
                      fontSize: 12.5,
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

              // 5. Buddies Summary Indicator
              Row(
                children: [
                  _buildMiniAvatarStack(buddies),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${buddies.length} rekan sedang aktif belajar di spot ini',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => _animateSheetTo(0.88),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Lihat Semua',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_up_rounded,
                          size: 16,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const Divider(height: 24, color: AppColors.borderSubtle),

              // ─────────────────────────────────────────────────────────────
              // 6. EXPANDED CONTENT: Facilities, Buddies List & Action CTA
              // ─────────────────────────────────────────────────────────────

              // Fasilitas Lengkap
              const Text(
                'Fasilitas Tersedia',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: spot.facilities.map((facility) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.cardSubtleBg,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.check_circle_outline_rounded,
                          size: 14,
                          color: AppColors.successGreen,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          facility,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textBody,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 22),

              // Buddies in this Spot Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Buddies in this Spot',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${buddies.length} Mahasiswa',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Daftar Mahasiswa Aktif di Spot
              ...buddies.map((buddy) => _buildBuddyItem(context, buddy)),

              const SizedBox(height: 24),

              // Action Buttons: Mulai Sesi & Lihat Detail Rute
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
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        side: const BorderSide(color: AppColors.primary),
                      ),
                      child: const Text(
                        'Halaman Detail',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Bergabung dan memulai sesi di ${spot.name}',
                            ),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                        context.goNamed(AppRouter.session);
                      },
                      icon: const Icon(
                        Icons.flash_on_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                      label: const Text(
                        'Mulai Sesi',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBuddyItem(BuildContext context, StudyBuddy buddy) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardSubtleBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.primaryLight,
                child: Text(
                  buddy.avatarInitials,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: buddy.isOnline
                        ? AppColors.activeGreen
                        : AppColors.textMuted,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  buddy.name,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  buddy.major,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  child: Text(
                    buddy.currentStudyTopic,
                    style: const TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Mengajak ${buddy.name} belajar bareng!'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Knock',
              style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniAvatarStack(List<StudyBuddy> buddies) {
    final displayBuddies = buddies.take(3).toList();
    return SizedBox(
      width: 48,
      height: 24,
      child: Stack(
        children: [
          for (int i = 0; i < displayBuddies.length; i++)
            Positioned(
              left: i * 14.0,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: i == 0
                      ? AppColors.studentAvatarPurple
                      : i == 1
                          ? AppColors.studentAvatarOlive
                          : AppColors.studentAvatarSlate,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
                child: Center(
                  child: Text(
                    displayBuddies[i].avatarInitials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8.5,
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

  IconData _getSpotIcon(String category) {
    switch (category.toLowerCase()) {
      case 'library':
        return Icons.local_library_rounded;
      case 'coworking':
        return Icons.laptop_chromebook_rounded;
      case 'event/meet':
        return Icons.event_seat_rounded;
      default:
        return Icons.school_rounded;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────
// CUSTOM PAINTER: Campus Map Canvas (Roads, Greenery, Lake)
// ─────────────────────────────────────────────────────────────────────────
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

    // Green campus zones
    final parkPath1 = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(size.width * 0.1, size.height * 0.22, 140, 110),
          const Radius.circular(24),
        ),
      );
    canvas.drawPath(parkPath1, parkPaint);

    final parkPath2 = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(size.width * 0.55, size.height * 0.52, 160, 120),
          const Radius.circular(28),
        ),
      );
    canvas.drawPath(parkPath2, parkPaint);

    // Lake / Water zone (Danau Kenanga UI)
    final lakePaint = Paint()
      ..color = const Color(0xFFC7DEFA)
      ..style = PaintingStyle.fill;
    final lakePath = Path()
      ..addOval(
        Rect.fromLTWH(size.width * 0.12, size.height * 0.58, 120, 80),
      );
    canvas.drawPath(lakePath, lakePaint);

    // Main Campus Boulevard
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

    // Cross Campus Avenue
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

// ─────────────────────────────────────────────────────────────────────────
// SPOT PIN & STUDENT AVATAR MARKERS
// ─────────────────────────────────────────────────────────────────────────
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
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: (isSelected ? AppColors.primary : Colors.black)
                    .withValues(alpha: 0.25),
                blurRadius: isSelected ? 16 : 8,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: isSelected ? Colors.white : AppColors.primary,
              width: 2.5,
            ),
          ),
          child: Icon(
            _getSpotIcon(spot.category),
            size: isSelected ? 24 : 18,
            color: isSelected ? Colors.white : AppColors.primary,
          ),
        ),
        const SizedBox(height: 3),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
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

  IconData _getSpotIcon(String category) {
    switch (category.toLowerCase()) {
      case 'library':
        return Icons.local_library_rounded;
      case 'coworking':
        return Icons.laptop_chromebook_rounded;
      case 'event/meet':
        return Icons.event_seat_rounded;
      default:
        return Icons.school_rounded;
    }
  }
}

class _StudentAvatarPin extends StatelessWidget {
  final String initials;
  final String name;
  final String statusTopic;
  final Color statusColor;

  const _StudentAvatarPin({
    required this.initials,
    required this.name,
    required this.statusTopic,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: '$name • $statusTopic',
      child: Column(
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
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 11,
                  height: 11,
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
              color: Colors.white.withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
