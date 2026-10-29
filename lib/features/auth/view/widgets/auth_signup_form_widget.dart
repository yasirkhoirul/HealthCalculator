import 'package:flutter/material.dart';
import '../../../../core/constant/app_colors.dart';
import '../../../../core/common/app_primary_button.dart';
import '../../../../core/common/app_text_field.dart';

/// Form widget for StudyMap Sign Up / Registration with FakeStore Username & Password.
class AuthSignUpFormWidget extends StatefulWidget {
  final void Function({
    required String username,
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
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  late final ValueNotifier<bool> _obscurePassword;
  late final ValueNotifier<bool> _obscureConfirmPassword;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _obscurePassword = ValueNotifier<bool>(true);
    _obscureConfirmPassword = ValueNotifier<bool>(true);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _obscurePassword.dispose();
    _obscureConfirmPassword.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSubmit?.call(
        username: _usernameController.text.trim(),
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
          // 1. Username
          AppTextField(
            controller: _usernameController,
            hintText: 'Pilih username (contoh: user_baru)',
            keyboardType: TextInputType.text,
            prefixIcon: const Icon(
              Icons.person_outline_rounded,
              color: AppColors.textSecondary,
              size: 22,
            ),
            validator: (value) {
              final trimmed = value?.trim() ?? '';
              if (trimmed.isEmpty) {
                return 'Silakan masukkan username baru';
              }
              if (trimmed.length < 3) {
                return 'Username minimal 3 karakter';
              }
              return null;
            },
            onFieldSubmitted: (_) => _handleSubmit(),
          ),

          const SizedBox(height: 12),

          // 2. Kata Sandi
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
                onFieldSubmitted: (_) => _handleSubmit(),
              );
            },
          ),

          const SizedBox(height: 12),

          // 3. Konfirmasi Kata Sandi
          ValueListenableBuilder<bool>(
            valueListenable: _obscureConfirmPassword,
            builder: (context, isObscure, child) {
              return AppTextField(
                controller: _confirmPasswordController,
                hintText: 'Ulangi kata sandi',
                obscureText: isObscure,
                prefixIcon: const Icon(
                  Icons.lock_reset_rounded,
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
                    _obscureConfirmPassword.value =
                        !_obscureConfirmPassword.value;
                  },
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Silakan konfirmasi kata sandi kamu';
                  }
                  if (value != _passwordController.text) {
                    return 'Kata sandi tidak cocok';
                  }
                  return null;
                },
                onFieldSubmitted: (_) => _handleSubmit(),
              );
            },
          ),

          const SizedBox(height: 18),

          // 4. Tombol Submit Pendaftaran
          AppPrimaryButton(
            text: 'Daftar dengan Username',
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
