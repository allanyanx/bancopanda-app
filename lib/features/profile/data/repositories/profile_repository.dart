import '../../../auth/model/usuario.dart';
import '../../model/cambio_contrasena.dart';
import '../../model/datos_perfil.dart';
import '../datasources/profile_data_source.dart';

class ProfileRepository {
  ProfileRepository(this._dataSource);

  final ProfileDataSource _dataSource;

  Future<Usuario> obtener() => _dataSource.obtener();
  Future<Usuario> actualizar(DatosPerfil datos) =>
      _dataSource.actualizar(datos);
  Future<void> cambiarContrasena(CambioContrasena datos) =>
      _dataSource.cambiarContrasena(datos);
}
