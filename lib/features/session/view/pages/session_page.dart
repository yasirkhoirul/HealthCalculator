import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:health_calculator/router/app_routes.dart';
import 'package:provider/provider.dart';
import '../../../../core/constant/app_colors.dart';
import '../viewmodels/session_timer_provider.dart';

/// Tab 3: Active Session (Sesi Fokus Belajar & Timer Melingkar)
class SessionPage extends StatelessWidget {
  const SessionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final timerProvider = context.watch<SessionTimerProvider>();
    final isRunning = timerProvider.isRunning;

    final surfaceColor = AppColors.surfaceOf(context);
    final borderColor = AppColors.borderOf(context);
    final borderSubtleColor = AppColors.borderSubtleOf(context);
    final textPrimaryColor = AppColors.textPrimaryOf(context);
    final textSecondaryColor = AppColors.textSecondaryOf(context);
    final textBodyColor = AppColors.textBodyOf(context);
    final primaryColor = AppColors.primaryOf(context);
    final primaryLightColor = AppColors.primaryLightOf(context);
    final successLightColor = AppColors.isDark(context)
        ? AppColors.darkSuccessLight
        : AppColors.successLight;

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      appBar: AppBar(
        backgroundColor: surfaceColor,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        title: Text(
          'Active Session',
          style: TextStyle(
            color: textPrimaryColor,
            fontSize: 19,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isRunning ? successLightColor : primaryLightColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isRunning ? AppColors.successGreen : primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  isRunning ? 'Fokus Berjalan' : 'Siap Mulai',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isRunning
                        ? AppColors.successGreen
                        : primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: borderSubtleColor, height: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            // 1. Session Title & Location
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: borderSubtleColor),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: primaryLightColor,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.track_changes_rounded,
                      color: primaryColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          timerProvider.sessionTitle,
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                            color: textPrimaryColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 14,
                              color: textSecondaryColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              timerProvider.currentSpotName,
                              style: TextStyle(
                                fontSize: 12,
                                color: textSecondaryColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // 2. Circular Timer Ring
            _buildCircularTimer(context, timerProvider),

            const SizedBox(height: 28),

            // 3. Preset Duration Chips
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildPresetChip(
                  context: context,
                  minutes: 25,
                  label: '25 Min (Pomodoro)',
                  isSelected: timerProvider.totalSeconds == 25 * 60,
                  onTap: () => timerProvider.setDurationMinutes(25),
                ),
                const SizedBox(width: 8),
                _buildPresetChip(
                  context: context,
                  minutes: 45,
                  label: '45 Min (Sprint)',
                  isSelected: timerProvider.totalSeconds == 45 * 60,
                  onTap: () => timerProvider.setDurationMinutes(45),
                ),
                const SizedBox(width: 8),
                _buildPresetChip(
                  context: context,
                  minutes: 60,
                  label: '60 Min (Deep)',
                  isSelected: timerProvider.totalSeconds == 60 * 60,
                  onTap: () => timerProvider.setDurationMinutes(60),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // 4. Timer Controls (Play/Pause, Reset)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: timerProvider.reset,
                  icon: const Icon(Icons.refresh_rounded, size: 20),
                  label: const Text('Reset'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: textSecondaryColor,
                    side: BorderSide(color: borderColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    if (isRunning) {
                      timerProvider.pause();
                    } else if (timerProvider.status == TimerStatus.paused) {
                      timerProvider.resume();
                    } else {
                      timerProvider.start();
                    }
                  },
                  icon: Icon(
                    isRunning
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                    size: 24,
                    color: Colors.white,
                  ),
                  label: Text(
                    isRunning
                        ? 'Jeda Fokus'
                        : timerProvider.status == TimerStatus.paused
                            ? 'Lanjutkan'
                            : 'Mulai Fokus',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 14,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // 5. Visibility / Ghost Mode Switch Card
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: borderSubtleColor),
              ),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: timerProvider.isGhostMode
                          ? primaryLightColor
                          : AppColors.cardSubtleBgOf(context),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      timerProvider.isGhostMode
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      color: timerProvider.isGhostMode
                          ? primaryColor
                          : textSecondaryColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ghost Mode saat Fokus',
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: textPrimaryColor,
                          ),
                        ),
                        Text(
                          'Sembunyikan titik lokasimu dari peta kampus',
                          style: TextStyle(
                            fontSize: 11.5,
                            color: textSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch.adaptive(
                    value: timerProvider.isGhostMode,
                    activeTrackColor: primaryColor,
                    onChanged: (_) => timerProvider.toggleGhostMode(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // 6. Active Buddies in Room Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: borderSubtleColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Rekan di Sesi Ini',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: textPrimaryColor,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () => context.pushNamed(AppRoutes.createSchedule),
                        icon: const Icon(Icons.add_rounded, size: 16),
                        label: const Text('Jadwal Baru'),
                        style: TextButton.styleFrom(
                          foregroundColor: primaryColor,
                          padding: EdgeInsets.zero,
                          textStyle: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: timerProvider.activeBuddies.map((buddy) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: primaryLightColor,
                              child: Text(
                                buddy.avatarInitials,
                                style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              buddy.name.split(' ').first,
                              style: TextStyle(
                                fontSize: 11,
                                color: textBodyColor,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularTimer(BuildContext context, SessionTimerProvider timer) {
    return Center(
      child: SizedBox(
        width: 220,
        height: 220,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background track
            SizedBox(
              width: 200,
              height: 200,
              child: CircularProgressIndicator(
                value: 1.0,
                strokeWidth: 14,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primaryLightOf(context).withValues(alpha: 0.6),
                ),
              ),
            ),
            // Active progress arc
            SizedBox(
              width: 200,
              height: 200,
              child: CircularProgressIndicator(
                value: timer.progressRatio,
                strokeWidth: 14,
                strokeCap: StrokeCap.round,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.activeGreen,
                ),
              ),
            ),
            // Center Time Display
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  timer.formattedTime,
                  style: TextStyle(
                    fontSize: 44,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1.0,
                    color: AppColors.textPrimaryOf(context),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  timer.isRunning ? 'Sisa Waktu' : 'Waktu Siap',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondaryOf(context),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPresetChip({
    required BuildContext context,
    required int minutes,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final primaryColor = AppColors.primaryOf(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : AppColors.surfaceOf(context),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? primaryColor : AppColors.borderOf(context),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.textBodyOf(context),
          ),
        ),
      ),
    );
  }
}
