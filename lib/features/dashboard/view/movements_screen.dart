import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../auth/viewmodel/auth_view_model.dart';
import '../data/repositories/dashboard_repository.dart';
import '../model/tarjeta.dart';
import '../viewmodel/movements_view_model.dart';
import 'widgets/card_summary.dart';
import 'widgets/load_error.dart';
import 'widgets/movimiento_tile.dart';

class MovementsScreen extends StatelessWidget {
  const MovementsScreen({super.key, this.tarjeta});

  final Tarjeta? tarjeta;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MovementsViewModel(
        repository: context.read<DashboardRepository>(),
        auth: context.read<AuthViewModel>(),
        tarjeta: tarjeta,
      )..cargar(),
      child: const _MovementsView(),
    );
  }
}

class _MovementsView extends StatelessWidget {
  const _MovementsView();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MovementsViewModel>();
    final tarjeta = vm.tarjeta;
    final error = vm.error;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          tarjeta == null ? 'Movimientos' : 'Movimientos de la tarjeta',
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: vm.cargar,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              if (tarjeta != null) ...[
                CardSummary(tarjeta: tarjeta),
                const SizedBox(height: 12),
              ],
              if (error != null)
                LoadError(mensaje: error, onReintentar: vm.cargar),
              if (vm.movimientos.isNotEmpty)
                for (final movimiento in vm.movimientos)
                  MovimientoTile(movimiento: movimiento)
              else if (vm.cargando)
                const Padding(
                  padding: EdgeInsets.only(top: 120),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (error == null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    tarjeta == null
                        ? 'Aún no tienes movimientos'
                        : 'Esta tarjeta aún no tiene movimientos',
                    style: Theme.of(context).textTheme.bodyMedium
                        ?.copyWith(color: AppColors.textSecondary),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
