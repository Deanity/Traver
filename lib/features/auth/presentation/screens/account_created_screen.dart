import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:traver/app/router/routes.dart';
import 'package:traver/core/theme/theme.dart';
import 'package:traver/core/widgets/primary_button.dart';

class AccountCreatedScreen extends ConsumerWidget {
  const AccountCreatedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Spacer(flex: 3),

                      // Centered Pin Illustration
                      Center(
                        child: Image.asset(
                          'assets/images/account_created_pin.png',
                          width: 120,
                          height: 132,
                          fit: BoxFit.contain,
                        ),
                      ),

                      const SizedBox(height: 48),

                      // Title (Left-aligned)
                      Text(
                        'Successfully created an\naccount',
                        style: GoogleFonts.urbanist(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                          height: 1.25,
                          letterSpacing: -0.3,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Subtitle (Left-aligned)
                      Text(
                        'After this you can explore any place you\nwant. enjoy it!',
                        style: GoogleFonts.urbanist(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF8A8A8A),
                          height: 1.45,
                        ),
                      ),

                      const Spacer(flex: 4),
                    ],
                  ),
                ),
              ),

              // Bottom Button "Let's Explore!"
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.35),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: PrimaryButton(
                    text: "Let's Explore!",
                    height: 56,
                    borderRadius: BorderRadius.circular(16),
                    onPressed: () {
                      context.push(AppRoutes.favoritePlaces);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
