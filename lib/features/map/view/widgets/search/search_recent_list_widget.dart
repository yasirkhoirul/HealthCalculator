import 'package:flutter/material.dart';
import '../../../../../core/constant/app_colors.dart';

/// Widget tampilan riwayat "Pencarian Terkini" (Recent Searches)
/// Ditampilkan ketika input query pencarian masih kosong.
class SearchRecentListWidget extends StatelessWidget {
  final List<String> recentSearches;
  final ValueChanged<String> onSelectRecent;
  final ValueChanged<String> onRemoveRecent;
  final VoidCallback onClearAll;

  const SearchRecentListWidget({
    super.key,
    required this.recentSearches,
    required this.onSelectRecent,
    required this.onRemoveRecent,
    required this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);
    final textPrimary = AppColors.textPrimaryOf(context);
    final textSecondary = AppColors.textSecondaryOf(context);
    final textMuted = AppColors.textMutedOf(context);
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    const primaryPurple = Color(0xFF4F46E5);

    if (recentSearches.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryPurple.withValues(alpha: isDark ? 0.2 : 0.1),
                ),
                child: const Icon(
                  Icons.history_toggle_off_rounded,
                  size: 28,
                  color: primaryPurple,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Belum Ada Riwayat Pencarian',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Ketik nama perpustakaan, kafe, atau ruang belajar kampus.',
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

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      children: [
        // ─── Header: "Pencarian Terkini" • "Hapus Semua" ───
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Pencarian Terkini',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: textPrimary,
                letterSpacing: -0.2,
              ),
            ),
            TextButton(
              onPressed: onClearAll,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Hapus Semua',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark ? const Color(0xFFA5B4FC) : primaryPurple,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // ─── Daftar Item Riwayat Pencarian ───
        ...recentSearches.map((query) {
          return Container(
            margin: const EdgeInsets.only(bottom: 6),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor, width: 0.8),
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () => onSelectRecent(query),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Row(
                    children: [
                      // Ikon Riwayat Jam
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDark
                              ? const Color(0xFF334155)
                              : const Color(0xFFF1F5F9),
                        ),
                        child: Icon(
                          Icons.history,
                          size: 18,
                          color: textSecondary,
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Teks Query Riwayat
                      Expanded(
                        child: Text(
                          query,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      // Tombol Hapus Satuan (✕)
                      Tooltip(
                        message: 'Hapus dari riwayat',
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () => onRemoveRecent(query),
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Icon(
                                Icons.close,
                                size: 18,
                                color: textMuted,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
