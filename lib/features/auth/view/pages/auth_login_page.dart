import 'package:flutter/material.dart';
import '../../../../core/constant/app_colors.dart';
import '../widgets/auth_header_widget.dart';
import '../widgets/auth_login_form_widget.dart';
import '../widgets/auth_social_button_widget.dart';
import 'auth_signup_page.dart';

/// Pure UI Scaffold Page for StudyMap Auth Login.
/// Handles only view and presentation logic without ViewModel/API integration.
class AuthLoginPage extends StatefulWidget {
  const AuthLoginPage({super.key});

  @override
  State<AuthLoginPage> createState() => _AuthLoginPageState();
}

class _AuthLoginPageState extends State<AuthLoginPage> {
  bool _isLoading = false;

  void _showFeedback(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.textPrimary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleGoogleSignIn() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() => _isLoading = false);
        _showFeedback('Melanjutkan login dengan Google...');
      }
    });
  }

  void _handleEmailSubmit(String email) {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() => _isLoading = false);
        _showFeedback('Tautan verifikasi dikirim ke $email');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.textPrimary,
            size: 22,
          ),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              _showFeedback('Kembali ke layar sebelumnya');
            }
          },
        ),
        title: const Text(
          'StudyMap',
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.4,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => _showFeedback('Pusat Bantuan StudyMap'),
            child: const Text(
              'Help',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: AppColors.borderSubtle,
            height: 1,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                  border: Border.all(
                    color: AppColors.borderSubtle,
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 1. Header (Badge, Logo with presence pin, Title, and Map Simulation Card)
                    const AuthHeaderWidget(),

                    const SizedBox(height: 20),

                    // 2. Google Social Login Button
                    AuthSocialButtonWidget(
                      isLoading: _isLoading,
                      onGoogleSignIn: _handleGoogleSignIn,
                    ),

                    const SizedBox(height: 18),

                    // 3. Campus Email Form & Submit Button
                    AuthLoginFormWidget(
                      isLoading: _isLoading,
                      onEmailSubmit: _handleEmailSubmit,
                    ),

                    const SizedBox(height: 20),

                    // 4. Terms of Service and Privacy Policy
                    _buildTermsAndPrivacy(),

                    const SizedBox(height: 10),

                    // 5. Navigation Link to SignUp Page
                    _buildSignUpNavigation(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTermsAndPrivacy() {
    return Column(
      children: [
        const Text(
          'Dengan melanjutkan, kamu menyetujui',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11.5,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 2),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            GestureDetector(
              onTap: () => _showFeedback('Membuka Ketentuan Layanan...'),
              child: const Text(
                'Ketentuan Layanan',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.primary,
                ),
              ),
            ),
            const Text(
              ' & ',
              style: TextStyle(
                fontSize: 11.5,
                color: AppColors.textSecondary,
              ),
            ),
            GestureDetector(
              onTap: () => _showFeedback('Membuka Kebijakan Privasi...'),
              child: const Text(
                'Kebijakan Privasi',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.primary,
                ),
              ),
            ),
            const Text(
              ' StudyMap.',
              style: TextStyle(
                fontSize: 11.5,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSignUpNavigation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Belum punya akun? ',
          style: TextStyle(
            fontSize: 13,
            color: AppColors.textBody,
            fontWeight: FontWeight.w500,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const AuthSignUpPage(),
              ),
            );
          },
          child: const Text(
            'Daftar',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
