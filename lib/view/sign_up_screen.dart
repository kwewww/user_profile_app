import 'package:flutter/material.dart';

import 'package:user_profile_app/extensions/build_context_extensions.dart';
import 'package:user_profile_app/extensions/widget_extensions.dart';
import 'package:user_profile_app/widgets/auth_page.dart';
import 'package:user_profile_app/widgets/glass_card.dart';
import 'package:user_profile_app/widgets/glass_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmation = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _createAccount() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Your account has been created.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthPage(
      child: AutofillGroup(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Create account',
                style: context.textStyles.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.7,
                ),
              ),
              8.verticalSpace,
              Text(
                'A few details and you are ready to go.',
                style: context.textStyles.bodyLarge?.copyWith(
                  color: Colors.white.withValues(alpha: 0.72),
                ),
              ),
              24.verticalSpace,
              GlassCard(
                padding: EdgeInsets.all(context.isCompact ? 20 : 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    GlassTextField(
                      controller: _nameController,
                      label: 'Full name',
                      hint: 'How should we call you?',
                      icon: Icons.person_outline_rounded,
                      autofillHints: const [AutofillHints.name],
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if ((value?.trim() ?? '').isEmpty) {
                          return 'Enter your name.';
                        }
                        return null;
                      },
                    ),
                    16.verticalSpace,
                    GlassTextField(
                      controller: _emailController,
                      label: 'Email address',
                      hint: 'you@example.com',
                      icon: Icons.alternate_email_rounded,
                      autofillHints: const [AutofillHints.newUsername],
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: _validateEmail,
                    ),
                    16.verticalSpace,
                    GlassTextField(
                      controller: _passwordController,
                      label: 'Password',
                      hint: 'At least 8 characters',
                      icon: Icons.lock_outline_rounded,
                      autofillHints: const [AutofillHints.newPassword],
                      obscureText: _obscurePassword,
                      onToggleVisibility: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                      textInputAction: TextInputAction.next,
                      validator: _validateNewPassword,
                    ),
                    16.verticalSpace,
                    GlassTextField(
                      controller: _confirmPasswordController,
                      label: 'Confirm password',
                      hint: 'Repeat your password',
                      icon: Icons.verified_user_outlined,
                      autofillHints: const [AutofillHints.newPassword],
                      obscureText: _obscureConfirmation,
                      onToggleVisibility: () {
                        setState(
                          () => _obscureConfirmation = !_obscureConfirmation,
                        );
                      },
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _createAccount(),
                      validator: _validateConfirmation,
                    ),
                    22.verticalSpace,
                    FilledButton(
                      onPressed: _createAccount,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(54),
                        backgroundColor: context.colors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text('Create account'),
                    ),
                  ],
                ),
              ),
              20.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.72)),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pushReplacementNamed('/sign-in'),
                    child: const Text('Sign in'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Enter your email address.';
    if (!email.contains('@')) return 'Enter a valid email address.';
    return null;
  }

  String? _validateNewPassword(String? value) {
    if ((value ?? '').length < 8) return 'Use at least 8 characters.';
    return null;
  }

  String? _validateConfirmation(String? value) {
    if (value != _passwordController.text) return 'Passwords do not match.';
    return null;
  }
}
