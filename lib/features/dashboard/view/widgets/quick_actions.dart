import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({
    super.key,
    required this.onTransferir,
    required this.onEfectivoMovil,
    required this.onPagarServicios,
    required this.onRecibirDinero,
  });

  final VoidCallback onTransferir;
  final VoidCallback onEfectivoMovil;
  final VoidCallback onPagarServicios;
  final VoidCallback onRecibirDinero;

  @override
  Widget build(BuildContext context) {
    final acciones = [
      (
        icono: Icons.swap_horiz_rounded,
        etiqueta: 'Transferir',
        onTap: onTransferir,
      ),
      (
        icono: Icons.file_download_outlined,
        etiqueta: 'Efectivo móvil',
        onTap: onEfectivoMovil,
      ),
      (
        icono: Icons.assignment_outlined,
        etiqueta: 'Pagar servicios',
        onTap: onPagarServicios,
      ),
      (
        icono: Icons.inventory_2_outlined,
        etiqueta: 'Recibir dinero',
        onTap: onRecibirDinero,
      ),
    ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final accion in acciones)
          Expanded(
            child: _QuickAction(
              icono: accion.icono,
              etiqueta: accion.etiqueta,
              onTap: accion.onTap,
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
