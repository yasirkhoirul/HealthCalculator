import 'package:flutter/material.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../data/models/spot_model.dart';

/// Kartu item hasil pencarian spot belajar kampus (Search Result Item Card).
/// Menampilkan thumbnail/icon, nama tebal ber-highlight, jarak, status meja, dan keramaian.
class SearchResultItemCard extends StatelessWidget {
  final SpotModel spot;
  final String query;
  final ValueChanged<SpotModel> onTap;

  const SearchResultItemCard({
    super.key,
    required this.spot,
    required this.query,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);
    final textPrimary = AppColors.textPrimaryOf(context);
    final textSecondary = AppColors.textSecondaryOf(context);
    final textMuted = AppColors.textMutedOf(context);
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    const primaryPurple = Color(0xFF4F46E5);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => onTap(spot),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ─── 1. Spot Thumbnail / Category Icon ───
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [
                        primaryPurple.withValues(alpha: 0.85),
                        const Color(0xFF6366F1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      _getCategoryIcon(spot.category),
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // ─── 2. Spot Details & Highlighted Name ───
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nama Tempat dengan Highlight Query
                      _buildHighlightedText(
                        text: spot.name,
                        query: query,
                        baseStyle: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: textPrimary,
                          letterSpacing: -0.2,
                        ),
                        highlightStyle: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w800,
                          color: primaryPurple,
                          backgroundColor: Color(0x224F46E5),
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Baris Subtitle: Jarak • Meja Terbuka • Keramaian
                      Row(
                        children: [
                          // Jarak
                          Icon(
                            Icons.near_me_rounded,
                            size: 13,
                            color: isDark ? const Color(0xFFA5B4FC) : primaryPurple,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            spot.formattedDistance,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isDark ? const Color(0xFFA5B4FC) : primaryPurple,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text('•', style: TextStyle(color: textMuted, fontSize: 11)),
                          const SizedBox(width: 6),

                          // Meja Terbuka / Status Keramaian
                          Text(
                            spot.crowdStatus,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: textSecondary,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text('•', style: TextStyle(color: textMuted, fontSize: 11)),
                          const SizedBox(width: 6),

                          // Vibe / Zone
                          Expanded(
                            child: Text(
                              spot.crowdLevel,
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w500,
                                color: textMuted,
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

                // ─── 3. Rating Badge / Panah Navigasi ───
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 14,
                        color: Color(0xFFD97706),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        spot.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF92400E),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Helper untuk menyorot kata kunci yang cocok pada teks nama tempat
  Widget _buildHighlightedText({
    required String text,
    required String query,
    required TextStyle baseStyle,
    required TextStyle highlightStyle,
  }) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      return Text(text, style: baseStyle, maxLines: 1, overflow: TextOverflow.ellipsis);
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = trimmed.toLowerCase();
    final spans = <TextSpan>[];
    int start = 0;

    while (true) {
      final index = lowerText.indexOf(lowerQuery, start);
      if (index < 0) {
        if (start < text.length) {
          spans.add(TextSpan(text: text.substring(start), style: baseStyle));
        }
        break;
      }

      if (index > start) {
        spans.add(TextSpan(text: text.substring(start, index), style: baseStyle));
      }

      spans.add(
        TextSpan(
          text: text.substring(index, index + trimmed.length),
          style: highlightStyle,
        ),
      );

      start = index + trimmed.length;
    }

    return RichText(
      text: TextSpan(children: spans),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  IconData _getCategoryIcon(String category) {
    final cat = category.toLowerCase();
    if (cat.contains('library') || cat.contains('perpustakaan')) {
      return Icons.local_library_rounded;
    } else if (cat.contains('cafe') || cat.contains('roastery') || cat.contains('kopi')) {
      return Icons.local_cafe_rounded;
    } else if (cat.contains('studio') || cat.contains('design')) {
      return Icons.palette_rounded;
    } else if (cat.contains('pod') || cat.contains('quiet')) {
      return Icons.meeting_room_rounded;
    }
    return Icons.business_rounded;
  }
}
