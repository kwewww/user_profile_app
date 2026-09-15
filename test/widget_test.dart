import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:user_profile_app/main.dart';

void main() {
  testWidgets('sign-in screen navigates to profile and sign-up', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Email address'), findsOneWidget);
    expect(find.text('Create an account'), findsOneWidget);

    await tester.enterText(
      find.byType(TextFormField).at(0),
      'alex@example.com',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'password');
    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();

    expect(find.text('Your profile'), findsOneWidget);
    expect(find.text('Account active'), findsOneWidget);

    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Create an account'));
    await tester.pumpAndSettle();

    expect(find.text('Create account'), findsWidgets);
    expect(find.text('Already have an account?'), findsOneWidget);
  });
}
