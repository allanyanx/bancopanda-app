import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/widgets/paso_layout.dart';
import '../../../dashboard/view/widgets/cuenta_option.dart';
import '../../../dashboard/view/widgets/load_error.dart';
import '../../viewmodel/transfer_view_model.dart';

class OrigenStep extends StatelessWidget {
  const OrigenStep({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TransferViewModel>();
    final error = vm.error;

    return PasoLayout(
      titulo: '¿Desde qué cuenta?',
      subtitulo: 'Elige la cuenta de la que saldrá el dinero',
      children: [
        if (error != null) LoadError(mensaje: error, onReintentar: vm.cargar),
        if (vm.cargando && vm.cuentas.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 80),
            child: Center(child: CircularProgressIndicator()),
          ),
        for (final cuenta in vm.cuentas)
          CuentaOption(
            cuenta: cuenta,
            seleccionada: cuenta.cuentaId == vm.origen?.cuentaId,
            onTap: () => vm.elegirOrigen(cuenta),
          ),
      ],
    );
  }
}
