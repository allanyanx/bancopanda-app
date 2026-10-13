import 'dart:convert';

import 'package:bancopanda_app/core/config/app_settings.dart';
import 'package:bancopanda_app/core/errors/app_exception.dart';
import 'package:bancopanda_app/core/network/api_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import '../helpers/in_memory_storage.dart';

void main() {
  ApiClient clienteQueResponde(http.Response Function(http.Request) handler) {
    return ApiClient(
      settings: AppSettings(InMemoryStorage()),
      httpClient: MockClient((request) async => handler(request)),
    );
  }

  http.Response json(Object body, int status) {
    return http.Response.bytes(
      utf8.encode(jsonEncode(body)),
      status,
      headers: {'content-type': 'application/problem+json'},
    );
  }

  Matcher errorConMensaje(String mensaje, {int? status}) {
    return throwsA(
      isA<AppException>()
          .having((e) => e.message, 'message', mensaje)
          .having((e) => e.statusCode, 'statusCode', status),
    );
  }

  test('usa la dirección configurada y envía el token', () async {
    late http.Request enviada;
    final api = clienteQueResponde((request) {
      enviada = request;
      return json({'ok': true}, 200);
    })
      ..token = 'abc';

    final respuesta = await api.post('/api/auth/login', {'a': 1});

    expect(respuesta, {'ok': true});
    expect(enviada.url.toString(), 'http://10.0.2.2:5258/api/auth/login');
    expect(enviada.headers['Authorization'], 'Bearer abc');
  });

  test('muestra el "detail" de un error de negocio, con tildes', () {
    final api = clienteQueResponde(
      (_) => json({'detail': 'Correo, cédula o contraseña incorrectos'}, 401),
    );

    expect(
      api.post('/api/auth/login', {}),
      errorConMensaje('Correo, cédula o contraseña incorrectos', status: 401),
    );
  });

  test('muestra el primer error de validación', () {
    final api = clienteQueResponde(
      (_) => json({
        'errors': {
          'Cedula': ['La cédula debe tener 10 dígitos'],
          'Correo': ['El correo no es válido'],
        },
      }, 400),
    );

    expect(
      api.post('/api/auth/registro', {}),
      errorConMensaje('La cédula debe tener 10 dígitos', status: 400),
    );
  });

  test('getList devuelve la lista que envía el servidor', () async {
    late http.Request enviada;
    final api = clienteQueResponde((request) {
      enviada = request;
      return json([
        {'id': 1},
        {'id': 2},
      ], 200);
    });

    final respuesta = await api.getList('/api/movimientos?limite=5');

    expect(respuesta, [
      {'id': 1},
      {'id': 2},
    ]);
    expect(
      enviada.url.toString(),
      'http://10.0.2.2:5258/api/movimientos?limite=5',
    );
  });

  test('getList avisa si el servidor no envía una lista', () {
    final api = clienteQueResponde((_) => json({'ok': true}, 200));

    expect(
      api.getList('/api/movimientos'),
      errorConMensaje('El servidor envió una respuesta inesperada'),
    );
  });

  test('getList muestra el "detail" cuando el servidor responde con error', () {
    final api = clienteQueResponde(
      (_) => json({'detail': 'Tarjeta no encontrada'}, 404),
    );

    expect(
      api.getList('/api/tarjetas/x/movimientos'),
      errorConMensaje('Tarjeta no encontrada', status: 404),
    );
  });

  test('avisa cuando no hay conexión con el servidor', () {
    final api = ApiClient(
      settings: AppSettings(InMemoryStorage()),
      httpClient: MockClient(
        (_) async => throw http.ClientException('Connection refused'),
      ),
    );

    expect(
      api.post('/api/auth/login', {}),
      errorConMensaje(
        'No se pudo conectar con el servidor. Revisa la dirección en Configuración.',
      ),
    );
  });
}
