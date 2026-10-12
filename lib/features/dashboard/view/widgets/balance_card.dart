import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../model/cuenta.dart';

/// Tarjeta con el saldo de la cuenta. El ojo oculta o muestra el monto.
class BalanceCard extends StatefulWidget {
  const BalanceCard({super.key, required this.cuenta});

  final Cuenta cuenta;

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  static const _saldoOculto = '••••••';

  bool _saldoVisible = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cuenta = widget.cuenta;

    final tenue = AppColors.textOnDark.withValues(alpha: 0.7);

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardSlate : AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -50,
            bottom: -70,
            child: Container(
              width: 190,
              height: 190,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark
                    ? AppColors.primary.withValues(alpha: 0.18)
                    : AppColors.textOnDark.withValues(alpha: 0.04),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 8, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Saldo Total',
                        style:
                            theme.textTheme.bodyMedium?.copyWith(color: tenue),
                      ),
                    ),
                    IconButton(
                      tooltip:
                          _saldoVisible ? 'Ocultar saldo' : 'Mostrar saldo',
                      icon: Icon(
                        _saldoVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 20,
                      ),
                      color: tenue,
                      onPressed: () =>
                          setState(() => _saldoVisible = !_saldoVisible),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Flexible(
                      child: Text(
                        _saldoVisible
                            ? Formatters.moneda(cuenta.saldo)
                            : _saldoOculto,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: AppColors.textOnDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      cuenta.moneda,
                      style: theme.textTheme.bodySmall?.copyWith(color: tenue),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cuenta.tipo.etiqueta,
                              style: theme.textTheme.bodySmall
                                  ?.copyWith(color: tenue),
                            ),
                            Text(
                              cuenta.numeroCuenta,
                              style: theme.textTheme.bodyLarge
                                  ?.copyWith(color: AppColors.textOnDark),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.account_balance_wallet_outlined,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
