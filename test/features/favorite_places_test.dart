import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traver/app/router/routes.dart';
import 'package:traver/core/constants/app_constants.dart';
import 'package:traver/core/services/local_storage.dart';
import 'package:traver/features/auth/presentation/screens/favorite_places_screen.dart';

void main() {
  testWidgets('FavoritePlacesScreen renders Screen 13 categories and toggles selection', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: const MaterialApp(
          home: FavoritePlacesScreen(),
        ),
      ),
    );

    // Verify Title and Button
    expect(find.text('Where is your favorite\nplace to explore?'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);

    // Verify all 6 category names
    expect(find.text('Beach'), findsOneWidget);
    expect(find.text('Mountain'), findsOneWidget);
    expect(find.text('Forest'), findsOneWidget);
    expect(find.text('Ocean'), findsOneWidget);
    expect(find.text('Camping'), findsOneWidget);
    expect(find.text('Fishing'), findsOneWidget);

    // Initial checkmarks: Mountain and Forest (2 check icons)
    expect(find.byIcon(Icons.check), findsNWidgets(2));

    // Tap Beach to select it
    await tester.tap(find.text('Beach'));
    await tester.pumpAndSettle();

    // Now 3 checkmarks
    expect(find.byIcon(Icons.check), findsNWidgets(3));

    // Tap Mountain to unselect it
    await tester.tap(find.text('Mountain'));
    await tester.pumpAndSettle();

    // Now 2 checkmarks (Forest, Beach)
    expect(find.byIcon(Icons.check), findsNWidgets(2));
  });

  testWidgets('Tapping Next saves favorites to local storage and navigates to home', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    final router = GoRouter(
      initialLocation: AppRoutes.favoritePlaces,
      routes: [
        GoRoute(
          path: AppRoutes.favoritePlaces,
          builder: (context, state) => const FavoritePlacesScreen(),
        ),
        GoRoute(
          path: AppRoutes.home,
          builder: (context, state) => const Scaffold(
            body: Text('Home Screen Target'),
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

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    // Verify navigation
    expect(find.text('Home Screen Target'), findsOneWidget);

    // Verify local storage has saved favorite places
    final storage = LocalStorage(prefs);
    final saved = storage.getJson(StorageKeys.favoritePlaces);
    expect(saved, isNotNull);
    expect(saved, isA<List>());
    expect((saved as List).contains('mountain'), isTrue);
    expect(saved.contains('forest'), isTrue);
  });
}
