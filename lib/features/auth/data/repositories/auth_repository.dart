import 'dart:convert';

import '../../../../core/network/api_client.dart';
import '../../../../core/storage/key_value_storage.dart';
import '../../model/datos_registro.dart';
import '../../model/sesion.dart';
import '../../model/usuario.dart';
import '../datasources/auth_data_source.dart';

/// Administra la sesión: la obtiene del datasource, la guarda cifrada en el
/// dispositivo y entrega el token al ApiClient para las siguientes peticiones.
class AuthRepository {
  AuthRepository({
    required this._dataSource,
    required this._storage,
    required this._apiClient,
  });

  static const _sessionKey = 'sesion';

  final AuthDataSource _dataSource;
  final KeyValueStorage _storage;
  final ApiClient _apiClient;

  Future<Sesion> login({
    required String identificador,
    required String contrasena,
  }) async {
    final sesion = await _dataSource.login(
      identificador: identificador,
      contrasena: contrasena,
    );
    await _save(sesion);
    return sesion;
  }

  Future<Sesion> register(DatosRegistro datos) async {
    final sesion = await _dataSource.register(datos);
    await _save(sesion);
    return sesion;
  }

  /// Recupera la sesión guardada al abrir la app. Devuelve null si no hay,
  /// si ya expiró o si los datos guardados están dañados.
  Future<Sesion?> restoreSession() async {
    final guardada = await _storage.read(_sessionKey);
    if (guardada == null) return null;

    try {
      final sesion = Sesion.fromJson(
        jsonDecode(guardada) as Map<String, dynamic>,
      );
      if (sesion.expirada) {
        await logout();
        return null;
      }
      _apiClient.token = sesion.token;
      return sesion;
    } on Object {
      await logout();
      return null;
    }
  }

  Future<void> logout() async {
    _apiClient.token = null;
    await _storage.delete(_sessionKey);
  }

  Future<void> _save(Sesion sesion) async {
    _apiClient.token = sesion.token;
    await _storage.write(_sessionKey, jsonEncode(sesion.toJson()));
  }

  Future<Sesion> actualizarUsuario(Sesion actual, Usuario usuario) async {
    final sesion = Sesion(
      token: actual.token,
      expiraEn: actual.expiraEn,
      usuario: usuario,
    );
    await _save(sesion);
    return sesion;
  }
}
