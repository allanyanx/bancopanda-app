import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/input_formatters.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/paso_layout.dart';
import '../../../dashboard/view/widgets/cuenta_option.dart';
import '../../model/destino.dart';
import '../../viewmodel/transfer_view_model.dart';
import '../widgets/destino_card.dart';

class DestinatarioStep extends StatefulWidget {
  const DestinatarioStep({super.key});

  @override
  State<DestinatarioStep> createState() => _DestinatarioStepState();
}

class _DestinatarioStepState extends State<DestinatarioStep> {
  final _formKey = GlobalKey<FormState>();
  final _numero = TextEditingController();
  final _cedula = TextEditingController();
  final _nombre = TextEditingController();
  String? _bancoId;

  @override
  void initState() {
    super.initState();
    final vm = context.read<TransferViewModel>();
    final destino = vm.destino;
    if (destino != null && !vm.aMisCuentas) {
      _bancoId = destino.bancoId;
      _numero.text = destino.numeroCuenta;
      _cedula.text = destino.cedula;
      _nombre.text = destino.nombre ?? '';
    }
  }

  @override
  void dispose() {
    for (final c in [_numero, _cedula, _nombre]) {
      c.dispose();
    }
    super.dispose();
  }

  void _continuar() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final vm = context.read<TransferViewModel>();
    final banco = vm.bancos.firstWhere((b) => b.bancoId == _bancoId);
    final nombre = _nombre.text.trim();

    vm.elegirDestino(
      Destino(
        bancoId: banco.bancoId,
        banco: banco.nombre,
        numeroCuenta: _numero.text.trim(),
        cedula: _cedula.text.trim(),
        nombre: nombre.isEmpty ? null : nombre,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TransferViewModel>();
    final theme = Theme.of(context);
    final error = vm.error;
    final frecuentes = vm.frecuentes;

    return PasoLayout(
      titulo: '¿A quién le transfieres?',
      subtitulo: 'A cualquier cuenta de Banco Panda o de otros bancos del país',
      boton: vm.aMisCuentas
          ? null
          : AppButton(label: 'Continuar', onPressed: _continuar),
      children: [
        if (vm.puedeTransferirEntreMisCuentas) ...[
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(
                value: false,
                label: Text('Otra persona'),
                icon: Icon(Icons.person_outline),
              ),
              ButtonSegment(
                value: true,
                label: Text('Mis cuentas'),
                icon: Icon(Icons.swap_horiz_rounded),
              ),
            ],
            selected: {vm.aMisCuentas},
            showSelectedIcon: false,
            style: SegmentedButton.styleFrom(
              selectedBackgroundColor: AppColors.primary,
              selectedForegroundColor: Colors.white,
            ),
            onSelectionChanged: (seleccion) =>
                vm.cambiarTipoDestino(aMisCuentas: seleccion.first),
          ),
          const SizedBox(height: 20),
        ],
        if (vm.aMisCuentas)
          for (final cuenta in vm.misOtrasCuentas)
            CuentaOption(
              cuenta: cuenta,
              onTap: () => vm.elegirCuentaPropia(cuenta),
            )
        else ...[
          if (frecuentes.isNotEmpty) ...[
            _Subtitulo('Frecuentes'),
            for (final b in frecuentes)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: DestinoCard(
                  titulo: b.nombre ?? 'Cuenta ${b.numeroCuenta}',
                  detalle: '${b.banco} · ${b.numeroCuenta}',
                  onTap: () => vm.elegirBeneficiario(b),
                ),
              ),
            const SizedBox(height: 12),
            _Subtitulo('Nuevo destinatario'),
          ],
          Form(
            key: _formKey,
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  initialValue: _bancoId,
                  isExpanded: true,
                  hint: const Text('Banco'),
                  dropdownColor: AppColors.fieldFill,
                  borderRadius: BorderRadius.circular(16),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.account_balance_outlined),
                  ),
                  items: [
                    for (final banco in vm.bancos)
                      DropdownMenuItem(
                        value: banco.bancoId,
                        child: Text(banco.nombre),
                      ),
                  ],
                  validator: (valor) => valor == null ? 'Elige el banco' : null,
                  onChanged: (valor) => setState(() => _bancoId = valor),
                ),
                const SizedBox(height: 14),
                AppTextField(
                  hint: 'Número de cuenta',
                  icon: Icons.numbers,
                  controller: _numero,
                  keyboardType: TextInputType.number,
                  inputFormatters: InputFormatters.numeroCuenta,
                  validator: Validators.numeroCuenta,
                ),
                const SizedBox(height: 14),
                AppTextField(
                  hint: 'Cédula del beneficiario',
                  icon: Icons.badge_outlined,
                  controller: _cedula,
                  keyboardType: TextInputType.number,
                  inputFormatters: InputFormatters.cedula,
                  validator: Validators.cedulaBeneficiario,
                ),
                const SizedBox(height: 14),
                AppTextField(
                  hint: 'Nombre (opcional)',
                  icon: Icons.person_outline,
                  controller: _nombre,
                  textCapitalization: TextCapitalization.words,
                  inputFormatters: InputFormatters.soloLetras,
                  validator: Validators.nombreOpcional,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _continuar(),
                ),
              ],
            ),
          ),
        ],
        if (error != null) MensajeError(error),
      ],
    );
  }
}

class _Subtitulo extends StatelessWidget {
  const _Subtitulo(this.texto);

  final String texto;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        texto,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
