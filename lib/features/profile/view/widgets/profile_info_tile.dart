import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Tarjeta menta con etiqueta y valor
class ProfileInfoTile extends StatelessWidget {
  const ProfileInfoTile({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceMint,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: textTheme.bodyLarge?.copyWith(color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}
