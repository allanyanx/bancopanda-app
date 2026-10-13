import 'package:bancopanda_app/core/config/app_settings.dart';
import 'package:bancopanda_app/core/network/api_client.dart';
import 'package:bancopanda_app/features/auth/data/datasources/auth_data_source.dart';
import 'package:bancopanda_app/features/auth/data/repositories/auth_repository.dart';
import 'package:bancopanda_app/features/auth/model/datos_registro.dart';
import 'package:bancopanda_app/features/auth/model/sesion.dart';
import 'package:bancopanda_app/features/auth/model/usuario.dart';
import 'package:bancopanda_app/features/auth/viewmodel/auth_view_model.dart';

import 'in_memory_storage.dart';

class _FakeAuthDataSource implements AuthDataSource {
  Sesion get _sesion => Sesion(
    token: 'token-de-prueba',
    expiraEn: DateTime.now().toUtc().add(const Duration(hours: 1)),
    usuario: const Usuario(
      usuarioId: '01a1275f-f1f4-7253-b408-302f76430b92',
      nombres: 'Andrea',
      apellidos: 'Barroso Torres',
      cedula: '1234567890',
      correo: 'prueba@bancopanda.test',
    ),
  );

  @override
  Future<Sesion> login({
    required String identificador,
    required String contrasena,
  }) async => _sesion;

  @override
  Future<Sesion> register(DatosRegistro datos) async => _sesion;
}

Future<AuthViewModel> authConSesionIniciada() async {
  final storage = InMemoryStorage();
  final auth = AuthViewModel(
    AuthRepository(
      dataSource: _FakeAuthDataSource(),
      storage: storage,
      apiClient: ApiClient(settings: AppSettings(storage)),
    ),
  );
  await auth.login(
    identificador: 'prueba@bancopanda.test',
    contrasena: 'Panda2026',
  );
  return auth;
}
