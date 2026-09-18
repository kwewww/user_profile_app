import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_profile_app/controllers/auth_controller.dart';
import 'package:user_profile_app/main.dart';
import 'package:user_profile_app/models/user_model.dart';
import 'package:user_profile_app/services/user_preferences_service.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('creates a local user and displays their profile', (
    WidgetTester tester,
  ) async {
    final controller = AuthController(UserPreferencesService());
    await tester.pumpWidget(MyApp(authController: controller));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Create an account'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), 'Alex Morgan');
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'alex@example.com',
    );
    await tester.enterText(find.byType(TextFormField).at(2), 'password1');
    await tester.enterText(find.byType(TextFormField).at(3), 'password1');
    await tester.tap(find.widgetWithText(FilledButton, 'Create account'));
    await tester.pumpAndSettle();

    expect(find.text('Your profile'), findsOneWidget);
    expect(find.text('Alex Morgan'), findsNWidgets(2));
    expect(find.text('alex@example.com'), findsNWidgets(2));
  });

  testWidgets('restores a valid active user directly to profile', (
    WidgetTester tester,
  ) async {
    final user = UserModel(
      id: 'user-42',
      name: 'Stored User',
      email: 'stored@example.com',
      password: 'password1',
      createdAt: DateTime(2026, 9, 1),
    );
    SharedPreferences.setMockInitialValues({
      'registered_users': [user.toJson()],
      'current_user_id': user.id,
    });

    await tester.pumpWidget(
      MyApp(authController: AuthController(UserPreferencesService())),
    );
    await tester.pumpAndSettle();

    expect(find.text('Your profile'), findsOneWidget);
    expect(find.text('Stored User'), findsNWidgets(2));
  });

  testWidgets('does not restore an active ID without a matching user', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({'current_user_id': 'missing-user'});

    await tester.pumpWidget(
      MyApp(authController: AuthController(UserPreferencesService())),
    );
    await tester.pumpAndSettle();

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Your profile'), findsNothing);
  });
}
