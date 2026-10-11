import '../../../../core/storage/key_value_storage.dart';
import '../../../auth/model/usuario.dart';
import '../../model/datos_perfil.dart';
import '../datasources/profile_data_source.dart';

class ProfileRepository {
  ProfileRepository({required this._dataSource, required this._storage});

  static const _notificationsKey = 'notificaciones';

  final ProfileDataSource _dataSource;
  final KeyValueStorage _storage;

  Future<Usuario> fetch() => _dataSource.fetch();

  Future<Usuario> update(DatosPerfil datos) => _dataSource.update(datos);

  Future<bool> loadNotifications() async {
    final guardada = await _storage.read(_notificationsKey);
    return guardada == null || guardada == 'true';
  }

  Future<void> saveNotifications(bool enabled) =>
      _storage.write(_notificationsKey, enabled.toString());
}
