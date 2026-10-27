import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../../../router/app_routes.dart';
import '../../../../profile/view/pages/user_detail_page.dart';
import '../../../data/models/spot_model.dart';

/// Modal Bottom Sheet detail spot belajar kampus (SpotDetailBottomSheet)
/// Menjadi Single Source of Truth untuk menampilkan detail spot baik dari klik marker peta
/// maupun dari pemilihan hasil pencarian (Search Overlay).
class SpotDetailBottomSheet extends StatefulWidget {
  final SpotModel spot;

  const SpotDetailBottomSheet({
    super.key,
    required this.spot,
  });

  /// Titik masuk tunggal (Single Entry Point) statis untuk memunculkan modal detail
  static Future<void> show(BuildContext context, SpotModel spot) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => SpotDetailBottomSheet(spot: spot),
    );
  }

  @override
  State<SpotDetailBottomSheet> createState() => _SpotDetailBottomSheetState();
}

class _SpotDetailBottomSheetState extends State<SpotDetailBottomSheet> {
  final Set<String> _wavedBuddies = {};
  bool _showAllBuddies = false;

  static const List<Map<String, String>> _allBuddies = [
    {
      'id': 'b-1',
      'name': 'Rian M.',
      'major': 'CS UI • Mobile Dev',
      'avatar': 'RM',
      'vibe': '🔥 Sedang Coding',
    },
    {
      'id': 'b-2',
      'name': 'Sarah K.',
      'major': 'Sistem Informasi • Semester 5',
      'avatar': 'SK',
      'vibe': '🎯 Deep Focus',
    },
    {
      'id': 'b-3',
      'name': 'Dimas P.',
      'major': 'Teknik Komputer',
      'avatar': 'DP',
      'vibe': '☕ Belajar Santai',
    },
    {
      'id': 'b-4',
      'name': 'Nadia S.',
      'major': 'Manajemen Bisnis • Semester 3',
      'avatar': 'NS',
      'vibe': '📊 Riset Pemasaran',
    },
    {
      'id': 'b-5',
      'name': 'Alif Fathur',
      'major': 'Informatika • Semester 7',
      'avatar': 'AF',
      'vibe': '⚡ Algoritma & Struktur Data',
    },
    {
      'id': 'b-6',
      'name': 'Clara Devina',
      'major': 'Statistika • Semester 5',
      'avatar': 'CD',
      'vibe': '📈 Data Science Python',
    },
    {
      'id': 'b-7',
      'name': 'Kevin Sanjaya',
      'major': 'Ilmu Komunikasi',
      'avatar': 'KS',
      'vibe': '🎬 Media Digital Kreatif',
    },
    {
      'id': 'b-8',
      'name': 'Alya Putri',
      'major': 'Psikologi 2022',
      'avatar': 'AP',
      'vibe': '📚 Review Jurnal Kognitif',
    },
  ];

  void _navigateToUserProfile(BuildContext context, String userId) {
    try {
      context.pushNamed(
        AppRoutes.userDetail,
        pathParameters: {'userId': userId},
      );
    } catch (_) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => UserDetailPage(userId: userId),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final spot = widget.spot;
    final isDark = AppColors.isDark(context);
    final surfaceColor = isDark ? const Color(0xFF0F172A) : Colors.white;
    final cardBgColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC);
    final textPrimary = AppColors.textPrimaryOf(context);
    final textSecondary = AppColors.textSecondaryOf(context);
    final textMuted = AppColors.textMutedOf(context);
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    const primaryPurple = Color(0xFF4F46E5);

