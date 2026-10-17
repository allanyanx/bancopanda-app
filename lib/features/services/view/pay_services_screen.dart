import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/status_dialog.dart';

/// Pagos de servicios básicos. Por ahora es solo visual: muestra el pago como
/// realizado pero no descuenta dinero.
class PayServicesScreen extends StatelessWidget {
  const PayServicesScreen({super.key});

  static const _servicios = [
    (
      icono: Icons.lightbulb_outline,
      nombre: 'Luz eléctrica',
      empresa: 'CNEL EP',
    ),
    (
      icono: Icons.water_drop_outlined,
      nombre: 'Agua potable',
      empresa: 'Interagua',
    ),
    (icono: Icons.wifi, nombre: 'Internet', empresa: 'Netlife'),
    (
      icono: Icons.smartphone,
      nombre: 'Recarga celular',
      empresa: 'Claro · Movistar · CNT',
    ),
    (icono: Icons.phone_outlined, nombre: 'Teléfono fijo', empresa: 'CNT'),
    (icono: Icons.tv_outlined, nombre: 'TV por cable', empresa: 'DirecTV'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Pagar servicios')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            Text(
              '¿Qué deseas pagar?',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Elige un servicio para pagarlo al instante',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 1.05,
              children: [
                for (final servicio in _servicios)
                  _ServicioTile(
                    icono: servicio.icono,
                    nombre: servicio.nombre,
                    empresa: servicio.empresa,
                    onTap: () => mostrarEstado(
                      context,
                      icono: Icons.check_rounded,
                      titulo: 'Pago realizado',
                      mensaje:
                          'Tu pago de ${servicio.nombre} (${servicio.empresa}) '
                          'se realizó con éxito.',
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ServicioTile extends StatelessWidget {
  const _ServicioTile({
    required this.icono,
    required this.nombre,
    required this.empresa,
    required this.onTap,
  });

  final IconData icono;
  final String nombre;
  final String empresa;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: isDark ? AppColors.surfaceDark : AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isDark ? Colors.transparent : theme.colorScheme.outlineVariant,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardGreen : AppColors.surfaceMint,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icono,
                  color: isDark ? AppColors.accent : AppColors.primaryDeep,
                ),
              ),
              const Spacer(),
              Text(
                nombre,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                empresa,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
