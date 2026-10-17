import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/status_dialog.dart';
import '../../auth/viewmodel/auth_view_model.dart';
import '../data/repositories/dashboard_repository.dart';
import '../model/resumen_dashboard.dart';
import '../viewmodel/dashboard_view_model.dart';
import 'widgets/balance_card.dart';
import 'widgets/cards_carousel.dart';
import 'widgets/dashboard_bottom_bar.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/load_error.dart';
import 'widgets/movimiento_tile.dart';
import 'widgets/quick_actions.dart';
import 'widgets/section_header.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DashboardViewModel(
        repository: context.read<DashboardRepository>(),
        auth: context.read<AuthViewModel>(),
      )..cargar(),
      child: const _DashboardView(),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  static const _margen = 20.0;
  static const _lateral = EdgeInsets.symmetric(horizontal: _margen);

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DashboardViewModel>();
    final usuario = context.watch<AuthViewModel>().usuario;
    final resumen = vm.resumen;
    final error = vm.error;

    return Scaffold(
      bottomNavigationBar: const DashboardBottomBar(),
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: vm.cargar,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 16),
            children: [
              Padding(
                padding: _lateral,
                child: DashboardHeader(nombre: usuario?.primerNombre ?? ''),
              ),
              if (error != null)
                Padding(
                  padding: _lateral.copyWith(top: 8),
                  child: LoadError(mensaje: error, onReintentar: vm.cargar),
                ),
              if (resumen != null)
                _DashboardContent(
                  resumen: resumen,
                  titular: usuario == null
                      ? ''
                      : '${usuario.primerNombre} ${usuario.primerApellido}',
                  saldoVisible: vm.saldoVisible,
                  onAlternarSaldo: vm.alternarSaldo,
                )
              else if (vm.cargando)
                const Padding(
                  padding: EdgeInsets.only(top: 120),
                  child: Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({
    required this.resumen,
    required this.titular,
    required this.saldoVisible,
    required this.onAlternarSaldo,
  });

  static const _margen = _DashboardView._margen;
  static const _lateral = _DashboardView._lateral;

  final ResumenDashboard resumen;
  final String titular;
  final bool saldoVisible;
  final VoidCallback onAlternarSaldo;

  /// Abre una pantalla que mueve dinero y, al volver de cualquier forma,
  /// recarga el inicio para que el saldo nunca quede desactualizado.
  Future<void> _abrirYRecargar(BuildContext context, String ruta) async {
    final vm = context.read<DashboardViewModel>();
    await context.push<bool>(ruta);
    await vm.cargar();
  }

  void _recibirDinero(BuildContext context) => mostrarEstado(
    context,
    icono: Icons.public,
    titulo: 'Próximamente',
    mensaje: 'Próximamente podrás recibir dinero del extranjero.',
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 16),
        Padding(
          padding: _lateral,
          child: BalanceCard(
            saldoTotal: resumen.saldoTotal,
            moneda: resumen.moneda,
            cuentas: resumen.cuentas,
            saldoVisible: saldoVisible,
            onAlternarSaldo: onAlternarSaldo,
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: _lateral,
          child: QuickActions(
            onTransferir: () => _abrirYRecargar(context, AppRoutes.transfer),
            onEfectivoMovil: () =>
                _abrirYRecargar(context, AppRoutes.mobileCash),
            onPagarServicios: () => context.push(AppRoutes.payServices),
            onRecibirDinero: () => _recibirDinero(context),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: _lateral,
          child: SectionHeader(
            titulo: 'Mis Tarjetas',
            onVerMas: () => context.push(AppRoutes.cards),
          ),
        ),
        const SizedBox(height: 8),
        CardsCarousel(
          tarjetas: resumen.tarjetas,
          titular: titular,
          padding: _margen,
        ),
        const SizedBox(height: 20),
        Padding(
          padding: _lateral,
          child: SectionHeader(
            titulo: 'Actividad reciente',
            onVerMas: () => context.push(AppRoutes.movements),
          ),
        ),
        const SizedBox(height: 4),
        if (resumen.movimientos.isEmpty)
          Padding(
            padding: _lateral.copyWith(top: 12),
            child: Text(
              'Aún no tienes movimientos',
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: AppColors.textSecondary),
            ),
          )
        else
          for (final movimiento in resumen.movimientos)
            Padding(
              padding: _lateral,
              child: MovimientoTile(movimiento: movimiento),
            ),
      ],
    );
  }
}
