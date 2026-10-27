import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constant/app_base_state.dart';
import '../../../../core/constant/app_colors.dart';
import '../../../../core/di/injection.dart';
import '../../data/models/user_profile_model.dart';
import '../viewmodels/profile_viewmodel.dart';
import '../widgets/edit_profile/edit_interests_widget.dart';
import '../widgets/edit_profile/edit_photo_bottom_sheet.dart';
import '../widgets/edit_profile/edit_profile_app_bar_widget.dart';
import '../widgets/edit_profile/edit_profile_header_card_widget.dart';
import '../widgets/edit_profile/edit_profile_stats_row_widget.dart';
import '../widgets/edit_profile/edit_profile_visibility_card_widget.dart';
import '../widgets/edit_profile/edit_student_form_widget.dart';

/// Halaman Edit Data Profil (Edit Profile Page)
/// Formulir interaktif lengkap untuk memperbarui data mahasiswa StudyMap.
class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProfileViewModel>.value(
      value: locator<ProfileViewModel>(),
      child: const _EditProfileContentView(),
    );
  }
}

class _EditProfileContentView extends StatefulWidget {
  const _EditProfileContentView();

  @override
  State<_EditProfileContentView> createState() => _EditProfileContentViewState();
}

class _EditProfileContentViewState extends State<_EditProfileContentView> {
  late final TextEditingController _nameController;
  late final TextEditingController _usernameController;
  late final TextEditingController _bioController;

  bool _controllersInitialized = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _usernameController = TextEditingController();
    _bioController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ProfileViewModel>().loadUserProfile();
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _syncControllers(UserProfileModel profile) {
    if (!_controllersInitialized) {
      _nameController.text = profile.name;
      _usernameController.text = profile.username;
      _bioController.text = profile.bio;
      _controllersInitialized = true;
    }
  }

  void _openPhotoBottomSheet() {
    EditPhotoBottomSheet.show(
      context,
      onCameraSelect: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Membuka Kamera untuk Foto Profil Baru'),
            duration: Duration(seconds: 1),
          ),
        );
      },
      onGallerySelect: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Membuka Galeri Foto Smartphone'),
            duration: Duration(seconds: 1),
          ),
        );
      },
      onZenlyAvatarSelect: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Kustomisasi 3D Zenly Avatar'),
            duration: Duration(seconds: 1),
          ),
        );
      },
    );
  }

  Future<void> _handleSave() async {
    final vm = context.read<ProfileViewModel>();
    final current = vm.currentProfile;
    if (current == null) return;

    final updated = current.copyWith(
      name: _nameController.text.trim(),
      username: _usernameController.text.trim(),
      bio: _bioController.text.trim(),
    );

    final success = await vm.updateProfile(updated);
    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Perubahan profil berhasil disimpan!',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.successGreen,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProfileViewModel>();
    final state = vm.state;

    // Sinkronkan controller dengan data profil aktif
    if (state is AppStateSuccess<UserProfileModel> && state.data != null) {
      _syncControllers(state.data!);
    } else if (vm.currentProfile != null) {
      _syncControllers(vm.currentProfile!);
    }

    final isSubmitting = vm.isLoading;

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      appBar: EditProfileAppBarWidget(
        isLoading: isSubmitting,
        onSave: _handleSave,
        onReset: () {
          final profile = vm.currentProfile;
          if (profile != null) {
            _nameController.text = profile.name;
            _usernameController.text = profile.username;
            _bioController.text = profile.bio;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Form dikembalikan ke data tersimpan.'),
                duration: Duration(seconds: 1),
              ),
            );
          }
        },
      ),
      body: SafeArea(
        top: false,
        child: switch (state) {
          // 1. Initial / Loading State
          AppStateInitial() ||
          AppStateLoading(message: final _) when vm.currentProfile == null =>
            Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryOf(context),
              ),
            ),

          // 2. Error State
          AppStateError(:final message) when vm.currentProfile == null =>
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.error_outline_rounded,
                        color: AppColors.errorDark,
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      message,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textPrimaryOf(context),
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => vm.loadUserProfile(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryOf(context),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                      label: const Text(
                        'Coba Lagi',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // 3. Success / Active Form
          _ => _buildProfileForm(context, vm.currentProfile!, isSubmitting),
        },
      ),
    );
  }

  Widget _buildProfileForm(
    BuildContext context,
    UserProfileModel profile,
    bool isSubmitting,
  ) {
    final vm = context.read<ProfileViewModel>();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Header Card (Avatar, Verified Badge, Campus Handle, Quick Action Buttons)
          EditProfileHeaderCardWidget(
            name: profile.name,
            username: profile.username,
            campusBranch: profile.campusBranch,
            photoUrl: profile.photoUrl,
            onGalleryTap: _openPhotoBottomSheet,
            onCameraTap: _openPhotoBottomSheet,
            onZenlyAvatarTap: _openPhotoBottomSheet,
          ),

          const SizedBox(height: 20),

          // 2. Stats Row (Aktivitas Belajar Semester Ini)
          EditProfileStatsRowWidget(
            totalFocusHours: profile.totalFocusHours,
            completedSessions: profile.completedSessions,
            studyBuddiesCount: profile.connectedBuddies,
            isSessionActive: true,
          ),

          const SizedBox(height: 20),

          // 3. Form Card: Data Pribadi Mahasiswa (SSO, Name, Username, Campus, Major, Bio)
          EditStudentFormWidget(
            nameController: _nameController,
            usernameController: _usernameController,
            bioController: _bioController,
            campus: profile.campus,
            majorAndYear: '${profile.major} • ${profile.academicYear}',
          ),

          const SizedBox(height: 18),

          // 4. Manajemen Minat Belajar Aktif
          EditInterestsWidget(
            interests: profile.interests,
            onAddInterest: (interest) => vm.addInterest(interest),
            onRemoveInterest: (interest) => vm.removeInterest(interest),
          ),

          const SizedBox(height: 18),

          // 5. Card Visibilitas di Peta Kampus
          EditProfileVisibilityCardWidget(
            isVisible: profile.isMapVisible,
            onToggle: (val) => vm.toggleMapVisibility(val),
          ),

          const SizedBox(height: 24),

          // 6. Tombol Utama Bawah: Full-width elevated pill button "✓ Simpan Perubahan"
          ElevatedButton(
            onPressed: isSubmitting ? null : _handleSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryOf(context),
              disabledBackgroundColor: AppColors.primaryOf(context).withValues(alpha: 0.5),
              elevation: 4,
              shadowColor: AppColors.primaryOf(context).withValues(alpha: 0.35),
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isSubmitting)
                  const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                else
                  const Icon(
                    Icons.check_circle_outline_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                const SizedBox(width: 8),
                Text(
                  isSubmitting ? 'Menyimpan...' : 'Simpan Perubahan',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
