import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Reusable social sign-in button with icon + label.
class AuthButton extends StatelessWidget {
  final String label;
  final Widget icon;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;

  const AuthButton({
    super.key,
    required this.label,
    required this.icon,
    this.onTap,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.white,
          foregroundColor: foregroundColor ?? AppColors.grey900,
          side: BorderSide(color: borderColor ?? AppColors.grey300),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 12),
            Text(label, style: AppTextStyles.button),
          ],
        ),
      ),
    );
  }
}
