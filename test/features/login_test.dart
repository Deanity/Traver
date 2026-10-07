import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traver/core/services/local_storage.dart';
import 'package:traver/features/auth/presentation/screens/login_screen.dart';

void main() {
  testWidgets('LoginScreen renders all elements and toggles remember me', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: const MaterialApp(
          home: LoginScreen(),
        ),
      ),
    );

    // Verify presence of elements
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Remember me'), findsOneWidget);
    expect(find.text('Forgot password'), findsOneWidget);
    expect(find.text('Create Account'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);

    // Initial checkbox state is unchecked (no check icon)
    expect(find.byIcon(Icons.check), findsNothing);

    // Tap Remember me to check
    await tester.tap(find.text('Remember me'));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.check), findsOneWidget);

    // Tap visibility icon to toggle password
    await tester.tap(find.byIcon(Icons.visibility_off_outlined));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
  });
}
