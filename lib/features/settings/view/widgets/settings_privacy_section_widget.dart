import 'package:flutter/material.dart';
import '../../../../core/constant/app_colors.dart';
import 'lime_switch_widget.dart';

/// Section: PRIVASI & PELACAKAN LOKASI MAP
/// Berisi toggle Ghost Mode, segmented control Radius Visibilitas Lokasi,
/// dan row selector "Siapa yang Dapat Mengetuk (Knock)".
class SettingsPrivacySectionWidget extends StatefulWidget {
  const SettingsPrivacySectionWidget({super.key});

  @override
  State<SettingsPrivacySectionWidget> createState() =>
      _SettingsPrivacySectionWidgetState();
}

class _SettingsPrivacySectionWidgetState
    extends State<SettingsPrivacySectionWidget> {
  // State interaktif lokal
  bool _isGhostMode = true;
  int _selectedRadiusIndex = 0; // 0: Tepat, 1: Samarkan 500m, 2: Kampus Saja
  String _selectedKnockPermission = 'Teman Saja';

  final List<String> _radiusOptions = [
    'Tepat',
    'Samarkan\n500m',
    'Kampus Saja',
  ];

  void _showKnockPermissionDialog() {
    final options = ['Semua Orang', 'Teman Saja', 'Tidak Ada'];
    final surfaceColor = AppColors.surfaceOf(context);
    final borderColor = AppColors.borderOf(context);
    final textPrimaryColor = AppColors.textPrimaryOf(context);
    final textSecondaryColor = AppColors.textSecondaryOf(context);
    final primaryColor = AppColors.primaryOf(context);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: surfaceColor,
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 38,
                    height: 4,
                    decoration: BoxDecoration(
                      color: borderColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Siapa yang Dapat Mengetuk (Knock)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Pilih siapa saja yang diizinkan mengirim sapaan dan ajakan belajar.',
                  style: TextStyle(
                    fontSize: 13,
                    color: textSecondaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                ...options.map((option) {
                  final isSelected = _selectedKnockPermission == option;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      option,
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? primaryColor : textPrimaryColor,
                      ),
                    ),
                    trailing: isSelected
                        ? Icon(
                            Icons.check_circle_rounded,
                            color: primaryColor,
                          )
                        : null,
                    onTap: () {
                      setState(() {
                        _selectedKnockPermission = option;
                      });
                      Navigator.pop(ctx);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppColors.primaryOf(context);
    final surfaceColor = AppColors.surfaceOf(context);
    final borderColor = AppColors.borderOf(context);
    final borderSubtleColor = AppColors.borderSubtleOf(context);
    final textPrimaryColor = AppColors.textPrimaryOf(context);
    final textSecondaryColor = AppColors.textSecondaryOf(context);
    final cardSubtleColor = AppColors.cardSubtleBgOf(context);
    final primaryLightColor = AppColors.primaryLightOf(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Section
        Row(
          children: [
            Icon(
              Icons.near_me_outlined,
              size: 17,
              color: primaryColor,
            ),
            const SizedBox(width: 8),
            Text(
              'PRIVASI & PELACAKAN LOKASI MAP',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: primaryColor,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Card Container
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: borderColor,
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Ghost Mode Toggle
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ghost Mode (Sembunyikan dari Peta)',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: textPrimaryColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Kamu tidak akan terlihat di peta ruang belajar. Rekor fokus & timer tetap dihitung.',
                          style: TextStyle(
                            fontSize: 12,
                            color: textSecondaryColor,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  LimeSwitchWidget(
                    value: _isGhostMode,
                    onChanged: (val) {
                      setState(() {
                        _isGhostMode = val;
                      });
                    },
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Divider(
                  height: 1,
                  thickness: 1,
                  color: borderSubtleColor,
                ),
              ),

              // 2. Radius Visibilitas Lokasi + Segmented Control
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Radius Visibilitas Lokasi',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: textPrimaryColor,
                    ),
                  ),
                  Text(
                    'Presisi Tinggi',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Segmented Control (3 Opsi: Tepat, Samarkan 500m, Kampus Saja)
              Container(
                height: 48,
                padding: const EdgeInsets.all(3.5),
                decoration: BoxDecoration(
                  color: cardSubtleColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: List.generate(_radiusOptions.length, (index) {
                    final isSelected = _selectedRadiusIndex == index;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedRadiusIndex = index;
                          });
                        },
                        behavior: HitTestBehavior.opaque,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          curve: Curves.easeInOut,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isSelected ? surfaceColor : Colors.transparent,
                            borderRadius: BorderRadius.circular(11),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.05),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Text(
                            _radiusOptions[index],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight:
                                  isSelected ? FontWeight.w800 : FontWeight.w500,
                              color: isSelected ? primaryColor : textSecondaryColor,
                              height: 1.15,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Divider(
                  height: 1,
                  thickness: 1,
                  color: borderSubtleColor,
                ),
              ),

              // 3. Row "Siapa yang Dapat Mengetuk (Knock)"
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Siapa yang Dapat Mengetuk (Knock)',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: textPrimaryColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Izin sapaan & ajakan belajar langsung',
                          style: TextStyle(
                            fontSize: 12,
                            color: textSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Pill Selector "Teman Saja"
                  GestureDetector(
                    onTap: _showKnockPermissionDialog,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: primaryLightColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _selectedKnockPermission.replaceAll(' ', '\n'),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: primaryColor,
                              height: 1.15,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.chevron_right_rounded,
                            size: 16,
                            color: textSecondaryColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
