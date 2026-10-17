import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/celular.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/input_formatters.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/paso_layout.dart';
import '../../../dashboard/view/widgets/cuenta_option.dart';
import '../../../dashboard/view/widgets/load_error.dart';
import '../../viewmodel/mobile_cash_view_model.dart';

/// Pantalla 1: de qué cuenta sale, cuánto y para qué número.
class FormularioEfectivo extends StatefulWidget {
  const FormularioEfectivo({super.key});

  @override
  State<FormularioEfectivo> createState() => _FormularioEfectivoState();
}

class _FormularioEfectivoState extends State<FormularioEfectivo> {
  final _formKey = GlobalKey<FormState>();
  final _monto = TextEditingController();
  final _celular = TextEditingController();

  @override
  void dispose() {
    _monto.dispose();
    _celular.dispose();
    super.dispose();
  }

  Future<void> _generar() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    await context.read<MobileCashViewModel>().generar(
      monto: double.parse(_monto.text.trim()),
      celular: _celular.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MobileCashViewModel>();
    final theme = Theme.of(context);
    final disponible = vm.cuenta?.saldo ?? 0;
    final registrado = vm.telefonoRegistrado;
    final error = vm.error;
    final pie = theme.textTheme.bodySmall?.copyWith(
      color: AppColors.textSecondary,
    );

    return PasoLayout(
      titulo: 'Retira sin tarjeta',
      subtitulo: 'Genera los códigos para que tú u otra persona retire el dinero en un cajero Banco Panda',
      boton: AppButton(
        label: 'Generar código',
        isLoading: vm.enviando,
        onPressed: vm.cuenta == null ? null : _generar,
      ),
      children: [
        if (vm.cargando && vm.cuentas.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 40),
            child: Center(child: CircularProgressIndicator()),
          ),
        if (error != null && vm.cuentas.isEmpty)
          LoadError(mensaje: error, onReintentar: vm.cargar),
        if (vm.cuentas.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text('Desde la cuenta', style: pie),
          ),
        for (final cuenta in vm.cuentas)
          CuentaOption(
            cuenta: cuenta,
            seleccionada: cuenta.cuentaId == vm.cuenta?.cuentaId,
            onTap: () => vm.elegirCuenta(cuenta),
          ),
        const SizedBox(height: 8),
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                hint: 'Monto (ej. 20.00)',
                icon: Icons.attach_money,
                controller: _monto,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: InputFormatters.monto,
                validator: (valor) => Validators.monto(
                  valor,
                  disponible: disponible,
                  maximo: MobileCashViewModel.montoMaximo,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                child: Text(
                  'Disponible: ${Formatters.moneda(disponible)}',
                  style: pie,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Número de destinatario',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              SegmentedButton<bool>(
                segments: [
                  ButtonSegment(
                    value: true,
                    label: const Text('Mi número'),
                    icon: const Icon(Icons.person_outline),
                    enabled: registrado != null,
                  ),
                  const ButtonSegment(
                    value: false,
                    label: Text('Otro número'),
                    icon: Icon(Icons.group_outlined),
                  ),
                ],
                selected: {vm.usarMiNumero},
                showSelectedIcon: false,
                style: SegmentedButton.styleFrom(
                  selectedBackgroundColor: AppColors.primary,
                  selectedForegroundColor: Colors.white,
                ),
                onSelectionChanged: (seleccion) =>
                    vm.elegirDestino(miNumero: seleccion.first),
              ),
              const SizedBox(height: 14),
              if (vm.usarMiNumero && registrado != null)
                _MiNumero(telefono: registrado)
              else
                AppTextField(
                  hint: '9XXXXXXXX',
                  icon: Icons.phone_android,
                  prefixText: Celular.prefijo,
                  controller: _celular,
                  keyboardType: TextInputType.phone,
                  inputFormatters: InputFormatters.celular,
                  validator: Validators.celular,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _generar(),
                ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.info_outline, size: 18, color: AppColors.primary),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'El dinero se descuenta al generar los códigos. '
                'Los códigos vencen en 24 horas.',
                style: pie,
              ),
            ),
          ],
        ),
        if (error != null && vm.cuentas.isNotEmpty) MensajeError(error),
      ],
    );
  }
}

/// Tarjeta menta con el celular registrado, oculto en parte.
class _MiNumero extends StatelessWidget {
  const _MiNumero({required this.telefono});

  final String telefono;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final tenue = isDark
        ? AppColors.textOnDark.withValues(alpha: 0.7)
        : AppColors.textSecondary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardGreen : AppColors.surfaceMint,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.phone_android,
                color: isDark ? AppColors.accent : AppColors.primaryDeep,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tu teléfono registrado',
                      style: theme.textTheme.bodySmall?.copyWith(color: tenue),
                    ),
                    Text(
                      Celular.oculto(telefono),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.check_circle, color: AppColors.primary),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Usarás este número en el cajero para retirar.',
            style: theme.textTheme.bodySmall?.copyWith(color: tenue),
          ),
        ],
      ),
    );
  }
}
