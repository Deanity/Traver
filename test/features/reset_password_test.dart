import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traver/core/services/local_storage.dart';
import 'package:traver/features/auth/presentation/screens/reset_password_screen.dart';

void main() {
  testWidgets('ResetPasswordScreen renders elements and validates passwords', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: const MaterialApp(
          home: ResetPasswordScreen(),
        ),
      ),
    );

    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    expect(find.text('Forgot Password'), findsOneWidget);
    expect(find.text('Create New Password'), findsOneWidget);
    expect(find.text('Save'), findsOneWidget);
    expect(
      find.text('Your password must include at least one symbol and be 8 or more characters long.'),
      findsOneWidget,
    );

    // Enter mismatched passwords
    final textFields = find.byType(TextFormField);
    await tester.enterText(textFields.first, 'newpassword123');
    await tester.enterText(textFields.last, 'differentpass');
    await tester.tap(find.text('Save'));
    await tester.pump();

    expect(find.text('Passwords do not match'), findsOneWidget);
  });
}
