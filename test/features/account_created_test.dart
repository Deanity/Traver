import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traver/app/router/routes.dart';
import 'package:traver/core/services/local_storage.dart';
import 'package:traver/features/auth/presentation/screens/account_created_screen.dart';

void main() {
  testWidgets('AccountCreatedScreen renders Screen 12 elements properly', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: const MaterialApp(
          home: AccountCreatedScreen(),
        ),
      ),
    );

    // Verify Screen 12 texts
    expect(find.text('Successfully created an\naccount'), findsOneWidget);
    expect(
      find.text('After this you can explore any place you\nwant. enjoy it!'),
      findsOneWidget,
    );
    expect(find.text("Let's Explore!"), findsOneWidget);

    // Verify Pin illustration asset image is present
    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('Tapping Let\'s Explore! navigates to favoritePlaces route', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    final router = GoRouter(
      initialLocation: AppRoutes.accountCreated,
      routes: [
        GoRoute(
          path: AppRoutes.accountCreated,
          builder: (context, state) => const AccountCreatedScreen(),
        ),
        GoRoute(
          path: AppRoutes.favoritePlaces,
          builder: (context, state) => const Scaffold(
            body: Text('Favorite Places Target'),
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

    await tester.tap(find.text("Let's Explore!"));
    await tester.pumpAndSettle();

    expect(find.text('Favorite Places Target'), findsOneWidget);
  });
}
