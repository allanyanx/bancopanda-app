import 'dart:async';

import 'package:bancopanda_app/core/errors/app_exception.dart';
import 'package:bancopanda_app/features/dashboard/data/datasources/dashboard_data_source.dart';
import 'package:bancopanda_app/features/dashboard/model/cuenta.dart';
import 'package:bancopanda_app/features/dashboard/model/movimiento.dart';
import 'package:bancopanda_app/features/dashboard/model/tarjeta.dart';

const cuentaAhorros = Cuenta(
  cuentaId: 'c1',
  numeroCuenta: '5000900001',
  tipo: TipoCuenta.ahorros,
  saldo: 12456.80,
  moneda: 'USD',
);

const cuentaCorriente = Cuenta(
  cuentaId: 'c2',
  numeroCuenta: '5000900002',
  tipo: TipoCuenta.corriente,
  saldo: 2283.61,
  moneda: 'USD',
);

final tarjetaVisa = Tarjeta(
  tarjetaId: 't1',
  numeroTarjeta: '4754009171454821',
  marca: MarcaTarjeta.visa,
  tipo: TipoTarjeta.debito,
  fechaExpiracion: DateTime(2029, 10, 13),
  activa: true,
  cuentaId: 'c1',
  numeroCuenta: '5000900001',
  saldo: 12456.80,
  moneda: 'USD',
);

final movimientoComida = Movimiento(
  movimientoId: 'm1',
  descripcion: 'McDonalds',
  monto: 9.75,
  tipo: TipoMovimiento.egreso,
  categoria: CategoriaMovimiento.comida,
  fecha: DateTime(2026, 10, 13, 12, 32),
  cuentaId: 'c1',
);

class FakeDashboardDataSource implements DashboardDataSource {
  AppException? error;
  Completer<void>? espera;
  List<Cuenta> cuentas = [cuentaAhorros, cuentaCorriente];

  int? limiteConsultado;

  Future<T> _responder<T>(T valor) async {
    await espera?.future;
    if (error != null) throw error!;
    return valor;
  }

  @override
  Future<List<Cuenta>> obtenerCuentas() => _responder(cuentas);

  @override
  Future<List<Tarjeta>> obtenerTarjetas() => _responder([tarjetaVisa]);

  @override
  Future<List<Movimiento>> obtenerMovimientos({required int limite}) {
    limiteConsultado = limite;
    return _responder([movimientoComida]);
  }
}
