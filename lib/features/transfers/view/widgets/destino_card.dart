import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Tarjeta menta con las iniciales, el nombre y el banco · cuenta.
class DestinoCard extends StatelessWidget {
  const DestinoCard({
    super.key,
    required this.titulo,
    required this.detalle,
    this.onTap,
    this.verificado = false,
  });

  final String titulo;
  final String detalle;
  final VoidCallback? onTap;
  final bool verificado;

  String get _iniciales {
    final partes = titulo.split(' ').where((p) => p.isNotEmpty).toList();
    if (partes.isEmpty || RegExp(r'^\d').hasMatch(partes.last)) return '#';
    return partes.take(2).map((p) => p[0].toUpperCase()).join();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final tenue = isDark
        ? AppColors.textOnDark.withValues(alpha: 0.7)
        : AppColors.textSecondary;

    return Material(
      color: isDark ? AppColors.cardGreen : AppColors.surfaceMint,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.primaryDeep,
                child: Text(
                  _iniciales,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      detalle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(color: tenue),
                    ),
                  ],
                ),
              ),
              if (verificado)
                const Icon(Icons.verified_outlined, color: AppColors.primary)
              else if (onTap != null)
                Icon(Icons.chevron_right, color: tenue),
            ],
          ),
        ),
      ),
    );
  }
}
