import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:traver/core/theme/theme.dart';

class RatingStars extends StatelessWidget {
  final double rating;
  final int maxStars;
  final double starSize;
  final Color starColor;
  final Color unratedColor;
  final TextStyle? textStyle;
  final bool showRatingNumber;
  final int? reviewCount;

  const RatingStars({
    super.key,
    required this.rating,
    this.maxStars = 5,
    this.starSize = 14,
    this.starColor = AppColors.primary,
    this.unratedColor = const Color(0xFFD6D6D6),
    this.textStyle,
    this.showRatingNumber = true,
    this.reviewCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(maxStars, (index) {
            final starPosition = index + 1;
            IconData icon;
            Color color;

            if (rating >= starPosition) {
              icon = Icons.star_rounded;
              color = starColor;
            } else if (rating >= starPosition - 0.5) {
              icon = Icons.star_half_rounded;
              color = starColor;
            } else {
              icon = Icons.star_rounded;
              color = unratedColor;
            }

            return Padding(
              padding: const EdgeInsets.only(right: 2),
              child: Icon(
                icon,
                size: starSize,
                color: color,
              ),
            );
          }),
        ),
        if (showRatingNumber) ...[
          const SizedBox(width: 4),
          Text(
            rating.toStringAsFixed(1),
            style: textStyle ??
                GoogleFonts.urbanist(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
          ),
        ],
        if (reviewCount != null) ...[
          const SizedBox(width: 2),
          Text(
            ' ($reviewCount)',
            style: GoogleFonts.urbanist(
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}
