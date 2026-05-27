import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_loading_shimmer.dart';

/// Login page — renders sign-in options and delegates all logic to [AuthBloc].
/// No business logic here.
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: _handleStateChanges,
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: AuthLoadingShimmer());
          }
          return _LoginContent(
            hasError: state is AuthError,
            errorMessage: state is AuthError ? state.message : null,
          );
        },
      ),
    );
  }

  void _handleStateChanges(BuildContext context, AuthState state) {
    // Navigation is handled by GoRouter's redirect — no Navigator.push here.
    if (state is AuthError) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(state.message),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
    }
  }
}

class _LoginContent extends StatelessWidget {
  final bool hasError;
  final String? errorMessage;

  const _LoginContent({
    required this.hasError,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const Spacer(flex: 2),
            _buildHeader(context),
            const Spacer(flex: 3),
            _buildSignInButtons(context),
            const SizedBox(height: 24),
            _buildDivider(),
            const SizedBox(height: 24),
            _buildAnonymousButton(context),
            const Spacer(flex: 1),
            _buildFooter(context),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        // App logo / icon
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(
            Icons.people_alt_rounded,
            color: AppColors.white,
            size: 40,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'StrangerMeet',
          style: AppTextStyles.heading1.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Meet interesting strangers.\nStart a conversation.',
          textAlign: TextAlign.center,
          style: AppTextStyles.body2,
        ),
      ],
    );
  }

  Widget _buildSignInButtons(BuildContext context) {
    return Column(
      children: [
        // Google Sign In
        AuthButton(
          label: 'Continue with Google',
          icon: Image.network(
            'https://www.google.com/favicon.ico',
            width: 20,
            height: 20,
            errorBuilder: (_, __, ___) =>
                const Icon(Icons.g_mobiledata, size: 24),
          ),
          onTap: () =>
              context.read<AuthBloc>().add(const AuthGoogleSignInRequested()),
        ),
        const SizedBox(height: 12),
        // Apple Sign In
        AuthButton(
          label: 'Continue with Apple',
          icon: const Icon(Icons.apple, size: 22, color: AppColors.black),
          backgroundColor: AppColors.black,
          foregroundColor: AppColors.white,
          borderColor: AppColors.black,
          onTap: () =>
              context.read<AuthBloc>().add(const AuthAppleSignInRequested()),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('or', style: AppTextStyles.body2),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }

  Widget _buildAnonymousButton(BuildContext context) {
    return TextButton(
      onPressed: () =>
          context.read<AuthBloc>().add(const AuthAnonymousSignInRequested()),
      child: Text(
        'Continue as Guest',
        style: AppTextStyles.body1.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Text(
      'By continuing, you agree to our Terms of Service\nand Privacy Policy.',
      textAlign: TextAlign.center,
      style: AppTextStyles.caption,
    );
  }
}
