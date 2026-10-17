import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/celular.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../../model/efectivo_movil.dart';

/// Pantalla 2: monto exitoso y los pasos para retirar en el cajero con los dos códigos.
class ResultadoEfectivo extends StatelessWidget {
  const ResultadoEfectivo({
    super.key,
    required this.efectivo,
    required this.esMiNumero,
  });

  final EfectivoMovil efectivo;
  final bool esMiNumero;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final verde = isDark ? AppColors.primary : AppColors.primaryDark;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            children: [
              _Tarjeta(
                child: Column(
                  children: [
                    Container(
                      width: 76,
                      height: 76,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark
                            ? AppColors.cardGreen
                            : AppColors.surfaceMint,
                      ),
                      alignment: Alignment.center,
                      child: const CircleAvatar(
                        radius: 26,
                        backgroundColor: AppColors.primary,
                        child: Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Efectivo móvil exitoso',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: verde,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      Formatters.moneda(efectivo.monto),
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _Tarjeta(
                child: Column(
                  children: [
                    const Icon(
                      Icons.local_atm_rounded,
                      size: 40,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: 12),
                    const _Paso(
                      texto: 'Elige Transacciones sin tarjeta y selecciona Efectivo móvil',
                    ),
                    const _Flecha(),
                    _Paso(
                      texto: 'Ingresa el primer código:',
                      valor: efectivo.primerCodigo,
                    ),
                    const _Flecha(),
                    _Paso(
                      texto: 'Ingresa el segundo código:',
                      valor: efectivo.segundoCodigo,
                    ),
                    const _Flecha(),
                    _Paso(
                      texto: esMiNumero
                          ? 'Ingresa tu número de celular'
                          : 'Ingresa el número de celular',
                      valor: Celular.ocultoLocal(efectivo.telefonoDestino),
                    ),
                    const _Flecha(),
                    const _Paso(texto: 'Retira tu efectivo'),
                    const SizedBox(height: 16),
                    Divider(color: theme.colorScheme.outlineVariant),
                    const SizedBox(height: 8),
                    Text(
                      'Vence el ${Formatters.fechaComprobante(efectivo.fechaExpiracion)}',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Estos códigos se muestran una sola vez.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: AppButton(
            label: 'Finalizar',
            onPressed: () => context.pop(true),
          ),
        ),
      ],
    );
  }
}

/// Caja blanca (gris oscuro en modo oscuro) con borde suave y esquinas redondeadas.
class _Tarjeta extends StatelessWidget {
  const _Tarjeta({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.transparent : theme.colorScheme.outlineVariant,
        ),
      ),
      child: child,
    );
  }
}

class _Paso extends StatelessWidget {
  const _Paso({required this.texto, this.valor});

  final String texto;
  final String? valor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final valor = this.valor;

    return Column(
      children: [
        Text(texto, textAlign: TextAlign.center, style: textTheme.bodyLarge),
        if (valor != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              valor,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ),
      ],
    );
  }
}

class _Flecha extends StatelessWidget {
  const _Flecha();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Icon(
        Icons.arrow_downward_rounded,
        color: AppColors.primary,
        size: 26,
      ),
    );
  }
}
