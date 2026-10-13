import 'dart:async';

import 'package:bancopanda_app/core/errors/app_exception.dart';
import 'package:bancopanda_app/features/auth/viewmodel/auth_view_model.dart';
import 'package:bancopanda_app/features/dashboard/data/repositories/dashboard_repository.dart';
import 'package:bancopanda_app/features/dashboard/viewmodel/dashboard_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_auth.dart';
import '../../helpers/fake_dashboard_data_source.dart';

void main() {
  late FakeDashboardDataSource dataSource;
  late AuthViewModel auth;
  late DashboardViewModel viewModel;

  setUp(() async {
    dataSource = FakeDashboardDataSource();
    auth = await authConSesionIniciada();
    viewModel = DashboardViewModel(
      repository: DashboardRepository(dataSource),
      auth: auth,
    );
  });

  test('carga cuentas, tarjetas y los últimos movimientos', () async {
    await viewModel.cargar();

    final resumen = viewModel.resumen!;
    expect(resumen.cuentas, [cuentaAhorros, cuentaCorriente]);
    expect(resumen.tarjetas, [tarjetaVisa]);
    expect(resumen.movimientos, [movimientoComida]);
    expect(resumen.saldoTotal, closeTo(14740.41, 0.001));
    expect(
      dataSource.limiteConsultado,
      DashboardViewModel.movimientosRecientes,
    );
    expect(viewModel.cargando, isFalse);
    expect(viewModel.error, isNull);
  });

  test('avisa a la vista mientras carga y al terminar', () async {
    final estados = <bool>[];
    viewModel.addListener(() => estados.add(viewModel.cargando));

    await viewModel.cargar();

    expect(estados, [true, false]);
  });

  test(
    'si el backend falla muestra su mensaje y conserva lo ya cargado',
    () async {
      await viewModel.cargar();
      dataSource.error = const AppException('El servidor tuvo un problema');

      await viewModel.cargar();

      expect(viewModel.error, 'El servidor tuvo un problema');
      expect(viewModel.resumen, isNotNull);
      expect(viewModel.cargando, isFalse);
      expect(auth.isLoggedIn, isTrue);
    },
  );

  test('si la sesión venció (401) cierra la sesión', () async {
    dataSource.error = const AppException('Sesión no válida', statusCode: 401);

    await viewModel.cargar();

    expect(viewModel.resumen, isNull);
    expect(auth.isLoggedIn, isFalse);
  });

  test('el ojo oculta y vuelve a mostrar el saldo', () {
    expect(viewModel.saldoVisible, isTrue);

    viewModel.alternarSaldo();
    expect(viewModel.saldoVisible, isFalse);

    viewModel.alternarSaldo();
    expect(viewModel.saldoVisible, isTrue);
  });

  test(
    'no falla si la pantalla se cierra antes de recibir la respuesta',
    () async {
      dataSource.espera = Completer<void>();
      final carga = viewModel.cargar();

      viewModel.dispose();
      dataSource.espera!.complete();

      await expectLater(carga, completes);
    },
  );
}
