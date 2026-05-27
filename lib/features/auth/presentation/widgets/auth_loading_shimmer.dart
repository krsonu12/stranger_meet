import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/theme/app_colors.dart';

/// Shimmer placeholder shown during auth loading state.
/// Resembles the login screen layout.
class AuthLoadingShimmer extends StatelessWidget {
  const AuthLoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.grey300,
      highlightColor: AppColors.grey100,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo placeholder
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(height: 32),
            // Title placeholder
            Container(
              width: 200,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 12),
            // Subtitle placeholder
            Container(
              width: 260,
              height: 16,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 48),
            // Button placeholders
            _shimmerButton(),
            const SizedBox(height: 12),
            _shimmerButton(),
            const SizedBox(height: 12),
            _shimmerButton(),
          ],
        ),
      ),
    );
  }

  Widget _shimmerButton() => Container(
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      );
}
