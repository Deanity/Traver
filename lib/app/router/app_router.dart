import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/widgets/placeholder_screen.dart';
import '../../features/auth/auth.dart';
import '../../features/onboarding/onboarding.dart';
import 'main_shell_screen.dart';
import 'routes.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.onboarding,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        redirect: (context, state) => AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.otp,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return OtpScreen(
            email: extra?['email'] as String?,
            name: extra?['name'] as String?,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.resetPassword,
        builder: (context, state) => const ResetPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.accountCreated,
        builder: (context, state) => const AccountCreatedScreen(),
      ),
      GoRoute(
        path: AppRoutes.favoritePlaces,
        builder: (context, state) => const PlaceholderScreen(title: 'Favorite Places'),
      ),

      // Bottom Navigation Tab Shell
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShellScreen(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const PlaceholderScreen(title: 'Home'),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.trips,
                builder: (context, state) => const PlaceholderScreen(title: 'My Trips'),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.wishlist,
                builder: (context, state) => const PlaceholderScreen(title: 'Wishlist'),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (context, state) => const PlaceholderScreen(title: 'Profile'),
              ),
            ],
          ),
        ],
      ),

      // Other Stack screens
      GoRoute(
        path: AppRoutes.destinationDetail,
        builder: (context, state) => PlaceholderScreen(
          title: 'Destination Detail: ${state.pathParameters['id']}',
        ),
      ),
      GoRoute(
        path: AppRoutes.search,
        builder: (context, state) => const PlaceholderScreen(title: 'Search'),
      ),
      GoRoute(
        path: AppRoutes.category,
        builder: (context, state) => PlaceholderScreen(
          title: 'Category: ${state.pathParameters['id']}',
        ),
      ),
      GoRoute(
        path: AppRoutes.notifications,
        builder: (context, state) => const PlaceholderScreen(title: 'Notifications'),
      ),
    ],
  );
});
