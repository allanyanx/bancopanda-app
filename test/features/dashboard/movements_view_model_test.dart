import 'package:bancopanda_app/core/errors/app_exception.dart';
import 'package:bancopanda_app/features/auth/viewmodel/auth_view_model.dart';
import 'package:bancopanda_app/features/dashboard/data/repositories/dashboard_repository.dart';
import 'package:bancopanda_app/features/dashboard/model/tarjeta.dart';
import 'package:bancopanda_app/features/dashboard/viewmodel/movements_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_auth.dart';
import '../../helpers/fake_dashboard_data_source.dart';

void main() {
  late FakeDashboardDataSource dataSource;
  late AuthViewModel auth;

  MovementsViewModel crear({Tarjeta? tarjeta}) => MovementsViewModel(
    repository: DashboardRepository(dataSource),
    auth: auth,
    tarjeta: tarjeta,
  );

  setUp(() async {
    dataSource = FakeDashboardDataSource();
    auth = await authConSesionIniciada();
  });

  test('con una tarjeta pide los movimientos de esa tarjeta', () async {
    final viewModel = crear(tarjeta: tarjetaVisa);

    await viewModel.cargar();

    expect(dataSource.tarjetaConsultada, tarjetaVisa.tarjetaId);
    expect(dataSource.limiteConsultado, MovementsViewModel.limite);
    expect(viewModel.movimientos, [movimientoComida]);
    expect(viewModel.cargando, isFalse);
    expect(viewModel.error, isNull);
  });

  test('sin tarjeta pide los movimientos de todas las cuentas', () async {
    final viewModel = crear();

    await viewModel.cargar();

    expect(dataSource.tarjetaConsultada, isNull);
    expect(dataSource.limiteConsultado, MovementsViewModel.limite);
    expect(viewModel.movimientos, [movimientoComida]);
  });

  test('si la tarjeta no existe muestra el mensaje del backend', () async {
    dataSource.error = const AppException(
      'Tarjeta no encontrada',
      statusCode: 404,
    );
    final viewModel = crear(tarjeta: tarjetaVisa);

    await viewModel.cargar();

    expect(viewModel.error, 'Tarjeta no encontrada');
    expect(viewModel.movimientos, isEmpty);
    expect(auth.isLoggedIn, isTrue);
  });

  test('si la sesión venció (401) cierra la sesión', () async {
    dataSource.error = const AppException('Sesión no válida', statusCode: 401);

    await crear(tarjeta: tarjetaVisa).cargar();

    expect(auth.isLoggedIn, isFalse);
  });
}
