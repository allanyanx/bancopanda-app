import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Estructura común de cada paso: título, contenido con scroll y, si hay,
/// el botón principal fijo abajo.
class PasoLayout extends StatelessWidget {
  const PasoLayout({
    super.key,
    required this.titulo,
    required this.children,
    this.subtitulo,
    this.boton,
  });

  final String titulo;
  final String? subtitulo;
  final List<Widget> children;
  final Widget? boton;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final boton = this.boton;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              Text(
                titulo,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (subtitulo != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitulo!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
              const SizedBox(height: 20),
              ...children,
            ],
          ),
        ),
        if (boton != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: boton,
          ),
      ],
    );
  }
}

class MensajeError extends StatelessWidget {
  const MensajeError(this.mensaje, {super.key});

  final String mensaje;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.error;

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error_outline, size: 20, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(mensaje, style: TextStyle(color: color)),
          ),
        ],
      ),
    );
  }
}