    return DraggableScrollableSheet(
      initialChildSize: 0.72,
      minChildSize: 0.40,
      maxChildSize: 0.94,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.45 : 0.15),
                blurRadius: 28,
                offset: const Offset(0, -6),
              ),
            ],
          ),
          child: Column(
            children: [
              // ─── 1. Drag Handle Pill ───
              const SizedBox(height: 12),
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
              const SizedBox(height: 12),

              // ─── 2. Header: Kategori & Tombol Tutup ───
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: primaryPurple.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        spot.category.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: primaryPurple,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                    Tooltip(
                      message: 'Tutup detail',
                      child: Material(
                        color: Colors.transparent,
                        shape: const CircleBorder(),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isDark
                                  ? const Color(0xFF334155)
                                  : const Color(0xFFF1F5F9),
                            ),
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.close_rounded,
                              size: 18,
                              color: textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // ─── 3. Scrollable Content ───
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    // Foto Thumbnail Tempat / Hero Image
                    if (spot.imageUrl != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Image.network(
                            spot.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: primaryPurple.withValues(alpha: 0.1),
                              child: const Icon(
                                Icons.image_not_supported_rounded,
                                color: primaryPurple,
                                size: 36,
                              ),
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 14),

                    // Nama Tempat & Rating
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            spot.name,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: textPrimary,
                              letterSpacing: -0.4,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF3C7),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                size: 15,
                                color: Color(0xFFD97706),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                spot.rating.toStringAsFixed(1),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF92400E),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Subtitle & Status Singkat
                    Text(
                      spot.subtitle,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        color: textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Quick Metrics Row (Jarak • Meja • Kondisi)
                    Row(
                      children: [
                        _buildMetricTile(
                          icon: Icons.near_me_rounded,
                          label: spot.formattedDistance,
                          sub: 'Jarak',
                          isDark: isDark,
                          textPrimary: textPrimary,
                          textMuted: textMuted,
                        ),
                        const SizedBox(width: 10),
                        _buildMetricTile(
                          icon: Icons.chair_alt_rounded,
                          label: '${spot.openDesks} Meja',
                          sub: 'Tersedia',
                          isDark: isDark,
                          textPrimary: textPrimary,
                          textMuted: textMuted,
                        ),
                        const SizedBox(width: 10),
                        _buildMetricTile(
                          icon: Icons.volume_down_rounded,
                          label: spot.crowdLevel,
                          sub: 'Kondisi',
                          isDark: isDark,
                          textPrimary: textPrimary,
                          textMuted: textMuted,
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // Occupancy Progress Banner
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: cardBgColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: borderColor, width: 0.8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Keterisian Meja Belajar',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: textPrimary,
                                ),
                              ),
                              Text(
                                '${(spot.occupancyRatio * 100).toInt()}% Penuh',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w800,
                                  color: spot.occupancyRatio > 0.8
                                      ? Colors.redAccent
                                      : primaryPurple,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: spot.occupancyRatio,
                              minHeight: 8,
                              backgroundColor: isDark
                                  ? const Color(0xFF334155)
                                  : const Color(0xFFE2E8F0),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                spot.openDesks > 5
                                    ? const Color(0xFF10B981)
                                    : const Color(0xFFF59E0B),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${spot.openDesks} meja kosong dari total ${spot.totalDesks} meja belajar',
                            style: TextStyle(fontSize: 12, color: textMuted),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Fasilitas Spot Belajar (Chips)
                    Text(
                      'Fasilitas Spot',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildFacilityChip(
                          icon: Icons.wifi_rounded,
                          label: 'Wi-Fi Kampus Cepat',
                          isDark: isDark,
                          borderColor: borderColor,
                        ),
                        _buildFacilityChip(
                          icon: Icons.electrical_services_rounded,
                          label: spot.powerOutletStatus ?? 'Colokan di tiap meja',
                          isDark: isDark,
                          borderColor: borderColor,
                        ),
                        _buildFacilityChip(
                          icon: Icons.ac_unit_rounded,
                          label: 'AC Sejuk',
                          isDark: isDark,
                          borderColor: borderColor,
                        ),
                        _buildFacilityChip(
                          icon: Icons.volume_off_rounded,
                          label: spot.crowdLevel,
                          isDark: isDark,
                          borderColor: borderColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Buddies di Spot Ini + Opsi Lihat Keseluruhan Teman + Tombol Wave
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Teman Belajar di Lokasi Ini',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: textPrimary,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEEF2FF),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            spot.friendsSummary,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: primaryPurple,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Opsi Pilihan Tampilan: Ringkasan (3) vs Keseluruhan Teman (8)
                    Row(
                      children: [
                        _buildBuddyFilterOption(
                          label: 'Ringkasan (3)',
                          isSelected: !_showAllBuddies,
                          onTap: () => setState(() => _showAllBuddies = false),
                          isDark: isDark,
                          primaryPurple: primaryPurple,
                          borderColor: borderColor,
                        ),
                        const SizedBox(width: 8),
                        _buildBuddyFilterOption(
                          key: const Key('option_all_buddies_chip'),
                          label: 'Keseluruhan Teman (${_allBuddies.length})',
                          isSelected: _showAllBuddies,
                          onTap: () => setState(() => _showAllBuddies = true),
                          isDark: isDark,
                          primaryPurple: primaryPurple,
                          borderColor: borderColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Petunjuk Interaksi Menekan Kolom Nama
                    Row(
                      children: [
                        Icon(
                          Icons.touch_app_outlined,
                          size: 13,
                          color: textMuted,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Ketuk nama mahasiswa untuk melihat profil lengkap',
                          style: TextStyle(
                            fontSize: 11,
                            color: textMuted,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // List Teman Belajar (Dinamis sesuai opsi yang dipilih)
                    ...(_showAllBuddies ? _allBuddies : _allBuddies.take(3)).map((buddy) {
                      final isWaved = _wavedBuddies.contains(buddy['id']);
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: cardBgColor,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: borderColor, width: 0.8),
                        ),
                        child: Row(
                          children: [
                            // Avatar Bulat (Dapat diketuk untuk membuka profil)
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: () => _navigateToUserProfile(context, buddy['id']!),
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: primaryPurple.withValues(alpha: 0.15),
                                  child: Text(
                                    buddy['avatar']!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      color: primaryPurple,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Kolom Nama & Info (Interaksi Masuk ke Profil Mahasiswa saat Ditekan)
                            Expanded(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  key: Key('buddy_name_col_${buddy['id']}'),
                                  borderRadius: BorderRadius.circular(8),
                                  onTap: () => _navigateToUserProfile(context, buddy['id']!),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                                buddy['name']!,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 13.5,
                                                  color: textPrimary,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            Icon(
                                              Icons.arrow_forward_ios_rounded,
                                              size: 11,
                                              color: textMuted,
                                            ),
                                          ],
                                        ),
                                        Text(
                                          buddy['major']!,
                                          style: TextStyle(
                                            fontSize: 11.5,
                                            color: textSecondary,
                                          ),
                                        ),
                                        Text(
                                          buddy['vibe']!,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: primaryPurple,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // Tombol Wave (Lambaikan Tangan)
                            OutlinedButton.icon(
                              onPressed: isWaved
                                  ? null
                                  : () {
                                      setState(() {
                                        _wavedBuddies.add(buddy['id']!);
                                      });
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Melambaikan tangan ke ${buddy['name']}! 👋',
                                          ),
                                          duration: const Duration(seconds: 1),
                                        ),
                                      );
                                    },
                              icon: Text(isWaved ? '✅' : '👋'),
                              label: Text(
                                isWaved ? 'Disapa' : 'Sapa',
                                style: const TextStyle(fontSize: 12),
                              ),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                foregroundColor: primaryPurple,
                                side: BorderSide(
                                  color: isWaved
                                      ? Colors.grey.shade400
                                      : primaryPurple,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),

                    // Tombol Toggle di Bawah List Teman
                    if (!_showAllBuddies)
                      Padding(
                        padding: const EdgeInsets.only(top: 4, bottom: 8),
                        child: SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            key: const Key('see_all_buddies_bottom_button'),
                            onPressed: () {
                              setState(() {
                                _showAllBuddies = true;
                              });
                            },
                            icon: const Icon(Icons.people_alt_rounded, size: 16),
                            label: Text(
                              'Lihat Keseluruhan Teman Belajar (${_allBuddies.length} Mahasiswa)',
                              style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: primaryPurple,
                              side: BorderSide(color: primaryPurple.withValues(alpha: 0.4)),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.only(top: 4, bottom: 8),
                        child: Center(
                          child: TextButton.icon(
                            key: const Key('collapse_buddies_bottom_button'),
                            onPressed: () {
                              setState(() {
                                _showAllBuddies = false;
                              });
                            },
                            icon: const Icon(Icons.keyboard_arrow_up_rounded, size: 18),
                            label: const Text(
                              'Tampilkan Lebih Sedikit (Ringkas)',
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: TextButton.styleFrom(
                              foregroundColor: primaryPurple,
                            ),
                          ),
                        ),
                      ),

                    const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              // ─── 4. Bottom Fixed Action Buttons (Check-in & Rute) ───
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  border: Border(
                    top: BorderSide(color: borderColor, width: 0.8),
                  ),
                ),
                child: Row(
                  children: [
                    // Tombol Tunjukkan Rute
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Menampilkan rute tercepat ke ${spot.name}...',
                              ),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                        icon: const Icon(Icons.directions_walk_rounded, size: 18),
                        label: const Text('Rute'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: primaryPurple,
                          side: const BorderSide(color: primaryPurple, width: 1.2),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Tombol Check-in Belajar
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Check-in aktif di ${spot.name}! Selamat belajar!',
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        icon: const Icon(Icons.check_circle_rounded, size: 18),
                        label: const Text('Check-in Belajar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryPurple,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMetricTile({
    required IconData icon,
    required String label,
    required String sub,
    required bool isDark,
    required Color textPrimary,
    required Color textMuted,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 16, color: const Color(0xFF4F46E5)),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              sub,
              style: TextStyle(fontSize: 10.5, color: textMuted),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFacilityChip({
    required IconData icon,
    required String label,
    required bool isDark,
    required Color borderColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor, width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFF4F46E5)),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white70 : const Color(0xFF334155),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBuddyFilterOption({
    Key? key,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
    required Color primaryPurple,
    required Color borderColor,
  }) {
    return Material(
      key: key,
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected
                ? primaryPurple
                : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? primaryPurple : borderColor,
              width: 0.8,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected
                  ? Colors.white
                  : (isDark ? Colors.white70 : const Color(0xFF475569)),
            ),
          ),
        ),
      ),
    );
  }
}
