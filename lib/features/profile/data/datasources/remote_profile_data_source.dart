import '../../../../core/network/api_client.dart';
import '../../../auth/model/usuario.dart';
import '../../model/datos_perfil.dart';
import 'profile_data_source.dart';

class RemoteProfileDataSource implements ProfileDataSource {
  const RemoteProfileDataSource(this._api);

  static const _path = '/api/usuarios/perfil';

  final ApiClient _api;

  @override
  Future<Usuario> fetch() async => Usuario.fromJson(await _api.get(_path));

  @override
  Future<Usuario> update(DatosPerfil datos) async =>
      Usuario.fromJson(await _api.put(_path, datos.toJson()));
}
