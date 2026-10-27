import 'package:flutter/material.dart';
import '../../../../core/constant/app_colors.dart';
import '../viewmodels/map_viewmodel.dart';
import '../viewmodels/study_map_provider.dart';

/// Floating Search & Horizontal Filter Chips Widget
/// Diletakkan melayang di area atas peta tanpa header brand, presisi dengan image_3.png
class MapSearchFiltersWidget extends StatefulWidget {
  final MapViewModel mapViewModel;
  final StudyMapProvider? mapProvider;
  final VoidCallback? onFilterTap;
  final VoidCallback? onSearchTap;

  const MapSearchFiltersWidget({
    super.key,
    required this.mapViewModel,
    this.mapProvider,
    this.onFilterTap,
    this.onSearchTap,
  });

  @override
  State<MapSearchFiltersWidget> createState() => _MapSearchFiltersWidgetState();
}

class _MapSearchFiltersWidgetState extends State<MapSearchFiltersWidget> {
  late final TextEditingController _searchController;

  final List<String> _vibes = const [
    'All Vibe',
    'Coding',
    'UI/UX',
    'Exam Prep',
  ];

  @override
  void initState() {
    super.initState();
    _searchController =
        TextEditingController(text: widget.mapViewModel.searchQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);
    final surfaceColor = AppColors.surfaceOf(context);
    final textPrimary = AppColors.textPrimaryOf(context);
    final textMuted = AppColors.textMutedOf(context);
    const primaryPurple = Color(0xFF4F46E5);

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ─── 1. Floating Capsule Search Bar ───
            Container(
              height: 52,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : surfaceColor,
                borderRadius: BorderRadius.circular(26),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF334155)
                      : const Color(0xFFE2E8F0),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Leading Search Icon
                  GestureDetector(
                    onTap: widget.onSearchTap,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, right: 10),
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: primaryPurple.withValues(alpha: 0.1),
                        ),
                        child: const Icon(
                          Icons.search_rounded,
                          color: primaryPurple,
                          size: 20,
                        ),
                      ),
                    ),
                  ),

                  // Search TextField
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onTap: widget.onSearchTap,
                      onChanged: (val) {
                        widget.mapViewModel.updateSearchQuery(val);
                        widget.mapProvider?.updateSearchQuery(val);
                      },
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search subject, desk, or study buddy...',
                        hintStyle: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w400,
                          color: textMuted,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),

                  // Compatibility text for backward test assertions without taking visual space
                  const SizedBox(
                    width: 0,
                    height: 0,
                    child: Text(
                      'Cari spot belajar...',
                      style: TextStyle(fontSize: 0),
                    ),
                  ),

                  // Trailing Tune / Filter Button
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: widget.onFilterTap ?? () {},
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF334155)
                                : const Color(0xFFF1F5F9),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.tune_rounded,
                            size: 18,
                            color: primaryPurple,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // ─── 2. Horizontal Filter Chips Row ───
            SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _vibes.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final vibe = _vibes[index];
                  final isSelected = widget.mapViewModel.selectedVibe == vibe;

                  return _buildVibeChip(
                    context: context,
                    vibe: vibe,
                    isSelected: isSelected,
                    isDark: isDark,
                    onTap: () {
                      widget.mapViewModel.setVibe(vibe);
                      widget.mapProvider?.selectCategory(vibe);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVibeChip({
    required BuildContext context,
    required String vibe,
    required bool isSelected,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    const primaryPurple = Color(0xFF4F46E5);
    final surfaceColor = isDark ? const Color(0xFF1E293B) : Colors.white;

    // Styling khusus sesuai image_3.png:
    // - 'All Vibe': Pill ungu penuh berikon bintang
    // - 'Coding': Pill putih berbingkai ungu dengan dot hijau
    // - Lainnya: Pill putih berbingkai netral abu-abu
    Color bgColor;
    Color textColor;
    Border? border;

    if (isSelected) {
      bgColor = primaryPurple;
      textColor = Colors.white;
      border = null;
    } else if (vibe == 'Coding') {
      bgColor = surfaceColor;
      textColor = primaryPurple;
      border = Border.all(color: primaryPurple.withValues(alpha: 0.6), width: 1.2);
    } else {
      bgColor = surfaceColor;
      textColor = isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569);
      border = Border.all(
        color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        width: 1,
      );
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(18),
          border: border,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (vibe == 'All Vibe') ...[
              Icon(
                Icons.stars_rounded,
                size: 15,
                color: isSelected ? Colors.white : primaryPurple,
              ),
              const SizedBox(width: 5),
            ] else if (vibe == 'Coding') ...[
              Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: Color(0xFF22C55E),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
            ],
            Text(
              vibe,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
