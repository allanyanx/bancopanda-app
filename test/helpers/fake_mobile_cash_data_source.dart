import 'dart:async';

import 'package:bancopanda_app/core/errors/app_exception.dart';
import 'package:bancopanda_app/features/mobile_cash/data/datasources/mobile_cash_data_source.dart';
import 'package:bancopanda_app/features/mobile_cash/model/efectivo_movil.dart';
import 'package:bancopanda_app/features/mobile_cash/model/solicitud_efectivo_movil.dart';

class FakeMobileCashDataSource implements MobileCashDataSource {
  AppException? error;
  Completer<void>? espera;

  final solicitudes = <SolicitudEfectivoMovil>[];

  @override
  Future<EfectivoMovil> crear(SolicitudEfectivoMovil solicitud) async {
    solicitudes.add(solicitud);
    await espera?.future;
    if (error != null) throw error!;
    return EfectivoMovil(
      efectivoMovilId: 'em1',
      codigo: '654243',
      monto: solicitud.monto,
      moneda: 'USD',
      telefonoDestino: solicitud.telefonoDestino,
      fechaCreacion: DateTime(2026, 10, 16, 21, 15),
      fechaExpiracion: DateTime(2026, 10, 17, 21, 15),
      estado: 'Pendiente',
      numeroCuenta: '5000900001',
      saldoDisponible: 80,
    );
  }
}
