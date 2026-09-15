import 'package:flutter/material.dart';

import 'package:user_profile_app/extensions/build_context_extensions.dart';
import 'package:user_profile_app/extensions/widget_extensions.dart';
import 'package:user_profile_app/widgets/auth_page.dart';
import 'package:user_profile_app/widgets/glass_card.dart';
import 'package:user_profile_app/widgets/glass_text_field.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signIn() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    Navigator.of(context).pushReplacementNamed('/profile');
  }

  void _showUnavailableMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('This option will be available soon.')),
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
              const _BrandMark(),
              26.verticalSpace,
              Text(
                'Welcome back',
                style: context.textStyles.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.7,
                ),
              ),
              8.verticalSpace,
              Text(
                'Sign in to pick up exactly where you left off.',
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
                      controller: _emailController,
                      label: 'Email address',
                      hint: 'you@example.com',
                      icon: Icons.alternate_email_rounded,
                      autofillHints: const [AutofillHints.email],
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: _validateEmail,
                    ),
                    16.verticalSpace,
                    GlassTextField(
                      controller: _passwordController,
                      label: 'Password',
                      hint: 'Enter your password',
                      icon: Icons.lock_outline_rounded,
                      autofillHints: const [AutofillHints.password],
                      obscureText: _obscurePassword,
                      onToggleVisibility: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _signIn(),
                      validator: _validatePassword,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _showUnavailableMessage,
                        child: const Text('Forgot password?'),
                      ),
                    ),
                    4.verticalSpace,
                    FilledButton(
                      onPressed: _signIn,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(54),
                        backgroundColor: context.colors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text('Sign in'),
                    ),
                    20.verticalSpace,
                    Row(
                      children: [
                        const Expanded(child: Divider(color: Color(0x55FFFFFF))),
                        Text(
                          'or continue with',
                          style: context.textStyles.labelMedium?.copyWith(
                            color: Colors.white.withValues(alpha: 0.58),
                          ),
                        ).padHorizontal(12),
                        const Expanded(child: Divider(color: Color(0x55FFFFFF))),
                      ],
                    ),
                    20.verticalSpace,
                    OutlinedButton.icon(
                      onPressed: _showUnavailableMessage,
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                        foregroundColor: Colors.white,
                        side: BorderSide(color: Colors.white.withValues(alpha: 0.30)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      icon: const Icon(Icons.g_mobiledata_rounded, size: 28),
                      label: const Text('Google'),
                    ),
                  ],
                ),
              ),
              20.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'New here?',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.72)),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pushReplacementNamed('/sign-up'),
                    child: const Text('Create an account'),
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

  String? _validatePassword(String? value) {
    if ((value ?? '').isEmpty) return 'Enter your password.';
    return null;
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: Colors.white.withValues(alpha: 0.28)),
      ),
      child: const Icon(Icons.person_rounded, color: Colors.white),
    );
  }
}
