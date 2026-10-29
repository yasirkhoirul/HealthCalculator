import 'package:flutter/material.dart';
import '../../../../core/constant/app_colors.dart';
import '../../../../core/common/app_primary_button.dart';
import '../../../../core/common/app_text_field.dart';

/// Form widget for StudyMap login with FakeStore Username & Password.
/// Includes:
/// - Divider ("atau masuk dengan username")
/// - Username + Password input fields with visibility toggle
/// - Submit button with loading state
/// - Privacy assurance banner ("Privasi terjamin...")
/// - Campus badges row (UAD, ITB, UI, UGM, 50+ Kampus)
class AuthLoginFormWidget extends StatefulWidget {
  final void Function(String username, String password)? onUsernameSubmit;
  final bool isLoading;

  const AuthLoginFormWidget({
    super.key,
    this.onUsernameSubmit,
    this.isLoading = false,
  });

  @override
  State<AuthLoginFormWidget> createState() => _AuthLoginFormWidgetState();
}

class _AuthLoginFormWidgetState extends State<AuthLoginFormWidget> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;
  late final ValueNotifier<bool> _obscurePassword;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _obscurePassword = ValueNotifier<bool>(true);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _obscurePassword.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onUsernameSubmit?.call(
        _usernameController.text.trim(),
        _passwordController.text,
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
          // 1. Divider with text
          Row(
            children: [
              const Expanded(
                child: Divider(
                  color: AppColors.border,
                  thickness: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'atau masuk dengan username',
                  style: TextStyle(
                    fontSize: 12.5,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Expanded(
                child: Divider(
                  color: AppColors.border,
                  thickness: 1,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // 2. Username Input Field
          AppTextField(
            controller: _usernameController,
            hintText: 'Username (contoh: mor_2314)',
            keyboardType: TextInputType.text,
            prefixIcon: const Icon(
              Icons.person_outline_rounded,
              color: AppColors.textSecondary,
              size: 22,
            ),
            validator: (value) {
              final trimmed = value?.trim() ?? '';
              if (trimmed.isEmpty) {
                return 'Silakan masukkan username kamu';
              }
              return null;
            },
            onFieldSubmitted: (_) => _handleSubmit(),
          ),

          const SizedBox(height: 12),

          // 3. Password Input Field with toggle visibility
          ValueListenableBuilder<bool>(
            valueListenable: _obscurePassword,
            builder: (context, isObscure, child) {
              return AppTextField(
                controller: _passwordController,
                hintText: 'Kata sandi (contoh: 83r5^_)',
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
                  if (value == null || value.isEmpty) {
                    return 'Silakan masukkan kata sandi kamu';
                  }
                  return null;
                },
                onFieldSubmitted: (_) => _handleSubmit(),
              );
            },
          ),

          const SizedBox(height: 16),

          // 4. Submit Button: Masuk dengan Username
          AppPrimaryButton(
            text: 'Masuk dengan Username',
            isLoading: widget.isLoading,
            trailingIcon: const Icon(
              Icons.arrow_forward_rounded,
              color: Colors.white,
              size: 20,
            ),
            backgroundColor: AppColors.primary,
            onPressed: _handleSubmit,
          ),

          const SizedBox(height: 18),

          // 5. Privacy Assurance Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.cardSubtleBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.primaryLight,
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Icon(
                    Icons.verified_user_outlined,
                    color: AppColors.successGreen,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 12.5,
                        color: AppColors.textBody,
                        height: 1.45,
                      ),
                      children: [
                        TextSpan(
                          text: 'Privasi terjamin. ',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        TextSpan(
                          text:
                              'Lokasimu hanya terlihat saat sesi belajar aktif (Ghost Mode didukung).',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // 6. Campus Badges / Chips
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCampusChip('UAD'),
              const SizedBox(width: 6),
              _buildCampusChip('ITB'),
              const SizedBox(width: 6),
              _buildCampusChip('UI'),
              const SizedBox(width: 6),
              _buildCampusChip('UGM'),
              const SizedBox(width: 6),
              _buildCampusChip('50+ Kampus'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCampusChip(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
