import 'package:flutter/material.dart';
import '../theme/theme.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Widget? leadingIcon;
  final double? width;
  final double height;

  const SecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.leadingIcon,
    this.width,
    this.height = 52.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.border, width: 1),
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.borderFull,
          ),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leadingIcon != null) ...[
              leadingIcon!,
              const SizedBox(width: AppSpacing.sm),
            ],
            Text(
              text,
              style: AppTypography.title.copyWith(color: AppColors.textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}
