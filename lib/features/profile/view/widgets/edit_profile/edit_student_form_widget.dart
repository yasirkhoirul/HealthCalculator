import 'package:flutter/material.dart';
import '../../../../../core/constant/app_colors.dart';

/// Form Card: Data Pribadi Mahasiswa
/// Berisi input Nama Lengkap, Username Kampus, Info SSO Readonly, dan Textarea Bio dengan dynamic counter.
class EditStudentFormWidget extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController usernameController;
  final TextEditingController bioController;
  final String campus;
  final String majorAndYear;

  const EditStudentFormWidget({
    super.key,
    required this.nameController,
    required this.usernameController,
    required this.bioController,
    required this.campus,
    required this.majorAndYear,
  });

  @override
  Widget build(BuildContext context) {
    final surfaceColor = AppColors.surfaceOf(context);
    final borderColor = AppColors.borderOf(context);
    final textPrimaryColor = AppColors.textPrimaryOf(context);
    final textSecondaryColor = AppColors.textSecondaryOf(context);
    final primaryColor = AppColors.primaryOf(context);
    final primaryLightColor = AppColors.primaryLightOf(context);
    final primaryBorderColor = AppColors.primaryBorderOf(context);
    final cardSubtleColor = AppColors.cardSubtleBgOf(context);
    final isDark = AppColors.isDark(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card: Badge SSO
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: primaryLightColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Icon(
                    Icons.badge_outlined,
                    color: primaryColor,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Data Pribadi',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: textPrimaryColor,
                        height: 1.1,
                      ),
                    ),
                    Text(
                      'Mahasiswa',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: textPrimaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: primaryLightColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: primaryBorderColor),
                ),
                child: Text(
                  'Tervalidasi SSO',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.primaryDark,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // 1. Input Nama Lengkap
          _buildFieldLabel(context, 'Nama Lengkap'),
          const SizedBox(height: 6),
          TextFormField(
            controller: nameController,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: textPrimaryColor,
            ),
            decoration: _buildInputDecoration(
              context: context,
              hint: 'Nama Lengkap',
              suffixIcon: Icon(
                Icons.edit_outlined,
                color: textSecondaryColor,
                size: 18,
              ),
            ),
          ),

          const SizedBox(height: 14),

          // 2. Input Username Kampus
          _buildFieldLabel(context, 'Username Kampus'),
          const SizedBox(height: 6),
          TextFormField(
            controller: usernameController,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: textPrimaryColor,
            ),
            decoration: _buildInputDecoration(
              context: context,
              hint: '@username',
              suffixIcon: Icon(
                Icons.verified_rounded,
                color: primaryColor,
                size: 18,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Digunakan teman untuk mencari posisi spot belajarmu di peta.',
            style: TextStyle(
              fontSize: 11,
              color: textSecondaryColor,
              height: 1.3,
            ),
          ),

          const SizedBox(height: 14),

          // 3. Display Field Readonly: Kampus / Universitas
          _buildFieldLabel(context, 'Kampus / Universitas'),
          const SizedBox(height: 6),
          _buildReadOnlyContainer(
            context: context,
            icon: Icons.school_rounded,
            text: campus,
          ),

          const SizedBox(height: 14),

          // 4. Display Field Readonly: Jurusan & Angkatan
          _buildFieldLabel(context, 'Jurusan & Angkatan'),
          const SizedBox(height: 6),
          _buildReadOnlyContainer(
            context: context,
            icon: Icons.account_tree_outlined,
            text: majorAndYear,
          ),

          const SizedBox(height: 14),

          // 5. Textarea Bio Singkat & Status Radar + Dynamic Counter
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildFieldLabel(context, 'Bio Singkat & Status Radar'),
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: bioController,
                builder: (context, value, _) {
                  return Text(
                    '${value.text.length}/120',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: textSecondaryColor,
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: bioController,
            maxLines: 3,
            maxLength: 120,
            buildCounter: (context, {required currentLength, required isFocused, maxLength}) =>
                const SizedBox.shrink(),
            style: TextStyle(
              fontSize: 13,
              color: textPrimaryColor,
              height: 1.4,
            ),
            decoration: InputDecoration(
              hintText: 'Tuliskan bio atau status radar belajarmu...',
              hintStyle: TextStyle(fontSize: 12.5, color: AppColors.textMutedOf(context)),
              filled: true,
              fillColor: cardSubtleColor,
              contentPadding: const EdgeInsets.all(12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: primaryColor, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(BuildContext context, String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimaryOf(context),
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required BuildContext context,
    required String hint,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(fontSize: 13, color: AppColors.textMutedOf(context)),
      filled: true,
      fillColor: AppColors.cardSubtleBgOf(context),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppColors.borderOf(context)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppColors.borderOf(context)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppColors.primaryOf(context), width: 1.5),
      ),
    );
  }

  Widget _buildReadOnlyContainer({
    required BuildContext context,
    required IconData icon,
    required String text,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.cardSubtleBgOf(context),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderOf(context)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryOf(context), size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimaryOf(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
