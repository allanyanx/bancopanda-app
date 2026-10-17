import 'package:bancopanda_app/core/errors/app_exception.dart';
import 'package:bancopanda_app/features/auth/viewmodel/auth_view_model.dart';
import 'package:bancopanda_app/features/dashboard/data/repositories/dashboard_repository.dart';
import 'package:bancopanda_app/features/dashboard/viewmodel/movements_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_auth.dart';
import '../../helpers/fake_dashboard_data_source.dart';

void main() {
  late FakeDashboardDataSource dataSource;
  late AuthViewModel auth;

  MovementsViewModel crear() => MovementsViewModel(
    repository: DashboardRepository(dataSource),
    auth: auth,
  );

  setUp(() async {
    dataSource = FakeDashboardDataSource();
    auth = await authConSesionIniciada();
  });

  test('pide los movimientos de todas las cuentas con su límite', () async {
    final viewModel = crear();

    await viewModel.cargar();

    expect(dataSource.limiteConsultado, MovementsViewModel.limite);
    expect(viewModel.movimientos, [movimientoComida]);
    expect(viewModel.cargando, isFalse);
    expect(viewModel.error, isNull);
  });

  test('si el backend falla muestra su mensaje', () async {
    dataSource.error = const AppException('El servidor tuvo un problema');
    final viewModel = crear();

    await viewModel.cargar();

    expect(viewModel.error, 'El servidor tuvo un problema');
    expect(viewModel.movimientos, isEmpty);
    expect(auth.isLoggedIn, isTrue);
  });

  test('si la sesión venció (401) cierra la sesión', () async {
    dataSource.error = const AppException('Sesión no válida', statusCode: 401);

    await crear().cargar();

    expect(auth.isLoggedIn, isFalse);
  });
}
