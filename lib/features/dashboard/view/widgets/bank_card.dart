import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../model/tarjeta.dart';
import 'balance_card.dart';

class BankCard extends StatelessWidget {
  const BankCard({
    super.key,
    required this.tarjeta,
    required this.titular,
    required this.color,
    required this.saldoVisible,
    required this.onTap,
  });

  static const width = 300.0;
  static const height = 180.0;

  final Tarjeta tarjeta;
  final String titular;
  final Color color;
  final bool saldoVisible;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final tenue = AppColors.textOnDark.withValues(alpha: 0.7);

    return Opacity(
      opacity: tarjeta.activa ? 1 : 0.6,
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            width: width,
            height: height,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text.rich(
                        const TextSpan(
                          text: 'Banco',
                          children: [
                            TextSpan(
                              text: 'Panda',
                              style: TextStyle(color: AppColors.accent),
                            ),
                          ],
                        ),
                        style: textTheme.titleMedium?.copyWith(
                          color: AppColors.textOnDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          saldoVisible
                              ? Formatters.moneda(tarjeta.saldo)
                              : BalanceCard.saldoOculto,
                          style: textTheme.bodyLarge?.copyWith(
                            color: AppColors.textOnDark,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          tarjeta.nombre,
                          style: textTheme.labelSmall?.copyWith(color: tenue),
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    Container(
                      width: 42,
                      height: 30,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceMint.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Text(
                      tarjeta.numeroOculto,
                      style: textTheme.bodyMedium?.copyWith(
                        color: tenue,
                        letterSpacing: 1.5,
                      ),
                    ),
                    if (!tarjeta.activa) ...[
                      const Spacer(),
                      Text(
                        'Inactiva',
                        style: textTheme.labelMedium?.copyWith(
                          color: AppColors.textOnDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
                const Spacer(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Formatters.expiracion(tarjeta.fechaExpiracion),
                            style: textTheme.labelSmall?.copyWith(color: tenue),
                          ),
                          Text(
                            titular,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodySmall?.copyWith(
                              color: AppColors.textOnDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      tarjeta.marca.etiqueta.toUpperCase(),
                      style: textTheme.titleLarge?.copyWith(
                        color: AppColors.textOnDark,
                        fontWeight: FontWeight.w800,
                        fontStyle: FontStyle.italic,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
