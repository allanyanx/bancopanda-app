import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../auth/viewmodel/auth_view_model.dart';
import '../../dashboard/data/repositories/dashboard_repository.dart';
import '../data/repositories/mobile_cash_repository.dart';
import '../viewmodel/mobile_cash_view_model.dart';
import 'widgets/formulario_efectivo.dart';
import 'widgets/resultado_efectivo.dart';

/// Efectivo móvil: pantalla 1 (cuenta, monto y número) → pantalla 2 (códigos para
/// retirar en el cajero). Al cerrar devuelve `true` para que el inicio recargue el saldo.
class MobileCashScreen extends StatelessWidget {
  const MobileCashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MobileCashViewModel(
        repository: context.read<MobileCashRepository>(),
        cuentas: context.read<DashboardRepository>(),
        auth: context.read<AuthViewModel>(),
      )..cargar(),
      child: const _MobileCashView(),
    );
  }
}

class _MobileCashView extends StatelessWidget {
  const _MobileCashView();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MobileCashViewModel>();
    final resultado = vm.resultado;

    return PopScope(
      // Mientras se genera no se puede salir, y desde los códigos se sale con "Finalizar".
      canPop: !vm.enviando && resultado == null,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && !vm.enviando) context.pop(true);
      },
      child: Scaffold(
        appBar: resultado == null
            ? AppBar(title: const Text('Efectivo móvil'))
            : AppBar(
                automaticallyImplyLeading: false,
                actions: [
                  IconButton(
                    tooltip: 'Cerrar',
                    icon: const Icon(Icons.close),
                    onPressed: () => context.pop(true),
                  ),
                ],
              ),
        body: SafeArea(
          child: resultado == null
              ? const FormularioEfectivo()
              : ResultadoEfectivo(
                  efectivo: resultado,
                  esMiNumero: vm.usarMiNumero,
                ),
        ),
      ),
    );
  }
}
