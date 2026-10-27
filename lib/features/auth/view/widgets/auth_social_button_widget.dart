import 'package:flutter/material.dart';
import '../../../../core/constant/app_colors.dart';

/// Custom widget for Social login button (Google) with pixel-perfect
/// branding, 'Sekali Ketuk' badge, and smooth press animations.
class AuthSocialButtonWidget extends StatelessWidget {
  final VoidCallback? onGoogleSignIn;
  final bool isLoading;

  const AuthSocialButtonWidget({
    super.key,
    this.onGoogleSignIn,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: isLoading ? null : onGoogleSignIn,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: isLoading
                ? const Center(
                    child: SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppColors.googleBlue),
                      ),
                    ),
                  )
                : Row(
                    children: [
                      // Google 4-color 'G' Logo
                      const SizedBox(
                        width: 24,
                        height: 24,
                        child: CustomPaint(
                          painter: _GoogleGLogoPainter(),
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Label
                      const Expanded(
                        child: Text(
                          'Lanjutkan dengan Google',
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),

                      // "Sekali Ketuk" Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.successLight,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFF86EFAC).withValues(alpha: 0.4),
                            width: 0.8,
                          ),
                        ),
                        child: const Text(
                          'Sekali Ketuk',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.successGreen,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

/// Precise vector painter for Google 'G' 4-color icon
class _GoogleGLogoPainter extends CustomPainter {
  const _GoogleGLogoPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final strokeWidth = size.width * 0.22;
    final rect =
        Rect.fromCircle(center: center, radius: radius - strokeWidth / 2);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    // Blue arc (Right top to horizontal bar)
    paint.color = AppColors.googleBlue;
    canvas.drawArc(rect, -0.7, 0.7, false, paint);

    // Green arc (Bottom)
    paint.color = AppColors.googleGreen;
    canvas.drawArc(rect, 0.0, 1.85, false, paint);

    // Yellow arc (Bottom left)
    paint.color = AppColors.googleYellow;
    canvas.drawArc(rect, 1.85, 1.35, false, paint);

    // Red arc (Top)
    paint.color = AppColors.googleRed;
    canvas.drawArc(rect, 3.2, 2.38, false, paint);

    // Horizontal Blue bar inside G
    final barPaint = Paint()
      ..color = AppColors.googleBlue
      ..style = PaintingStyle.fill;
    final barHeight = strokeWidth;
    final barWidth = radius * 0.95;
    final barRect = Rect.fromLTWH(
      center.dx - 1,
      center.dy - (barHeight / 2),
      barWidth + 1,
      barHeight,
    );
    canvas.drawRect(barRect, barPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
