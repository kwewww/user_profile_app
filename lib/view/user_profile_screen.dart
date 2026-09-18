import 'package:flutter/material.dart';

import 'package:user_profile_app/controllers/auth_controller.dart';
import 'package:user_profile_app/extensions/build_context_extensions.dart';
import 'package:user_profile_app/extensions/widget_extensions.dart';
import 'package:user_profile_app/models/user_model.dart';
import 'package:user_profile_app/widgets/auth_page.dart';
import 'package:user_profile_app/widgets/glass_card.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({required this.authController, super.key});

  final AuthController authController;

  @override
  Widget build(BuildContext context) {
    // The session gate only presents this screen for a validated active user.
    final user = authController.currentUser!;

    return AuthPage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Your profile',
                  style: context.textStyles.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.7,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Sign out',
                onPressed: authController.signOut,
                icon: const Icon(Icons.logout_rounded, color: Colors.white),
              ),
            ],
          ),
          8.verticalSpace,
          Text(
            'Your account at a glance.',
            style: context.textStyles.bodyLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.72),
            ),
          ),
          24.verticalSpace,
          _UserDetailsCard(user: user),
          20.verticalSpace,
          GlassCard(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFF75F1C3).withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.verified_rounded,
                    color: Color(0xFF75F1C3),
                  ),
                ),
                14.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Account active',
                        style: context.textStyles.titleSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      4.verticalSpace,
                      Text(
                        'Your profile is ready to use.',
                        style: context.textStyles.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.68),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UserDetailsCard extends StatelessWidget {
  const _UserDetailsCard({required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: EdgeInsets.all(context.isCompact ? 20 : 24),
      child: Column(
        children: [
          Container(
            width: 92,
            height: 92,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF9F8CFF), Color(0xFF47D8EE)],
              ),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.46),
                width: 2,
              ),
            ),
            child: Text(
              user.initials,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          16.verticalSpace,
          Text(
            user.name,
            style: context.textStyles.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          4.verticalSpace,
          Text(
            user.email,
            style: context.textStyles.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.68),
            ),
          ),
          24.verticalSpace,
          const Divider(color: Color(0x44FFFFFF)),
          8.verticalSpace,
          _ProfileDetail(
            icon: Icons.person_outline_rounded,
            label: 'Full name',
            value: user.name,
          ),
          _ProfileDetail(
            icon: Icons.alternate_email_rounded,
            label: 'Email address',
            value: user.email,
          ),
          _ProfileDetail(
            icon: Icons.calendar_today_outlined,
            label: 'Member since',
            value: _formatMemberSince(user.createdAt),
          ),
        ],
      ),
    );
  }

  String _formatMemberSince(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}

class _ProfileDetail extends StatelessWidget {
  const _ProfileDetail({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFD5D1FF)),
          14.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: context.textStyles.labelMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.58),
                  ),
                ),
                3.verticalSpace,
                Text(
                  value,
                  style: context.textStyles.bodyLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
