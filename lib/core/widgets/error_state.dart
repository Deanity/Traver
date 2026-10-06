import 'package:flutter/material.dart';
import '../theme/theme.dart';
import 'primary_button.dart';

class ErrorStateWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorStateWidget({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded, size: 54, color: AppColors.error),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Oops, Something Went Wrong',
              style: AppTypography.title,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              style: AppTypography.body.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.xl),
              PrimaryButton(
                text: 'Try Again',
                onPressed: onRetry,
                width: 160,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
