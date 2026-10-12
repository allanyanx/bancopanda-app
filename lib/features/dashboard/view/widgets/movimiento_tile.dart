import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../model/movimiento.dart';

/// Fila de un movimiento en "Actividad reciente".
class MovimientoTile extends StatelessWidget {
  const MovimientoTile({super.key, required this.movimiento});

  final Movimiento movimiento;

  static IconData _icono(CategoriaMovimiento categoria) {
    return switch (categoria) {
      CategoriaMovimiento.sueldo => Icons.payments_outlined,
      CategoriaMovimiento.transferencia => Icons.swap_horiz_rounded,
      CategoriaMovimiento.comida => Icons.fastfood_outlined,
      CategoriaMovimiento.transporte => Icons.directions_bus_outlined,
      CategoriaMovimiento.compras => Icons.checkroom_outlined,
      CategoriaMovimiento.servicios => Icons.receipt_long_outlined,
      CategoriaMovimiento.otros => Icons.account_balance_wallet_outlined,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final esIngreso = movimiento.tipo == TipoMovimiento.ingreso;
    final monto = Formatters.moneda(movimiento.monto);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
              border: isDark
                  ? null
                  : Border.all(color: theme.colorScheme.outlineVariant),
            ),
            child: Icon(
              _icono(movimiento.categoria),
              color: AppColors.textPrimary,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movimiento.descripcion,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyLarge,
                ),
                Text(
                  Formatters.fechaMovimiento(movimiento.fecha),
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            esIngreso ? '+$monto' : '-$monto',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: esIngreso ? AppColors.primary : null,
            ),
          ),
        ],
      ),
    );
  }
}
