import 'dart:async';

import 'package:flutter/material.dart';
import 'package:user_profile_app/controllers/auth_controller.dart';
import 'package:user_profile_app/core/app_logger.dart';
import 'package:user_profile_app/services/user_preferences_service.dart';
import 'package:user_profile_app/view/sign_in_screen.dart';
import 'package:user_profile_app/view/user_profile_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, this.authController});

  /// Supplying a controller makes the app straightforward to test.
  final AuthController? authController;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AuthController _authController =
      widget.authController ?? AuthController(UserPreferencesService());
  late final bool _ownsAuthController = widget.authController == null;

  @override
  void dispose() {
    if (_ownsAuthController) _authController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF7C6CFF);

    return MaterialApp(
      title: 'Profile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: accent,
          brightness: Brightness.dark,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(color: Color(0xFFDFD9FF)),
          hintStyle: TextStyle(color: Color(0xFFAEB6D1)),
          prefixIconColor: Color(0xFFD5D1FF),
          suffixIconColor: Color(0xFFD5D1FF),
        ),
      ),
      home: _SessionGate(authController: _authController),
    );
  }
}

/// Selects the correct view after validating the locally stored active session.
class _SessionGate extends StatefulWidget {
  const _SessionGate({required this.authController});

  final AuthController authController;

  @override
  State<_SessionGate> createState() => _SessionGateState();
}

class _SessionGateState extends State<_SessionGate> {
  @override
  void initState() {
    super.initState();
    unawaited(widget.authController.restoreSession());
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.authController,
      builder: (context, _) {
        if (widget.authController.isLoadingSession) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (widget.authController.isLoggedIn) {
          AppLogger.info('Session gate rendered the profile screen.');
          return UserProfileScreen(authController: widget.authController);
        }

        AppLogger.info('Session gate rendered the sign-in screen.');
        return SignInScreen(authController: widget.authController);
      },
    );
  }
}
