import 'dart:convert';

import 'package:bancopanda_app/core/config/app_settings.dart';
import 'package:bancopanda_app/core/network/api_client.dart';
import 'package:bancopanda_app/features/dashboard/data/datasources/remote_dashboard_data_source.dart';
import 'package:bancopanda_app/features/dashboard/model/cuenta.dart';
import 'package:bancopanda_app/features/dashboard/model/movimiento.dart';
import 'package:bancopanda_app/features/dashboard/model/tarjeta.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import '../../helpers/in_memory_storage.dart';

void main() {
  late Uri consultada;

  RemoteDashboardDataSource dataSourceQueResponde(Object body) {
    return RemoteDashboardDataSource(
      ApiClient(
        settings: AppSettings(InMemoryStorage()),
        httpClient: MockClient((request) async {
          consultada = request.url;
          return http.Response.bytes(utf8.encode(jsonEncode(body)), 200);
        }),
      ),
    );
  }

  test('lee las cuentas tal como las envía el backend', () async {
    final dataSource = dataSourceQueResponde([
      {
        'cuentaId': 'c1000000-0000-4000-8000-000000000001',
        'numeroCuenta': '5000900001',
        'tipo': 'Ahorros',
        'saldo': 12456.80,
        'moneda': 'USD',
      },
      {
        'cuentaId': 'c1000000-0000-4000-8000-000000000002',
        'numeroCuenta': '5000900002',
        'tipo': 'Corriente',
        'saldo': 100,
        'moneda': 'USD',
      },
    ]);

    final cuentas = await dataSource.obtenerCuentas();

    expect(consultada.path, '/api/cuentas');
    expect(cuentas.first.tipo, TipoCuenta.ahorros);
    expect(cuentas.first.saldo, 12456.80);
    expect(cuentas.last.tipo, TipoCuenta.corriente);
    expect(cuentas.last.saldo, 100.0);
  });

  test('lee las tarjetas con su marca, tipo y vencimiento', () async {
    final dataSource = dataSourceQueResponde([
      {
        'tarjetaId': 'd1000000-0000-4000-8000-000000000001',
        'ultimosDigitos': '4821',
        'marca': 'Visa',
        'tipo': 'Debito',
        'fechaExpiracion': '2029-10-13',
        'activa': true,
        'cuentaId': 'c1000000-0000-4000-8000-000000000001',
        'saldo': 12456.80,
        'moneda': 'USD',
      },
    ]);

    final tarjeta = (await dataSource.obtenerTarjetas()).single;

    expect(consultada.path, '/api/tarjetas');
    expect(tarjeta.marca, MarcaTarjeta.visa);
    expect(tarjeta.tipo, TipoTarjeta.debito);
    expect(tarjeta.nombre, 'Visa Débito');
    expect(tarjeta.numeroOculto, '•••• 4821');
    expect(tarjeta.fechaExpiracion, DateTime(2029, 10, 13));
    expect(tarjeta.activa, isTrue);
  });

  test('pide los movimientos de una tarjeta con su límite', () async {
    final dataSource = dataSourceQueResponde([
      {
        'movimientoId': '58f4319d-87f5-440e-9455-65653f7a5797',
        'descripcion': 'Pago de nómina',
        'monto': 1850.00,
        'tipo': 'Ingreso',
        'categoria': 'Sueldo',
        'fecha': '2026-10-13T09:34:57.188362Z',
        'cuentaId': 'c1000000-0000-4000-8000-000000000001',
      },
    ]);

    final movimiento = (await dataSource.obtenerMovimientosDeTarjeta(
      'd1000000-0000-4000-8000-000000000001',
      limite: 50,
    )).single;

    expect(
      consultada.path,
      '/api/tarjetas/d1000000-0000-4000-8000-000000000001/movimientos',
    );
    expect(consultada.queryParameters, {'limite': '50'});
    expect(movimiento.descripcion, 'Pago de nómina');
    expect(movimiento.esIngreso, isTrue);
    expect(movimiento.categoria, CategoriaMovimiento.sueldo);
    expect(movimiento.fecha.isUtc, isFalse);
    expect(movimiento.fecha.toUtc().hour, 9);
  });

  test('pide los últimos movimientos de todas las cuentas', () async {
    final dataSource = dataSourceQueResponde([]);

    final movimientos = await dataSource.obtenerMovimientos(limite: 5);

    expect(consultada.path, '/api/movimientos');
    expect(consultada.queryParameters, {'limite': '5'});
    expect(movimientos, isEmpty);
  });

  test('una categoría que la app no conoce se muestra como "Otros"', () {
    final movimiento = Movimiento.fromJson({
      'movimientoId': 'm1',
      'descripcion': 'Farmacia',
      'monto': 22.35,
      'tipo': 'Egreso',
      'categoria': 'Salud',
      'fecha': '2026-10-13T09:34:57Z',
      'cuentaId': 'c1',
    });

    expect(movimiento.categoria, CategoriaMovimiento.otros);
    expect(movimiento.esIngreso, isFalse);
  });
}
