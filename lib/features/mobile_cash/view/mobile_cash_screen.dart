import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/input_formatters.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/detalle_row.dart';
import '../../../core/widgets/paso_layout.dart';
import '../../auth/viewmodel/auth_view_model.dart';
import '../../dashboard/data/repositories/dashboard_repository.dart';
import '../../dashboard/view/widgets/cuenta_option.dart';
import '../../dashboard/view/widgets/load_error.dart';
import '../data/repositories/mobile_cash_repository.dart';
import '../model/efectivo_movil.dart';
import '../viewmodel/mobile_cash_view_model.dart';

/// Efectivo móvil: monto + celular → código para retirar en cajero sin tarjeta.
/// Al cerrar después de generar el código devuelve `true` para recargar el inicio.
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
      canPop: !vm.enviando && resultado == null,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && !vm.enviando) context.pop(true);
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: resultado == null,
          title: Text(resultado == null ? 'Efectivo móvil' : 'Código generado'),
        ),
        body: SafeArea(
          child: resultado == null
              ? const _Formulario()
              : _Resultado(efectivo: resultado),
        ),
      ),
    );
  }
}

class _Formulario extends StatefulWidget {
  const _Formulario();

  @override
  State<_Formulario> createState() => _FormularioState();
}

class _FormularioState extends State<_Formulario> {
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
    final error = vm.error;
    final pie = theme.textTheme.bodySmall?.copyWith(
      color: AppColors.textSecondary,
    );

    return PasoLayout(
      titulo: 'Retira sin tarjeta',
      subtitulo: 'Genera un código para que tú u otra persona retire el dinero en un cajero Banco Panda',
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
        if (vm.cuentas.length > 1)
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
                  ],
                ),
              ),
              const SizedBox(height: 14),
              AppTextField(
                hint: '9XXXXXXXX',
                icon: Icons.phone_android,
                prefixText: MobileCashViewModel.prefijoCelular,
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
                'El dinero se descuenta al generar el código. '
                'El código vence en 24 horas.',
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

class _Resultado extends StatelessWidget {
  const _Resultado({required this.efectivo});

  final EfectivoMovil efectivo;

  void _copiar(BuildContext context) {
    Clipboard.setData(ClipboardData(text: efectivo.codigo));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Código copiado'),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
                    Icons.phone_android,
                    size: 44,
                    color: AppColors.primaryDeep,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Tu código de retiro',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardSlate : AppColors.surfaceDark,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (final digito in efectivo.codigo.split(''))
                          Container(
                            width: 38,
                            height: 48,
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColors.textOnDark.withValues(
                                alpha: 0.08,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              digito,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                color: AppColors.accent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: () => _copiar(context),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.textOnDark,
                      ),
                      icon: const Icon(Icons.copy_rounded, size: 18),
                      label: const Text('Copiar código'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              DetalleBox(
                children: [
                  DetalleRow(
                    etiqueta: 'Monto',
                    valor: Formatters.moneda(efectivo.monto),
                  ),
                  DetalleRow(
                    etiqueta: 'Para el celular',
                    valor: efectivo.telefonoDestino,
                  ),
                  DetalleRow(etiqueta: 'Desde', valor: efectivo.numeroCuenta),
                  DetalleRow(
                    etiqueta: 'Vence',
                    valor: Formatters.fechaComprobante(
                      efectivo.fechaExpiracion,
                    ),
                  ),
                  DetalleRow(
                    etiqueta: 'Saldo disponible',
                    valor: Formatters.moneda(efectivo.saldoDisponible),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.lock_outline,
                    size: 18,
                    color: theme.colorScheme.error,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Este código se muestra una sola vez. Compártelo solo '
                      'con quien retirará el dinero.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
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
