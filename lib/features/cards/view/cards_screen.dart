import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/detalle_row.dart';
import '../../../core/widgets/status_dialog.dart';
import '../../auth/viewmodel/auth_view_model.dart';
import '../../dashboard/data/repositories/dashboard_repository.dart';
import '../../dashboard/model/tarjeta.dart';
import '../../dashboard/view/widgets/bank_card.dart';
import '../../dashboard/view/widgets/load_error.dart';
import '../viewmodel/cards_view_model.dart';

class CardsScreen extends StatelessWidget {
  const CardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CardsViewModel(
        repository: context.read<DashboardRepository>(),
        auth: context.read<AuthViewModel>(),
      )..cargar(),
      child: const _CardsView(),
    );
  }
}

class _CardsView extends StatelessWidget {
  const _CardsView();

  void _agregarTarjeta(BuildContext context) => mostrarEstado(
    context,
    icono: Icons.credit_card_off_outlined,
    titulo: 'No estás habilitado',
    mensaje: 'Por ahora no estás habilitado para tener una nueva tarjeta.',
  );

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CardsViewModel>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final error = vm.error;
    final colores = [
      isDark ? AppColors.cardSlate : AppColors.surfaceDark,
      AppColors.cardGreen,
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Mis tarjetas')),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: vm.cargar,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              if (error != null)
                LoadError(mensaje: error, onReintentar: vm.cargar),
              if (vm.cargando && vm.tarjetas.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 120),
                  child: Center(child: CircularProgressIndicator()),
                ),
              for (final (indice, tarjeta) in vm.tarjetas.indexed) ...[
                BankCard(
                  tarjeta: tarjeta,
                  titular: vm.titular,
                  color: colores[indice % colores.length],
                  numeroCompleto: true,
                  ancho: double.infinity,
                ),
                const SizedBox(height: 12),
                _Detalle(tarjeta: tarjeta, titular: vm.titular),
                const SizedBox(height: 24),
              ],
              OutlinedButton.icon(
                onPressed: () => _agregarTarjeta(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: isDark
                      ? AppColors.primary
                      : AppColors.primaryDark,
                  side: const BorderSide(color: AppColors.primary),
                  minimumSize: const Size.fromHeight(56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                icon: const Icon(Icons.add_card_outlined),
                label: const Text('Agregar tarjeta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Detalle extends StatelessWidget {
  const _Detalle({required this.tarjeta, required this.titular});

  final Tarjeta tarjeta;
  final String titular;

  @override
  Widget build(BuildContext context) {
    return DetalleBox(
      children: [
        DetalleRow(etiqueta: 'Número', valor: tarjeta.numeroFormateado),
        DetalleRow(etiqueta: 'Titular', valor: titular),
        DetalleRow(
          etiqueta: 'Vence',
          valor: Formatters.expiracion(tarjeta.fechaExpiracion),
        ),
        DetalleRow(etiqueta: 'Tipo', valor: tarjeta.tipo.etiqueta),
        DetalleRow(etiqueta: 'Marca', valor: tarjeta.marca.etiqueta),
        DetalleRow(
          etiqueta: 'Estado',
          valor: tarjeta.activa ? 'Activa' : 'Inactiva',
        ),
        DetalleRow(etiqueta: 'Cuenta asociada', valor: tarjeta.numeroCuenta),
      ],
    );
  }
}
