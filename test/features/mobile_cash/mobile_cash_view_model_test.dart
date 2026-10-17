import 'dart:async';

import 'package:bancopanda_app/core/errors/app_exception.dart';
import 'package:bancopanda_app/features/auth/viewmodel/auth_view_model.dart';
import 'package:bancopanda_app/features/dashboard/data/repositories/dashboard_repository.dart';
import 'package:bancopanda_app/features/mobile_cash/data/repositories/mobile_cash_repository.dart';
import 'package:bancopanda_app/features/mobile_cash/viewmodel/mobile_cash_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_auth.dart';
import '../../helpers/fake_dashboard_data_source.dart';
import '../../helpers/fake_mobile_cash_data_source.dart';

void main() {
  late FakeMobileCashDataSource dataSource;
  late AuthViewModel auth;
  late MobileCashViewModel viewModel;

  Future<MobileCashViewModel> crear({
    String? telefono = '+593987654321',
  }) async {
    auth = await authConSesionIniciada(telefono: telefono);
    final vm = MobileCashViewModel(
      repository: MobileCashRepository(dataSource),
      cuentas: DashboardRepository(FakeDashboardDataSource()),
      auth: auth,
    );
    await vm.cargar();
    return vm;
  }

  setUp(() async {
    dataSource = FakeMobileCashDataSource();
    viewModel = await crear();
  });

  test('carga las cuentas, elige la primera y usa "Mi número" por defecto', () {
    expect(viewModel.cuentas, [cuentaAhorros, cuentaCorriente]);
    expect(viewModel.cuenta, cuentaAhorros);
    expect(viewModel.telefonoRegistrado, '+593987654321');
    expect(viewModel.usarMiNumero, isTrue);
  });

  test('con "Mi número" no manda teléfono: el API usa el registrado', () async {
    viewModel.elegirCuenta(cuentaCorriente);

    expect(await viewModel.generar(monto: 20), isTrue);

    final enviada = dataSource.solicitudes.single.toJson();
    expect(enviada['cuentaId'], cuentaCorriente.cuentaId);
    expect(enviada['monto'], 20);
    expect(enviada.containsKey('telefonoDestino'), isFalse);
    expect(viewModel.resultado!.primerCodigo, '1274');
    expect(viewModel.resultado!.segundoCodigo, '9519');
  });

  test('con "Otro número" manda ese celular con +593', () async {
    viewModel.elegirDestino(miNumero: false);

    expect(await viewModel.generar(monto: 20, celular: '991234567'), isTrue);

    final enviada = dataSource.solicitudes.single.toJson();
    expect(enviada['telefonoDestino'], '+593991234567');
  });

  test('con "Otro número" vacío no envía nada', () async {
    viewModel.elegirDestino(miNumero: false);

    expect(await viewModel.generar(monto: 20, celular: ''), isFalse);
    expect(dataSource.solicitudes, isEmpty);
  });

  test('sin celular registrado solo se puede usar "Otro número"', () async {
    viewModel = await crear(telefono: null);

    expect(viewModel.telefonoRegistrado, isNull);
    expect(viewModel.usarMiNumero, isFalse);

    viewModel.elegirDestino(miNumero: true);
    expect(viewModel.usarMiNumero, isFalse);
  });

  test(
    'si se reintenta después de un error, manda el MISMO identificador',
    () async {
      dataSource.error = const AppException('El servidor tardó demasiado');
      expect(await viewModel.generar(monto: 20), isFalse);
      expect(viewModel.error, 'El servidor tardó demasiado');
      expect(viewModel.resultado, isNull);

      dataSource.error = null;
      expect(await viewModel.generar(monto: 20), isTrue);

      final ids = dataSource.solicitudes.map((s) => s.solicitudId).toSet();
      expect(ids, hasLength(1));
    },
  );

  test('no envía dos veces si se toca el botón mientras espera', () async {
    dataSource.espera = Completer<void>();
    final primera = viewModel.generar(monto: 20);

    expect(await viewModel.generar(monto: 20), isFalse);

    dataSource.espera!.complete();
    expect(await primera, isTrue);
    expect(dataSource.solicitudes, hasLength(1));
  });

  test('si la sesión venció (401) cierra la sesión', () async {
    dataSource.error = const AppException('Sesión no válida', statusCode: 401);

    await viewModel.generar(monto: 20);

    expect(auth.isLoggedIn, isFalse);
  });
}
