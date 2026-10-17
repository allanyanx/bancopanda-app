import 'dart:async';

import 'package:bancopanda_app/core/errors/app_exception.dart';
import 'package:bancopanda_app/features/transfers/data/datasources/transfers_data_source.dart';
import 'package:bancopanda_app/features/transfers/model/banco.dart';
import 'package:bancopanda_app/features/transfers/model/beneficiario.dart';
import 'package:bancopanda_app/features/transfers/model/comprobante.dart';
import 'package:bancopanda_app/features/transfers/model/solicitud_transferencia.dart';

const bancoPanda = Banco(bancoId: Banco.bancoPandaId, nombre: 'Banco Panda');
const bancoPichincha = Banco(
  bancoId: 'b0000000-0000-4000-8000-000000000003',
  nombre: 'Banco Pichincha',
);

const carlosFrecuente = Beneficiario(
  beneficiarioId: 'e1',
  bancoId: Banco.bancoPandaId,
  banco: 'Banco Panda',
  numeroCuenta: '5000900003',
  cedula: '0923456781',
  nombre: 'Carlos Mendoza',
);

/// Un frecuente que apunta a la propia cuenta de ahorros de Andrea (5000900001).
const miCuentaFrecuente = Beneficiario(
  beneficiarioId: 'e2',
  bancoId: Banco.bancoPandaId,
  banco: 'Banco Panda',
  numeroCuenta: '5000900001',
  cedula: '1234567890',
  nombre: 'Andrea Barroso',
);

class FakeTransfersDataSource implements TransfersDataSource {
  AppException? error;
  Completer<void>? espera;

  final solicitudes = <SolicitudTransferencia>[];

  Future<T> _responder<T>(T Function() valor) async {
    await espera?.future;
    if (error != null) throw error!;
    return valor();
  }

  @override
  Future<List<Banco>> obtenerBancos() =>
      _responder(() => [bancoPanda, bancoPichincha]);

  @override
  Future<List<Beneficiario>> obtenerBeneficiarios() =>
      _responder(() => [carlosFrecuente, miCuentaFrecuente]);

  @override
  Future<Comprobante> transferir(SolicitudTransferencia solicitud) {
    solicitudes.add(solicitud);
    return _responder(
      () => Comprobante(
        transferenciaId: 'tr1',
        referencia: '20261016123456',
        fecha: DateTime(2026, 10, 16, 18, 30),
        monto: solicitud.monto,
        moneda: 'USD',
        cuentaOrigen: '5000900001',
        banco: solicitud.destino.banco,
        cuentaDestino: solicitud.destino.numeroCuenta,
        beneficiario: solicitud.destino.nombre,
        saldoDisponible: 100 - solicitud.monto,
      ),
    );
  }
}
