import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../model/tarjeta.dart';

class CardSummary extends StatelessWidget {
  const CardSummary({super.key, required this.tarjeta});

  final Tarjeta tarjeta;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final vence = Formatters.expiracion(tarjeta.fechaExpiracion);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceMint,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.credit_card_outlined, color: AppColors.primaryDark),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tarjeta.nombre,
                  style: textTheme.bodyLarge?.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '${tarjeta.numeroOculto} · Vence $vence',
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (!tarjeta.activa)
            Text(
              'Inactiva',
              style: textTheme.labelLarge?.copyWith(color: AppColors.error),
            ),
        ],
      ),
    );
  }
}
