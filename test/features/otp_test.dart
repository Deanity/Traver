import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traver/app/router/routes.dart';
import 'package:traver/core/services/local_storage.dart';
import 'package:traver/features/auth/presentation/screens/otp_screen.dart';

void main() {
  testWidgets('OtpScreen renders Screen 11 verification elements correctly', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: const MaterialApp(
          home: OtpScreen(),
        ),
      ),
    );

    // Verify Screen 11 headers and texts
    expect(find.text('Create Your Account'), findsOneWidget);
    expect(find.text('OTP Verification'), findsOneWidget);
    expect(find.text('Send code reload in'), findsOneWidget);
    expect(find.text('Submit'), findsOneWidget);

    // Default pre-filled OTP numbers matching design: 1, 3, 5, 4
    expect(find.text('1'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    expect(find.text('5'), findsOneWidget);
    expect(find.text('4'), findsOneWidget);
  });

  testWidgets('OtpScreen validates incomplete code', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: const MaterialApp(
          home: OtpScreen(),
        ),
      ),
    );

    // Clear one of the digits
    await tester.enterText(find.widgetWithText(TextField, '1'), '');
    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();

    expect(find.text('Please enter the complete 4-digit verification code'), findsOneWidget);
  });

  testWidgets('Submitting valid OTP navigates to accountCreated', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    final router = GoRouter(
      initialLocation: AppRoutes.otp,
      routes: [
        GoRoute(
          path: AppRoutes.otp,
          builder: (context, state) => const OtpScreen(),
        ),
        GoRoute(
          path: AppRoutes.accountCreated,
          builder: (context, state) => const Scaffold(
            body: Text('Account Created Screen Target'),
          ),
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

    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();

    expect(find.text('Account Created Screen Target'), findsOneWidget);
  });
}
