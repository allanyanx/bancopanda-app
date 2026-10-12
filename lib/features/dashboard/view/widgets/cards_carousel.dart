import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../model/tarjeta.dart';
import 'bank_card.dart';

/// Carrusel horizontal de "Mis Tarjetas".
class CardsCarousel extends StatelessWidget {
  const CardsCarousel({
    super.key,
    required this.tarjetas,
    required this.saldo,
    required this.titular,
    required this.padding,
  });

  final List<Tarjeta> tarjetas;
  final double saldo;
  final String titular;

  /// Margen lateral: las tarjetas empiezan alineadas con el resto del
  /// contenido, pero al deslizar llegan hasta el borde de la pantalla.
  final double padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (tarjetas.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: padding, vertical: 12),
        child: Text(
          'Aún no tienes tarjetas',
          style: theme.textTheme.bodyMedium
              ?.copyWith(color: AppColors.textSecondary),
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
          saldo: saldo,
          titular: titular,
          color: colores[index % colores.length],
        ),
      ),
    );
  }
}
