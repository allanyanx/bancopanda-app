import 'dart:async';

import 'package:bancopanda_app/core/errors/app_exception.dart';
import 'package:bancopanda_app/features/auth/viewmodel/auth_view_model.dart';
import 'package:bancopanda_app/features/dashboard/data/repositories/dashboard_repository.dart';
import 'package:bancopanda_app/features/transfers/data/repositories/transfers_repository.dart';
import 'package:bancopanda_app/features/transfers/model/banco.dart';
import 'package:bancopanda_app/features/transfers/model/destino.dart';
import 'package:bancopanda_app/features/transfers/viewmodel/transfer_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_auth.dart';
import '../../helpers/fake_dashboard_data_source.dart';
import '../../helpers/fake_transfers_data_source.dart';

void main() {
  late FakeTransfersDataSource dataSource;
  late FakeDashboardDataSource cuentas;
  late AuthViewModel auth;
  late TransferViewModel viewModel;

  const juanPichincha = Destino(
    bancoId: 'b0000000-0000-4000-8000-000000000003',
    banco: 'Banco Pichincha',
    numeroCuenta: '2201998877',
    cedula: '0912121212',
    nombre: 'Juan Pérez',
  );

  setUp(() async {
    dataSource = FakeTransfersDataSource();
    cuentas = FakeDashboardDataSource();
    auth = await authConSesionIniciada();
    viewModel = TransferViewModel(
      repository: TransfersRepository(dataSource),
      cuentas: DashboardRepository(cuentas),
      auth: auth,
    );
    await viewModel.cargar();
  });

  void hastaConfirmar({double monto = 50}) {
    viewModel
      ..elegirOrigen(cuentaAhorros)
      ..elegirDestino(juanPichincha)
      ..confirmarMonto(monto);
  }

  test('carga cuentas, bancos y frecuentes y empieza en el origen', () {
    expect(viewModel.cuentas, [cuentaAhorros, cuentaCorriente]);
    expect(viewModel.bancos, [bancoPanda, bancoPichincha]);
    expect(viewModel.beneficiarios, [carlosFrecuente, miCuentaFrecuente]);
    expect(viewModel.paso, PasoTransferencia.origen);
    expect(viewModel.puedeTransferirEntreMisCuentas, isTrue);
  });

  test(
    'flujo completo a otro banco: envía banco, cuenta, cédula, nombre y monto',
    () async {
      hastaConfirmar(monto: 25.5);
      expect(viewModel.paso, PasoTransferencia.confirmar);

      expect(await viewModel.transferir(), isTrue);

      final enviada = dataSource.solicitudes.single.toJson();
      expect(enviada['cuentaOrigenId'], cuentaAhorros.cuentaId);
      expect(enviada['bancoId'], juanPichincha.bancoId);
      expect(enviada['numeroCuenta'], '2201998877');
      expect(enviada['cedula'], '0912121212');
      expect(enviada['nombre'], 'Juan Pérez');
      expect(enviada['monto'], 25.5);
      expect(enviada['solicitudId'], matches(RegExp(r'^[0-9a-f-]{36}$')));
      expect(viewModel.paso, PasoTransferencia.comprobante);
      expect(viewModel.comprobante!.referencia, '20261016123456');
    },
  );

  test(
    'si se reintenta después de un error, manda el MISMO identificador',
    () async {
      hastaConfirmar();
      dataSource.error = const AppException('El servidor tardó demasiado');
      expect(await viewModel.transferir(), isFalse);

      dataSource.error = null;
      expect(await viewModel.transferir(), isTrue);

      final ids = dataSource.solicitudes.map((s) => s.solicitudId).toSet();
      expect(dataSource.solicitudes, hasLength(2));
      expect(ids, hasLength(1));
    },
  );

  test('si cambia el monto se genera un identificador nuevo', () async {
    hastaConfirmar();
    dataSource.error = const AppException('Error');
    await viewModel.transferir();

    dataSource.error = null;
    viewModel
      ..retroceder()
      ..confirmarMonto(60);
    await viewModel.transferir();

    final ids = dataSource.solicitudes.map((s) => s.solicitudId).toSet();
    expect(ids, hasLength(2));
  });

  test('elegir un frecuente usa sus datos como destino', () {
    viewModel
      ..elegirOrigen(cuentaAhorros)
      ..elegirBeneficiario(carlosFrecuente);

    expect(viewModel.destino!.numeroCuenta, '5000900003');
    expect(viewModel.destino!.cedula, '0923456781');
    expect(viewModel.destino!.esBancoPanda, isTrue);
    expect(viewModel.paso, PasoTransferencia.monto);
  });

  test('los frecuentes no muestran la propia cuenta de origen', () {
    viewModel.elegirOrigen(cuentaAhorros);
    expect(viewModel.frecuentes, [carlosFrecuente]);

    viewModel
      ..retroceder()
      ..elegirOrigen(cuentaCorriente);
    expect(viewModel.frecuentes, [carlosFrecuente, miCuentaFrecuente]);
  });

  test('entre mis cuentas va a Banco Panda con mi cédula y mi nombre', () {
    viewModel
      ..elegirOrigen(cuentaAhorros)
      ..cambiarTipoDestino(aMisCuentas: true);
    expect(viewModel.misOtrasCuentas, [cuentaCorriente]);

    viewModel.elegirCuentaPropia(cuentaCorriente);

    final destino = viewModel.destino!;
    expect(destino.bancoId, Banco.bancoPandaId);
    expect(destino.numeroCuenta, cuentaCorriente.numeroCuenta);
    expect(destino.cedula, '1234567890');
    expect(destino.nombre, 'Andrea Barroso');
  });

  test('no deja elegir la misma cuenta de origen en Banco Panda', () {
    viewModel.elegirOrigen(cuentaAhorros);

    final aceptado = viewModel.elegirDestino(
      Destino(
        bancoId: Banco.bancoPandaId,
        banco: 'Banco Panda',
        numeroCuenta: cuentaAhorros.numeroCuenta,
        cedula: '1234567890',
      ),
    );

    expect(aceptado, isFalse);
    expect(viewModel.error, 'No puedes transferir a la misma cuenta');
    expect(viewModel.paso, PasoTransferencia.destinatario);
  });

  test('con una sola cuenta no ofrece transferir entre mis cuentas', () async {
    cuentas.cuentas = [cuentaAhorros];
    await viewModel.cargar();

    expect(viewModel.puedeTransferirEntreMisCuentas, isFalse);
  });

  test(
    'si el servidor rechaza la transferencia se queda en confirmar',
    () async {
      hastaConfirmar();
      dataSource.error = const AppException(
        'Saldo insuficiente para realizar la transferencia',
      );

      expect(await viewModel.transferir(), isFalse);
      expect(
        viewModel.error,
        'Saldo insuficiente para realizar la transferencia',
      );
      expect(viewModel.paso, PasoTransferencia.confirmar);
      expect(viewModel.comprobante, isNull);
    },
  );

  test('si la sesión venció (401) cierra la sesión', () async {
    dataSource.error = const AppException('Sesión no válida', statusCode: 401);

    await viewModel.cargar();

    expect(auth.isLoggedIn, isFalse);
  });

  test('mientras envía no se puede retroceder ni enviar dos veces', () async {
    hastaConfirmar();
    dataSource.espera = Completer<void>();

    final primera = viewModel.transferir();
    expect(viewModel.retroceder(), isFalse);
    expect(viewModel.paso, PasoTransferencia.confirmar);
    expect(await viewModel.transferir(), isFalse);

    dataSource.espera!.complete();
    expect(await primera, isTrue);
    expect(dataSource.solicitudes, hasLength(1));
  });

  test('retroceder vuelve paso a paso y no sale del comprobante', () async {
    hastaConfirmar();

    expect(viewModel.retroceder(), isTrue);
    expect(viewModel.paso, PasoTransferencia.monto);
    expect(viewModel.retroceder(), isTrue);
    expect(viewModel.paso, PasoTransferencia.destinatario);
    expect(viewModel.retroceder(), isTrue);
    expect(viewModel.paso, PasoTransferencia.origen);
    expect(viewModel.retroceder(), isFalse);

    hastaConfirmar();
    await viewModel.transferir();
    expect(viewModel.retroceder(), isFalse);
    expect(viewModel.paso, PasoTransferencia.comprobante);
  });

  test(
    'no falla si la pantalla se cierra antes de recibir la respuesta',
    () async {
      hastaConfirmar();
      dataSource.espera = Completer<void>();
      final envio = viewModel.transferir();

      viewModel.dispose();
      dataSource.espera!.complete();

      await expectLater(envio, completes);
    },
  );
}
