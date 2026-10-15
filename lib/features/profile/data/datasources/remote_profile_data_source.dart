import '../../../../core/network/api_client.dart';
import '../../../auth/model/usuario.dart';
import '../../model/cambio_contrasena.dart';
import '../../model/datos_perfil.dart';
import 'profile_data_source.dart';

class RemoteProfileDataSource implements ProfileDataSource {
  const RemoteProfileDataSource(this._api);

  final ApiClient _api;

  @override
  Future<Usuario> obtener() async =>
      Usuario.fromJson(await _api.get('/api/usuarios/me'));

  @override
  Future<Usuario> actualizar(DatosPerfil datos) async =>
      Usuario.fromJson(await _api.put('/api/usuarios/me', datos.toJson()));

  @override
  Future<void> cambiarContrasena(CambioContrasena datos) async {
    await _api.put('/api/usuarios/me/contrasena', datos.toJson());
  }
}
