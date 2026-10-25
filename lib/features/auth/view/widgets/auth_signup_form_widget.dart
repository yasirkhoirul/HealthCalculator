import 'package:flutter/material.dart';
import '../../../../core/constant/app_colors.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/app_text_field.dart';

/// Pure UI Form widget for StudyMap Sign Up / Registration.
class AuthSignUpFormWidget extends StatefulWidget {
  /// Dipanggil hanya jika seluruh field valid.
  final void Function({
    required String name,
    required String email,
    required String campus,
    required String password,
  })? onSubmit;
  final bool isLoading;

  const AuthSignUpFormWidget({
    super.key,
    this.onSubmit,
    this.isLoading = false,
  });

  @override
  State<AuthSignUpFormWidget> createState() => _AuthSignUpFormWidgetState();
}

class _AuthSignUpFormWidgetState extends State<AuthSignUpFormWidget> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _campusController;
  late final TextEditingController _passwordController;

  late final ValueNotifier<bool> _obscurePassword;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _campusController = TextEditingController();
    _passwordController = TextEditingController();
    _obscurePassword = ValueNotifier<bool>(true);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _campusController.dispose();
    _passwordController.dispose();
    _obscurePassword.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSubmit?.call(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        campus: _campusController.text.trim(),
        password: _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Nama Lengkap
          AppTextField(
            controller: _nameController,
            hintText: 'Nama lengkap kamu',
            prefixIcon: const Icon(
              Icons.person_outline_rounded,
              color: AppColors.textSecondary,
              size: 22,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Silakan masukkan nama lengkap';
              }
              return null;
            },
          ),

          const SizedBox(height: 12),

          // 2. Email Kampus
          AppTextField(
            controller: _emailController,
            hintText: 'nama@kampus.ac.id',
            keyboardType: TextInputType.emailAddress,
            prefixIcon: const Icon(
              Icons.school_outlined,
              color: AppColors.textSecondary,
              size: 22,
            ),
            validator: (value) {
              final trimmed = value?.trim() ?? '';
              if (trimmed.isEmpty) {
                return 'Silakan masukkan email kampus';
              }
              final emailRegex = RegExp(
                r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
              );
              if (!emailRegex.hasMatch(trimmed)) {
                return 'Format email tidak valid (contoh: nama@kampus.ac.id)';
              }
              return null;
            },
          ),

          const SizedBox(height: 12),

          // 3. Nama Kampus
          AppTextField(
            controller: _campusController,
            hintText: 'Universitas / Institut (contoh: Universitas Ahmad Dahlan, UGM)',
            prefixIcon: const Icon(
              Icons.account_balance_outlined,
              color: AppColors.textSecondary,
              size: 22,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Silakan masukkan asal kampus';
              }
              return null;
            },
          ),

          const SizedBox(height: 12),

          // 4. Kata Sandi
          ValueListenableBuilder<bool>(
            valueListenable: _obscurePassword,
            builder: (context, isObscure, child) {
              return AppTextField(
                controller: _passwordController,
                hintText: 'Kata sandi minimal 6 karakter',
                obscureText: isObscure,
                prefixIcon: const Icon(
                  Icons.lock_outline_rounded,
                  color: AppColors.textSecondary,
                  size: 22,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    isObscure
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.textMuted,
                    size: 20,
                  ),
                  onPressed: () {
                    _obscurePassword.value = !_obscurePassword.value;
                  },
                ),
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return 'Kata sandi minimal 6 karakter';
                  }
                  return null;
                },
              );
            },
          ),

          const SizedBox(height: 18),

          // 5. Tombol Submit Pendaftaran
          AppPrimaryButton(
            text: 'Daftar Akun Baru',
            isLoading: widget.isLoading,
            trailingIcon: const Icon(
              Icons.arrow_forward_rounded,
              color: Colors.white,
              size: 20,
            ),
            backgroundColor: AppColors.primary,
            onPressed: _handleSubmit,
          ),
        ],
      ),
    );
  }
}
