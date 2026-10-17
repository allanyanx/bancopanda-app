import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/detalle_row.dart';
import '../../../../core/widgets/paso_layout.dart';
import '../../viewmodel/transfer_view_model.dart';

class ConfirmarStep extends StatelessWidget {
  const ConfirmarStep({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TransferViewModel>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final origen = vm.origen!;
    final destino = vm.destino!;
    final error = vm.error;

    return PasoLayout(
      titulo: 'Revisa y confirma',
      subtitulo: 'Verifica los datos antes de transferir',
      boton: AppButton(
        label: 'Transferir',
        isLoading: vm.enviando,
        onPressed: vm.transferir,
      ),
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardSlate : AppColors.surfaceDark,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Text(
                'Vas a transferir',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textOnDark.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                Formatters.moneda(vm.monto ?? 0),
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: AppColors.textOnDark,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        DetalleBox(
          children: [
            DetalleRow(
              etiqueta: 'Desde',
              valor: '${origen.tipo.etiqueta}\n${origen.numeroCuenta}',
            ),
            DetalleRow(etiqueta: 'Banco', valor: destino.banco),
            DetalleRow(etiqueta: 'Cuenta destino', valor: destino.numeroCuenta),
            DetalleRow(etiqueta: 'Cédula', valor: destino.cedula),
            if (destino.nombre != null)
              DetalleRow(etiqueta: 'Beneficiario', valor: destino.nombre!),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Icon(
              destino.esBancoPanda ? Icons.bolt_outlined : Icons.schedule,
              size: 18,
              color: AppColors.primary,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                destino.esBancoPanda
                    ? 'Entre cuentas Banco Panda el dinero llega al instante.'
                    : 'A otros bancos el dinero se acredita según los horarios del banco destino.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
        if (error != null) MensajeError(error),
      ],
    );
  }
}
