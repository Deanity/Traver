import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class TraverLogo extends StatelessWidget {
  final double fontSize;
  final Color textColor;
  final Color dotColor;

  const TraverLogo({
    super.key,
    this.fontSize = 28,
    this.textColor = Colors.white,
    this.dotColor = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = GoogleFonts.urbanist(
      fontSize: fontSize,
      fontWeight: FontWeight.w800,
      color: textColor,
      letterSpacing: -0.5,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text('Tra', style: textStyle),
        Text(
          'v',
          style: textStyle.copyWith(color: dotColor),
        ),
        Text('er', style: textStyle),
      ],
    );
  }
}
