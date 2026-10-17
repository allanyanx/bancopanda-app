import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../model/cuenta.dart';

/// Tarjeta oscura de una cuenta, con el mismo estilo del saldo del inicio.
class CuentaOption extends StatelessWidget {
  const CuentaOption({
    super.key,
    required this.cuenta,
    required this.onTap,
    this.seleccionada = false,
  });

  final Cuenta cuenta;
  final VoidCallback onTap;
  final bool seleccionada;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final tenue = AppColors.textOnDark.withValues(alpha: 0.7);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: isDark ? AppColors.cardSlate : AppColors.surfaceDark,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: seleccionada ? AppColors.accent : Colors.transparent,
            width: 2,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 12, 16),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withValues(alpha: 0.2),
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet_outlined,
                    color: AppColors.accent,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cuenta.tipo.etiqueta,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: tenue,
                        ),
                      ),
                      Text(
                        cuenta.numeroCuenta,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: AppColors.textOnDark,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Disponible',
                      style: theme.textTheme.bodySmall?.copyWith(color: tenue),
                    ),
                    Text(
                      Formatters.moneda(cuenta.saldo),
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: AppColors.textOnDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 4),
                Icon(Icons.chevron_right, color: tenue),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
