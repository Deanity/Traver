import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:traver/core/constants/app_constants.dart';
import 'package:traver/core/theme/theme.dart';
import 'package:traver/core/widgets/rating_stars.dart';
import 'package:traver/features/destination/data/destination_model.dart';

class DestinationCard extends StatelessWidget {
  final DestinationModel destination;
  final bool isFavorite;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteToggle;
  final double width;
  final double height;

  const DestinationCard({
    super.key,
    required this.destination,
    this.isFavorite = false,
    this.onTap,
    this.onFavoriteToggle,
    this.width = 186,
    this.height = 240,
  });

  @override
  Widget build(BuildContext context) {
    final imagePath = destination.images.isNotEmpty
        ? destination.images.first
        : AssetPaths.onboarding1;

    return SizedBox(
      width: width,
      height: height,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background Image
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: const Color(0xFFE0E0E0),
                    child: const Icon(
                      Icons.image_not_supported_outlined,
                      size: 40,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),

              // Bottom Dark Gradient Overlay
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Color(0x10000000),
                        Color(0x90000000),
                        Color(0xDD000000),
                      ],
                      stops: [0.35, 0.55, 0.8, 1.0],
                    ),
                  ),
                ),
              ),

              // Top-Right Favorite Heart Button
              Positioned(
                top: 12,
                right: 12,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onFavoriteToggle,
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        size: 20,
                        color: isFavorite ? const Color(0xFFFF4842) : const Color(0xFF8A8A8A),
                      ),
                    ),
                  ),
                ),
              ),

              // Bottom Text Overlay Details
              Positioned(
                left: 14,
                right: 14,
                bottom: 14,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      destination.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.urbanist(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 13,
                          color: Color(0xFFEAEAEA),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            destination.location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.urbanist(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFFEAEAEA),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    RatingStars(
                      rating: destination.rating,
                      starSize: 12,
                      textStyle: GoogleFonts.urbanist(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
