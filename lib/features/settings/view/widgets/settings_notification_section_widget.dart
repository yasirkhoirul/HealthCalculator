import 'package:flutter/material.dart';
import '../../../../core/constant/app_colors.dart';
import 'lime_switch_widget.dart';

/// Section: NOTIFIKASI & PENGINGAT
/// Berisi toggle notifikasi sesi teman, toggle pengingat Pomodoro,
/// serta navigasi pilihan "Suara & Getaran".
class SettingsNotificationSectionWidget extends StatefulWidget {
  const SettingsNotificationSectionWidget({super.key});

  @override
  State<SettingsNotificationSectionWidget> createState() =>
      _SettingsNotificationSectionWidgetState();
}

class _SettingsNotificationSectionWidgetState
    extends State<SettingsNotificationSectionWidget> {
  // State interaktif lokal
  bool _friendSessionNotif = true;
  bool _pomodoroNotif = true;
  String _selectedSound = 'Lonceng Dingin';

  final List<String> _soundOptions = [
    'Lonceng Dingin',
    'Suara Alami (Hutan)',
    'Bip Klasik',
    'Hening (Getar Saja)',
  ];

  void _showSoundPicker() {
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
                  'Suara & Getaran',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Pilih melodi notifikasi untuk sesi belajar dan istirahat.',
                  style: TextStyle(
                    fontSize: 13,
                    color: textSecondaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                ..._soundOptions.map((sound) {
                  final isSelected = _selectedSound == sound;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      sound,
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
                        _selectedSound = sound;
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
    final textMutedColor = AppColors.textMutedOf(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Section
        Row(
          children: [
            Icon(
              Icons.notifications_active_outlined,
              size: 17,
              color: primaryColor,
            ),
            const SizedBox(width: 8),
            Text(
              'NOTIFIKASI & PENGINGAT',
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
              // 1. Sesi Belajar Teman di Sekitar
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sesi Belajar Teman di Sekitar',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: textPrimaryColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Beri tahu saat kawan mulai fokus di gedung yang sama',
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
                    value: _friendSessionNotif,
                    onChanged: (val) {
                      setState(() {
                        _friendSessionNotif = val;
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

              // 2. Pengingat Pomodoro & Istirahat
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pengingat Pomodoro & Istirahat',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: textPrimaryColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Jadwal target 25m fokus dan interval rileks 5m',
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
                    value: _pomodoroNotif,
                    onChanged: (val) {
                      setState(() {
                        _pomodoroNotif = val;
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

              // 3. Suara & Getaran
              InkWell(
                onTap: _showSoundPicker,
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Suara & Getaran',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: textPrimaryColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Lofi bell & haptic feedback',
                              style: TextStyle(
                                fontSize: 12,
                                color: textSecondaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _selectedSound,
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w500,
                              color: textSecondaryColor,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.chevron_right_rounded,
                            size: 18,
                            color: textMutedColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
