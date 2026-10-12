import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../auth/viewmodel/auth_view_model.dart';
import '../data/repositories/dashboard_repository.dart';
import '../model/resumen_dashboard.dart';
import '../viewmodel/dashboard_view_model.dart';
import 'widgets/balance_card.dart';
import 'widgets/cards_carousel.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/movimiento_tile.dart';
import 'widgets/quick_actions.dart';
import 'widgets/section_header.dart';

/// Pantalla de inicio: saldo, accesos rápidos, tarjetas y actividad reciente.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // El view model vive mientras dure la sesión: al cerrar sesión la
    // pantalla se destruye y el siguiente usuario empieza sin datos previos.
    return ChangeNotifierProvider(
      create: (context) =>
          DashboardViewModel(context.read<DashboardRepository>())..load(),
      child: const _DashboardView(),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DashboardViewModel>();
    final resumen = viewModel.resumen;

    final Widget contenido;
    if (resumen != null) {
      contenido = _DashboardContent(resumen: resumen);
    } else if (viewModel.error != null) {
      contenido = _DashboardError(
        mensaje: viewModel.error!,
        onReintentar: viewModel.load,
      );
    } else {
      contenido = const Center(child: CircularProgressIndicator());
    }

    return SafeArea(bottom: false, child: contenido);
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({required this.resumen});

  static const _margen = 20.0;
  static const _lateral = EdgeInsets.symmetric(horizontal: _margen);

  final ResumenDashboard resumen;

  @override
  Widget build(BuildContext context) {
    final usuario = context.watch<AuthViewModel>().usuario;
    final titular = usuario == null
        ? ''
        : '${usuario.primerNombre} ${usuario.primerApellido}';

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      children: [
        Padding(
          padding: _lateral,
          child: DashboardHeader(nombre: usuario?.primerNombre ?? ''),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: _lateral,
          child: BalanceCard(cuenta: resumen.cuenta),
        ),
        const SizedBox(height: 20),
        const Padding(padding: _lateral, child: QuickActions()),
        const SizedBox(height: 20),
        Padding(
          padding: _lateral,
          child: SectionHeader(
            titulo: 'Mis Tarjetas',
            onVerMas: () => context.go(AppRoutes.cards),
          ),
        ),
        const SizedBox(height: 8),
        CardsCarousel(
          tarjetas: resumen.tarjetas,
          saldo: resumen.cuenta.saldo,
          titular: titular,
          padding: _margen,
        ),
        const SizedBox(height: 20),
        Padding(
          padding: _lateral,
          child: SectionHeader(
            titulo: 'Actividad reciente',
            onVerMas: () => context.go(AppRoutes.movements),
          ),
        ),
        const SizedBox(height: 4),
        if (resumen.movimientos.isEmpty)
          Padding(
            padding: _lateral.copyWith(top: 12),
            child: Text(
              'Aún no tienes movimientos',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
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

class _DashboardError extends StatelessWidget {
  const _DashboardError({required this.mensaje, required this.onReintentar});

  final String mensaje;
  final VoidCallback onReintentar;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              mensaje,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: onReintentar,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}
