import 'package:flutter/material.dart';
import '../../../../core/constant/app_colors.dart';
import '../../data/models/study_status_model.dart';

/// Floating Emote Bubble melayang di atas avatar pin marker pada peta.
/// Menampilkan kombinasi ikon emote dan teks status singkat pengguna/teman.
class MapStatusBubbleWidget extends StatelessWidget {
  final StudyStatusModel status;
  final bool isMyLocation;

  const MapStatusBubbleWidget({
    super.key,
    required this.status,
    this.isMyLocation = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);
    final surfaceColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textPrimaryColor = AppColors.textPrimaryOf(context);
    final primaryColor = AppColors.primaryOf(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          constraints: const BoxConstraints(maxWidth: 130),
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3.5),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isMyLocation
                  ? primaryColor.withValues(alpha: 0.55)
                  : (isDark
                      ? const Color(0xFF334155)
                      : const Color(0xFFE2E8F0)),
              width: isMyLocation ? 1.2 : 0.8,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.12),
                blurRadius: 6,
                offset: const Offset(0, 2.5),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                status.emoji,
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  status.displayText,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: textPrimaryColor,
                    letterSpacing: -0.1,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        // Subtle downward pin arrow / tail
        CustomPaint(
          size: const Size(8, 4),
          painter: _TrianglePainter(
            color: surfaceColor,
            strokeColor: isMyLocation
                ? primaryColor.withValues(alpha: 0.55)
                : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
          ),
        ),
      ],
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;
  final Color strokeColor;

  _TrianglePainter({required this.color, required this.strokeColor});

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, paint);

    final borderPaint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(_TrianglePainter oldDelegate) =>
      color != oldDelegate.color || strokeColor != oldDelegate.strokeColor;
}
