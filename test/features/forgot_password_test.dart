import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:traver/features/auth/presentation/screens/forgot_password_screen.dart';

void main() {
  testWidgets('ForgotPasswordScreen renders all elements and validates input', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ForgotPasswordScreen(),
      ),
    );

    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    expect(find.text('Input Your Email'), findsOneWidget);
    expect(find.text('Forgot Your Password?'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Submit'), findsOneWidget);

    // Test clear and submit invalid email
    await tester.enterText(find.byType(TextFormField), '');
    await tester.tap(find.text('Submit'));
    await tester.pump();

    expect(find.text('Please input your email address'), findsOneWidget);
  });
}
