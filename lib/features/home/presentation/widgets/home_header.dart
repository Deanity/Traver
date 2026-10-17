import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:traver/app/router/routes.dart';
import 'package:traver/core/theme/theme.dart';
import 'package:traver/features/auth/presentation/session_provider.dart';

class HomeHeader extends ConsumerWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    final user = session.user;

    // Default to Pristia if not logged in or first name is Pristia
    String displayName = 'Pristia';
    if (user != null && user.name.trim().isNotEmpty) {
      displayName = user.name.trim().split(' ').first;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // User Avatar & Greeting
          InkWell(
            onTap: () => context.go(AppRoutes.profile),
            borderRadius: BorderRadius.circular(24),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFF0F0F0), width: 1.5),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/avatars/avatar_image.png',
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: const Color(0xFFE8E8E8),
                        child: const Icon(
                          Icons.person,
                          color: AppColors.textSecondary,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Hello, $displayName!',
                  style: GoogleFonts.urbanist(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          // Notification Bell with Red Badge Dot
          GestureDetector(
            onTap: () => context.push(AppRoutes.notifications),
            behavior: HitTestBehavior.opaque,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.notifications_none_rounded,
                      size: 26,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                // Red badge dot
                Positioned(
                  top: 7,
                  right: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF4842),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
