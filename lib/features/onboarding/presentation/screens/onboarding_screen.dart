import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:traver/app/router/routes.dart';
import 'package:traver/core/widgets/primary_button.dart';
import 'package:traver/core/widgets/traver_logo.dart';
import 'package:traver/features/auth/presentation/session_provider.dart';
import '../../data/onboarding_item.dart';
import '../widgets/onboarding_indicator.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  late final PageController _pageController;
  int _currentPage = 0;
  final List<OnboardingItem> _items = OnboardingItem.defaultItems;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _handleNext() async {
    if (_currentPage < _items.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      await ref.read(onboardingDoneProvider.notifier).completeOnboarding();
      if (mounted) {
        context.go(AppRoutes.login);
      }
    }
  }

  void _onSelectPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          fit: StackFit.expand,
          children: [
            // PageView for image + gradient + text content
            PageView.builder(
              controller: _pageController,
              itemCount: _items.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                final item = _items[index];
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    // Background Image
                    Image.asset(
                      item.imagePath,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),

                    // Contrast gradient overlay
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                          colors: [
                            Colors.black.withValues(alpha: 0.35),
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.25),
                            Colors.black.withValues(alpha: 0.75),
                            Colors.black.withValues(alpha: 0.95),
                          ],
                        ),
                      ),
                    ),

                    // Content
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const TraverLogo(fontSize: 28),
                            const SizedBox(height: 20),
                            Text(
                              item.title,
                              style: GoogleFonts.urbanist(
                                fontSize: 40,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                height: 1.15,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              item.description,
                              style: GoogleFonts.urbanist(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.white.withValues(alpha: 0.85),
                                height: 1.45,
                              ),
                            ),
                            // Space reserved for fixed indicator and button
                            const SizedBox(height: 130),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),

            // Fixed Bottom Controls (Indicator + Button)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      OnboardingIndicator(
                        count: _items.length,
                        currentIndex: _currentPage,
                        onSelect: _onSelectPage,
                      ),
                      const SizedBox(height: 24),
                      PrimaryButton(
                        text: _currentPage == _items.length - 1
                            ? 'Get Started'
                            : 'Next',
                        height: 56.0,
                        onPressed: _handleNext,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
