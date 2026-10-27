import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../viewmodels/session_timer_viewmodel.dart';

/// Widget indikator timer melingkar (Circular Timer Ring)
class TimerRingWidget extends StatelessWidget {
  final SessionTimerViewModel timer;
  final double size;

  const TimerRingWidget({
    super.key,
    required this.timer,
    this.size = 220,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background track
            SizedBox(
              width: size - 20,
              height: size - 20,
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
              width: size - 20,
              height: size - 20,
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
}
