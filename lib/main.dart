import 'package:flutter/material.dart';
import 'package:user_profile_app/view/sign_in_screen.dart';
import 'package:user_profile_app/view/sign_up_screen.dart';
import 'package:user_profile_app/view/user_profile_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      initialRoute: '/sign-in',
      routes: {
        '/sign-in': (_) => const SignInScreen(),
        '/sign-up': (_) => const SignUpScreen(),
        '/profile': (_) => const UserProfileScreen(),
      },
    );
  }
}
