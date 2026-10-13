import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.titulo,
    required this.onVerMas,
  });

  final String titulo;
  final VoidCallback onVerMas;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final verde = isDark ? AppColors.primary : AppColors.primaryDark;

    return Row(
      children: [
        Expanded(
          child: Text(
            titulo,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        InkWell(
          onTap: onVerMas,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            child: Row(
              children: [
                Text(
                  'Ver más',
                  style: theme.textTheme.bodySmall?.copyWith(color: verde),
                ),
                Icon(Icons.chevron_right, size: 18, color: verde),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
