import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../auth/model/usuario.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.usuario});

  final Usuario usuario;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final iniciales = '${usuario.primerNombre[0]}${usuario.primerApellido[0]}'
        .toUpperCase();

    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 56,
              backgroundColor: AppColors.fieldBorder,
              child: Text(
                iniciales,
                style: theme.textTheme.displaySmall?.copyWith(
                  color: AppColors.primaryDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Positioned(
              right: 4,
              top: 4,
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: AppColors.primaryDeep,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark
                        ? AppColors.backgroundDark
                        : AppColors.background,
                    width: 3,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '${usuario.primerNombre} ',
                style: const TextStyle(color: AppColors.primaryDeep),
              ),
              TextSpan(text: usuario.primerApellido),
            ],
          ),
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
