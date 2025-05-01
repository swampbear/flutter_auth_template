/*
  File: lib/widgets/auth_widgets.dart
  Contains reusable widgets for authentication screens
*/

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  const AuthHeader(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final height = MediaQuery.of(context).size.height * 0.3;
    final cs = theme.colorScheme;
    final textStyle = theme.textTheme.headlineSmall?.copyWith(
      color: cs.onPrimary,
      fontWeight: FontWeight.bold,
    );

    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: cs.primary,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      alignment: Alignment.center,
      child: Text(title, textAlign: TextAlign.center, style: textStyle),
    );
  }
}

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final IconData icon;
  final Widget? suffix;
  final String? Function(String?)? validator;

  const InputField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.suffix,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.elementSpacing),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(
            icon,
            color: Theme.of(context).inputDecorationTheme.prefixIconColor,
          ),
          suffixIcon: suffix,
        ),
        validator: validator,
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final String label;
  final bool loading;
  final VoidCallback onPressed;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.loading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // We assume you want to use your secondary color for the button BG,
    // and the matching onSecondary for its text/icon color.
    final bg = theme.colorScheme.secondary;
    final fg = theme.colorScheme.onSecondary;

    return SizedBox(
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          textStyle: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: loading ? null : onPressed,
        child:
            loading
                // spinner uses the same fg color
                ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(fg),
                  ),
                )
                // plain Text inherits the button’s textStyle & fg
                : Text(label),
      ),
    );
  }
}

class SeparatorWithText extends StatelessWidget {
  final String text;

  const SeparatorWithText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.fieldSpacing),
      child: Row(
        children: [
          const Expanded(child: Divider()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
          ),
          const Expanded(child: Divider()),
        ],
      ),
    );
  }
}

class SocialButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const SocialButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
      ),
    );
  }
}

class AuthFooterLink extends StatelessWidget {
  final String text;
  final String actionText;
  final VoidCallback onTap;

  const AuthFooterLink({
    super.key,
    required this.text,
    required this.actionText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppTheme.paddingVertical),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(text, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onTap,
            child: Text(
              actionText,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
