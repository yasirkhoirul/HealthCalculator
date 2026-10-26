import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:health_calculator/router/app_routes.dart';
import 'package:provider/provider.dart';
import '../../../../core/constant/app_base_state.dart';
import '../../../../core/constant/app_colors.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/mock/mock_data.dart';
import '../../data/models/spot_model.dart';
import '../../data/models/user_presence_model.dart';
import '../viewmodels/map_search_viewmodel.dart';
import '../viewmodels/map_viewmodel.dart';
import '../viewmodels/study_map_provider.dart';
import '../widgets/map_bottom_spots_sheet_widget.dart';
import '../widgets/map_interactive_pins_widget.dart';
import '../widgets/map_my_location_marker_widget.dart';
import '../widgets/map_search_filters_widget.dart';
import '../widgets/map_status_picker_bottom_sheet.dart';
import '../widgets/map_spot_marker_widget.dart';
import '../widgets/map_user_detail_bottom_sheet.dart';
import '../widgets/map_user_marker_widget.dart';
import '../widgets/search/map_search_overlay_widget.dart';
import '../widgets/spot_detail/spot_detail_bottom_sheet.dart';

/// Halaman MapScreen lengkap dengan gestur pinch-to-zoom murni, kalkulasi ukuran
/// marker konstan (Google Maps behavior), floating search bar, dan bottom sheet.
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with SingleTickerProviderStateMixin {
  static const double _sheetCollapsedSize = 0.12;
  static const double _sheetExpandedSize = 0.88;

  late final TextEditingController _searchController;
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();

  late final TransformationController _transformationController;
  late final AnimationController _recenterAnimationController;
  Animation<Matrix4>? _recenterMatrixAnimation;

  late final MapSearchViewModel _searchViewModel;
  bool _isSearchOverlayOpen = false;

  void _resetSheetToCollapsed() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _sheetController.isAttached) {
        _sheetController.animateTo(
          _sheetCollapsedSize,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(() {
      if (mounted) setState(() {});
    });

    _searchViewModel = locator.isRegistered<MapSearchViewModel>()
        ? locator<MapSearchViewModel>()
        : MapSearchViewModel();

    _transformationController = TransformationController();
    _transformationController.addListener(_onTransformationChanged);

    _recenterAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    )..addListener(() {
        if (_recenterMatrixAnimation != null) {
          _transformationController.value = _recenterMatrixAnimation!.value;
        }
      });
  }

  void _onTransformationChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _sheetController.dispose();
    _searchViewModel.dispose();
    _transformationController.removeListener(_onTransformationChanged);
    _transformationController.dispose();
    _recenterAnimationController.dispose();
    super.dispose();
  }

  void _handleSpotSelectedFromSearch(
    SpotModel spot,
    StudyMapProvider mapProvider,
    MapViewModel? mapVm,
  ) async {
    // 1. Simpan history
    _searchViewModel.addRecentSearch(spot.name);

    // 2. Tutup search overlay & unfocus
    FocusScope.of(context).unfocus();
    setState(() => _isSearchOverlayOpen = false);

    // 3. Pusatkan koordinat peta ke posisi spot
    mapVm?.animateToLocation(spot.latitude, spot.longitude);
    _animateToSpotLocation(spot);

    // 4. Update status spot terpilih di ViewModel & Provider
    mapVm?.selectSpot(spot);
    try {
      final matchingStudySpot = mapProvider.filteredSpots.firstWhere(
        (s) =>
            s.id == spot.id ||
            s.name.toLowerCase() == spot.name.toLowerCase(),
      );
      mapProvider.selectSpot(matchingStudySpot);
    } catch (_) {}

    // 5. Buka bottom sheet tunggal (Single Source of Truth)
    await SpotDetailBottomSheet.show(context, spot);

    // 6. Lifecycle & Dismiss: Bersihkan status pin aktif & tetapkan posisi balik bottom sheet
    if (mounted) {
      mapVm?.clearSelectedSpot();
      mapProvider.clearSelectedSpot();
      _resetSheetToCollapsed();
    }
  }

  void _handleSpotMarkerTapped(
    SpotModel spotModel,
    StudySpot studySpot,
    StudyMapProvider mapProvider,
    MapViewModel? mapVm,
  ) async {
    // 1. Panggil mapViewModel.selectSpot(spot)
    mapVm?.selectSpot(spotModel);
    mapProvider.selectSpot(studySpot);
    mapVm?.animateToLocation(spotModel.latitude, spotModel.longitude);
    _animateToSpotLocation(spotModel);

    // 2. Buka modal melalui SpotDetailBottomSheet.show(context, spot)
    await SpotDetailBottomSheet.show(context, spotModel);

    // 3. Lifecycle & Dismiss: Ketika modal ditutup, bersihkan status pin aktif & tetapkan posisi balik
    if (mounted) {
      mapVm?.clearSelectedSpot();
      mapProvider.clearSelectedSpot();
      _resetSheetToCollapsed();
    }
  }

  SpotModel _findSpotModel(StudySpot spot, MapViewModel? mapVm) {
    final spots = mapVm?.allSpots ?? SpotModel.defaultSpots;
    return spots.firstWhere(
      (s) =>
          s.id == spot.id ||
          s.name.toLowerCase() == spot.name.toLowerCase(),
      orElse: () => SpotModel(
        id: spot.id,
        name: spot.name,
        category: spot.category,
        subtitle: spot.address,
        distanceInMeters: spot.distanceMeters,
        crowdStatus: '${spot.availableSeats} Meja Tersedia',
        crowdLevel: spot.isPopular ? 'Moderate Crowd' : 'Silent Zone',
        friendsSummary: '3 friends nearby',
        latitude: spot.latitude,
        longitude: spot.longitude,
        rating: spot.rating,
        isOpen: true,
        openDesks: spot.availableSeats,
        totalDesks: spot.maxCapacity,
      ),
    ).copyWith(name: spot.name);
  }

  void _animateToSpotLocation(SpotModel spot) {
    final beginMatrix = _transformationController.value;
    final endMatrix = Matrix4.identity();

    _recenterMatrixAnimation = Matrix4Tween(
      begin: beginMatrix,
      end: endMatrix,
    ).animate(
      CurvedAnimation(
        parent: _recenterAnimationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _recenterAnimationController.reset();
    _recenterAnimationController.forward();
  }

  void _animateToUserLocation(MapViewModel? mapVm) {
    mapVm?.recenterToMyLocation();

    final beginMatrix = _transformationController.value;
    final endMatrix = Matrix4.identity();

    _recenterMatrixAnimation = Matrix4Tween(
      begin: beginMatrix,
      end: endMatrix,
    ).animate(
      CurvedAnimation(
        parent: _recenterAnimationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _recenterAnimationController.reset();
    _recenterAnimationController.forward();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Memusatkan ke lokasi Anda di ${mapVm?.myLocation?.currentSpotName ?? 'kampus UI'}',
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _showStatusPickerSheet(BuildContext context, MapViewModel mapVm) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MapStatusPickerBottomSheet(mapViewModel: mapVm),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mapProvider = context.watch<StudyMapProvider>();
    final selectedSpot = mapProvider.selectedSpot;
    final spots = mapProvider.filteredSpots;
    final isDark = AppColors.isDark(context);

    MapViewModel? mapVm;
    try {
      mapVm = context.watch<MapViewModel>();
    } catch (_) {
      if (locator.isRegistered<MapViewModel>()) {
        mapVm = locator<MapViewModel>();
      }
    }

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFE5ECF6),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final matrix = _transformationController.value;

          return Stack(
            fit: StackFit.expand,
            children: [
              // ─── 1. Map Viewport (Interactive Campus Canvas with Pure Pinch-To-Zoom & Pan) ───
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDark
                          ? const [Color(0xFF0F172A), Color(0xFF1E293B)]
                          : const [Color(0xFFE8EFF8), Color(0xFFDFE9F5)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: InteractiveViewer(
                    transformationController: _transformationController,
                    minScale: 0.75,
                    maxScale: 3.5,
                    boundaryMargin: const EdgeInsets.all(600),
                    clipBehavior: Clip.none,
                    child: SizedBox(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          mapVm?.clearSelectedUser();
                          mapVm?.clearSelectedSpot();
                          mapProvider.clearSelectedSpot();
                          _resetSheetToCollapsed();
                          FocusScope.of(context).unfocus();
                        },
                        child: CustomPaint(
                          size: Size(constraints.maxWidth, constraints.maxHeight),
                          painter: _CampusMapPainter(isDark: isDark),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // ─── 2. Pin & Marker (Ukuran Konstan di Layar / Scale-Invariant Google Maps Behavior) ───
              ..._buildScaleInvariantMarkers(
                context: context,
                constraints: constraints,
                matrix: matrix,
                spots: spots,
                selectedSpot: selectedSpot,
                mapProvider: mapProvider,
                mapVm: mapVm,
                isDark: isDark,
              ),

              // ─── 3. Fixed Viewport HUD Overlays ───
              // Compass Direction 'N' Control (Fixed HUD - Kiri Atas)
              Positioned(
                left: 16,
                top: 155,
                child: MapCompassControlWidget(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Kompas: Menghadap ke Utara (N)'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                ),
              ),

              // Floating Right Action Controls (Eye, Fire, Target GPS)
              Positioned(
                right: 16,
                top: 150,
                child: MapRightControlsStackWidget(
                  onEyeTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Visibilitas: Lokasi aktif terlihat teman'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  onFireTap: () {
                    mapVm?.setVibe('Coding');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Menampilkan Trending Study Vibe: Coding'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  onGpsTap: () => _animateToUserLocation(mapVm),
                ),
              ),

              // ─── 4. Floating Search Bar & Horizontal Filter Chips di Area Atas ───
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: MapSearchFiltersWidget(
                  mapViewModel: mapVm ?? locator<MapViewModel>(),
                  mapProvider: mapProvider,
                  onSearchTap: () => setState(() => _isSearchOverlayOpen = true),
                  onFilterTap: () => context.pushNamed(AppRoutes.topSpotsList),
                ),
              ),

              // ─── 5. Persistent Draggable Bottom Sheet (Top Campus Spots & View Map List) ───
              _buildDraggableBottomSheet(context, mapVm),

              // ─── 6. Smart Search Overlay View ───
              if (_isSearchOverlayOpen)
                Positioned.fill(
                  child: MapSearchOverlayWidget(
                    viewModel: _searchViewModel,
                    onClose: () => setState(() => _isSearchOverlayOpen = false),
                    onSpotSelected: (spot) {
                      _handleSpotSelectedFromSearch(spot, mapProvider, mapVm);
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // SCALE-INVARIANT MARKERS (GOOGLE MAPS BEHAVIOR)
  // Koordinat letak terproyeksi matriks transformasi, sementara dimensi visual
  // fisik marker (avatar, bubble, chip) tetap konstan di layar perangkat.
  // ─────────────────────────────────────────────────────────────────────────
  List<Widget> _buildScaleInvariantMarkers({
    required BuildContext context,
    required BoxConstraints constraints,
    required Matrix4 matrix,
    required List<StudySpot> spots,
    required StudySpot? selectedSpot,
    required StudyMapProvider mapProvider,
    required MapViewModel? mapVm,
    required bool isDark,
  }) {
    final users = mapVm?.presenceState.dataOrNull ?? const <UserPresenceModel>[];
    final userOffsets = [
      const Offset(0.15, 0.35),
      const Offset(0.38, 0.22),
      const Offset(0.64, 0.52),
      const Offset(0.18, 0.62),
      const Offset(0.72, 0.60),
    ];

    final markers = <Widget>[];

    // Helper untuk mengkalkulasi koordinat layar dari faktor posisi denah
    Offset toScreen(double factorX, double factorY) {
      final base = Offset(constraints.maxWidth * factorX, constraints.maxHeight * factorY);
      return MatrixUtils.transformPoint(matrix, base);
    }

    // 1. Pin 1: ⚡ Kotlin • 45m (Base: 0.16, 0.32)
    final p1 = toScreen(0.16, 0.32);
    markers.add(
      Positioned(
        left: p1.dx,
        top: p1.dy,
        child: MapKotlinPinWidget(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Sesi Kotlin: 45m • 84% kapasitas fokus'),
                duration: Duration(seconds: 1),
              ),
            );
          },
        ),
      ),
    );

    // 2. Pin 2: 👋 Studio • 3 buddies [HOT] (Base: 0.44, 0.18)
    final p2 = toScreen(0.44, 0.18);
    markers.add(
      Positioned(
        left: p2.dx,
        top: p2.dy,
        child: MapStudioHotPinWidget(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Studio: 3 buddies aktif (Trending HOT)'),
                duration: Duration(seconds: 1),
              ),
            );
          },
        ),
      ),
    );

    // 3. Pin 3: ☕ Calculus • Cafe Ada (Base: 0.60, 0.48)
    final p3 = toScreen(0.60, 0.48);
    markers.add(
      Positioned(
        left: p3.dx,
        top: p3.dy,
        child: MapCalculusCafePinWidget(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Calculus di Cafe Ada: Santai sambil ngopi'),
                duration: Duration(seconds: 1),
              ),
            );
          },
        ),
      ),
    );

    // 4. Presensi mahasiswa / pengguna lain (MapUserMarkerWidget)
    for (int i = 0; i < users.length; i++) {
      final user = users[i];
      final isSelected = mapVm?.selectedUser?.id == user.id;
      final offsetFactor = userOffsets[i % userOffsets.length];
      final screenPos = toScreen(offsetFactor.dx, offsetFactor.dy);

      markers.add(
        Positioned(
          left: screenPos.dx - 22,
          top: screenPos.dy - 22,
          child: MapUserMarkerWidget(
            user: user,
            isSelected: isSelected,
            onTap: () {
              mapVm?.selectUser(user);
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => MapUserDetailBottomSheet(user: user),
              ).whenComplete(() => mapVm?.clearSelectedUser());
            },
          ),
        ),
      );
    }

    // 5. Pin Lokasi Saya (Current User Location Pin dengan Pulsing Radar)
    if (mapVm?.myLocation != null) {
      final myPos = toScreen(0.50, 0.30);
      markers.add(
        Positioned(
          left: myPos.dx - 29,
          top: myPos.dy - 29,
          child: MapMyLocationMarkerWidget(
            user: mapVm!.myLocation!,
            onTap: () => _showStatusPickerSheet(context, mapVm),
          ),
        ),
      );
    }

    // 6. Marker Pin Spot Belajar Kampus
    final spotPositions = [
      const Offset(0.32, 0.44), // Main Campus Library Floor 2
      const Offset(0.68, 0.38), // Student Hub & Coworking
      const Offset(0.48, 0.65), // Engineering Event Hall
      const Offset(0.22, 0.68), // Vokasi Creative Coworking
    ];

    for (int i = 0; i < spots.length; i++) {
      final spot = spots[i];
      final isSelected = selectedSpot?.id == spot.id || mapVm?.selectedSpot?.id == spot.id;
      final posFactor = spotPositions[i % spotPositions.length];
      final screenPos = toScreen(posFactor.dx, posFactor.dy);
      final spotModel = _findSpotModel(spot, mapVm);

      markers.add(
        Positioned(
          left: screenPos.dx - 32,
          top: screenPos.dy - 34,
          child: MapSpotMarkerWidget(
            spot: spotModel,
            isSelected: isSelected,
            onTap: () => _handleSpotMarkerTapped(spotModel, spot, mapProvider, mapVm),
          ),
        ),
      );
    }

    return markers;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // INTERACTIVE DRAGGABLE / SLIDING BOTTOM SHEET
  // Collapsed: Ringkasan Top Campus Spots
  // Expanded: Detail Fasilitas & Buddies in this Spot + Aksi
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildDraggableBottomSheet(
    BuildContext context,
    MapViewModel? mapVm,
  ) {
    final isDark = AppColors.isDark(context);
    final surfaceColor = AppColors.surfaceOf(context);
    final borderColor = AppColors.borderOf(context);
    final primaryColor = AppColors.primaryOf(context);
    final textPrimaryColor = AppColors.textPrimaryOf(context);
    final textSecondaryColor = AppColors.textSecondaryOf(context);
    final currentLocationName =
        mapVm?.myLocation?.currentSpotName ?? 'Perpustakaan Pusat UAD';

    return DraggableScrollableSheet(
      controller: _sheetController,
      initialChildSize: _sheetCollapsedSize,
      minChildSize: _sheetCollapsedSize,
      maxChildSize: _sheetExpandedSize,
      snap: true,
      snapSizes: const [_sheetCollapsedSize, 0.42, _sheetExpandedSize],
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.12),
                blurRadius: 28,
                offset: const Offset(0, -6),
              ),
            ],
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            children: [
              // 1. Drag Handle Pill
              Center(
                child: Container(
                  width: 44,
                  height: 4.5,
                  decoration: BoxDecoration(
                    color: borderColor,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // 2. Bar Informasi Lokasi Sekarang (Current Location Bar)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor, width: 0.8),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.my_location_rounded,
                        size: 17,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Lokasi Sekarang',
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              color: textSecondaryColor,
                            ),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            currentLocationName,
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: textPrimaryColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () => _animateToUserLocation(mapVm),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.gps_fixed_rounded, size: 12, color: primaryColor),
                            const SizedBox(width: 4),
                            Text(
                              'Pusatkan',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // 3. Top Campus Spots Live Preview Sheet
              MapBottomSpotsSheetWidget(
                mapViewModel: mapVm ?? locator<MapViewModel>(),
                onViewMapList: () =>
                    context.pushNamed(AppRoutes.topSpotsList),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────
// CUSTOM PAINTER: Campus Map Canvas (Roads, Greenery, Lake)
// ─────────────────────────────────────────────────────────────────────────
class _CampusMapPainter extends CustomPainter {
  final bool isDark;

  const _CampusMapPainter({this.isDark = false});

  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = isDark ? const Color(0xFF1E293B) : Colors.white
      ..strokeWidth = 26
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final roadBorderPaint = Paint()
      ..color = isDark ? const Color(0xFF334155) : const Color(0xFFCAD7E8)
      ..strokeWidth = 30
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final parkPaint = Paint()
      ..color = isDark ? const Color(0xFF143026) : const Color(0xFFD4E8DC)
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
      ..color = isDark ? const Color(0xFF0F2B48) : const Color(0xFFC7DEFA)
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
  bool shouldRepaint(covariant _CampusMapPainter oldDelegate) =>
      oldDelegate.isDark != isDark;
}


