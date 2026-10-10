import '../../../../core/network/api_client.dart';
import '../../model/datos_registro.dart';
import '../../model/sesion.dart';
import 'auth_data_source.dart';

/// Implementación que habla con la API .NET.
class RemoteAuthDataSource implements AuthDataSource {
  const RemoteAuthDataSource(this._api);

  final ApiClient _api;

  @override
  Future<Sesion> login({
    required String identificador,
    required String contrasena,
  }) async {
    final json = await _api.post('/api/auth/login', {
      'identificador': identificador,
      'contrasena': contrasena,
    });
    return Sesion.fromJson(json);
  }

  @override
  Future<Sesion> register(DatosRegistro datos) async {
    final json = await _api.post('/api/auth/registro', datos.toJson());
    return Sesion.fromJson(json);
  }
}
