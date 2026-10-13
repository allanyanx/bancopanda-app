import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/proximamente.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  static const _acciones = [
    (icono: Icons.swap_horiz_rounded, etiqueta: 'Transferir'),
    (icono: Icons.file_download_outlined, etiqueta: 'Efectivo móvil'),
    (icono: Icons.assignment_outlined, etiqueta: 'Pagar servicios'),
    (icono: Icons.inventory_2_outlined, etiqueta: 'Recibir dinero'),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final accion in _acciones)
          Expanded(
            child: _QuickAction(
              icono: accion.icono,
              etiqueta: accion.etiqueta,
              onTap: () => mostrarProximamente(context),
            ),
          ),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icono,
    required this.etiqueta,
    required this.onTap,
  });

  final IconData icono;
  final String etiqueta;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: AppColors.primaryDeep,
          borderRadius: BorderRadius.circular(14),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: SizedBox.square(
              dimension: 56,
              child: Icon(icono, color: Colors.white, size: 26),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          etiqueta,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
