import 'package:flutter/material.dart';
import '../theme/theme.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final double? width;
  final double height;
  final Color? backgroundColor;
  final Color? textColor;
  final BorderRadius? borderRadius;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.leadingIcon,
    this.trailingIcon,
    this.width,
    this.height = 54.0,
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primary,
          foregroundColor: textColor ?? AppColors.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? AppRadius.borderLg,
          ),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.onPrimary),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (leadingIcon != null) ...[
                    leadingIcon!,
                    const SizedBox(width: AppSpacing.sm),
                  ],
                  Text(
                    text,
                    style: AppTypography.title.copyWith(
                      color: textColor ?? AppColors.onPrimary,
                    ),
                  ),
                  if (trailingIcon != null) ...[
                    const SizedBox(width: AppSpacing.sm),
                    trailingIcon!,
                  ],
                ],
              ),
      ),
    );
  }
}
