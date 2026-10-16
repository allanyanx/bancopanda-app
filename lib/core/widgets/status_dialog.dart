import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

Future<void> mostrarEstado(
  BuildContext context, {
  required IconData icono,
  required String titulo,
  String? mensaje,
}) {
  return showDialog<void>(
    context: context,
    builder: (ctx) {
      // El tema se lee aquí, con el contexto del diálogo, para que siempre
      // use el tema vigente (incluso justo después de cambiar de modo).
      final theme = Theme.of(ctx);
      final scheme = theme.colorScheme;

      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 68,
                height: 68,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surfaceMint,
                ),
                child: Icon(icono, size: 34, color: AppColors.primaryDeep),
              ),
              const SizedBox(height: 16),
              Text(
                titulo,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: scheme.onSurface,
                ),
              ),
              if (mensaje != null) ...[
                const SizedBox(height: 8),
                Text(
                  mensaje,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Aceptar'),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
