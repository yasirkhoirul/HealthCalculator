import 'package:flutter/material.dart';
import '../../../../core/constant/app_colors.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/app_text_field.dart';

/// Form widget for StudyMap campus email login.
/// Includes:
/// - Divider ("atau gunakan email kampus")
/// - Campus email input with graduation cap icon
/// - "Lanjutkan dengan Email Kampus" button with right arrow
/// - Privacy assurance banner ("Privasi terjamin...")
/// - Campus badges row (ITB, UI, UGM, Binus, 50+ Kampus)
class AuthLoginFormWidget extends StatefulWidget {
  final ValueChanged<String>? onEmailSubmit;
  final bool isLoading;

  const AuthLoginFormWidget({
    super.key,
    this.onEmailSubmit,
    this.isLoading = false,
  });

  @override
  State<AuthLoginFormWidget> createState() => _AuthLoginFormWidgetState();
}

class _AuthLoginFormWidgetState extends State<AuthLoginFormWidget> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onEmailSubmit?.call(_emailController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Divider with text "atau gunakan email kampus"
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
                  'atau gunakan email kampus',
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

          // 2. Campus Email Input Field
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
                return 'Silakan masukkan email kampus kamu';
              }
              final emailRegex = RegExp(
                r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
              );
              if (!emailRegex.hasMatch(trimmed)) {
                return 'Format email tidak valid (contoh: nama@kampus.ac.id)';
              }
              return null;
            },
            onFieldSubmitted: (_) => _handleSubmit(),
          ),

          const SizedBox(height: 14),

          // 3. Primary Button: "Lanjutkan dengan Email Kampus"
          AppPrimaryButton(
            text: 'Lanjutkan dengan Email Kampus',
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

          // 4. Privacy Assurance Banner
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

          // 5. Campus Badges / Chips
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCampusChip('ITB'),
              const SizedBox(width: 6),
              _buildCampusChip('UI'),
              const SizedBox(width: 6),
              _buildCampusChip('UGM'),
              const SizedBox(width: 6),
              _buildCampusChip('Binus'),
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
