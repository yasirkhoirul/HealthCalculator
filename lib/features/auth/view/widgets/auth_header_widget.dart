import 'package:flutter/material.dart';
import '../../../../core/constant/app_colors.dart';

/// Header widget for StudyMap Auth Screen.
/// Contains:
/// 1. 'Campus Social Learning Map' badge
/// 2. Brand logo with active presence pin
/// 3. Title & description
/// 4. Live Map Social Learning simulation card with active students
class AuthHeaderWidget extends StatelessWidget {
  const AuthHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 1. Campus Social Learning Map Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.primaryBorder.withValues(alpha: 0.6),
              width: 1,
            ),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('🎓', style: TextStyle(fontSize: 13)),
              SizedBox(width: 6),
              Text(
                'Campus Social Learning Map',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.1,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // 2. StudyMap Brand Logo with Location/Pin Badge
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.menu_book_rounded,
                color: Colors.white,
                size: 36,
              ),
            ),
            // Neon Green Presence / Pin Indicator
            Positioned(
              top: -3,
              right: -3,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: AppColors.activeGreen,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2.5),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.activeGreen.withValues(alpha: 0.6),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.darkDot,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // 3. Title & Subtitle
        const Text(
          'StudyMap',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Temukan teman belajar & spot favorit di sekitarmu secara real-time.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.5,
              height: 1.45,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
          ),
        ),

        const SizedBox(height: 18),

        // 4. Live Map Social Learning simulation card
        _buildMapSimulationCard(),
      ],
    );
  }

  Widget _buildMapSimulationCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.cardSubtleBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border, width: 1.2),
      ),
      child: Column(
        children: [
          // Top Stats Bar: Active count & Radius
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 1,420+ Mahasiswa aktif pill
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.border,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.successGreen,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        '1,420+ Mahasiswa aktif',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Radius 2 km pill
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.border,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.explore_outlined,
                        size: 13,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Radius 2 km',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textBody,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Map canvas simulation with floating active student markers
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                // Row 1: Rian (Left) & Sarah (Right)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStudentPill(
                      avatarLetter: 'R',
                      avatarBg: AppColors.studentAvatarPurple,
                      name: 'Rian',
                      activity: 'Kotlin • Perpustakaan',
                      tagColor: AppColors.successGreen,
                    ),
                    _buildStudentPill(
                      avatarLetter: 'S',
                      avatarBg: AppColors.studentAvatarSlate,
                      name: 'Sarah',
                      activity: 'UI/UX • Selasar FT',
                      tagColor: const Color(0xFF2563EB),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Row 2: Dika (Center bottom)
                Center(
                  child: _buildStudentPill(
                    avatarLetter: 'D',
                    avatarBg: AppColors.studentAvatarOlive,
                    name: 'Dika',
                    activity: 'Exam Prep • Kafe Kiri',
                    tagColor: AppColors.textBody,
                    hasLiveDot: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentPill({
    required String avatarLetter,
    required Color avatarBg,
    required String name,
    required String activity,
    required Color tagColor,
    bool hasLiveDot = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.border,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Avatar
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: avatarBg,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                avatarLetter,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Name and Activity
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                activity,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: tagColor,
                ),
              ),
            ],
          ),

          if (hasLiveDot) ...[
            const SizedBox(width: 8),
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.activeGreen,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 2),
          ],
        ],
      ),
    );
  }
}
