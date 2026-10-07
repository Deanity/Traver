import 'package:flutter/material.dart';
import '../theme/theme.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String? labelText;
  final String? hintText;
  final String? errorText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final bool readOnly;
  final VoidCallback? onTap;
  final Color? fillColor;
  final BorderRadius? borderRadius;
  final FloatingLabelBehavior? floatingLabelBehavior;

  const AppTextField({
    super.key,
    this.controller,
    this.label,
    this.labelText,
    this.hintText,
    this.errorText,
    this.obscureText = false,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.validator,
    this.readOnly = false,
    this.onTap,
    this.fillColor,
    this.borderRadius,
    this.floatingLabelBehavior,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = borderRadius ?? AppRadius.borderLg;
    final outlineBorder = OutlineInputBorder(
      borderRadius: effectiveRadius,
      borderSide: const BorderSide(color: AppColors.border, width: 1.2),
    );
    final focusedBorder = OutlineInputBorder(
      borderRadius: effectiveRadius,
      borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
    );
    final errorBorder = OutlineInputBorder(
      borderRadius: effectiveRadius,
      borderSide: const BorderSide(color: AppColors.error, width: 1.2),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          readOnly: readOnly,
          onTap: onTap,
          onChanged: onChanged,
          validator: validator,
          style: AppTypography.body.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            labelText: labelText,
            floatingLabelBehavior: floatingLabelBehavior ??
                (labelText != null ? FloatingLabelBehavior.always : null),
            labelStyle: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
            floatingLabelStyle: WidgetStateTextStyle.resolveWith((states) {
              if (states.contains(WidgetState.focused)) {
                return AppTypography.caption.copyWith(
                  color: AppColors.primary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                );
              }
              return AppTypography.caption.copyWith(
                color: AppColors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              );
            }),
            hintText: hintText,
            errorText: errorText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            filled: fillColor != null,
            fillColor: fillColor,
            border: outlineBorder,
            enabledBorder: outlineBorder,
            focusedBorder: focusedBorder,
            errorBorder: errorBorder,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
        ),
      ],
    );
  }
}

