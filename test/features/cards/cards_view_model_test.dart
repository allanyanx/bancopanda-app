import 'package:bancopanda_app/core/errors/app_exception.dart';
import 'package:bancopanda_app/features/cards/viewmodel/cards_view_model.dart';
import 'package:bancopanda_app/features/dashboard/data/repositories/dashboard_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_auth.dart';
import '../../helpers/fake_dashboard_data_source.dart';

void main() {
  test('carga las tarjetas y arma el nombre del titular', () async {
    final viewModel = CardsViewModel(
      repository: DashboardRepository(FakeDashboardDataSource()),
      auth: await authConSesionIniciada(),
    );

    await viewModel.cargar();

    expect(viewModel.tarjetas, [tarjetaVisa]);
    expect(viewModel.titular, 'Andrea Barroso');
    expect(viewModel.error, isNull);
  });

  test('si el backend falla muestra su mensaje', () async {
    final dataSource = FakeDashboardDataSource()
      ..error = const AppException('El servidor tuvo un problema');
    final viewModel = CardsViewModel(
      repository: DashboardRepository(dataSource),
      auth: await authConSesionIniciada(),
    );

    await viewModel.cargar();

    expect(viewModel.error, 'El servidor tuvo un problema');
    expect(viewModel.tarjetas, isEmpty);
  });
}
