import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/input_formatters.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/paso_layout.dart';
import '../../viewmodel/transfer_view_model.dart';
import '../widgets/destino_card.dart';

class MontoStep extends StatefulWidget {
  const MontoStep({super.key});

  @override
  State<MontoStep> createState() => _MontoStepState();
}

class _MontoStepState extends State<MontoStep> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _monto;

  @override
  void initState() {
    super.initState();
    final vm = context.read<TransferViewModel>();
    _monto = TextEditingController(text: vm.monto?.toStringAsFixed(2) ?? '');
  }

  @override
  void dispose() {
    _monto.dispose();
    super.dispose();
  }

  void _continuar() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    context.read<TransferViewModel>().confirmarMonto(
      double.parse(_monto.text.trim()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TransferViewModel>();
    final disponible = vm.origen?.saldo ?? 0;
    final destino = vm.destino;
    final pie = Theme.of(context).textTheme.bodySmall
        ?.copyWith(color: AppColors.textSecondary);

    return PasoLayout(
      titulo: '¿Cuánto quieres transferir?',
      boton: AppButton(label: 'Continuar', onPressed: _continuar),
      children: [
        if (destino != null) ...[
          DestinoCard(
            titulo: destino.titulo,
            detalle: '${destino.banco} · ${destino.numeroCuenta}',
          ),
          const SizedBox(height: 20),
        ],
        Form(
          key: _formKey,
          child: AppTextField(
            hint: '0.00',
            icon: Icons.attach_money,
            controller: _monto,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: InputFormatters.monto,
            validator: (valor) => Validators.monto(
              valor,
              disponible: disponible,
              maximo: TransferViewModel.montoMaximo,
            ),
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _continuar(),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Disponible: ${Formatters.moneda(disponible)}',
                  style: pie,
                ),
              ),
              Text(
                'Máximo ${Formatters.moneda(TransferViewModel.montoMaximo)}',
                style: pie,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
