import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../auth/viewmodel/auth_view_model.dart';
import '../../dashboard/data/repositories/dashboard_repository.dart';
import '../data/repositories/transfers_repository.dart';
import '../viewmodel/transfer_view_model.dart';
import 'steps/comprobante_step.dart';
import 'steps/confirmar_step.dart';
import 'steps/destinatario_step.dart';
import 'steps/monto_step.dart';
import 'steps/origen_step.dart';
import 'widgets/pasos_indicator.dart';

/// Flujo de transferencia: origen → destinatario → monto → confirmar → comprobante.
class TransferScreen extends StatelessWidget {
  const TransferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TransferViewModel(
        repository: context.read<TransfersRepository>(),
        cuentas: context.read<DashboardRepository>(),
        auth: context.read<AuthViewModel>(),
      )..cargar(),
      child: const _TransferView(),
    );
  }
}

class _TransferView extends StatelessWidget {
  const _TransferView();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TransferViewModel>();
    final paso = vm.paso;
    final terminado = paso == PasoTransferencia.comprobante;

    return PopScope(
      // Mientras se envía no se puede salir: así siempre se ve el comprobante.
      canPop: paso == PasoTransferencia.origen && !vm.enviando,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop || vm.enviando) return;
        if (terminado) {
          context.pop(true);
        } else {
          vm.retroceder();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: !terminado,
          title: Text(terminado ? 'Comprobante' : 'Transferir'),
        ),
        body: SafeArea(
          child: Column(
            children: [
              if (!terminado)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                  child: PasosIndicator(paso: paso),
                ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: KeyedSubtree(
                    key: ValueKey(paso),
                    child: switch (paso) {
                      PasoTransferencia.origen => const OrigenStep(),
                      PasoTransferencia.destinatario =>
                        const DestinatarioStep(),
                      PasoTransferencia.monto => const MontoStep(),
                      PasoTransferencia.confirmar => const ConfirmarStep(),
                      PasoTransferencia.comprobante => const ComprobanteStep(),
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
