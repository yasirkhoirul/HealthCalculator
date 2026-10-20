import 'package:flutter/material.dart';
import '../../../../core/constant/app_colors.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/app_text_field.dart';

/// Pure UI Form widget for StudyMap Sign Up / Registration.
class AuthSignUpFormWidget extends StatefulWidget {
  final VoidCallback? onSignUpSuccess;
  final bool isLoading;

  const AuthSignUpFormWidget({
    super.key,
    this.onSignUpSuccess,
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

  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _campusController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _campusController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSignUpSuccess?.call();
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
            hintText: 'Universitas / Institut (contoh: ITB, UI, UGM)',
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
          AppTextField(
            controller: _passwordController,
            hintText: 'Kata sandi minimal 6 karakter',
            obscureText: _obscurePassword,
            prefixIcon: const Icon(
              Icons.lock_outline_rounded,
              color: AppColors.textSecondary,
              size: 22,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColors.textMuted,
                size: 20,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            validator: (value) {
              if (value == null || value.length < 6) {
                return 'Kata sandi minimal 6 karakter';
              }
              return null;
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
