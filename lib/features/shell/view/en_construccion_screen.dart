import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Pantalla provisional para las pestañas que aún no están construidas.
class EnConstruccionScreen extends StatelessWidget {
  const EnConstruccionScreen({
    super.key,
    required this.titulo,
    required this.icono,
  });

  final String titulo;
  final IconData icono;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icono, size: 56, color: AppColors.primary),
              const SizedBox(height: 16),
              Text(
                titulo,
                style: textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Esta sección está en construcción 🐼',
                textAlign: TextAlign.center,
                style: textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
