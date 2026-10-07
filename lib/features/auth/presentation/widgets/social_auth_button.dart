import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

class SocialAuthBar extends StatelessWidget {
  final VoidCallback? onInstagramTap;
  final VoidCallback? onGoogleTap;
  final VoidCallback? onFacebookTap;

  const SocialAuthBar({
    super.key,
    this.onInstagramTap,
    this.onGoogleTap,
    this.onFacebookTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _SocialCircleButton(
          onTap: onInstagramTap,
          child: const _InstagramIcon(size: 22),
        ),
        const SizedBox(width: 24),
        _SocialCircleButton(
          onTap: onGoogleTap,
          child: const _GoogleIcon(size: 22),
        ),
        const SizedBox(width: 24),
        _SocialCircleButton(
          onTap: onFacebookTap,
          child: const _FacebookIcon(size: 22),
        ),
      ],
    );
  }
}

class _SocialCircleButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  const _SocialCircleButton({
    required this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap ?? () {},
        borderRadius: BorderRadius.circular(28),
        child: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFFEBEBEB),
              width: 0.8,
            ),
          ),
          alignment: Alignment.center,
          child: child,
        ),
      ),
    );
  }
}

class _InstagramIcon extends StatelessWidget {
  final double size;
  const _InstagramIcon({required this.size});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _InstagramPainter(),
    );
  }
}

class _InstagramPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = AppColors.textPrimary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final fillPaint = Paint()
      ..color = AppColors.textPrimary
      ..style = PaintingStyle.fill;

    // Outer rounded rectangle
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(1, 1, size.width - 2, size.height - 2),
      const Radius.circular(5.5),
    );
    canvas.drawRRect(rrect, strokePaint);

    // Center circle
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width * 0.24,
      strokePaint,
    );

    // Top-right dot
    canvas.drawCircle(
      Offset(size.width * 0.76, size.height * 0.24),
      1.5,
      fillPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _GoogleIcon extends StatelessWidget {
  final double size;
  const _GoogleIcon({required this.size});

  @override
  Widget build(BuildContext context) {
    return Text(
      'G',
      style: GoogleFonts.montserrat(
        fontSize: size * 1.05,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
        height: 1.0,
      ),
    );
  }
}

class _FacebookIcon extends StatelessWidget {
  final double size;
  const _FacebookIcon({required this.size});

  @override
  Widget build(BuildContext context) {
    return Text(
      'f',
      style: GoogleFonts.roboto(
        fontSize: size * 1.25,
        fontWeight: FontWeight.w900,
        color: AppColors.textPrimary,
        height: 1.0,
      ),
    );
  }
}
