import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traver/core/services/local_storage.dart';
import 'package:traver/features/onboarding/presentation/screens/onboarding_screen.dart';

void main() {
  testWidgets('OnboardingScreen navigates through 3 stages and finishes', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: const MaterialApp(
          home: OnboardingScreen(),
        ),
      ),
    );

    // Initial Stage 1
    expect(find.text('Lets explore\nthe world'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);

    // Tap Next -> Stage 2
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.text('Visit tourist\nattractions'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);

    // Tap Next -> Stage 3
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.text('Get ready for\nnext trip'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
  });
}
