import 'package:bancopanda_app/core/config/app_settings.dart';
import 'package:bancopanda_app/core/errors/app_exception.dart';
import 'package:bancopanda_app/core/network/api_client.dart';
import 'package:bancopanda_app/features/auth/data/datasources/auth_data_source.dart';
import 'package:bancopanda_app/features/auth/data/repositories/auth_repository.dart';
import 'package:bancopanda_app/features/auth/model/datos_registro.dart';
import 'package:bancopanda_app/features/auth/model/sesion.dart';
import 'package:bancopanda_app/features/auth/model/usuario.dart';
import 'package:bancopanda_app/features/auth/viewmodel/auth_view_model.dart';
import 'package:bancopanda_app/features/profile/data/datasources/profile_data_source.dart';
import 'package:bancopanda_app/features/profile/data/repositories/profile_repository.dart';
import 'package:bancopanda_app/features/profile/model/datos_perfil.dart';
import 'package:bancopanda_app/features/profile/viewmodel/profile_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/in_memory_storage.dart';

const _usuario = Usuario(
  usuarioId: '01a1275f-f1f4-7253-b408-302f76430b92',
  nombres: 'Andrea',
  apellidos: 'Barroso Torres',
  cedula: '1234567890',
  correo: 'prueba@bancopanda.test',
  telefono: '0987654321',
);

class FakeAuthDataSource implements AuthDataSource {
  Future<Sesion> _sesion() async => Sesion(
    token: 'token-de-prueba',
    expiraEn: DateTime.now().toUtc().add(const Duration(hours: 1)),
    usuario: _usuario,
  );

  @override
  Future<Sesion> login({
    required String identificador,
    required String contrasena,
  }) => _sesion();

  @override
  Future<Sesion> register(DatosRegistro datos) => _sesion();
}

class FakeProfileDataSource implements ProfileDataSource {
  AppException? error;
  Usuario servidor = _usuario;
  DatosPerfil? recibido;

  @override
  Future<Usuario> fetch() async {
    if (error != null) throw error!;
    return servidor;
  }

  @override
  Future<Usuario> update(DatosPerfil datos) async {
    if (error != null) throw error!;
    recibido = datos;
    return servidor = Usuario(
      usuarioId: servidor.usuarioId,
      nombres: datos.nombres,
      apellidos: datos.apellidos,
      cedula: servidor.cedula,
      correo: datos.correo,
      telefono: datos.telefono,
    );
  }
}

void main() {
  late InMemoryStorage storage;
  late FakeProfileDataSource dataSource;
  late AuthViewModel auth;
  late ProfileViewModel viewModel;

  const datos = DatosPerfil(
    nombres: 'Andrea Melina',
    apellidos: 'Barroso Torres',
    correo: 'prueba@bancopanda.test',
    telefono: '0999999999',
  );

  setUp(() async {
    storage = InMemoryStorage();
    dataSource = FakeProfileDataSource();
    auth = AuthViewModel(
      AuthRepository(
        dataSource: FakeAuthDataSource(),
        storage: storage,
        apiClient: ApiClient(settings: AppSettings(storage)),
      ),
    );
    await auth.login(identificador: 'a@b.com', contrasena: 'Panda2026');

    viewModel = ProfileViewModel(
      repository: ProfileRepository(dataSource: dataSource, storage: storage),
      auth: auth,
    );
  });

  test('guardar actualiza el usuario de la sesión', () async {
    final ok = await viewModel.save(datos);

    expect(ok, isTrue);
    expect(viewModel.isSaving, isFalse);
    expect(viewModel.error, isNull);
    expect(auth.usuario?.nombres, 'Andrea Melina');
    expect(auth.usuario?.telefono, '0999999999');
    expect(storage.data['sesion'], contains('Andrea Melina'));
  });

  test('guardar muestra el error del backend y conserva la sesión', () async {
    dataSource.error = const AppException(
      'La contraseña actual es incorrecta',
      statusCode: 400,
    );

    final ok = await viewModel.save(datos);

    expect(ok, isFalse);
    expect(viewModel.error, 'La contraseña actual es incorrecta');
    expect(auth.isLoggedIn, isTrue);

    viewModel.clearError();
    expect(viewModel.error, isNull);
  });

  test('un 401 al guardar cierra la sesión', () async {
    dataSource.error = const AppException('Sesión no válida', statusCode: 401);

    final ok = await viewModel.save(datos);

    expect(ok, isFalse);
    expect(auth.isLoggedIn, isFalse);
    expect(viewModel.usuario, isNull);
  });

  test('refrescar trae los datos del servidor', () async {
    dataSource.servidor = const Usuario(
      usuarioId: '01a1275f-f1f4-7253-b408-302f76430b92',
      nombres: 'Andrea',
      apellidos: 'Barroso Torres',
      cedula: '1234567890',
      correo: 'nuevo@bancopanda.test',
      telefono: '0987654321',
    );

    await viewModel.refresh();

    expect(viewModel.usuario?.correo, 'nuevo@bancopanda.test');
  });

  test('refrescar sin conexión no cierra la sesión', () async {
    dataSource.error = const AppException('No se pudo conectar');

    await viewModel.refresh();

    expect(auth.isLoggedIn, isTrue);
    expect(viewModel.usuario?.correo, 'prueba@bancopanda.test');
  });

  test('las notificaciones se guardan y se recuperan', () async {
    expect(viewModel.notificationsEnabled, isTrue);

    await viewModel.setNotifications(false);

    final otro = ProfileViewModel(
      repository: ProfileRepository(dataSource: dataSource, storage: storage),
      auth: auth,
    );
    await otro.loadPreferences();

    expect(otro.notificationsEnabled, isFalse);
  });
}
