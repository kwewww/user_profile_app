import 'package:flutter/material.dart';

import 'package:user_profile_app/extensions/build_context_extensions.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = context.isCompact ? 20.0 : 28.0;

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF111B3E), Color(0xFF251842), Color(0xFF0C3042)],
          ),
        ),
        child: Stack(
          children: [
            const _Glow(
              alignment: Alignment.topRight,
              color: Color(0xFF8B5CF6),
            ),
            const _Glow(
              alignment: Alignment.bottomLeft,
              color: Color(0xFF22D3EE),
            ),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: 32,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 440),
                    child: child,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({required this.alignment, required this.color});

  final Alignment alignment;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Align(
        alignment: alignment,
        child: Transform.translate(
          offset: Offset(alignment.x * 72, alignment.y * 72),
          child: Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [color.withValues(alpha: 0.60), Colors.transparent],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
