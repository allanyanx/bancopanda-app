import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../model/cuenta.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({
    super.key,
    required this.saldoTotal,
    required this.moneda,
    required this.cuentas,
    required this.saldoVisible,
    required this.onAlternarSaldo,
  });

  static const saldoOculto = '••••••';

  final double saldoTotal;
  final String moneda;
  final List<Cuenta> cuentas;
  final bool saldoVisible;
  final VoidCallback onAlternarSaldo;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final tenue = AppColors.textOnDark.withValues(alpha: 0.7);

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardSlate : AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
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
                    : AppColors.textOnDark.withValues(alpha: 0.05),
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
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: tenue,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: saldoVisible ? 'Ocultar saldo' : 'Mostrar saldo',
                      icon: Icon(
                        saldoVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 20,
                      ),
                      color: tenue,
                      onPressed: onAlternarSaldo,
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Flexible(
                      child: Text(
                        saldoVisible
                            ? Formatters.moneda(saldoTotal)
                            : saldoOculto,
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
                      moneda,
                      style: theme.textTheme.bodySmall?.copyWith(color: tenue),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                for (final (indice, cuenta) in cuentas.indexed)
                  Padding(
                    padding: EdgeInsets.only(
                      right: 12,
                      top: indice == 0 ? 0 : 10,
                    ),
                    child: _CuentaRow(
                      cuenta: cuenta,
                      numeroVisible: saldoVisible,
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

class _CuentaRow extends StatelessWidget {
  const _CuentaRow({required this.cuenta, required this.numeroVisible});

  final Cuenta cuenta;
  final bool numeroVisible;

  String get _numero {
    final numero = cuenta.numeroCuenta;
    return numeroVisible
        ? numero
        : '•••• ${numero.substring(numero.length - 4)}';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final tenue = AppColors.textOnDark.withValues(alpha: 0.7);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cuenta.tipo.etiqueta,
                style: textTheme.bodySmall?.copyWith(color: tenue),
              ),
              Text(
                _numero,
                style: textTheme.bodyLarge?.copyWith(
                  color: AppColors.textOnDark,
                ),
              ),
            ],
          ),
        ),
        const Icon(
          Icons.account_balance_wallet_outlined,
          color: AppColors.primary,
        ),
      ],
    );
  }
}
