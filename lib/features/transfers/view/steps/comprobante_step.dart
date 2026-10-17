import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/detalle_row.dart';
import '../../viewmodel/transfer_view_model.dart';

class ComprobanteStep extends StatelessWidget {
  const ComprobanteStep({super.key});

  @override
  Widget build(BuildContext context) {
    final comprobante = context.watch<TransferViewModel>().comprobante!;
    final theme = Theme.of(context);
    final beneficiario = comprobante.beneficiario;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            children: [
              Center(
                child: Container(
                  width: 84,
                  height: 84,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.surfaceMint,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    size: 48,
                    color: AppColors.primaryDeep,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '¡Transferencia exitosa!',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                Formatters.moneda(comprobante.monto),
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              Text(
                Formatters.fechaComprobante(comprobante.fecha),
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              DetalleBox(
                children: [
                  DetalleRow(
                    etiqueta: 'Referencia',
                    valor: comprobante.referencia,
                  ),
                  DetalleRow(
                    etiqueta: 'Desde',
                    valor: comprobante.cuentaOrigen,
                  ),
                  DetalleRow(etiqueta: 'Banco', valor: comprobante.banco),
                  DetalleRow(
                    etiqueta: 'Para',
                    valor: beneficiario == null
                        ? comprobante.cuentaDestino
                        : '$beneficiario\n${comprobante.cuentaDestino}',
                  ),
                  DetalleRow(
                    etiqueta: 'Saldo disponible',
                    valor: Formatters.moneda(comprobante.saldoDisponible),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: AppButton(
            label: 'Volver al inicio',
            onPressed: () => context.pop(true),
          ),
        ),
      ],
    );
  }
}
