import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key}) : _horizontal = false;

  const AuthHeader.horizontal({super.key}) : _horizontal = true;

  static const _logo = 'assets/images/logo.png';

  final bool _horizontal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bancoColor = isDark
        ? theme.colorScheme.onSurface.withValues(alpha: 0.75)
        : AppColors.textPrimary;
    final pandaColor = isDark ? AppColors.primary : AppColors.primaryDark;
    final nombre = theme.textTheme.headlineLarge?.copyWith(
      fontWeight: FontWeight.bold,
      height: 1.1,
    );

    if (_horizontal) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(_logo, height: 84),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Banco', style: nombre?.copyWith(color: bancoColor)),
              Text('Panda', style: nombre?.copyWith(color: pandaColor)),
            ],
          ),
        ],
      );
    }

    return Column(
      children: [
        Image.asset(_logo, height: 130),
        const SizedBox(height: 8),
        Text.rich(
          TextSpan(
            text: 'Banco ',
            style: nombre?.copyWith(color: bancoColor),
            children: [
              TextSpan(text: 'Panda', style: TextStyle(color: pandaColor)),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Tu dinero, tu tranquilidad',
          style: theme.textTheme.bodyMedium?.copyWith(color: pandaColor),
        ),
      ],
    );
  }
}
