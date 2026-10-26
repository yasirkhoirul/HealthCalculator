import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constant/app_colors.dart';
import '../../../../core/di/injection.dart';
import '../viewmodels/map_viewmodel.dart';
import '../widgets/top_spots/spot_list_card_widget.dart';

/// Halaman Detail Daftar Spot Kampus ("Campus Spots" / View Map List)
/// Menampilkan seluruh spot belajar yang diurutkan berdasarkan jarak terdekat atau paling relevan.
class TopSpotsListPage extends StatelessWidget {
  const TopSpotsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    MapViewModel? mapVm;
    try {
      mapVm = context.watch<MapViewModel>();
    } catch (_) {
      if (locator.isRegistered<MapViewModel>()) {
        mapVm = locator<MapViewModel>();
      }
    }

    final vm = mapVm ?? locator<MapViewModel>();

    return ChangeNotifierProvider.value(
      value: vm,
      child: const _TopSpotsListView(),
    );
  }
}

class _TopSpotsListView extends StatelessWidget {
  const _TopSpotsListView();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MapViewModel>();
    final isDark = AppColors.isDark(context);
    final surfaceColor = AppColors.surfaceOf(context);
    final textPrimary = AppColors.textPrimaryOf(context);
    final textMuted = AppColors.textMutedOf(context);

    final spots = vm.spots;
    final sortBy = vm.sortBy;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: surfaceColor,
        elevation: 0,
        scrolledUnderElevation: 1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: textPrimary,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Campus Spots',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            Text(
              '${spots.length} spot aktif di sekitarmu',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: textMuted,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // ─── 1. Segmented Sorting Bar: "Paling Dekat" vs "Paling Relevan" ───
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: surfaceColor,
            child: Container(
              height: 44,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildSortTab(
                      label: 'Paling Dekat',
                      icon: Icons.near_me_rounded,
                      isSelected: sortBy == 'nearest',
                      isDark: isDark,
                      onTap: () => vm.setSortBy('nearest'),
                    ),
                  ),
                  Expanded(
                    child: _buildSortTab(
                      label: 'Paling Relevan',
                      icon: Icons.trending_up_rounded,
                      isSelected: sortBy == 'relevant',
                      isDark: isDark,
                      onTap: () => vm.setSortBy('relevant'),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ─── 2. Vibe Category Filter Chips ───
          Container(
            height: 48,
            color: surfaceColor,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              children: [
                _buildFilterChip(
                  context: context,
                  label: 'All Vibe',
                  isSelected: vm.selectedVibe == 'All Vibe',
                  onTap: () => vm.setVibe('All Vibe'),
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  context: context,
                  label: 'Coding',
                  hasDot: true,
                  isSelected: vm.selectedVibe == 'Coding',
                  onTap: () => vm.setVibe('Coding'),
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  context: context,
                  label: 'UI/UX',
                  isSelected: vm.selectedVibe == 'UI/UX',
                  onTap: () => vm.setVibe('UI/UX'),
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  context: context,
                  label: 'Exam Prep',
                  isSelected: vm.selectedVibe == 'Exam Prep',
                  onTap: () => vm.setVibe('Exam Prep'),
                ),
              ],
            ),
          ),

          Divider(
            height: 1,
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          ),

          // ─── 3. List of Spot Cards (ListView.separated) ───
          Expanded(
            child: spots.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_off_rounded,
                          size: 56,
                          color: textMuted.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Tidak ada spot belajar ditemukan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Coba ganti filter vibe atau kata kunci pencarian.',
                          style: TextStyle(
                            fontSize: 13,
                            color: textMuted,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    itemCount: spots.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final spot = spots[index];
                      return SpotListCardWidget(
                        spot: spot,
                        onTap: () {
                          vm.selectSpot(spot);
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Spot ${spot.name} dipilih di peta (${spot.formattedDistance})',
                              ),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                        onRouteTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Navigasi rute tercepat ke ${spot.name}...',
                              ),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortTab({
    required String label,
    required IconData icon,
    required bool isSelected,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    const primaryPurple = Color(0xFF4F46E5);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? primaryPurple : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: primaryPurple.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected
                  ? Colors.white
                  : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: isSelected
                    ? Colors.white
                    : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required BuildContext context,
    required String label,
    required bool isSelected,
    bool hasDot = false,
    required VoidCallback onTap,
  }) {
    const primaryPurple = Color(0xFF4F46E5);
    final isDark = AppColors.isDark(context);
    final surfaceColor = isDark ? const Color(0xFF1E293B) : Colors.white;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? primaryPurple : surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? primaryPurple
                : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (hasDot && !isSelected) ...[
              Container(
                width: 6.5,
                height: 6.5,
                decoration: const BoxDecoration(
                  color: Color(0xFF22C55E),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 5),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? Colors.white
                    : (isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
