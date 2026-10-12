import 'dart:convert';

import 'package:bancopanda_app/core/config/app_settings.dart';
import 'package:bancopanda_app/core/errors/app_exception.dart';
import 'package:bancopanda_app/core/network/api_client.dart';
import 'package:bancopanda_app/features/auth/data/datasources/auth_data_source.dart';
import 'package:bancopanda_app/features/auth/data/repositories/auth_repository.dart';
import 'package:bancopanda_app/features/auth/model/datos_registro.dart';
import 'package:bancopanda_app/features/auth/model/sesion.dart';
import 'package:bancopanda_app/features/auth/viewmodel/auth_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/in_memory_storage.dart';

Map<String, dynamic> sesionJson({required DateTime expiraEn}) => {
      'token': 'token-de-prueba',
      'expiraEn': expiraEn.toUtc().toIso8601String(),
      'usuario': {
        'usuarioId': '01a1275f-f1f4-7253-b408-302f76430b92',
        'nombres': 'Andrea',
        'apellidos': 'Barroso Torres',
        'cedula': '1234567890',
        'correo': 'prueba@bancopanda.test',
        'telefono': '0987654321',
      },
    };

class FakeAuthDataSource implements AuthDataSource {
  AppException? error;

  Future<Sesion> _responder() async {
    if (error != null) throw error!;
    return Sesion.fromJson(
      sesionJson(expiraEn: DateTime.now().add(const Duration(hours: 1))),
    );
  }

  @override
  Future<Sesion> login({
    required String identificador,
    required String contrasena,
  }) =>
      _responder();

  @override
  Future<Sesion> register(DatosRegistro datos) => _responder();
}

void main() {
  late InMemoryStorage storage;
  late ApiClient apiClient;
  late FakeAuthDataSource dataSource;
  late AuthViewModel viewModel;

  setUp(() {
    storage = InMemoryStorage();
    apiClient = ApiClient(settings: AppSettings(storage));
    dataSource = FakeAuthDataSource();
    viewModel = AuthViewModel(
      AuthRepository(
        dataSource: dataSource,
        storage: storage,
        apiClient: apiClient,
      ),
    );
  });

  test('lee la fecha tal como la envía .NET (7 decimales)', () {
    final json = sesionJson(expiraEn: DateTime.now())
      ..['expiraEn'] = '2026-10-10T20:52:42.1469142Z';

    final sesion = Sesion.fromJson(json);

    expect(sesion.expiraEn.isUtc, isTrue);
    expect(sesion.expiraEn.hour, 20);
    expect(sesion.usuario.primerNombre, 'Andrea');
    expect(sesion.usuario.primerApellido, 'Barroso');
  });

  test('login correcto: inicia sesión, guarda la sesión y entrega el token',
      () async {
    final ok = await viewModel.login(
      identificador: 'prueba@bancopanda.test',
      contrasena: 'Panda2026',
    );

    expect(ok, isTrue);
    expect(viewModel.isLoggedIn, isTrue);
    expect(viewModel.isLoading, isFalse);
    expect(viewModel.error, isNull);
    expect(viewModel.usuario?.nombres, 'Andrea');
    expect(storage.data.containsKey('sesion'), isTrue);
    expect(apiClient.token, 'token-de-prueba');
  });

  test('login incorrecto: muestra el mensaje del backend', () async {
    dataSource.error = const AppException(
      'Correo, cédula o contraseña incorrectos',
      statusCode: 401,
    );

    final ok = await viewModel.login(identificador: 'x@y.com', contrasena: 'z');

    expect(ok, isFalse);
    expect(viewModel.isLoggedIn, isFalse);
    expect(viewModel.error, 'Correo, cédula o contraseña incorrectos');

    viewModel.clearError();
    expect(viewModel.error, isNull);
  });

  test('registro correcto: deja la sesión iniciada', () async {
    final ok = await viewModel.register(
      const DatosRegistro(
        cedula: '1234567890',
        nombres: 'Andrea',
        apellidos: 'Barroso Torres',
        correo: 'prueba@bancopanda.test',
        telefono: '0987654321',
        contrasena: 'Panda2026',
        aceptaTerminos: true,
      ),
    );

    expect(ok, isTrue);
    expect(viewModel.isLoggedIn, isTrue);
  });

  test('restaura una sesión vigente al abrir la app', () async {
    storage.data['sesion'] = jsonEncode(
      sesionJson(expiraEn: DateTime.now().add(const Duration(minutes: 30))),
    );

    await viewModel.restoreSession();

    expect(viewModel.isLoggedIn, isTrue);
    expect(apiClient.token, 'token-de-prueba');
  });

  test('descarta una sesión expirada', () async {
    storage.data['sesion'] = jsonEncode(
      sesionJson(expiraEn: DateTime.now().subtract(const Duration(minutes: 1))),
    );

    await viewModel.restoreSession();

    expect(viewModel.isLoggedIn, isFalse);
    expect(storage.data.containsKey('sesion'), isFalse);
  });

  test('cerrar sesión borra la sesión y el token', () async {
    await viewModel.login(identificador: 'a@b.com', contrasena: 'Panda2026');

    await viewModel.logout();

    expect(viewModel.isLoggedIn, isFalse);
    expect(storage.data, isEmpty);
    expect(apiClient.token, isNull);
  });
}
