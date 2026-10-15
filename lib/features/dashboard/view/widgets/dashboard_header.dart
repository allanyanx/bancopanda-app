import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/proximamente.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key, required this.nombre});

  static const _logo = 'assets/images/logo.png';

  final String nombre;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final verde = isDark ? AppColors.primary : AppColors.primaryDark;

    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Image.asset(_logo, height: 26),
              const SizedBox(width: 6),
              Flexible(
                child: Text.rich(
                  TextSpan(
                    text: 'Hola, ',
                    children: [
                      TextSpan(
                        text: nombre,
                        style: TextStyle(color: verde),
                      ),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: 'Notificaciones',
          icon: const Icon(Icons.notifications_none_outlined),
          color: verde,
          onPressed: () => mostrarProximamente(context),
        ),
      ],
    );
  }
}
