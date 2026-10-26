import 'package:flutter/material.dart';
import '../../../../../core/constant/app_base_state.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../data/models/spot_model.dart';
import 'search_result_item_card.dart';

/// Widget daftar hasil pencarian dinamis (Live Search Results)
/// Ditampilkan saat kolom pencarian memiliki teks kata kunci.
class SearchResultsListWidget extends StatelessWidget {
  final AppBaseState<List<SpotModel>> searchState;
  final String query;
  final ValueChanged<SpotModel> onSpotTap;

  const SearchResultsListWidget({
    super.key,
    required this.searchState,
    required this.query,
    required this.onSpotTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);
    final textPrimary = AppColors.textPrimaryOf(context);
    final textMuted = AppColors.textMutedOf(context);
    const primaryPurple = Color(0xFF4F46E5);

    return Column(
      children: [
        // ─── 1. Indikator Loading Debounce ───
        if (searchState.isLoading)
          const LinearProgressIndicator(
            minHeight: 2.5,
            backgroundColor: Colors.transparent,
            valueColor: AlwaysStoppedAnimation<Color>(primaryPurple),
          ),

        // ─── 2. Konten Hasil Pencarian Berdasarkan State ───
        Expanded(
          child: switch (searchState) {
            AppStateLoading() => _buildLoadingState(isDark),
            AppStateEmpty(:final message) =>
              _buildEmptyState(context, message ?? 'Spot belajar tidak ditemukan'),
            AppStateError(:final message) =>
              _buildErrorState(context, message),
            AppStateSuccess(:final data) =>
              _buildSuccessState(context, data ?? const [], textPrimary, textMuted),
            _ => const SizedBox.shrink(),
          },
        ),
      ],
    );
  }

  /// Tampilan loading halus saat menunggu debounce atau fetching
  Widget _buildLoadingState(bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          height: 72,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(16),
          ),
        );
      },
    );
  }

  /// Tampilan Empty State ("Spot belajar tidak ditemukan")
  Widget _buildEmptyState(BuildContext context, String message) {
    final textPrimary = AppColors.textPrimaryOf(context);
    final textMuted = AppColors.textMutedOf(context);
    final isDark = AppColors.isDark(context);
    const primaryPurple = Color(0xFF4F46E5);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryPurple.withValues(alpha: isDark ? 0.2 : 0.08),
              ),
              child: const Icon(
                Icons.search_off_rounded,
                size: 32,
                color: primaryPurple,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Coba gunakan kata kunci lain seperti "Library", "Cafe", atau "Coworking".',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: textMuted,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Tampilan Error State
  Widget _buildErrorState(BuildContext context, String message) {
    final textPrimary = AppColors.textPrimaryOf(context);
    final textMuted = AppColors.textMutedOf(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded, size: 40, color: Colors.redAccent),
            const SizedBox(height: 12),
            Text(
              'Terjadi Kendala Pencarian',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: textMuted),
            ),
          ],
        ),
      ),
    );
  }

  /// Tampilan Daftar Hasil Sukses
  Widget _buildSuccessState(
    BuildContext context,
    List<SpotModel> spots,
    Color textPrimary,
    Color textMuted,
  ) {
    if (spots.isEmpty) {
      return _buildEmptyState(context, 'Spot belajar tidak ditemukan');
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: spots.length,
      itemBuilder: (context, index) {
        final spot = spots[index];
        return SearchResultItemCard(
          spot: spot,
          query: query,
          onTap: onSpotTap,
        );
      },
    );
  }
}
