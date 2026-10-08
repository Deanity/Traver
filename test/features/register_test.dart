import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:traver/app/router/routes.dart';
import 'package:traver/core/services/local_storage.dart';
import 'package:traver/features/auth/presentation/screens/login_screen.dart';
import 'package:traver/features/auth/presentation/screens/register_screen.dart';

void main() {
  testWidgets('RegisterScreen renders Screen 08 name step correctly', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: const MaterialApp(
          home: RegisterScreen(),
        ),
      ),
    );

    // Verify Screen 08 headers and labels
    expect(find.text('Create Your Account'), findsOneWidget);
    expect(find.text("What's is your name?"), findsOneWidget);
    expect(find.text('First Name'), findsOneWidget);
    expect(find.text('Last Name'), findsOneWidget);

    // Default pre-filled values matching design
    expect(find.text('Pristia'), findsOneWidget);
    expect(find.text('Candra'), findsOneWidget);

    // Primary action button
    expect(find.text('Input Email'), findsOneWidget);

    // Tap Input Email advances to Step 2 ("And, your email?")
    await tester.tap(find.text('Input Email'));
    await tester.pumpAndSettle();

    expect(find.text('And, your email?'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Create Password'), findsOneWidget);

    // Tap back button returns to Step 1 (Screen 08)
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    expect(find.text("What's is your name?"), findsOneWidget);
    expect(find.text('Input Email'), findsOneWidget);
  });

  testWidgets('RegisterScreen validates empty name fields', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: const MaterialApp(
          home: RegisterScreen(),
        ),
      ),
    );

    // Clear first name
    await tester.enterText(find.widgetWithText(TextFormField, 'Pristia'), '');
    await tester.tap(find.text('Input Email'));
    await tester.pumpAndSettle();

    expect(find.text('Please enter your first name'), findsOneWidget);
  });

  testWidgets('Tapping Create Account on LoginScreen navigates to RegisterScreen (Screen 08)', (tester) async {
    SharedPreferences.setMockInitialValues({'onboarding_done': true});
    final prefs = await SharedPreferences.getInstance();

    final router = GoRouter(
      initialLocation: AppRoutes.login,
      routes: [
        GoRoute(
          path: AppRoutes.login,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: AppRoutes.register,
          builder: (context, state) => const RegisterScreen(),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: MaterialApp.router(
          routerConfig: router,
        ),
      ),
    );

    expect(find.text('Create Account'), findsOneWidget);
    await tester.tap(find.text('Create Account'));
    await tester.pumpAndSettle();

    // Verify user is now on Screen 08 (RegisterScreen)
    expect(find.text('Create Your Account'), findsOneWidget);
    expect(find.text("What's is your name?"), findsOneWidget);
    expect(find.text('First Name'), findsOneWidget);
    expect(find.text('Last Name'), findsOneWidget);
    expect(find.text('Input Email'), findsOneWidget);
  });
}
