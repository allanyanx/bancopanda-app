import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../model/tarjeta.dart';
import 'bank_card.dart';

class CardsCarousel extends StatelessWidget {
  const CardsCarousel({
    super.key,
    required this.tarjetas,
    required this.titular,
    required this.saldoVisible,
    required this.padding,
    required this.onTarjeta,
  });

  final List<Tarjeta> tarjetas;
  final String titular;
  final bool saldoVisible;
  final double padding;
  final ValueChanged<Tarjeta> onTarjeta;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (tarjetas.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: padding, vertical: 12),
        child: Text(
          'Aún no tienes tarjetas',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    final colores = [
      isDark ? AppColors.cardSlate : AppColors.surfaceDark,
      AppColors.cardGreen,
    ];

    return SizedBox(
      height: BankCard.height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: padding),
        itemCount: tarjetas.length,
        separatorBuilder: (context, index) => const SizedBox(width: 14),
        itemBuilder: (context, index) => BankCard(
          tarjeta: tarjetas[index],
          titular: titular,
          color: colores[index % colores.length],
          saldoVisible: saldoVisible,
          onTap: () => onTarjeta(tarjetas[index]),
        ),
      ),
    );
  }
}
