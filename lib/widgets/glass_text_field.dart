import 'package:flutter/material.dart';

class GlassTextField extends StatelessWidget {
  const GlassTextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.autofillHints,
    this.keyboardType,
    this.obscureText = false,
    this.onToggleVisibility,
    this.textInputAction,
    this.onFieldSubmitted,
    this.validator,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final Iterable<String>? autofillHints;
  final TextInputType? keyboardType;
  final bool obscureText;
  final VoidCallback? onToggleVisibility;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    final outline = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.16)),
    );

    return TextFormField(
      controller: controller,
      autofillHints: autofillHints,
      keyboardType: keyboardType,
      obscureText: obscureText,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      validator: validator,
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        suffixIcon: onToggleVisibility == null
            ? null
            : IconButton(
                tooltip: obscureText ? 'Show password' : 'Hide password',
                onPressed: onToggleVisibility,
                icon: Icon(
                  obscureText
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
              ),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.08),
        enabledBorder: outline,
        focusedBorder: outline.copyWith(
          borderSide: const BorderSide(color: Color(0xFF8BE9FD), width: 1.4),
        ),
        errorBorder: outline.copyWith(
          borderSide: const BorderSide(color: Color(0xFFFF9A9A)),
        ),
        focusedErrorBorder: outline.copyWith(
          borderSide: const BorderSide(color: Color(0xFFFF9A9A), width: 1.4),
        ),
      ),
    );
  }
}
