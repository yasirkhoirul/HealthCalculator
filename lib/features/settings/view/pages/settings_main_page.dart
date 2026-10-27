import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constant/app_colors.dart';
import '../../../auth/view/viewmodels/auth_view_models.dart';
import '../../../profile/view/viewmodels/profile_viewmodel.dart';
import '../widgets/settings_account_section_widget.dart';
import '../widgets/settings_notification_section_widget.dart';
import '../widgets/settings_privacy_section_widget.dart';
import '../widgets/settings_support_section_widget.dart';
import '../widgets/settings_theme_section_widget.dart';

/// Halaman Pengaturan (Settings Main Page)
/// Fokus murni pada konfigurasi aplikasi dan preferensi sistem.
/// Diakses secara eksklusif via ikon gear pada Halaman Profil Utama.
class SettingsMainPage extends StatelessWidget {
  const SettingsMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final profileVm = context.watch<ProfileViewModel>();
    final user = profileVm.user;
    final userEmail = user.email.isNotEmpty ? user.email : 'ahmad.farhan@itb.ac.id';

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      appBar: AppBar(
        backgroundColor: AppColors.surfaceOf(context),
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: AppColors.primaryOf(context),
            size: 24,
          ),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              Navigator.of(context).maybePop();
            }
          },
          tooltip: 'Kembali',
        ),
        title: Text(
          'Pengaturan',
          style: TextStyle(
            color: AppColors.textPrimaryOf(context),
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search_rounded,
              color: AppColors.textSecondaryOf(context),
              size: 22,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cari Pengaturan Aplikasi'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            tooltip: 'Cari Pengaturan',
          ),
          const SizedBox(width: 4),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.borderSubtleOf(context), height: 1),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Section Tampilan & Tema (Dark Mode, Light Mode, & Sinkronisasi Sistem)
              const SettingsThemeSectionWidget(),
              const SizedBox(height: 22),

              // 2. Section Privasi & Pelacakan Lokasi Map
              const SettingsPrivacySectionWidget(),
              const SizedBox(height: 22),

              // 3. Section Notifikasi & Pengingat
              const SettingsNotificationSectionWidget(),
              const SizedBox(height: 22),

              // 4. Section Akun & Keamanan (Email Kampus Terhubung SSO)
              SettingsAccountSectionWidget(
                email: userEmail,
                onEmailTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Email SSO Kampus: $userEmail (Tervalidasi)'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                onPasswordTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Kelola kata sandi akun SSO di portal kampus.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                onDevicesTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Melihat perangkat aktif terhubung.'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
              ),
              const SizedBox(height: 22),

              // 5. Section Bantuan, Dukungan, & Tombol Logout Keluar Akun
              SettingsSupportSectionWidget(
                onLogoutTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Berhasil keluar dari akun StudyMap'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                  context.read<AuthViewModel>().signOut();
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
